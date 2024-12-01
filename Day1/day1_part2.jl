using DelimitedFiles

lists = readdlm("input.txt", Int64)

left_list = lists[:, 1]
right_list = lists[:, 2]

similarity_score = 0

for element in left_list
    count = sum(right_list .== element) 
    global similarity_score += element * count
end

println(similarity_score)