#!/usr/bin/env python3
"""
PAK-NZE-Julia Diagnostic Collector
Runs comprehensive review of the PAK-NZE-Julia repository state.
Produces results/diagnostic_report.md and results/diagnostic_data.json.

Usage:
    python3 pak_nze_diagnostic.py [path_to_PAK-NZE-Julia]

If no path is given, assumes current directory is PAK-NZE-Julia/.
"""

import os
import sys
import re
import json
import subprocess
import hashlib
from pathlib import Path
from datetime import datetime
from collections import defaultdict

try:
    import csv
except ImportError:
    csv = None


SUSPICIOUS_PATTERNS = {
    "scenario_multiplier": [
        r'scenario\s*==\s*"REF".*\*\s*\d+\.\d+',
        r'scenario\s*==\s*"LCB".*\*\s*\d+\.\d+',
        r'scenario\s*==\s*"NZE".*\*\s*\d+\.\d+',
        r'\*\s*9\.0',
        r'\*\s*4\.6',
    ],
    "uniform_province_split": [
        r'/\s*length\s*\(\s*sets\.provinces\s*\)',
        r'/\s*length\s*\(\s*provinces\s*\)',
        r'/\s*7\b',
        r'/\s*max\s*\(\s*length\s*\(\s*sets\.provinces',
    ],
    "uniform_fuel_split": [
        r'/\s*length\s*\(\s*sets\.fuels\s*\)',
        r'/\s*length\s*\(\s*fuels\s*\)',
        r'/\s*max\s*\(\s*length\s*\(\s*sets\.fuels',
    ],
    "rng_calls": [
        r'\brand\s*\(',
        r'\brandn\s*\(',
        r'\bMath\.random\s*\(',
        r'\bnp\.random\s*\.',
    ],
    "hardcoded_results": [
        r'vals\s*=\s*\[\s*\d+\.\d+\s*,\s*\d+\.\d+\s*,',
        r'base\s*=\s*tag\s*==\s*"ref"\s*\?',
        r'base\s*=\s*s\s*==\s*"power"\s*\?',
        r'flow_twh\s*=\s*\[\s*\d+\.\d+\s*,',
    ],
    "hardcoded_hydrogen_ratios": [
        r'\*\s*0\.45\b',
        r'\*\s*0\.20\b',
        r'\*\s*0\.15\b',
        r'\*\s*0\.05\b',
    ],
}


def run(cmd, cwd=None, check=False):
    try:
        result = subprocess.run(
            cmd, cwd=cwd, capture_output=True, text=True, timeout=60, shell=False
        )
        return result.stdout, result.stderr, result.returncode
    except Exception as e:
        return "", str(e), -1


def find_repo(arg):
    if arg:
        p = Path(arg).resolve()
    else:
        p = Path.cwd().resolve()
    if p.name == "PAK-NZE-Julia":
        return p
    candidate = p / "PAK-NZE-Julia"
    if candidate.exists():
        return candidate
    return p


def collect_file_inventory(repo):
    inventory = []
    extensions_of_interest = {".jl", ".toml", ".yaml", ".yml", ".md", ".cff",
                              ".json", ".ipynb", ".py", ".sh", ".csv", ".png",
                              ".pdf", ".jld2", "Dockerfile"}
    for path in repo.rglob("*"):
        if not path.is_file():
            continue
        if any(part.startswith(".") and part not in {".github", ".gitignore",
               ".zenodo.json", ".dockerignore"} for part in path.parts):
            continue
        if "node_modules" in path.parts or ".git" in path.parts:
            continue
        suffix = path.suffix.lower() if path.suffix else path.name
        if suffix in extensions_of_interest or path.name in {"Dockerfile",
                                                              "Project.toml",
                                                              "Manifest.toml"}:
            try:
                size = path.stat().st_size
                mtime = datetime.fromtimestamp(path.stat().st_mtime).isoformat()
                inventory.append({
                    "path": str(path.relative_to(repo)),
                    "size": size,
                    "modified": mtime,
                })
            except Exception:
                pass
    return sorted(inventory, key=lambda x: x["path"])


