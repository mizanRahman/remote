require 'rest-client'
require 'net/ssh'


def ssh
	begin
		puts "connecing to #{@hostname}"
		if not @session
	    	session = Net::SSH.start(@hostname, @username, :password => @password)
	    end
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
		puts cmd
    	run ssh, cmd
	end
end

def backup(ssh, paths) 
	paths.each do |path|

    	dir = path[0..path.rindex("/")-1]
    	puts dir


		cmd = "ls -la #{dir}"
		puts cmd
    	run ssh, cmd
  #   	# find the directory form path patern (config/*.prop--> config)

    	backup_dir = "#{dir}/backup/#{Time.now.strftime('%Y%m%d-%H%M%S')}"
    	puts backup_dir
    	cmd = "test -d #{backup_dir} || mkdir -p #{backup_dir} && cp #{path} #{backup_dir}"
		puts cmd
    	run ssh, cmd

    	cmd = "ls -la #{backup_dir}"
		puts cmd
    	run ssh, cmd
  # 

	end
end



