class SanitizeTriviaTermsToBeAsciiStrings < ActiveRecord::Migration
  def self.up
    puts "àáâãäå".mb_chars.normalize(:kd).gsub(/[^\x00-\x7F]/n,'').downcase.to_s
    Trivia.find_each do|trivia|
      trivia.fact = trivia.fact.mb_chars.normalize(:kd).gsub(/[^\x00-\x7F]/n,'').downcase.to_s
      trivia.save!
    end
  end

  def self.down
  end
end
