include("../src/TrajectoryMatrices.jl")
using TrajectoryMatrices
using Base.Test

info("Beginning tests...")
data = collect(1:21)

# Make sure everything is compiled before testing
traj = TrajectoryMatrix(data, 3)

@test traj[1,3] == 3
@test traj[19, 3] == 21
@test size(traj) == (19,3)

trans_traj = traj'

@test trans_traj[3,1] == 3
@test trans_traj[3, 19] == 21
@test size(trans_traj) == (3,19)

data_mem = @allocated collect(1:21)
traj_mem = @allocated TrajectoryMatrix(data, 3)
tran_mem = @allocated traj'

@test traj_mem < (data_mem * 2)
@test tran_mem < (traj_mem * 3)

data = [1 1 1 1; 2 2 2 2; 3 3 3 3]
expected = [1 1 1 1 2 2 2 2; 2 2 2 2 3 3 3 3]
traj = TrajectoryMatrix(data, 2)

for i in eachindex(expected)
    @test expected[i] == traj[i]
end

expected = expected'
traj = traj'

for i in eachindex(expected)
    @test expected[i] == traj[i]
end

traj[1] = 8
@test traj[1] == 8

traj[1,1] = 9
@test traj[1,1] == 9

info("All tests passed.")
