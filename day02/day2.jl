lines = readlines("input.txt")
reports = [parse.(Int, split(line)) for line in lines]

function is_safe(report)
    is_monotonic = all(diff(report) .> 0) || all(diff(report) .< 0)
    difference_okay = all(1 .<= abs.(diff(report)) .<= 3)

    return is_monotonic && difference_okay
end

function can_be_made_safe(report)
    for i in 1:length(report)
        new_report = [report[j] for j in 1:length(report) if j != i]
        if is_safe(new_report)
            return true
        end
    end
    return false
end    

safe_count = sum(is_safe(row) for row in data)
new_safe_count = sum(is_safe(row) || can_be_made_safe(row) for row in data)

println(safe_count)
println(new_safe_count)