#!/usr/bin/env ruby

require 'date'
require 'optparse'

class Calendar
  def initialize(year, month)
    @year = year
    @month = month
    @last_day = Date.new(@year, @month, -1)
    @first_day = Date.new(@year, @month, 1)
  end

  def print_result
    number_of_days
    what_day
    show_month_year
    show_week
    count = 0
    @days.each do |day|
      count += 1
      if day.class == String
        print day
      elsif day < 10
        print "#{day}  "
      else 
        print "#{day} "
      end
      if count % 7 == 0
        puts "\n"
      end
    end
    puts "\n"
  end
  
  def show_month_year
    print "      #{@month}月 #{@year}"
    puts "\n"
  end

  def show_week
    week = ["日", "月", "火", "水", "木", "金", "土"]
    week.each do |day|
      print "#{day} "
    end
    puts "\n"
  end

  def number_of_days
    @days = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10,
      11, 12, 13, 14, 15, 16, 17, 18, 19, 20,
      21, 22, 23, 24, 25, 26, 27, 28, 29, 30]
    case @last_day.day
      when 30
        @days
      when 31
        @days.push(31)
      when 28
        @days.pop(2)
      when 29
        @days.pop
    end
  end

  def what_day
    day = @first_day.strftime('%a')
    case day
      when "Mon"
        @days.unshift('   ')
      when "Tue"
        @days.unshift('   ', '   ')
      when "wed"
        @days.unshift('   ', '   ', '   ')
      when "Thu"
        @days.unshift('   ', '   ', '   ','   ')
      when "Fri"
        @days.unshift('   ', '   ', '   ', '   ', '   ')
      when "Sat"
        @days.unshift('   ', '   ', '   ','    ', '   ', '   ')
    end
  end
end

opt = OptionParser.new
option = {}
opt.on('-y VAL'){ |year|
  option[:year] = year.to_i
}
opt.on('-m VAL'){ |month|
  option[:month] = month.to_i
}
opt.parse!(ARGV)
Calendar.new(option[:year], option[:month]).print_result
