require 'rake/clean'

namespace :community_engine_wikis do
	desc 'Test the community_engine_wikis plugin.'
	Rake::TestTask.new(:test) do |t|
		t.libs << 'lib'
		t.pattern = 'vendor/plugins/community_engine_wikis/test/**/*_test.rb'
		t.verbose = true
	end
	Rake::Task['community_engine_wikis:test'].comment = "Run the community_engine_wikis plugin tests."
end