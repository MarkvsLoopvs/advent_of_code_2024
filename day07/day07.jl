function parse_input(file)
    data = Dict{Int, Vector{Int}}()
    for line in eachline(file)
        parts = split(line, ":")
        target = parse(Int, strip(parts[1]))
        numbers = [parse(Int, x) for x in split(strip(parts[2]))]
        data[target] = numbers
    end
    return data
end

function can_express_plus_mult(target, numbers, current_result, memo)

    if isempty(numbers)
        return current_result == target
    end

    key = (current_result, numbers)
    if haskey(memo, key)
        return memo[key]
    end

    head, tail = numbers[1], numbers[2:end]

    add_result = can_express_plus_mult(target, tail, current_result + head, memo)

    mult_result = can_express_plus_mult(target, tail, current_result * head, memo)

    memo[key] = add_result || mult_result
    return memo[key]
end

function can_express_plus_mult_concat(target, numbers, current_result, memo)

    if isempty(numbers)
        return current_result == target
    end

    key = (current_result, numbers)
    if haskey(memo, key)
        return memo[key]
    end

    head, tail = numbers[1], numbers[2:end]

    add_result = can_express_plus_mult_concat(target, tail, current_result + head, memo)

    mult_result = can_express_plus_mult_concat(target, tail, current_result * head, memo)

    concat_result = can_express_plus_mult_concat(
        target, tail, parse(Int, string(current_result) * string(head)), memo
    )

    memo[key] = add_result || mult_result || concat_result
    return memo[key]
end

function find_expressible_plus_mult(data)
    results = []
    for (target, numbers) in data
        if can_express_plus_mult(target, numbers[2:end], numbers[1], Dict())
            push!(results, target)
        end
    end
    return results
end

function find_expressible_plus_mult_concat(data)
    results = []
    for (target, numbers) in data
        if can_express_plus_mult_concat(target, numbers[2:end], numbers[1], Dict())
            push!(results, target)
        end
    end
    return results
end

file_path = "input.txt" 
open(file_path) do file
    data = parse_input(file)

    expressible_plus_mult = find_expressible_plus_mult(data)
    println(sum(expressible_plus_mult))

    expressible_plus_mult_concat = find_expressible_plus_mult_concat(data)
    println(sum(expressible_plus_mult_concat))
end