def collect_git_state(repo):
    out = {}
    log, _, _ = run(["git", "log", "--oneline", "-n", "30"], cwd=repo)
    out["recent_commits"] = log.strip().splitlines()
    tags, _, _ = run(["git", "tag", "-l"], cwd=repo)
    out["tags"] = tags.strip().splitlines()
    status, _, _ = run(["git", "status", "--short"], cwd=repo)
    out["status"] = status.strip().splitlines()
    branch, _, _ = run(["git", "rev-parse", "--abbrev-ref", "HEAD"], cwd=repo)
    out["branch"] = branch.strip()
    return out


def read_text_safe(path, max_bytes=200000):
    try:
        with open(path, "r", encoding="utf-8", errors="replace") as f:
            return f.read(max_bytes)
    except Exception as e:
        return f"<read error: {e}>"


def collect_yaml_configs(repo):
    configs = {}
    config_dir = repo / "config"
    if not config_dir.exists():
        return configs
    for yaml_file in config_dir.rglob("*.yaml"):
        configs[str(yaml_file.relative_to(repo))] = read_text_safe(yaml_file)
    for yml_file in config_dir.rglob("*.yml"):
        configs[str(yml_file.relative_to(repo))] = read_text_safe(yml_file)
    return configs


def find_jump_variables(repo):
    variables = []
    src_files = list((repo / "src").rglob("*.jl")) if (repo / "src").exists() else []
    pattern = re.compile(
        r'@variable\s*\(\s*model\s*,\s*([a-zA-Z_][a-zA-Z0-9_]*)'
        r'(?:\s*\[([^\]]*)\])?'
        r'([^)]*)\)',
        re.MULTILINE
    )
    for src in src_files:
        text = read_text_safe(src)
        for match in pattern.finditer(text):
            name = match.group(1)
            indices = (match.group(2) or "").strip()
            extras = (match.group(3) or "").strip()
            line_no = text[:match.start()].count("\n") + 1
            variables.append({
                "name": name,
                "indices": indices,
                "extras": extras,
                "file": str(src.relative_to(repo)),
                "line": line_no,
            })
    return variables


def find_constraints(repo):
    constraints = []
    src_files = list((repo / "src").rglob("*.jl")) if (repo / "src").exists() else []
    pattern = re.compile(r'@constraint\s*\(', re.MULTILINE)
    for src in src_files:
        text = read_text_safe(src)
        count = len(pattern.findall(text))
        if count > 0:
            constraints.append({
                "file": str(src.relative_to(repo)),
                "constraint_blocks": count,
            })
    return constraints


def find_parameters(repo):
    params = {"struct_fields": [], "loaded_keys": []}
    param_file = repo / "src" / "parameters.jl"
    if not param_file.exists():
        return params
    text = read_text_safe(param_file)
    struct_match = re.search(
        r'(?:mutable\s+)?struct\s+ModelParameters\s*\n(.*?)\nend',
        text, re.DOTALL
    )
    if struct_match:
        for line in struct_match.group(1).splitlines():
            line = line.strip()
            if line and not line.startswith("#"):
                parts = line.split("::")
                if len(parts) == 2:
                    params["struct_fields"].append({
                        "name": parts[0].strip(),
                        "type": parts[1].strip().rstrip(","),
                    })
    return params


