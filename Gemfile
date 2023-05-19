source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?('/')
  "https://github.com/#{repo_name}.git"
end

platforms :ruby do
  if ENV['DB'] == 'mysql'
    gem 'mysql2'
  else
    gem 'pg', '~> 1.1'
  end
end

gem 'deface', '~> 1.0'
gem 'rails-controller-testing'
gem 'spree', github: 'spree/spree', branch: 'main'
gem 'spree_backend', github: 'spree/spree_backend', branch: 'main'

gemspec
