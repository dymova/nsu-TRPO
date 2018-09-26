def compute_list_of_strings(input_chars, n)
  # if n == 0
  #   return []
  # end

  (1..n).reduce([""]) {|resultList|
    resultList.reduce([]) {|tmpList, word|
      tmpList + input_chars.select {|char| char != word[-1]}.map {|char| word + char}
    }
  }
end


print compute_list_of_strings(%w(a b c), 0)
