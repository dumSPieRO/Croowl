require 'curb'
require 'nokogiri'

class Loader
  def load(urls)

  end
end

class Test

  def start_testing(*params)
    puts "Start testing"
  end

  def finish_testing(*params)
    puts "Finish test"
  end

  def result?(result, test_result )
    test_result == result
  end

  def get_test_results(*params)
    [1, 2, nil, 3, 4, 5, nil]
  end

  def get_method_result(method, *params)
    #Todo: Block rename
    block = lambda{
      puts "  Params #{params}"
      method.call(*params)
    }
    params == [] ? method.call :  block.call
  end

  def get_params(*params)
    [1, 2, 3, 5, 5]
  end

  def run(method)
    correct = 0
    incorrect = 0
    incorrectly = []
    errors = 0
    bl = lambda { |elem|
      incorrect += 1
      incorrectly.append(elem)
    }
    start_testing
    puts "Method: #{method}"
    tests  = get_test_results
    params = get_params
    tests.each_with_index do |current_test, i|
      puts " #{i}. Start test number #{i}"
      start_testing
      puts " Method #{method.name} say:"
      res = get_method_result(method, *params[i])
      result = result?(res, current_test)
      result ? correct += 1 : bl.call(i)
      puts " Result test numb #{i}:: \n  :(T-> \"#{current_test}\" ---> R-> \"#{res}\"):#{result} "
      finish_testing
      puts "Finish test number #{i}\n "
    end
    puts "Method: #{method}"
    puts "Result tests::"
    puts "            ::Sum: #{tests.length}"
    puts "            ::Correct: #{correct}"
    puts "            ::Incorrectly: #{incorrect} --> (#{incorrectly})"
    puts "            ::Errors: #{errors}"
  end
end

def lol(*pa)
end

test = Test.new
meth = method(:lol)

puts test.run(meth)
