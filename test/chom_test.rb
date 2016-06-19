require 'test_helper'

class ChomTest < Minitest::Test
  def setup
    @chom = Chom::App.new
    @user = Etc.getlogin
  end

  def expected_chown_output
    "Attempting 'chown -R g+w .' as '#{@user}'... Success!\n"
  end

  def expected_chmod_output
    "Attempting 'chmod -R #{@user}:www' as '#{@user}'... Failed.\nTry running with 'sudo chom'.\n"
  end

  def test_version_number
    refute_nil ::Chom::VERSION
  end

  def test_creation
    assert_equal true, @chom.instance_of?(Chom::App)
  end

  def test_user
    assert_equal @user, @chom.user
  end

  def test_run
    Dir.mktmpdir do |dir|
      Dir.chdir dir
      assert_output "#{expected_chown_output}#{expected_chmod_output}" do
        assert_raises Exception do
          @chom.run
        end
      end
    end
  end

  def test_chown_dir_and_files_recursively
    file_permission_not_group_writable = '40700'
    file_permission_group_writable = '40720'
    Dir.mktmpdir do |dir|
      Dir.chdir dir
      dir_permissions_before_chown = format('%o', File.stat('.').mode)
      assert_equal file_permission_not_group_writable, dir_permissions_before_chown
      assert_output expected_chown_output do
        @chom.send(:chown_dir_and_files_recursively)
      end
      dir_permissions_after_chown = format('%o', File.stat('.').mode)
      assert_equal file_permission_group_writable, dir_permissions_after_chown
    end
  end

  def test_chmod_dir_and_files_recursively
    Dir.mktmpdir do |dir|
      Dir.chdir dir
      assert_output expected_chmod_output do
        assert_raises Exception do
          @chom.send(:chmod_dir_and_files_recursively)
        end
      end
    end
  end

  def test_suggest_running_as_sudo_and_exit
    assert_raises Exception do
      assert_output "Try running with 'sudo chom'." do
        @chom.send(:suggest_running_as_sudo_and_exit)
      end
    end
  end
end
