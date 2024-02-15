# frozen_string_literal: true

class Frame
  attr_reader :shots

  def initialize(shots, frame_number)
    @shots = shots
    @frame_number = frame_number
  end

  def calculate_score(frames)
    next_frame = frames[@frame_number + 1]
    after_next_frame = frames[@frame_number + 2]

    if next_frame.nil?
      current_frame_points_sum
    else
      current_frame_points_sum + bonus_points(next_frame, after_next_frame)
    end
  end

  private

  def current_frame_points_sum
    @shots.sum(&:point)
  end

  def bonus_points(next_frame, after_next_frame)
    if @shots[0].strike?
      strike_points(next_frame, after_next_frame)
    elsif spare?
      spare_points(next_frame)
    else
      0
    end
  end

  def strike_points(next_frame, after_next_frame)
    next_frame_points = next_frame.shots.map(&:point)
    after_next_frame_points = after_next_frame.shots.map(&:point) if after_next_frame

    if next_frame.shots[0].strike? && after_next_frame
      next_frame_points[0] + after_next_frame_points[0]
    else
      next_frame_points.take(2).sum
    end
  end

  def spare_points(next_frame)
    next_frame_points = next_frame.shots.map(&:point)
    next_frame_points[0]
  end

  def spare?
    @shots.sum(&:point) == 10
  end
end
