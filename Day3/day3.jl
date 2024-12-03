input = read("input.txt", String)

mul_pattern = r"mul\((\d{1,3}),(\d{1,3})\)"
combined_pattern = r"mul\((\d{1,3}),(\d{1,3})\)|do\(\)|don't\(\)"

total_sum = 0
total_sum_enabled = 0
enabled = true

for match in eachmatch(pattern, input)
    x = parse(Int, match.captures[1]) 
    y = parse(Int, match.captures[2])  
    global total_sum += x * y
end

for match in eachmatch(combined_pattern, input)
    if match.match == "do()"
        global enabled = true
    elseif match.match == "don't()"
        global enabled = false
    elseif occursin("mul", match.match) && enabled
        x, y = parse(Int, match.captures[1]), parse(Int, match.captures[2])
        global total_sum_enabled += x * y
    end
end

println(total_sum)
println(total_sum_enabled)