def collect_csv_stats(repo):
    csv_stats = []
    tables_dir = repo / "results" / "tables"
    if not tables_dir.exists():
        return csv_stats
    for csv_file in sorted(tables_dir.rglob("*.csv")):
        try:
            with open(csv_file, "r", encoding="utf-8", errors="replace") as f:
                lines = f.readlines()
            row_count = len(lines) - 1 if lines else 0
            header = lines[0].strip().split(",") if lines else []
            stat = {
                "file": str(csv_file.relative_to(repo)),
                "rows": row_count,
                "columns": header,
                "column_count": len(header),
                "column_stats": {},
                "first_three_rows": [l.rstrip() for l in lines[1:4]],
                "last_three_rows": [l.rstrip() for l in lines[-3:]] if len(lines) > 4 else [],
            }
            for col_idx, col_name in enumerate(header):
                values = []
                for line in lines[1:]:
                    parts = line.strip().split(",")
                    if col_idx < len(parts):
                        try:
                            v = float(parts[col_idx])
                            values.append(v)
                        except ValueError:
                            pass
                if values:
                    stat["column_stats"][col_name] = {
                        "n_numeric": len(values),
                        "min": min(values),
                        "max": max(values),
                        "mean": sum(values) / len(values),
                        "all_zero": all(v == 0 for v in values),
                        "all_same": len(set(values)) == 1,
                        "sample": values[:5],
                    }
            csv_stats.append(stat)
        except Exception as e:
            csv_stats.append({
                "file": str(csv_file.relative_to(repo)),
                "error": str(e),
            })
    return csv_stats


def scan_suspicious_patterns(repo):
    findings = defaultdict(list)
    search_dirs = ["src", "post", "scripts", "tests"]
    for sub in search_dirs:
        d = repo / sub
        if not d.exists():
            continue
        for jl_file in d.rglob("*.jl"):
            text = read_text_safe(jl_file)
            for category, patterns in SUSPICIOUS_PATTERNS.items():
                for pat in patterns:
                    for m in re.finditer(pat, text):
                        line_no = text[:m.start()].count("\n") + 1
                        line_text = text.splitlines()[line_no - 1] if line_no - 1 < len(text.splitlines()) else ""
                        findings[category].append({
                            "file": str(jl_file.relative_to(repo)),
                            "line": line_no,
                            "match": m.group(0),
                            "context": line_text.strip(),
                        })
    return dict(findings)


def collect_figure_inventory(repo):
    figs = []
    fig_dir = repo / "results" / "figures"
    if not fig_dir.exists():
        return figs
    for f in sorted(fig_dir.rglob("*")):
        if f.is_file() and f.suffix.lower() in {".png", ".pdf", ".svg"}:
            figs.append({
                "file": str(f.relative_to(repo)),
                "size": f.stat().st_size,
                "modified": datetime.fromtimestamp(f.stat().st_mtime).isoformat(),
            })
    return figs


def collect_test_summary(repo):
    tests = []
    tests_dir = repo / "tests"
    if not tests_dir.exists():
        return tests
    for t in sorted(tests_dir.rglob("*.jl")):
        text = read_text_safe(t)
        n_at_test = len(re.findall(r'@test\b', text))
        n_assertions = len(re.findall(r'_assert_range\b|@assert\b', text))
        tests.append({
            "file": str(t.relative_to(repo)),
            "test_macros": n_at_test,
            "custom_assertions": n_assertions,
            "lines": text.count("\n") + 1,
        })
    return tests


def collect_results_logs(repo):
    logs = {}
    res_dir = repo / "results"
    if not res_dir.exists():
        return logs
    for md_file in sorted(res_dir.rglob("*.md")):
        logs[str(md_file.relative_to(repo))] = read_text_safe(md_file, max_bytes=20000)
    return logs


def headline_sanity_check(csv_stats):
    headline = {}
    for stat in csv_stats:
        fname = stat.get("file", "")
        if "scenario_comparison" in fname:
            headline["scenario_comparison"] = {
                "rows": stat.get("rows"),
                "columns": stat.get("columns"),
                "first_three": stat.get("first_three_rows"),
            }
        if "power_sector_emissions" in fname:
            headline["power_sector_emissions"] = stat.get("column_stats", {})
        if "power_sector_fuel_import_dependency" in fname:
            headline["import_dependency"] = stat.get("column_stats", {})
        if "generation_mix" in fname:
            headline["generation_mix"] = {
                "rows": stat.get("rows"),
                "first_three": stat.get("first_three_rows"),
            }
        if "nze_capacity_summary" in fname:
            headline["nze_capacity_summary"] = stat.get("column_stats", {})
    return headline


