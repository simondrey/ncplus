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
      @time = Time.at(show[2])# time of air show
      @length = s[3]# in seconds
      @unknown_2 = s[4]# always zero?
      @unknown_3 = s[5]# time of end?
      @age_limit = s[6]
      @year = s[7]
    end
    
    def more
      @more ||= program_info(@id)
    end
    
    # Return full info about the show
    def program_info(show_id)
      JSON.parse(
        open("http://ncplus.pl/program-tv?rm=ajax&id=#{show_id}&v=5").read
      )
    end
        
  end
  
  class Epg
    def initialize()
      @ncplus_url = 'http://ncplus.pl/epgjson/'
      
      @epg = {}
      @today = Time.now.strftime("%Y-%m-%d")
      @epg[@today] = JSON.parse(open(@ncplus_url + @today + '.ejson').read)
    end
    
    # ------------------------------------------------------------------
    # Return EPG for a given date and store it in @epg
    # ------------------------------------------------------------------
    def epg(year, month, day, refresh=false)
      if refresh 
        @epg[date.to_s] = JSON.parse(
          open(@ncplus_url + "#{year}-#{month}-#{day}.ejson").read
        )
      else
        @epg[date.to_s] ||= JSON.parse(
          open(@ncplus_url + "#{year}-#{month}-#{day}.ejson").read
        )
      end
    end
    
    def today
      @epg[@today]
    end
    
    # Return the list of channels
    def channel_names
      today.map { |_, name, _| name }
    end
    
    # Return list of shows in a given channel
    def shows(channel:, date: nil)
      date ||= @today
      year, month, day = date[0..3], date[5..6], date[8..9]
      puts("Channel: #{channel} Year: #{year} Month: #{month} Day: #{day}") 
    end
    

    
    # Return details about a given show
    def details(show)
      Show.new(show)
    end
  end
end
