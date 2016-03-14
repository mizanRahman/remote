require 'rubygems'
require 'net/ssh'

@hostname = "192.168.33.10"
@username = "vagrant"
@password = "vagrant"

@cmd = "ls -al"

 begin
    ssh = Net::SSH.start(@hostname, @username, :password => @password)
    
    res = ssh.exec!(@cmd)
    puts res

    res = ssh.exec!("uname -a")
    puts res


    res = ssh.exec!("service nagios status")
    puts res

    res = ssh.exec!("service apache2 status")
    puts res

    res = ssh.exec!("service httpd status")
    puts res

    res = ssh.exec!("nc -z -v localhost 20-1000 2>&1| grep success")
    puts res

    res = ssh.exec!("ls /vagrant/")
    puts res

    res = ssh.exec!('grep "psm" /vagrant/*')
    puts res


    res = ssh.exec!('sed -i "s/psm.url=.*/psm.url=10.88.230.12/g" /vagrant/*.properties')
    puts res


    res = ssh.exec!('grep "psm" /vagrant/*')
    puts res

    ssh.close
  rescue
    puts "Unable to connect to #{@hostname} using #{@username}/#{@password}"
  end