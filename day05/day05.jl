input = read("input.txt", String)

function parse_input(file_content::String)
    sections = split(file_content, "\n\n")
    rules_section = split(sections[1], "\n")
    updates_section = split(sections[2], "\n")

    rules = Vector{Tuple{Int,Int}}()
    for rule in rules_section
        rule_parts = split(rule, "|")
        push!(rules, (parse(Int, rule_parts[1]), parse(Int, rule_parts[2])))
    end

    updates = Vector{Vector{Int}}()
    for update in updates_section
        update_pages = parse.(Int, split(update, ","))
        push!(updates, update_pages)
    end

    return rules, updates
end

function is_update_in_order(update::Vector{Int}, rules::Vector{Tuple{Int,Int}})
    for (before, after) in rules
        if in(before, update) && in(after, update)
            before_idx = findfirst(x -> x == before, update)
            after_idx = findfirst(x -> x == after, update)
            if before_idx > after_idx
                return false
            end
        end
    end
    return true
end

function reorder_update(update::Vector{Int}, rules::Vector{Tuple{Int, Int}})
    ordered_update = copy(update) 
    changed = true

    while changed
        changed = false
        for (before, after) in rules
            if in(before, ordered_update) && in(after, ordered_update)
                before_idx = findfirst(x -> x == before, ordered_update)
                after_idx = findfirst(x -> x == after, ordered_update)
                if before_idx > after_idx
                    ordered_update[before_idx], ordered_update[after_idx] = ordered_update[after_idx], ordered_update[before_idx]
                    changed = true
                end
            end
        end
    end

    return ordered_update
end

function middle_page(update::Vector{Int})
    middle_idx = Int(floor(length(update) / 2)) + 1
    return update[middle_idx]
end

function solve_task(rules::Vector{Tuple{Int, Int}}, updates::Vector{Vector{Int}})
    sum_middle_pages_in_order = 0
    sum_middle_pages_reorder = 0
    
    for update in updates
        if is_update_in_order(update, rules)
            sum_middle_pages_in_order += middle_page(update)
        else
            ordered_update = reorder_update(update, rules)
            sum_middle_pages_reorder += middle_page(ordered_update)
        end
    end
    
    return sum_middle_pages_in_order, sum_middle_pages_reorder
end

rules, updates = parse_input(input)

sum_middle_pages_in_order, sum_middle_pages_reorder = solve_task(rules, updates)

println(sum_middle_pages_in_order)
println(sum_middle_pages_reorder)