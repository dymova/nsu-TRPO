class ParallelArray < Array
  @thread_count = 4

  def thread_count=(pool_size)
    @thread_count = pool_size
  end

  def map(&block)
    run_parallel {|chunk| chunk.map {|element| block.call(element)}}
        .reduce([]) {|result, chunk| result + chunk}
  end

  def any?(&block)
    run_parallel {|chunk| chunk.any? {|element| block.call(element)}}.any?
  end

  def all?(&block)
    run_parallel {|chunk| chunk.all? {|element| block.call(element)}}.all?
  end

  def select(&block)
    run_parallel {|chunk| chunk.select {|element| block.call(element)}}
        .reduce([]) {|result, chunk| result + chunk}
  end

  def run_parallel(&block)
    chuck_count = size / @thread_count
    threads = []
    each_slice(chuck_count).map {|slice|
      threads << Thread.new {
        block.call(slice)
      }
    }
    threads.map {|thread| thread.join.value}
  end

end


parallel_array = ParallelArray.new(5) {|i| i}
parallel_array.thread_count = 4
print "initial array ", parallel_array, "\n"

print "map_result ", parallel_array.map {|i| i * i}, "\n"
print "select_result ", parallel_array.select {|i| i != 2}, "\n"
print "any_result ", parallel_array.any? {|i| i == 2}, "\n"
print "all_result ", parallel_array.all? {|i| i < 10}, "\n"


