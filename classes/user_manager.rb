class UserManager

  # user_exists?() checks if a username already exists
  # registered users.
  #
  # == Example
  #
  #  # Check if the user "picat" exists or not.
  #  users = UserManager.new
  #  users.user_exists?("picat")
  #  => true
  #
  def user_exists?(username)
    Dir["private/accounts/*.yaml"].each do |user_file|
      return true if YAML.load_file(user_file)[:username] == username
    end
    false
  end

  # email_exists?() checks if an email is already registered
  #
  # == Example
  #
  #  # Check if the email "picat@emuiasa.io" exists or not.
  #  users = UserManager.new
  #  users.email_exists?("picat@emuiasa.io")
  #  => true
  #
  def email_exists?(email)
    Dir["private/accounts/*.yaml"].each do |user_file|
      return true if YAML.load_file(user_file)[:email] == email
    end
    false
  end

  # team_exists?() checks if that team exists or not
  # for any registered user
  #
  # == Example
  #
  #  # Check if the team "red" exists or not.
  #  users = UserManager.new
  #  users.team_exists?("red")
  #  => true
  #
  def team_exists?(team)
    Dir["private/accounts/*.yaml"].each do |user_file|
      return true if YAML.load_file(user_file)[:team] == team
    end
    false
  end

  # user_file() checks if a user_file exists
  # for any registered user and returns the file
  # name
  #
  # == Example
  #
  #  # Typical use case
  #  users = UserManager.new
  #  users.user_file("picat")
  #  => "private/accounts/account.yaml"
  #
  #  # If there is not a file for the username
  #  users = UserManager.new
  #  users.user_file("picat")
  #  => false
  #
  def user_file(username)
    Dir["private/accounts/*.yaml"].each do |user_file|
      return user_file if YAML.load_file(user_file)[:username] == username
    end
    false
  end

  # existing_users() return an array of the current
  # registered users as User objects.
  #
  # == Example
  #
  #  # Typical use to retrieve a list of users
  #  users = UserManager.new
  #  users.existing_users
  #  => ["picat", "peterpython", "blu3wing"]
  #
  def existing_users
    users = []
    Dir["private/accounts/*.yaml"].each do |user_file|
      users << YAML.load_file(user_file)[:username]
    end
    users
  end

  # load_scores() returns the scores for the registered
  # users as a bunch of hashes inside of an array.
  #
  # == Example
  #
  #  # Typical use to retrieve scores
  #  users = UserManager.new
  #  users.load_scores
  #  => [{:username=>"picat", :points=>0, :real_name=>"Kent Gruber"}]
  #
  #  # Typical use to retrieve scores for a specific team "red".
  #  users = UserManager.new
  #  users.load_scores(:team => "red")
  #  => [{:username=>"picat", :points=>0, :real_name=>"Kent Gruber", :team=>"red"}]
  #
  #  # Typical use to retrieve scores for a specific team "yellow", with
  #  # a real name of "Peter Pilarski"
  #  users = UserManager.new
  #  users.load_scores(:team => "yellow", :real_name=>"Peter Pilarski")
  #  => [{:username=>"peterpython", :points=>0, :real_name=>"Peter Pilarski", :team=>"yellow"}]
  #
  def load_scores(filter=false)
    scores = []
    Dir["private/accounts/*.yaml"].each do |user_file|
      user_data = YAML.load_file(user_file)
      if filter
        if filter[:username]
          next unless user_data[:username] == filter[:username]
        elsif filter[:points]
          next unless user_data[:points] == filter[:points]
        elsif filter[:real_name]
          next unless user_data[:real_name] == filter[:real_name]
        elsif filter[:team]
          next unless user_data[:team] == filter[:team]
        end
      end
      score = {}
      score[:username] = user_data[:username]
      score[:points] = user_data[:points]
      score[:real_name] = user_data[:real_name]
      score[:team] = user_data[:team] if user_data[:team]
      scores << score
    end
    return false if scores.empty?
    scores
  end

  # remove() method easily allows the user manager to remove users
  # based on their username
  #
  # == Examples
  #
  #  # Typical use case to remove a user.
  #  users = UserManager.new
  #  users.remove(:username => "picat")
  #  => true
  #
  def remove(params)
    if params[:username]
      if user_file(params[:username])
        delete_file(user_file(params[:username]))
      else
        false
      end
    end
  end

  # delete_file() will attempt to delete a file if it can and return
  # true, otherwise - if it cannot - it will return false.
  #
  # == Examples
  #
  #  # Typical use case to delete a file.
  #  users = UserManager.new
  #  users.delete_file("example_file.txt")
  #  => true
  #
  def delete_file(file)
    begin
      File.delete(file)
      true
    rescue
      false
    end
  end

  # debug() method to be able pry into this class's behavior
  #
  # == Examples
  #
  #  # Debug the UserManager class to see whaz up
  #  users = UserManager.new
  #  users.debug
  #  [1] pry(#<UserManager>)> _
  #
  def debug
    binding.pry
  end

end
