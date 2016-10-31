#!/usr/bin/env ruby

require 'pry'

module Sinatra
  module App
    module Helpers

      # username() grabs the username stored in the user's
      # session or returns false if there is no username
      # associated with the session
      #
      # == Example
      #
      #  # Typical use case to get a session's username
      #  username
      #  => picat
      #
      def username
        session[:username] ? session[:username] : false
      end

      # is_authenticated?() checks if a user is authenticated
      # by checking if they have a username associated with their
      # session or not.
      #
      # == Example
      #
      #  # Typical use case if a user is logged in
      #  is_authenticated?
      #  => true
      #
      #  # Typical use case if a user isn't logged in
      #  is_authenticated?
      #  => false
      #
      def is_authenticated?
        return !!session[:username]
      end

      # is_authenticated?() helps ensure some content
      # is for users which are authenticated only and
      # will redirect users if they are not.
      #
      # == Example
      #
      #  # Typical use to require a page be for authenticated
      #  # users only.
      #  require_logged_in
      #
      def require_logged_in
        redirect('/') unless is_authenticated?
      end

      # points() will get points for a user in a session if they
      # are logged in as that user
      #
      # == Example
      #
      #  # Typical use case to check points.
      #  points
      #  => 200
      #
      def points
        username ? user_data(username)[:points] : false
      end

      # user_data() will get the associated data for a user
      # in a hash.
      #
      # == Example
      #
      #  # Typical use case to check points.
      #  user_data("picat")
      #  => returns a hash
      #
      def user_data(user_name)
        user = User.new
        user.load_data(user_name)
        user.data
      end

    end
  end
end