def write_markdown_report(out_path, data):
    lines = []
    lines.append("# PAK-NZE-Julia Diagnostic Report")
    lines.append(f"\nGenerated: {data['timestamp']}")
    lines.append(f"Repository: {data['repo_path']}")
    lines.append("")

    lines.append("## 1. Git State")
    git = data.get("git", {})
    lines.append(f"- Branch: `{git.get('branch', 'unknown')}`")
    lines.append(f"- Tags: {', '.join(git.get('tags', [])) or 'none'}")
    lines.append(f"- Uncommitted changes: {len(git.get('status', []))} files")
    lines.append("- Recent commits (last 30):")
    for c in git.get("recent_commits", [])[:30]:
        lines.append(f"  - `{c}`")
    lines.append("")

    lines.append("## 2. File Inventory Summary")
    inv = data.get("file_inventory", [])
    by_ext = defaultdict(int)
    for f in inv:
        ext = Path(f["path"]).suffix or Path(f["path"]).name
        by_ext[ext] += 1
    lines.append(f"Total tracked files: {len(inv)}")
    for ext, n in sorted(by_ext.items(), key=lambda x: -x[1]):
        lines.append(f"- `{ext}`: {n}")
    lines.append("")

    lines.append("## 3. JuMP Variables")
    vars_ = data.get("jump_variables", [])
    lines.append(f"Total @variable declarations: {len(vars_)}")
    lines.append("")
    lines.append("| Name | Indices | File | Line |")
    lines.append("|---|---|---|---|")
    for v in vars_:
        lines.append(f"| `{v['name']}` | `{v['indices']}` | `{v['file']}` | {v['line']} |")
    lines.append("")

    lines.append("## 4. Constraints by File")
    cons = data.get("constraints", [])
    for c in cons:
        lines.append(f"- `{c['file']}`: {c['constraint_blocks']} constraint blocks")
    lines.append("")

    lines.append("## 5. ModelParameters Struct Fields")
    params = data.get("parameters", {})
    fields = params.get("struct_fields", [])
    lines.append(f"Total fields: {len(fields)}")
    for f in fields:
        lines.append(f"- `{f['name']}` :: `{f['type']}`")
    lines.append("")

    lines.append("## 6. Suspicious Code Patterns")
    susp = data.get("suspicious_patterns", {})
    if not susp:
        lines.append("No suspicious patterns found.")
    for category, hits in susp.items():
        lines.append(f"\n### {category} ({len(hits)} occurrences)")
        for h in hits:
            lines.append(f"- `{h['file']}:{h['line']}` — `{h['context']}`")
    lines.append("")

    lines.append("## 7. CSV Output Audit")
    csv_stats = data.get("csv_stats", [])
    lines.append(f"Total CSV files: {len(csv_stats)}")
    lines.append("")
    for stat in csv_stats:
        if "error" in stat:
            lines.append(f"### `{stat['file']}` — ERROR: {stat['error']}")
            continue
        lines.append(f"### `{stat['file']}`")
        lines.append(f"- Rows: {stat.get('rows', 0)}")
        lines.append(f"- Columns: {', '.join(stat.get('columns', []))}")
        col_stats = stat.get("column_stats", {})
        if col_stats:
            lines.append("- Column statistics:")
            for col, s in col_stats.items():
                flags = []
                if s.get("all_zero"):
                    flags.append("ALL_ZERO")
                if s.get("all_same") and not s.get("all_zero"):
                    flags.append("ALL_SAME")
                flag_str = f" [{', '.join(flags)}]" if flags else ""
                lines.append(
                    f"  - `{col}`: n={s['n_numeric']}, min={s['min']:.4g}, "
                    f"max={s['max']:.4g}, mean={s['mean']:.4g}{flag_str}"
                )
        if stat.get("first_three_rows"):
            lines.append("- First three rows:")
            for row in stat["first_three_rows"]:
                lines.append(f"  - `{row}`")
        lines.append("")

    lines.append("## 8. Headline Sanity Check")
    headline = data.get("headline_sanity", {})
    lines.append(f"```json\n{json.dumps(headline, indent=2)}\n```")
    lines.append("")

    lines.append("## 9. Figures Inventory")
    figs = data.get("figures", [])
    lines.append(f"Total figures: {len(figs)}")
    for f in figs:
        size_kb = f["size"] / 1024
        lines.append(f"- `{f['file']}` ({size_kb:.1f} KB, modified {f['modified']})")
    lines.append("")

    lines.append("## 10. Test Suite")
    tests = data.get("tests", [])
    for t in tests:
        lines.append(
            f"- `{t['file']}`: {t['test_macros']} @test, "
            f"{t['custom_assertions']} custom, {t['lines']} lines"
        )
    lines.append("")

    lines.append("## 11. Results Logs")
    logs = data.get("results_logs", {})
    for log_path in sorted(logs.keys()):
        lines.append(f"\n### `{log_path}`")
        lines.append("```")
        lines.append(logs[log_path][:5000])
        lines.append("```")
    lines.append("")

    lines.append("## 12. Configuration Files")
    configs = data.get("configs", {})
    for cfg_path, cfg_text in sorted(configs.items()):
        lines.append(f"\n### `{cfg_path}`")
        lines.append("```yaml")
        lines.append(cfg_text[:3000])
        lines.append("```")

    with open(out_path, "w", encoding="utf-8") as f:
        f.write("\n".join(lines))


