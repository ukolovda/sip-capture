require 'socket'
require 'json'

module Sip
  module Capture
    
    class Hep3

      SIGNATURE = "HEP3"
      GENERIC_VENDOR_ID = 0

      def self.capture_all(host, port, &block)
        h = Hep3.new
        h.bind(host, port)
        h.capture_all(&block)
      end

      def bind(host, port)
        @socket = UDPSocket.new
        @socket.bind(host, port)
      end

      def process_data(data)
        if (item = parse(data))
          yield item if block_given?
        end
      end

      def capture_all(&block)
        @in_loop = true
        while @in_loop do
          begin
            data = @socket.recvfrom_nonblock(65535)  #=> ["aaa", ["AF_INET", 33302, "localhost.localdomain", "127.0.0.1"]]
            process_data data[0], &block
          rescue IO::WaitReadable
            IO.select([s1], [], [], 10)
            retry
          end
        end
      end

      def stop
        @in_loop = false
      end
      
      private

      HEP3_FIELDS = {
          1 => [:ip_protocol_family, :uint8],
          2 => [:ip_protocol_id, :uint8],
          3 => [:ipv4_source_address, :ipv4],
          4 => [:ipv4_destination_address, :ipv4],
          5 => [:ipv6_source_address, :ipv6],
          6 => [:ipv6_destination_address, :ipv6],
          7 => [:protocol_source_port, :uint16],
          8 => [:protocol_destination_port, :uint16],
          9 => [:timestamp_sec, :uint32],
          10=> [:timestamp_usec, :uint32],
          11=> [:protocol_type, :uint8],
          12=> [:capture_agent_id, :uint32],
          13=> [:keep_alive_timer, :uint16],
          14=> [:authenticate_key, :str],
          15=> [:payload, :str]
      }

      def parse(data)
        # See https://github.com/sipcapture/HEP
        if hep3?(data)
          item = {}
          length = data[4..5].unpack("S>").first
          pos = 6
          while pos < length do
            vendor_id, type_id, chunk_length = data[pos..pos+5].unpack("S>S>S>")
            payload = data[pos+6...pos+chunk_length]
            if vendor_id == GENERIC_VENDOR_ID
              if (info = HEP3_FIELDS[type_id])
                name, parse_method = info
                item[name] = send(:"parse_#{parse_method}", payload)
              end
            end
            pos += chunk_length
          end
          item
        end
      end

      def hep3?(data)
        data[0..3] == SIGNATURE
      end

      def parse_uint8(payload)
        payload.unpack("C").first
      end

      def parse_uint16(payload)
        payload.unpack("S>").first
      end

      def parse_uint32(payload)
        payload.unpack("L>").first
      end

      def parse_ipv4(payload)
        payload.unpack("CCCC").join(".")
      end

      def parse_ipv6(payload)
    #    payload.unpack("CCCCCC").map{}.join(".")
        nil
      end

      def parse_str(payload)
        payload.force_encoding('UTF-8')
      end
    end

  end
end
