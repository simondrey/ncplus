#!/usr/bin/ruby

require 'rubygems'
require 'bundler/setup'
require 'open-uri'
require 'date'
require 'json'

module NCPlus
  class Show
    attr_accessor :id, :title, :time, :length, :unknown_2, :unknown_3, :age_limit, :year
  
    def initialize(s)
      @id = s[0]
      @title = s[1]
      @time = Time.at(s[2])# time of air show
      @length = s[3]# in seconds
      @unknown_2 = s[4]# always zero?
      @unknown_3 = s[5]# some kind of unique ncplus-id
      @age_limit = s[6]
      @year = s[7]
    end
    
    # Returns full info for the show with a given show_id
    def program_info(show_id)
      JSON.parse(
        open("http://ncplus.pl/program-tv?rm=ajax&id=#{show_id}&v=5").read
      )
    end
    
    def more
      @more ||= program_info(@id)
    end
    
    alias details more
    alias full_info more
    alias description more
  end
  
  class Channel
    def initialize(epg_obj, chname, date)
      @name = chname
      @shows_cache = Hash.new([])
      chia = epg_obj.channel_initializer_array(channel: chname, date: date)
      chia[3].each do |show|
        @shows_cache[date] << Show.new(show)
      end
    end
    
    def shows(date)
      @shows_cache[date]
    end
  end
  
  class Epg
    def initialize
      @ncplus_url = 'http://ncplus.pl/epgjson/'
      
      @epg_cache = {}
      @today = Time.now.strftime("%Y-%m-%d")
      @epg_cache[@today] = JSON.parse(open(@ncplus_url + @today + '.ejson').read)
    end
    
    def deep_initialize
      # initialize all shows ... not sure if it make sense
    end
    
    def epg(year, month, day, refresh=false)
      date = "#{year}-#{month}-#{day}"
      if refresh 
        @epg_cache[date.to_s] = JSON.parse(
          open(@ncplus_url + "#{year}-#{month}-#{day}.ejson").read
        )
      else
        @epg_cache[date.to_s] ||= JSON.parse(
          open(@ncplus_url + "#{year}-#{month}-#{day}.ejson").read
        )
      end
    end
    
    def today
      @epg_cache[@today]
    end
    
    # Return the list of channels
    def channels
      today.map { |_, name, _| name }.sort
    end
    
    def available?(chname)
      channels.include? chname
    end
    
    # Return array with details for a given channel, by default for today date
    # Returns: [id, channel_name, date, [ ... array_of_shows ... ]]
    def channel_initializer_array(channel:, date: nil)
      raise ArgumentError, "There is no channel '#{channel}'" unless available?(channel)
      date ||= @today
      year, month, day = date[0..3], date[5..6], date[8..9]
      epg(year, month, day).select { |c| c[1]==channel }.first.insert(2, date)
    end

    # Return Object with details about a given show
    def details(show)
      Show.new(show)
    end
  end
end
