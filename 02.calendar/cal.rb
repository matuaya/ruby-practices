#!/usr/bin/env ruby

require 'date'
require 'optparse'

class Calendar
  WEEK = ["日", "月", "火", "水", "木", "金", "土"]
  def initialize(year = Date.today.year, month = Date.today.month)
    @year = year
    @month = month
    @last_day = Date.new(@year, @month, -1)
    @first_day = Date.new(@year, @month, 1)
  end

  def print_result
    show_month_year
    show_week
    number_of_blanks

    (@first_day..@last_day).each do |date|
      print date.day.to_s.rjust(3)
      puts if date.wday == 6
    end
  end
  
  def show_month_year
    puts "       #{@month}月 #{@year}"
  end

  def show_week
    puts " #{ WEEK.join(' ')}"
  end

  def number_of_blanks
    print '   '* @first_day.wday
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
year = option[:year] || Date.today.year
month = option[:month] || Date.today.month
Calendar.new(year, month).print_result
