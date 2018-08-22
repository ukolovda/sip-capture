# Sip::Capture

This gem user in capture-server for FreeSwitch and other SIP servers with HEP3 logging

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'sip-capture'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install sip-capture

## Usage

```ruby
Sip::Capture::Hep3.capture_all('127.0.0.1', 9060) do |item|
  puts item.inspect 
  # => {"ip_protocol_family":2,
  #     "ip_protocol_id":6,
  #     "protocol_type":1,
  #     "ipv4_source_address":"169.254.0.2",
  #     "protocol_source_port":33620,
  #     "ipv4_destination_address":"169.254.0.2",
  #     "protocol_destination_port":4443,
  #     "timestamp_sec":1534916954,
  #     "timestamp_usec":433421,
  #     "capture_agent_id":114163712,
  #     "payload":"BYE sip:0011@169.254.0.2:5060;transport=udp SIP/2.0\r\nVia: SIP/2.0/WSS df7jal...."}
  
end
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/ukolovda/sip-capture.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
