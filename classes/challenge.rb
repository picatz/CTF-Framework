class Challenge
  attr_accessor :name, :title, :points, :type, :text, :flag, :strict

  # debug() method to be able pry into this class's behavior
  #
  # == Examples
  #
  #  # Debug the Challenge class to see whaz up
  #  challenge = Challenge.new
  #  challenge.debug
  #  [1] pry(#<UserManager>)> _
  #
  def debug
    binding.pry
  end

  # load_data() loads information about challenges
  #
  # == Example
  #
  #  # Load a user challenge called "hackthe"
  #  user = Challenge.new
  #  user.load_data(:name => "hackthe")
  #  => true
  #
  def load_data(filter)
    binding.pry
    challenge = Challenge.new
    YAML.load_file("config.yaml")[:name].each do |challenge|
      challenge = YAML.load_file("config.yaml")[:challenges]
      if filter[:name]
        next unless challenge[:name] == filter[:name]
      elsif filter[:tile]
        next unless challenge[:name] == filter[:name]
      elsif filter[:points]
        next unless challenge[:points] == filter[:points]
      elsif filter[:type]
        next unless challenge[:type] == filter[:type]
      elsif filter[:text]
        next unless challenge[:text] == filter[:text]
      elsif filter[:flag]
        next unless challenge[:flag] == filter[:flag]
      elsif filter[:strict]
        next unless challenge[:strict] == filter[:strict]
      end
    end
  end
end
