class ChallengeManager

  # debug() method to be able pry into this class's behavior
  #
  # == Examples
  #
  #  # Debug the ChallengeManager class to see whaz up
  #  challenges = ChallengeManager.new
  #  challenges.debug
  #  [1] pry(#<UserManager>)> _
  #
  def debug
    binding.pry
  end

  # got_flag?() determines if a user has gotten the flag or
  # not by passing that job to the Engine
  #
  # == Examples
  #
  #  # Typical use case to check if the user has gotten the flag
  #  challenges = ChallengeManager.new
  #  challenges.got_flag?(challenge_name, flag_check)
  #  => true
  #
  #  # Typical use case if user has put in a bad flag
  #  challenges = ChallengeManager.new
  #  challenges.got_flag?(challenge_name, flag_check)
  #  => false
  #
  def got_flag?(challenge_name, flag_check)
    if challenge_exists?(challenge_name)
      challenge = load_challenges(:name => challenge_name, :count => 1 )
      Engine.new.process_flag( :flag => challenge[:flag], :submission => flag_check, :strict => challenge[:stirct])
    else
      false
    end
  end

  # challenge_exists?() determines if a challenge of a challenge
  # name exists or not.
  #
  # == Examples
  #
  #  # Typical use case to check if a challenge "hackthe" exists
  #  challenges = ChallengeManager.new
  #  challenges.challenge_exists?("hackthe")
  #  => true
  #
  #  # Typical use case if challenge "hackthe" doesn't exist
  #  challenges = ChallengeManager.new
  #  challenges.challenge_exists?("hackthe")
  #  => false
  #
  def challenge_exists?(challenge_name)
    YAML.load_file("config.yaml")[:challenges].each do |challenge|
      return true if challenge[:name] == challenge_name
    end
    false
  end

  # load_challenges() will load challenges and takes in an optional
  # filter option which is a hash to filter the different content
  # of a typical challenge including :name, :title, :points, :type,
  # and more.
  #
  # == Examples
  #
  #  # Typical use case to load all challenge
  #  challenges = ChallengeManager.new
  #  challenges.load_challenges
  #
  def load_challenges(filter=false)
    challenges = []
    YAML.load_file("config.yaml")[:challenges].each do |challenge|
      if filter
        if filter[:name]
          next unless challenge[:name] == filter[:name]
        elsif filter[:title]
          next unless challenge[:title] == filter[:title]
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
      challenges << challenge
    end
    return false if challenges.empty?
    if filter[:count]
      filtered_challenges = []
      count = filter[:count]
      if challenges.count >= count
        count.times do
          filtered_challenges << challenges.pop
        end
      else
        false
      end
      if count == 1
        return filtered_challenges[0]
      end
      return filtered_challenges
    end
    challenges
  end
end
