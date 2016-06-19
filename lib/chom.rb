require 'chom/version'
require 'fileutils'

# Chom is a command line utility that alters the permissions of your current directory and its subdirectories to work
# properly with your web server.
#
# Specificaly, it executes:
#   $ chown -R g+w .
#   $ chmod -R <username>:<system www group> .

module Chom
  # The App class stores Chom's functionality. It is executed with Chom::App.new.run.
  class App
    attr_reader :user

    # Creates Chom instance and sets user and group
    def initialize
      @user = Etc.getlogin
      @group = system_www_group
    end

    # Chom command line utility executes run to recursively chown and chmod the current directory.
    def run
      chown_dir_and_files_recursively
      chmod_dir_and_files_recursively
    end

    private

    # Figure out system www group
    def system_www_group
      %w(www-data www).each do |possible_www_group|
        begin
          return possible_www_group if Etc.getgrnam possible_www_group
        rescue ArgumentError
          next
        end
      end
      failure_exit_with_msg "I can't figure out the proper www group for this system."
    end

    # Recursively changes ownership of current directory to the logged in user with the group www.
    def chown_dir_and_files_recursively
      print "Attempting 'chown -R g+w .' as '#{@user}'... "
      FileUtils.chmod_R 'g+w', '.'
      puts 'Success!'
    rescue Errno::EPERM
      failure_exit_with_msg sudo_msg
    end

    # Recursively changes permissions of current directory to be group writable.
    def chmod_dir_and_files_recursively
      print "Attempting 'chmod -R #{@user}:#{@group}' as '#{@user}'... "
      FileUtils.chown_R @user, @group, '.'
      puts 'Success!'
    rescue Errno::EPERM
      failure_exit_with_msg sudo_msg
    end

    # Suggests running chom using sudo if regular execution fails due to lack of rights.
    def failure_exit_with_msg(msg)
      puts 'Failed.'
      puts msg
      exit false
    end

    # Failure Message for both chown and chmod
    def sudo_msg
      "Try running with 'sudo chom'."
    end
  end
end
