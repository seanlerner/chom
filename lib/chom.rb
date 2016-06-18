require 'chom/version'
require 'fileutils'

module Chom
  class App
    class << self
      attr_accessor :user
    end

    @user = ENV['USER']

    def self.run
      puts 'Starting.'
      # chom
    rescue SystemCallError => e # TODO: maybe try errno::whatever it was before
      # system 'sudo -s'
      system('sudo -s ')
      chom
      system 'exit'
    ensure
      puts 'Finished.'
    end

    def chom
      # chown_dir_and_files_recursively
      # chmod_dir_and_files_recursively
    end

    def self.chown_dir_and_files_recursively
      FileUtils.chmod_R 'g+w', '.'
    end

    def self.chmod_dir_and_files_recursively
      FileUtils.chown_R @user, 'www', '.'
    end
  end
end

# ruby -e "require '../lib/chom.rb'; Chom::App.run"
