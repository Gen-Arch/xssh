require 'xssh'
require 'xssh/cli'

Xssh.configure do
  source   "centos7 'host1',    'ssh://vagrant:vagrant@localhost',     port: 2222"
  source   "centos7 'host2',    'ssh://vagrant:vagrant@localhost',     port: 2200"
  source   "centos7 'bastion',  'ssh://ec2-user:@i-01b69a3c23268723e', config: true"

  template(type: :centos7) do
    bind(:iplist) do
      cmd('ifconfig')
    end
  end
end

pp Xssh.find(name: "host1")

Xssh.get("host1", log: [STDOUT, "test1.log"]) do |s|
  s.cmd('hostname')
  s.close
end
