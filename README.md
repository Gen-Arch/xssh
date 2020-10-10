# Xssh

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'xssh'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install xssh

## Usage

```

require 'xssh'

Xssh.configure do
  source   "centos7 'exsample-server', 'ssh://vagrant:vagrant@localhost', port: 2222"
  template(type: :centos7) do
    bind(:iplist) do
      cmd('ifconfig')
    end
  end
end


s = Xssh.get('exsample-server', log: 'test.log')

puts s.cmd('ls')
puts s.cmd('hostname')
puts s.iplist
s.close


#=> ==== output ls ====
#=> ls
#=> [vagrant@exsample-server ~]$
#=> 
#=> ==== output hostname ====
#=> hostname
#=> exsample-server
#=> [vagrant@exsample-server ~]$
#=> 
#=> ==== output ifconfig ====
#=> ifconfig
#=> enp0s3: flags=4163<UP,BROADCAST,RUNNING,MULTICAST>  mtu 1500
#=>         inet 10.0.2.15  netmask 255.255.255.0  broadcast 10.0.2.255
#=>         inet6 fe80::1f59:5849:f41f:7979  prefixlen 64  scopeid 0x20<link>
#=>         ether 08:00:27:37:f8:46  txqueuelen 1000  (Ethernet)
#=>         RX packets 777  bytes 99545 (97.2 KiB)
#=>         RX errors 0  dropped 0  overruns 0  frame 0
#=>         TX packets 565  bytes 114880 (112.1 KiB)
#=>         TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0
#=> 
#=> lo: flags=73<UP,LOOPBACK,RUNNING>  mtu 65536
#=>         inet 127.0.0.1  netmask 255.0.0.0
#=>         inet6 ::1  prefixlen 128  scopeid 0x10<host>
#=>         loop  txqueuelen 1  (Local Loopback)
#=>         RX packets 68  bytes 5524 (5.3 KiB)
#=>         RX errors 0  dropped 0  overruns 0  frame 0
#=>         TX packets 68  bytes 5524 (5.3 KiB)
#=>         TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0
#=> 
#=> [vagrant@exsample-server ~]$
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/xssh.

