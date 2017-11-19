#!/usr/bin/ruby

require 'minitest/autorun'
load './lib/ncplus.rb'

class TestNCPlus < Minitest::Test
	def setup
		@epg = NCPlus::Epg.new
	end
	
	def test_channels_type
		assert_equal Array, @epg.channels.class
	end
	
	def test_shows_type
		assert_equal Array, @epg.shows(channel: 'HBO').class
	end
end