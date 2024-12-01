using DelimitedFiles

lists = readdlm("input.txt", Int64)

left_list = lists[:, 1]
right_list = lists[:, 2]

sort!(left_list)
sort!(right_list)

total_distance = sum(abs.(left_list .- right_list))
