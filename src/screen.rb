#!/usr/bin/env ruby

require "rubygems"
require "dnssd"

Thread.abort_on_exception = true

servers = {}
DNSSD.browse '_rfb._tcp' do |reply|
  resolver = DNSSD.resolve reply do |reply|
    addresses = []

    service = DNSSD::Service.new

    service.getaddrinfo reply.target do |addrinfo|
      addresses << addrinfo.address
      break unless addrinfo.flags.more_coming?
    end

    name = reply.fullname
    name.gsub!("_rfb._tcp.", "")
    name.gsub!("\\032", " ")
    name.gsub!(/\.local\.$/, "")
    hostname = reply.target.sub(/\.$/, "")

    servers[name] = hostname
  end
end

sleep 0.3

query = "";

ARGV.each do|a|
  query = a
end

# Allow for custom vnc:// addresses

unless (query.empty?)
  servers[query] = query
end  

puts '<?xml version="1.0" encoding="UTF-8"?>'
puts '<items>'

default = <<-EOF
    <item arg="#{query}" uid="#{query}" valid="yes">
        <title>Connect to...</title>
        <subtitle>Enter host to connect to</subtitle>
        <icon>icon.png</icon>
    </item>
  EOF

if (query.empty?)
  puts default
else
  servers = servers.select { |name, hostname| name.downcase.include?(query.downcase) || hostname.downcase.include?(query.downcase) }
end

local_hostname = `hostname`

servers.each do |name, hostname|
  unless hostname == local_hostname.gsub(/\s+/, "")
    item = <<-EOF
      <item arg="#{hostname}" uid="#{hostname}" valid="yes">
        <title>#{name}</title>
        <subtitle>Connect to #{hostname}</subtitle>
        <icon>icon.png</icon>
      </item>
    EOF
    puts item
  end
end

if (servers.empty?)
  puts default
end

puts "</items>"