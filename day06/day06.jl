const DIRECTIONS = Dict(
    '^' => (-1,  0),
    '>' => ( 0,  1),
    'v' => ( 1,  0),
    '<' => ( 0, -1)
)

const DIR_ORDER = ['^', '>', 'v', '<']

function parse_map(input::String)
    lines = split(input, "\n") 
    return [collect(line) for line in lines]
end

function turn_right(d::Char)
    idx = findfirst(x -> x == d, DIR_ORDER)
    return DIR_ORDER[mod(idx, length(DIR_ORDER)) + 1] 
end

function initialize_guard(grid::Vector{Vector{Char}})
    for i in 1:length(grid)
        for j in 1:length(grid[i])
            c = grid[i][j]
            if c in ['^','>','v','<']
                dir = c
                grid[i][j] = '.'  
                return (i, j), dir
            end
        end
    end
    error("No guard found on the map.")
end

function inbounds(grid, i, j)
    return i >= 1 && i <= length(grid) && j >= 1 && j <= length(grid[i])
end

function is_free(grid, i, j)
    return inbounds(grid, i, j) && grid[i][j] != '#'
end

function build_graph(grid)
    R = length(grid)
    C = length(grid[1])
    graph = Dict{Tuple{Int,Int,Char}, Tuple{Int,Int,Char}}()

    for i in 1:R
        for j in 1:C
            if grid[i][j] != '#'
                for dir in DIR_ORDER
                    di, dj = DIRECTIONS[dir]
                    ni, nj = i + di, j + dj

                    if inbounds(grid, ni, nj)
                        if grid[ni][nj] == '#'
                            next_dir = turn_right(dir)
                            graph[(i, j, dir)] = (i, j, next_dir)
                        else
                            graph[(i, j, dir)] = (ni, nj, dir)
                        end
                    else
                    end
                end
            end
        end
    end

    return graph
end

function simulate_path(grid, startpos::Tuple{Int,Int}, startdir::Char, graph)
    (ci, cj) = startpos
    dir = startdir

    grid[ci][cj] = 'X'

    visited_states = Set{Tuple{Int,Int,Char}}()
    push!(visited_states, (ci, cj, dir))

    looped_path = false

    while true
        if !haskey(graph, (ci, cj, dir))
            di, dj = DIRECTIONS[dir]
            ni, nj = ci + di, cj + dj
            if !inbounds(grid, ni, nj)
                break
            else
                break
            end
        end

        (ni, nj, ndir) = graph[(ci, cj, dir)]

        ci, cj, dir = ni, nj, ndir

        if inbounds(grid, ci, cj) && grid[ci][cj] == '.'
            grid[ci][cj] = 'X'
        end

        if (ci, cj, dir) in visited_states
            looped_path = true
            break
        else
            push!(visited_states, (ci, cj, dir))
        end
    end

    return grid, looped_path
end

function get_visited_positions(final_grid)
    visited_positions = Set{Tuple{Int, Int}}()
    for i in 1:length(final_grid)
        for j in 1:length(final_grid[i])
            if final_grid[i][j] == 'X'
                push!(visited_positions, (i, j))
            end
        end
    end
    return visited_positions
end

function count_possible_loops(grid, startpos, startdir)
    graph = build_graph(grid)
    final_grid, _ = simulate_path(copy(grid), startpos, startdir, graph)
    visited_positions = get_visited_positions(final_grid)

    loop_count = 0

    for (i, j) in visited_positions
        if !(i == startpos[1] && j == startpos[2])  
            original = grid[i][j] 
            grid[i][j] = '#'     
            graph = build_graph(grid)
            _, looped_path = simulate_path(copy(grid), startpos, startdir, graph)

            if looped_path
                loop_count += 1
            end

            grid[i][j] = original
        end
    end

    return loop_count
end

input = read("input.txt", String)

grid = parse_map(input)
startpos, startdir = initialize_guard(grid)
graph = build_graph(grid)
final_grid, looped_path = simulate_path(grid, startpos, startdir, graph)

count_x = sum([c == 'X' ? 1 : 0 for row in final_grid for c in row])
loop_count = count_possible_loops(grid, startpos, startdir)
println(count_x)
println(loop_count)

