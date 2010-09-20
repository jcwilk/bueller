require 'git'

module GitSupport
  extend self

  def project_name; 'the-perfect-gem'; end
  def name; 'foo'; end
  def email; 'bar@example.com'; end
  def github_user; 'technicalpickles'; end
  def github_token; 'zomgtoken'; end

  def valid_config
    { 'user.name' => name, 'user.email' => email, 'github.user' => github_user, 'github.token' => github_token }
  end

  def stub_config(options = {})
    Git.stub!(:global_config).and_return(options)
  end
end
