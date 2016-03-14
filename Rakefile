require 'rubygems'

require './util.rb'

@hostname = "192.168.33.10"
@username = "vagrant"
@password = "vagrant"


desc "connect to server"
task :connect do
	ssh
    puts "connecing to #{@hostname}"
    remote_run @ssh, 'uname -a'
    puts "connected."
end

desc "show server info"
task :info => [:connect] do
    remote_run @ssh, 'uname -a'
    remote_run @ssh, 'top'
end

desc "network status"
task :network => [:connect, :netcat] do
    remote_run @ssh,'netstat -nap| grep tcp'
end

desc "network status"
task :netcat =>[:connect] do
	netcat @ssh, [21,22,80,8080,3000,1531,3306]
end

desc "network status"
task :http, [:arg1] => [] do
	check_health 'http://httpbin.org/get'
	check_health 'http://httpbin.org/post', true
	check_health 'http://google.com'
	# check_health 'http://map.kpp.com/mobile-platform-1.0'
end


desc "service status"
task :service, [:arg1] => [:connect] do
	remote_run @ssh, 'for qw in `ls /etc/init.d/*`; do  $qw status | grep -i running; done'
end


