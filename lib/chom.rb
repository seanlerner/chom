require 'chom/version'
require 'fileutils'
require 'colorize'

module Chom
  class App
    attr_reader :user

    def initialize
      @user = ENV['SUDO_USER']
    end

    def run
      chown_dir_and_files_recursively
      chmod_dir_and_files_recursively
    end

    def chown_dir_and_files_recursively
      print "Attempting 'chown -R g+w .' as '#{@user}'... "
      FileUtils.chmod_R 'g+w', '.'
      puts 'Success!'.green
    rescue Errno::EPERM
      puts 'Failed.'.red
      suggest_running_as_sudo_and_exit
    end

    def chmod_dir_and_files_recursively
      print "Attempting 'chmod -R #{@user}:www' as '#{@user}'... "
      FileUtils.chown_R @user, 'www', '.'
      puts 'Success!'.green
    rescue Errno::EPERM
      puts 'Failed.'.red
      suggest_running_as_sudo_and_exit
    end

    def suggest_running_as_sudo_and_exit
      puts "Try running with 'sudo chom'".yellow
      exit 1
    end
  end
end
