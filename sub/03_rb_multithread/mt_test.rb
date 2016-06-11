#!/usr/bin/env ruby
# Ruby $B$K$h$k4JC1$J%^%k%A%9%l%C%I(B

require "io/console"
 
view_thread = Thread.new do
  loop do
    print "\033[2K\r#{Time.now.strftime("%F %T")}"
    sleep 1
  end
end
 
input_thread = Thread.new do
#  while STDIN.getch != "q"; end
  while STDIN.getch != "q" 
    puts
    puts STDIN.getch
  end
  puts
  view_thread.kill
end
 
view_thread.join
input_thread.join
