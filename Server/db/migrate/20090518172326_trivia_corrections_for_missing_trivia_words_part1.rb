class TriviaCorrectionsForMissingTriviaWordsPart1 < ActiveRecord::Migration
  def self.up
    #t = Trivia.find(15)
    #puts t.fact.inspect
    #t.fact = "The first commercial espresso machine was manufactured in Italy in 1906."
    #t.save!
    missing_periods = []
    Trivia.find_each do|t|
      missing_periods << t if not t.fact.match(/\.$/)
    end
    for t in missing_periods do
      puts "#{t.id} => #{t.fact}"
    end
    # fixes for
    if missing_periods.size == 9
      missing_periods[1].fact = "The prototype of the first espresso machine was created in France in 1822."
      missing_periods[1].save!
      missing_periods[2].fact = "The first commercial espresso machine was manufactured in Italy in 1906."
      missing_periods[2].save!
      missing_periods[3].fact = "Those British are sophisticated people, in almost everything except their choice of coffee. They still drink instant ten-to-one over fresh brewed."
      missing_periods[3].save!
      missing_periods[4].fact = "The Venetians first introduced coffee to Europe in 1615."
      missing_periods[4].save!
      missing_periods[5].fact = "William Penn purchased a pound of coffee in New York in 1683 for $4.68."
      missing_periods[5].save!
      missing_periods[6].fact = "Iced coffee in a can has been popular in Japan since 1945."
      missing_periods[6].save!
    end
  end

  def self.down
  end
end
