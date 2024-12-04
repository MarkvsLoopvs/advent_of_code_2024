using DelimitedFiles

lists = readdlm("input.txt", Int64)

left_list = lists[:, 1]
right_list = lists[:, 2]

similarity_score = 0

for element in left_list
    count = sum(right_list .== element) 
    global similarity_score += element * count
end

sort!(left_list)
sort!(right_list)

total_distance = sum(abs.(left_list .- right_list))
println(total_distance)
println(similarity_score)