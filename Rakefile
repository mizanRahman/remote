require 'rubygems'

require './util.rb'

@hostname = "192.168.33.10"
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

desc "network status"
task :http, [:arg1] => [] do
	check_health 'http://httpbin.org/get'
	check_health 'http://httpbin.org/post', true
	check_health 'http://google.com'
	# check_health 'http://map.kpp.com/mobile-platform-1.0'
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

