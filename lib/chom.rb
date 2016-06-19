require 'chom/version'
require 'fileutils'

# Chom is a command line utility that alters the permissions of your current directory and its subdirectories to work
# properly with your web server.
#
# Specificaly, it executes:
#   $ chown -R g+w .
#   $ chmod -R <username>:www .

module Chom
  # The App class stores Chom's functionality. It is executed with Chom::App.new.run.
  class App
    # @user is used throughout this class to reference logged in user's username.
    attr_reader :user

    # Creates Chom instance and assigns logged in user's username to @user.
    def initialize
      @user = Etc.getlogin
    end

    # Chom command line utility executes run to recursively chown and chmod the current directory.
    def run
      chown_dir_and_files_recursively
      chmod_dir_and_files_recursively
    end

    private

    # Recursively changes ownership of current directory to the logged in user with the group www.
    def chown_dir_and_files_recursively
      print "Attempting 'chown -R g+w .' as '#{@user}'... "
      FileUtils.chmod_R 'g+w', '.'
      puts 'Success!'
    rescue Errno::EPERM
      puts 'Failed.'
      suggest_running_as_sudo_and_exit
    end

    # Recursively changes permissions of current directory to be group writable.
    def chmod_dir_and_files_recursively
      print "Attempting 'chmod -R #{@user}:www' as '#{@user}'... "
      FileUtils.chown_R @user, 'www', '.'
      puts 'Success!'
    rescue Errno::EPERM
      puts 'Failed.'
      suggest_running_as_sudo_and_exit
    end

    # Suggests running chom using sudo if regular execution fails due to lack of rights.
    def suggest_running_as_sudo_and_exit
      puts "Try running with 'sudo chom'."
      exit false
    end
  end
end
