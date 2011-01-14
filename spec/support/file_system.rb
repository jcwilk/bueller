module FileSystem
  extend self

  def tmp_dir
    '/tmp/bueller_test'
  end

  def fixture_path(fixture = nil)
    path = File.join '../fixtures', fixture
    File.expand_path(path, File.dirname(__FILE__))
  end

  def remove_tmpdir!
    FileUtils.rm_rf(tmp_dir)
  end

  def create_tmpdir!
    FileUtils.mkdir_p(tmp_dir)
  end

  def git_dir_path
    File.join(FileSystem.tmp_dir, 'git') 
  end
end
