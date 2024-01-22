# frozen_string_literal: true

require_relative 'frame'

class ScoreCalculator
  # フレームがストライクか、スペアか、それ以外かで、そのフレームのスコアの計算方法を変える
  def initialize(current_frame, next_frame = nil, next_next_frame = nil)
    @current_frame = current_frame
    @next_frame = next_frame if next_frame
    @next_next_frame = next_next_frame if next_next_frame

    @current_frame_sum = @current_frame.first_shot + @current_frame.second_shot + @current_frame.third_shot
  end

  def calculate_current_frame_score
    if @next_frame.nil?
      calculate_open_frame
    elsif @current_frame.shot_type == 'strike'
      calculate_strike
    elsif @current_frame.shot_type == 'spare'
      calculate_spare
    else
      calculate_open_frame
    end
  end

  private

  def calculate_open_frame
    @current_frame_sum
  end

  def calculate_strike
    if @next_frame.first_shot == 10 && @next_next_frame
      @current_frame_sum + @next_frame.first_shot + @next_next_frame.first_shot
    else
      @current_frame_sum + @next_frame.first_shot + @next_frame.second_shot
    end
  end

  def calculate_spare
    @current_frame_sum + @next_frame.first_shot
  end
end
