class Card
  COLORS = [ :red, :green, :blue, :yellow ]
  ACTIONS = [ :skip, :reverse, :plus2 ]

  attr_reader :color, :value
  attr_writer :color

  def initialize color, value=nil, wild=false
    @color, @value, @wild = color, value, wild
  end

  def to_s

    if @value
      "#{@color.to_s[0..0]}/#{@value}"
    else
      @color.to_s[0..0]
    end

  end

  def wild?
    @wild
  end

  def Card.deck
    deck = []

    # 4 of each wild type
    4.times {
      deck << Card.new(nil, nil, true)
      deck << Card.new(nil, :plus4, true)
    }

    # one 0 for each color
    COLORS.each { |c| deck << Card.new(c, 0) }

    # two of each action and number per color
    2.times do

      COLORS.each do |c|
        ACTIONS.each { |a| deck << Card.new(c, a) }
        (1..9).each { |n| deck << Card.new(c, n) }
      end

    end

    deck
  end

end