def main():
    repo_arg = sys.argv[1] if len(sys.argv) > 1 else None
    repo = find_repo(repo_arg)
    if not repo.exists():
        print(f"ERROR: Repository path does not exist: {repo}")
        sys.exit(1)

    print(f"Scanning repository: {repo}")

    data = {
        "timestamp": datetime.now().isoformat(),
        "repo_path": str(repo),
        "git": collect_git_state(repo),
        "file_inventory": collect_file_inventory(repo),
        "configs": collect_yaml_configs(repo),
        "jump_variables": find_jump_variables(repo),
        "constraints": find_constraints(repo),
        "parameters": find_parameters(repo),
        "csv_stats": collect_csv_stats(repo),
        "suspicious_patterns": scan_suspicious_patterns(repo),
        "figures": collect_figure_inventory(repo),
        "tests": collect_test_summary(repo),
        "results_logs": collect_results_logs(repo),
    }
    data["headline_sanity"] = headline_sanity_check(data["csv_stats"])

    out_dir = repo / "results"
    out_dir.mkdir(exist_ok=True)
    json_path = out_dir / "diagnostic_data.json"
    md_path = out_dir / "diagnostic_report.md"

    with open(json_path, "w", encoding="utf-8") as f:
        json.dump(data, f, indent=2, default=str)

    write_markdown_report(md_path, data)

    print(f"\nWrote: {md_path}")
    print(f"Wrote: {json_path}")
    print("\nSummary:")
    print(f"  Files scanned: {len(data['file_inventory'])}")
    print(f"  JuMP variables: {len(data['jump_variables'])}")
    print(f"  Parameter struct fields: {len(data['parameters'].get('struct_fields', []))}")
    print(f"  CSV files audited: {len(data['csv_stats'])}")
    print(f"  Figures: {len(data['figures'])}")
    susp_total = sum(len(v) for v in data['suspicious_patterns'].values())
    print(f"  Suspicious pattern matches: {susp_total}")
    print(f"  Tests: {len(data['tests'])}")


if __name__ == "__main__":
    main()