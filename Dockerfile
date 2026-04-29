FROM julia:1.10-bookworm
WORKDIR /app
LABEL org.opencontainers.image.title="PAK-NZE-Julia"
LABEL org.opencontainers.image.description="Open-source Julia-JuMP replication of GIZ-EPRC PAK-IEM 2.0"
LABEL org.opencontainers.image.licenses="MIT"
LABEL org.opencontainers.image.source="https://github.com/PLACEHOLDER/PAK-NZE-Julia"
COPY . /app
RUN julia --project=. -e "using Pkg; Pkg.instantiate(); Pkg.precompile()"
CMD ["julia", "--project=.", "src/solve.jl", "--scenario", "REF", "--solver", "HiGHS"]
