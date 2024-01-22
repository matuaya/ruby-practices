# frozen_string_literal: true

require_relative 'score_calculator'

class Game
  FINAL_FRAME = 9
  def initialize(game)
    @game = game
  end

  def calculate_score
    # 最終的な合計スコアを計算する
    generate_frames_from_game

    points = 0
    @frames.each_with_index do |frame, frame_number|
      current_frame = frame
      next_frame = @frames[frame_number + 1]
      next_next_frame = @frames[frame_number + 2]

      score_calculator = ScoreCalculator.new(current_frame, next_frame, next_next_frame)
      points += score_calculator.calculate_current_frame_score
    end
    points
  end

  private

  def generate_frames_from_game
    # ショットを10フレームに分ける
    game_shots = @game.split(',')
    shots = game_shots.map { |shot| shot == 'X' ? %w[X 0] : shot }.flatten

    @frames = []
    final_frame = []
    shots.each_slice(2).each_with_index do |shot_pair, frame_number|
      if frame_number < FINAL_FRAME
        @frames << Frame.new(shot_pair)
      else
        final_frame << shot_pair
      end
    end

    final_frame_shots = final_frame.map { |final_frame_shot| final_frame_shot[0] == 'X' ? 'X' : final_frame_shot }.flatten
    @frames << Frame.new(final_frame_shots)
  end
end

game = ARGV[0]
puts Game.new(game).calculate_score
