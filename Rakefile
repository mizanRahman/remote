require 'rubygems'
require 'uri'
require './util.rb'

# @hostname = "192.168.33.10"
# @username = "vagrant"
# @password = "vagrant"

@hostname = "49.0.39.237"

@username = "vagrant"
@password = "vagrant"


desc "connect to server"
task :connect do
	ssh do |session|
		puts "connecing to #{@hostname}"
	    run session, 'uname -a'
	    puts "connected."
	end
end

desc "show server info"
task :info => [] do
	ssh do |session|
	    run session, 'uname -a'
    	run session, 'top'
	end
end

desc "network status"
task :network => [:netcat] do
	ssh do |session|
   		run session,'netstat -nap| grep tcp'
	end
end

desc "network status"
task :netcat =>[] do
	ssh do |session|
		netcat session, [21,22,80,8080,3000,1531,3306]
	end
end

desc "web service status"
task :http, [:arg1] => [] do
		File.open(".health_check", "r").each do |line|

			if line =~ URI::regexp
			    url = line.strip
				check_health url, true
			else
				puts "#{line.strip} invalid url. skipping..."
			end

		end
end


desc "service status"
task :service, [:arg1] => [] do
	ssh do |session|
		run session, 'for qw in `ls /etc/init.d/*`; do  $qw status | grep -i running; done'
	end
end


desc "resolve host by pinging the host"
task :resolve => [] do
	ssh do |session|
		resolve_etc_hosts session, ['app1.kpp.com','localhost', 'google.com']
	end
end


desc "resolve host by pinging the host"
task :backup => [] do
	ssh do |session|
		backup session, ['config/*.properties','server/war/*.war']
	end
end


desc "resolve host by pinging the host"
task :changelog => [] do
	system "git status"
	hash = `git rev-parse HEAD`
	puts "hash=#{hash}"
	commit_hash_file=".commit_hash"
	
	last_hash = File.open(commit_hash_file, "a+").first
	puts "last_hash=#{last_hash}"

	# last_hash = "e6504cf"

	if last_hash != hash
		cmd = "git log #{last_hash}..  --oneline"
		puts cmd
		system cmd
		puts "updating"
		File.open(commit_hash_file, 'w+') do |f|
			f.write(hash) 
		end
	else
		puts "same"
	end

end
