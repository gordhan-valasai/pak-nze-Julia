using Test, YAML
@testset "Scenario sanity" begin
  sc=YAML.load_file("config/scenarios.yaml")
  @test haskey(sc["scenarios"],"REF")
  @test haskey(sc["scenarios"],"LCB")
  @test haskey(sc["scenarios"],"NZE")
  @test sc["scenarios"]["NZE"]["renewable_target_2050"] >= 0.93
  @test sc["scenarios"]["LCB"]["renewable_target_2050"] >= 0.60
end
