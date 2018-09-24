require "yaml"

def standard_page(name:, path:, &block)

	topnav_page "#{path}", "#{name}" do

		menu do
			nav "Home", :home, "/"

			Dir["data/perf/*"].each do |path|
				link_name = path.sub("data/perf/","")
				slug = link_name.downcase.gsub("µ's", "muse")
				nav "#{link_name}", :music, "/#{slug}" do

					nav "Songs", :music, "/#{slug}/songs"
					nav "Events", :microphone, "/#{slug}/events"
				end
			end
		end

		row do
			col 12 do
				h1 "#{name}"
				br
			end
		end

		instance_eval(&block)
	end

end
