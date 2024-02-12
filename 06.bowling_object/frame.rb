# frozen_string_literal: true

require_relative 'shot'

class Frame
  attr_reader :shots, :score

  def initialize(shot_pair, frame_number)
    @shots = shot_pair
    @frame_number = frame_number
    @score = @shots.map(&:convert_to_int)
  end

  def calculate_score(frames)
    current_frame = frames[@frame_number]
    next_frame = frames[@frame_number + 1]
    after_next_frame = frames[@frame_number + 2]

    current_frame_score_sum = @score.sum

    if next_frame.nil?
      current_frame_score_sum
    elsif current_frame.strike?
      if next_frame.strike? && after_next_frame
        current_frame_score_sum + next_frame.score[0] + after_next_frame.score[0]
      else
        current_frame_score_sum + next_frame.score[0] + next_frame.score[1]
      end
    elsif current_frame.spare?
      current_frame_score_sum + next_frame.score[0]
    else
      current_frame_score_sum
    end
  end

  def strike?
    @score[0] == 10
  end

  def spare?
    @score.sum == 10
  end
end
