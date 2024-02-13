# frozen_string_literal: true

class Frame
  attr_reader :shots, :score

  def initialize(shots, frame_number)
    @shots = shots
    @frame_number = frame_number
  end

  def calculate_score(frames)
    next_frame = next_frame(frames)
    after_next_frame = after_next_frame(frames)

    current_frame_score_sum = @shots.sum(&:point)
    next_frame_score = next_frame.shots.map(&:point) if next_frame
    after_next_frame_score = after_next_frame.shots.map(&:point) if after_next_frame

    if next_frame.nil?
      current_frame_score_sum
    elsif @shots[0].strike?
      if next_frame.shots[0].strike? && after_next_frame
        current_frame_score_sum + next_frame_score[0] + after_next_frame_score[0]
      else
        current_frame_score_sum + next_frame_score[0] + next_frame_score[1]
      end
    elsif spare?
      current_frame_score_sum + next_frame_score[0]
    else
      current_frame_score_sum
    end
  end

  def spare?
    @shots.sum(&:point) == 10
  end
end

private

def next_frame(frames)
  frames[@frame_number + 1]
end

def after_next_frame(frames)
  frames[@frame_number + 2]
end
