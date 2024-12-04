matrix = readlines("input.txt")
rows = length(matrix)
cols = length(matrix[1])

function find_xmas(matrix, dx, dy)
    count = 0
    for i in 1:rows
        for j in 1:cols
            found = true
            for k in 0:3 
                x = i + k * dx
                y = j + k * dy
                if x < 1 || x > rows || y < 1 || y > cols || matrix[x][y] != "XMAS"[k+1]
                    found = false
                    break
                end
            end
            count += found
        end
    end
    return count
end


function find_x_mas(matrix, i, j)
    count = 0
    if matrix[i][j] == 'A'
        if i > 1 && j > 1 && i < rows && j < cols
            if matrix[i-1][j-1] == 'M' && matrix[i+1][j+1] == 'S' &&
               matrix[i-1][j+1] == 'M' && matrix[i+1][j-1] == 'S'
                count += 1
            end

            if matrix[i-1][j-1] == 'S' && matrix[i+1][j+1] == 'M' &&
               matrix[i-1][j+1] == 'S' && matrix[i+1][j-1] == 'M'
                count += 1
            end

            if matrix[i-1][j-1] == 'M' && matrix[i+1][j+1] == 'S' &&
               matrix[i+1][j-1] == 'M' && matrix[i-1][j+1] == 'S'
                count += 1
            end

            if matrix[i-1][j-1] == 'S' && matrix[i+1][j+1] == 'M' &&
               matrix[i+1][j-1] == 'S' && matrix[i-1][j+1] == 'M'
                count += 1
            end
        end
    end
    return count
end

directions = [(0, 1), (1, 0), (1, 1), (1, -1), (0, -1), (-1, 0), (-1, -1), (-1, 1)]
xmas_count = sum(find_xmas(matrix, dx, dy) for (dx, dy) in directions)
x_mas_count = 0 

for i in 2:rows-1
    for j in 2:cols-1
        global x_mas_count += find_x_mas(matrix, i, j)
    end
end

println(xmas_count)
println(x_mas_count)
