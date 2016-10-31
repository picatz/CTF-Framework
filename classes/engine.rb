class Engine

  # process_flag() processes a flag, taking in one required
  # key in the params hash passed in, the :flag param; and then
  # one optional param, the :strict parameter which will
  # help determine to use the Engine's wiggle method or not.
  #
  # == Example
  #
  #  # Typical use case to process a flag in the Engine
  #  engine = Engine.new
  #  engine.process_flag(:flag => "Ruby", :submission => "ruby")
  #  => true
  #
  #  # Typical use case to process a flag in a strict manner
  #  engine = Engine.new
  #  engine.process_flag(:strict => true, :flag => "Ruby", :submission => "ruby")
  #  => false
  #
  def process_flag(params)
    if params[:strict]
      params[:flag] == params[:submission]
    else
      wiggle(params[:flag]) == wiggle(params[:submission])
    end
  end

  # wiggle() will allow for some wiggle room for the user when they
  # attempt to submit a flag into the engine. This allow for things like
  # bogus whitespace and capitalization spelling errors to be mitigated.
  # Essentially, being a little nicer to your users when they submit a flag.
  #
  # == Example
  #
  #  # Typical use case to wiggle a string
  #  engine = Engine.new
  #  engine.wiggle("Kent Gruber")
  #  => "reburgtnek"
  #  engine.wiggle("KEnt      gRuber  ")
  #  => "reburgtnek"
  #
  def wiggle(flag)
    flag.strip.gsub(' ','').downcase.reverse
  end
end
