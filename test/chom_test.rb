require 'test_helper'

class ChomTest < Minitest::Test
  def setup
    @chom = Chom::App.new
  end

  def test_version_number
    refute_nil ::Chom::VERSION
  end

  def test_creation
    assert_equal true, @chom.instance_of?(Chom::App)
  end

  def test_user
    assert_equal ENV['USER'], @chom.user
  end

  def test_chown_dir_and_files_recursively
    Dir.mktmpdir do |dir|
      Dir.chdir dir
      file_permission_not_group_writable = '40700'
      assert_equal file_permission_not_group_writable, format('%o', File.stat('.').mode)
      assert_output "Attempting 'chown -R g+w .' as '#{ENV['USER']}'... Success!\n" do
        @chom.send(:chown_dir_and_files_recursively)
      end
      file_permission_group_writable = '40720'
      assert_equal file_permission_group_writable, format('%o', File.stat('.').mode) # ensure directory is group writable
    end
  end

  # def test_chmod_dir_and_files_recursively
  #   Dir.mktmpdir do |dir|
  #     Dir.chdir dir
  #     initial_group = Etc.getgrgid(File.stat('.').gid).name
  #     file_permission_not_group_writable = '40700'
  #     assert_equal file_permission_not_group_writable, format('%o', File.stat('.').mode)
  #     assert_output "Attempting 'chown -R g+w .' as '#{ENV['USER']}'... Success!\n" do
  #       @chom.send(:chmod_dir_and_files_recursively)
  #     end
  #     file_permission_group_writable = '40720'
  #     assert_equal file_permission_group_writable, format('%o', File.stat('.').mode) # ensure directory is group writable
  #   end
  # end
end
