require 'cucumber'
require 'cucumber/rake/task'

desc 'Cucumber meets iPod'

task :test => :cukes

Cucumber::Rake::Task.new(:cukes) do |t|

  t.cucumber_opts = [
                     "-t ~@restart",
                     "-t ~@failz",
                     "--format progress -o log/cucumber.log",
                     "--format html     -o log/index.html",
                     "--format junit    -o log/",
                     "--format pretty"]
end


