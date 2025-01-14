require 'bundler'
begin
  Bundler.setup
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end

require '<%= require_name %>'

require '<%= feature_support_require %>'
<% if feature_support_extend %>

World(<%= feature_support_extend %>)
<% end %>
