require 'rest-client'
require 'net/ssh'


def ssh
	begin
		puts "connecing to #{@hostname}"
	    session = Net::SSH.start(@hostname, @username, :password => @password)
	    puts "connected."
	    yield session
	    session.close
  	rescue
    	puts "Unable to connect to #{@hostname} using #{@username}/#{@password}"
	end    	
end


def run(ssh,cmd)
	res = ssh.exec!(cmd)
    puts res
end


def netcat(ssh, ports) 
	ports.each do |port|
    	run ssh, "nc -zv #{@hostname} #{port}"
	end
end


def check_health(url, details_trace=false)
	begin
	res = RestClient.get url
	rescue => e
	  res = e.response
	end

	puts "======| #{url} is #{res.code==200? 'fine':'not healthy'} |======"
	puts res if details_trace
	res.code==200
end



def resolve_etc_hosts(ssh, hosts) 
	hosts.each do |host|
		cmd = "ping -q -c 1 -t 1 #{host}" + '| grep PING | sed -e "s/).*//" | sed -e "s/.*(//"'
		puts host
    	run ssh, cmd
	end
end

