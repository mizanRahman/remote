require 'rest-client'
require 'net/ssh'


def ssh 
    @ssh = Net::SSH.start(@hostname, @username, :password => @password)
end


def remote_run(ssh,cmd)
	res = ssh.exec!(cmd)
    puts res
end


def netcat(ssh, ports) 
	ports.each do |port|
    	remote_run ssh, "nc -zv #{@hostname} #{port}"
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