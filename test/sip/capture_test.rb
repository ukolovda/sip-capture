require "test_helper"
require 'socket'

class Sip::CaptureTest < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::Sip::Capture::VERSION
  end

  def test_capture
    capture = Sip::Capture::Hep3.new
    capture.bind '127.0.0.1', 9060
    s1 = UDPSocket.new
    s1.connect('127.0.0.1', 9060)
    data = ['HEP3', "\x00\x10",
      "\x00\x00", "\x00\x0f", "\x00\x0a", "test"].join('')
    s1.send data, 0
    capture.capture_all do |item|
      # puts item
      assert_equal 'test', item[:payload]
      break
    end
  end
end
