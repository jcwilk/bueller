require 'git'

module GitSupport
  extend self

  def project_name; 'the-perfect-gem'; end
  def git_name; 'foo'; end
  def git_email; 'bar@example.com'; end
  def github_user; 'technicalpickles'; end
  def github_token; 'zomgtoken'; end

  def valid_config
    { 'user.name' => git_name, 'user.email' => git_email, 'github.user' => github_user, 'github.token' => github_token }
  end

  def stub_config(options = {})
    Git.stub!(:global_config).and_return(options)
  end
end
