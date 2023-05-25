n = 1
while n <= 20
  if n % 3 == 0 && n % 5 == 0
    puts "FizzBuzz"
  elsif n % 3 == 0
    puts "Fizz"
  elsif n % 5 == 0
    puts "Buzz"
  else 
    puts n
  end
  n += 1
end
