require 'chom/version'
require 'fileutils'

# +Chom+ is a command line utility that alters the permissions of your
# current directory and its subdirectories to work properly with your web
# server.
#
# Specificaly, it executates `chown -R g+w .` and `chmod -R <username>:www .`

module Chom
  # +Chom's+ functionality is stored in its App class and executed with Chom.new.run
  class App
    # @user is used through this class to reference logged in user's username
    attr_reader :user

    # When a Chom instance is created, logged in user's username is stored in @user
    def initialize
      @user = Etc.getlogin
    end

    # `chom` command line utility executes `run` to both chown and chmod currently
    # directory recursively
    def run
      chown_dir_and_files_recursively
      chmod_dir_and_files_recursively
    end

    private

    def chown_dir_and_files_recursively
      print "Attempting 'chown -R g+w .' as '#{@user}'... "
      FileUtils.chmod_R 'g+w', '.'
      puts 'Success!'
    rescue Errno::EPERM
      puts 'Failed.'
      suggest_running_as_sudo_and_exit
    end

    def chmod_dir_and_files_recursively
      print "Attempting 'chmod -R #{@user}:www' as '#{@user}'... "
      FileUtils.chown_R @user, 'www', '.'
      puts 'Success!'
    rescue Errno::EPERM
      puts 'Failed.'
      suggest_running_as_sudo_and_exit
    end

    def suggest_running_as_sudo_and_exit
      puts "Try running with 'sudo chom'."
      exit false
    end
  end
end
