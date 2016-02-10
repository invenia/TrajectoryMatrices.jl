"""
Represents a trajector matrix without using any more
memory than the source data.

https://en.wikipedia.org/wiki/Singular_spectrum_analysis#SSA_as_a_model-free_tool

Techinally this will work for for source data of arbitrary dimensions, however,
under most use cases it'll either be a 1d array or a 2d array
(ie: each time step as a set of features)
"""
type TrajectoryMatrix{T,N} <: AbstractArray{T,N}
    data::AbstractArray{T}
    window::Int
    nsteps::Int
    step_size::Int
    nrows::Int
    ncols::Int
    trans::Bool
end

function TrajectoryMatrix{T}(data::AbstractArray{T}, window; trans=false)
    src_size = size(data)
    nsteps = src_size[1]
    step_size = isempty(src_size[2:end]) ? 1 : prod(src_size[2:end])

    ncols = window * step_size
    nrows = nsteps - window + 1

    if trans
        # Reverse the nrows and ncols if this is to be a transposed TrajectoryMatrix
        return TrajectoryMatrix{T,2}(data, window, nsteps, step_size, ncols, nrows, trans)
    else
        return TrajectoryMatrix{T,2}(data, window, nsteps, step_size, nrows, ncols, trans)
    end
end

Base.size{T}(matrix::TrajectoryMatrix{T}) = (matrix.nrows, matrix.ncols)
Base.linearindexing(::Type{TrajectoryMatrix}) = Base.LinearFast()


function compute_index{T}(matrix::TrajectoryMatrix{T}, i::Int, j::Int)
    @fastmath begin
        # Base case
        if !matrix.trans
            # If we think of the source data as a matrix
            # the step is the row
            step = i + floor((j-1) / matrix.step_size)

            # the sub_step is the column
            sub_step = ((j-1) % matrix.step_size) + 1

            # info("Internal Index: ( $step, $sub_step )")
            idx = round(Int, (size(matrix.data, 1) * (sub_step-1)) + step)

            return idx
        else
            # If we think of the source data as a matrix
            # the step is the row
            step = j + floor((i-1) / matrix.step_size)

            # the sub_step is the column
            sub_step = ((i-1) % matrix.step_size) + 1

            # info("Internal Index: ( $step, $sub_step )")
            idx = round(Int, (size(matrix.data, 1) * (sub_step-1)) + step)

            return idx
        end
    end
end

function Base.getindex{T}(matrix::TrajectoryMatrix{T}, i::Int, j::Int)
    return matrix.data[compute_index(matrix, i, j)]
end

function Base.getindex{T}(matrix::TrajectoryMatrix{T}, i::Int)
    idx = ind2sub(size(matrix), i)
    return matrix.data[compute_index(matrix, idx[1], idx[2])]
end

function Base.setindex!{T}(matrix::TrajectoryMatrix{T}, v::T, i::Int)
    idx = ind2sub(size(matrix), i)
    matrix.data[compute_index(matrix, idx[1], idx[2])] = v
end

function Base.setindex!{T}(matrix::TrajectoryMatrix{T}, v::T, i::Int, j::Int)
    return matrix.data[compute_index(matrix, i, j)] = v
end

function Base.transpose{T}(m::TrajectoryMatrix{T})
    if m.trans
        return TrajectoryMatrix(m.data, m.window; trans=false)
    else
        return TrajectoryMatrix(m.data, m.window; trans=true)
    end
end

function Base.ctranspose{T}(m::TrajectoryMatrix{T})
    data = map(i -> conj(i), m.data)

    if m.trans
        return TrajectoryMatrix(data, m.window; trans=false)
    else
        return TrajectoryMatrix(data, m.window; trans=true)
    end
end

function traj{T}(data::AbstractArray{T}, window; compressed=false)
    traj = TrajectoryMatrix(data, window)

    if compressed
        return traj
    else
        result = Array{T}(size(traj))
        for i in eachindex(traj)
            result[i] = traj[i]
        end

        return result
    end
end
