#!/usr/bin/ruby

# Draft notes of my goal with this gem

epg = NCPlus::Epg.new

epg.channels
epg.shows# all shows on all channels
epg.shows('TVP1')# all shows on TVP1

epg.list.channels

for ch in epg.channels do
	puts ch.name
end

epg.channels.each do |ch|
	puts ch.name
end

puts ch.name

puts epg.now# print all show currently on air on all channells

puts epg.now(time: '+30min')

tvp1 = epg.channel('TVP1')# NCPlus::TVChannel

now_on_tvp1 = tvp1.show(Time.now)
now_on_tvp1 = tvp1.now# another version
documentary_on_tvp1 = tvp1.show(type: 'documentary')

hbo = epg.channel('HBO')
now_on_hbo = hbo.now# what's now on HBO
next_on_hbo = hbo.next# what's next on HBO
next_drama_on_hbo = hbo.next(:drama)

puts(hbo.today[0..4])# print next 5 shows on HBO

