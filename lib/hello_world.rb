require 'thor'

class HelloWorld < Thor
  desc "greet", "Print hello world message"
  def greet
    puts "Hello World!"
  end
end
