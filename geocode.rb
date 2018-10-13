require 'geocoder'
require 'yaml'
require 'pry'
require './source/util'

if ENV["GOOGLE_API_KEY"]
	Geocoder.configure(lookup: :google, api_key: ENV["GOOGLE_API_KEY"])
end

loclist = YAML.load_file("extradata/locs.yml")

locinfo = YAML.load_file("extradata/geocoder_cache.yml")

begin
loclist.each do |loc,v|
	key = keyize(loc)
	if locinfo.has_key?(key)
		if locinfo[key][:bb][0].is_a? String
			locinfo[key][:bb] = [
				locinfo[key][:bb][0].to_f,
				locinfo[key][:bb][2].to_f,
				locinfo[key][:bb][1].to_f,
				locinfo[key][:bb][3].to_f,
			]
		end
	else
		res = Geocoder.search(loc)
		if res.length != 0
			puts "found #{key}"

			if ENV["GOOGLE_API_KEY"]
				locinfo[key] = {
					lat: res[0].latitude,
					lon: res[0].longitude,
					bb: res[0].viewport
				}
			else
				locinfo[key] = {
					lat: res[0].latitude,
					lon: res[0].longitude,
					bb: [
						res[0].boundingbox[0].to_f,
						res[0].boundingbox[2].to_f,
						res[0].boundingbox[1].to_f,
						res[0].boundingbox[3].to_f,
					]
				}
			end
		else
			p "can't find #{key}"
		end
	end
end
rescue => e
	p e
end

File.write("extradata/geocoder_cache.yml", locinfo.to_yaml)
