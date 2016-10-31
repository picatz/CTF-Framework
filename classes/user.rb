class User
  attr_accessor :username, :password, :id, :points, :email, :real_name

  # create() sets up a new user and all the required information
  # that we will want to know about a user.
  #
  # == Example
  #
  #  # Typical use to create a new user
  #  user = User.new
  #  user.create(request, 'Kurt Cobain', 'kc', 'ilikerocknroll', 'kc@nirvana.com' )
  #  => true
  #
  def create(request, real_name, username, password, email, team = false )
    @id = SecureRandom.uuid
    @username = username
    @password = hash_plaintext(password)
    @points = 0
    @email = email
    @real_name = real_name
    @team = team if team
    @created = Time.now
    @submissions = 0
    @failed_submissions = 0
    @successful_submissions = 0
    @completed_challenges = []
    @associated_ips = []
    @associated_ips << request.ip
    @associated_user_agents = []
    @associated_user_agents << request.user_agent
    save_data
  end

  # data() makes a hashed version of the information about a user
  #
  # == Example
  #
  #  # Typical use to get a hashed version of a user's "bob" data
  #  user = User.new
  #  user.load("bob")
  #  => true
  #  user.data
  #  => hash is returned
  #
  def data
    user = {}
    user[:id] = @id
    user[:username] = @username
    user[:password] = @password
    user[:points] = @points
    user[:email] = @email
    user[:real_name] = @real_name
    user[:team] = @team
    user[:created] = @created
    user[:submissions] = @submissions
    user[:failed_submissions] = @failed_submissions
    user[:successful_submissions] = @successful_submissions
    user[:completed_challenges] = @completed_challenges
    user[:associated_ips] = @associated_ips
    user[:associated_user_agents] = @associated_user_agents
    user
  end

  # save_data() saves information about the user
  #
  # == Example
  #
  #  # Create a new user, change something (like points) and save
  #  user = User.new
  #  user.create(request, 'Kurt Cobain', 'kc', 'ilikerocknroll', 'kc@nirvana.com' )
  #  user.points = 9001
  #  user.save_data
  #  => true
  #
  def save_data
    File.open("private/accounts/#{@id}.yaml", "w") { |f| f.write data.to_yaml }
    true
  end

  # load_data() loads information about pre-existing users
  #
  # == Example
  #
  #  # Create a new user object and load a user "picat"
  #  user = User.new
  #  user.load_data("picat")
  #  => true
  #
  def load_data(username, fast = false)
    users = UserManager.new
    if users.user_exists?(username)
      user = YAML.load_file(users.user_file(username))
      @id = user[:id]
      @username = user[:username]
      @password = user[:password]
      unless fast
        @points = user[:points]
        @email = user[:email]
        @real_name = user[:real_name]
        @team = user[:team] if user[:team]
        @created = user[:created]
        @submissions = user[:submissions]
        @failed_submissions = user[:failed_submissions]
        @successful_submissions = user[:successful_submissions]
        @completed_challenges = user[:completed_challenges]
        @associated_ips = user[:associated_ips]
        @associated_user_agents = user[:associated_user_agents]
      end
      data
    else
      false
    end
  end

  # hash_plaintext() hashes a plaintext password with
  # or without a pre-determine salt.
  #
  # == Examples
  #
  #  # Create a new hashed password with a plaintext password
  #  user = User.new
  #  user.hash_plaintext("strongpassword")
  #
  #  # Hash a password with a pre-existing salt.
  #  user = User.new
  #  user.hash_plaintext("strongpassword", "salty")
  #
  def hash_plaintext(plaintext_password, salt=false)
    if salt
      salted_hash = BCrypt::Engine.hash_secret(plaintext_password, salt)
      salt + salted_hash.gsub(salt,'|||')
    else
      salt = BCrypt::Engine.generate_salt
      salted_hash = BCrypt::Engine.hash_secret(plaintext_password, salt)
      salt + salted_hash.gsub(salt,'|||')
    end
  end

  # password_match?() checks if this application's custom formated
  # hashed password matches the plaintext password when given the
  # same salt.
  #
  # == Examples
  #
  #  # Check if the plaintext password matches the user hashes password
  #  # when hashed with the same salt.
  #  user = User.new
  #  user.load("picat")
  #  user.password
  #  => "$2a$10$LYnAOR7xExBJteBVTatQAO|||AeleEF4vpc5uFOYcqK4ZnU7AHjHZYUy"
  #  user.password_match?("strongpassword")
  #  => false
  #  user.password_match?("strongerpassword")
  #  => true
  #
  def password_match?(password)
    salt = @password.split('|||').first
    if @password == hash_plaintext(password, salt)
      true
    else
      false
    end
  end

  # add_points() takes in two parameters
  # as a hash which are optional the :username and :challenge
  # to be able to add points to a user
  #
  # == Example
  #
  #  # Typical use case to add 100 points to a user "picat".
  #  user = User.new
  #  user.load_data("picat")
  #  user.add_points(:points => 100)
  #  => true
  #
  def add_points(params=false)
    load_data(params[:username]) if params[:username]
    if params[:points]
      @points += params[:points].to_i
      save_data
      return true
    end
    false
  end

  # add_completed_challenge() takes in two parameters
  # as a hash which are optional the :username and :challenge
  # to be able to add a completed challenge to a user's associated
  # data
  #
  # == Example
  #
  #  # Typical use case to check if a user has already
  #  # completed a challenge or not.
  #  user = User.new
  #  user.load_data("picat")
  #  user.add_completed_challenge(:challenge => "hackthe")
  #  => true
  #
  def add_completed_challenge(params)
    load_data(params[:username]) if params[:username]
    if params[:challenge]
      @completed_challenges << params[:challenge]
      save_data
      return true
    end
    false
  end

  # already_completed_challenge?() takes in two parameters
  # as a hash which are optional the :username and :challenge
  #
  #
  # == Example
  #
  #  # Typical use case to check if a user has already
  #  # completed a challenge or not.
  #  user = User.new
  #  user.load_data("picat")
  #  user.already_already_completed_challenge?(:challenge => "hackthe")
  #  => true
  #
  def already_completed_challenge?(params)
    load_data(params[:username]) if params[:username]
    if params[:challenge]
      @completed_challenges.include?(params[:challenge])
    end
  end

  # debug() method to be able pry into this class's behavior
  #
  # == Examples
  #
  #  # Debug the User class with the user "picat"'s information
  #  user = User.new
  #  user.load("picat")
  #  user.debug
  #  [1] pry(#<User>)> _
  #
  def debug
    binding.pry
  end

end
