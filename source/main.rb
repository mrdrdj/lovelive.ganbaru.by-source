require "yaml"
require "redcarpet"

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

def post_name_to_url_path(md_file)
	md_file.gsub(/-/, "/").gsub(/blog\//,"").gsub(".md", "")
end


def render(md_file)
	meta = YAML.load_file(md_file)
	renderer = Redcarpet::Render::HTML.new()
	markdown = Redcarpet::Markdown.new(renderer, autolink: true, tables: true)
	content = File.read(md_file).split("---", 2)[1]

	if meta["toppic"]
		div align:"center" do
			image meta["toppic"]
		end
		hr
	end

	rendered = markdown.render(content)

	rendered.gsub!(/<img src="(.+?)"/, '<img class="img-responsive" src="/images/\\1"')

	text rendered

	if meta["gallery"]

		gallery(
			meta["gallery"].map{|x| "/images/" + x}, 
			meta["gallery"].map{|x| "/images/" + x.sub(".", "-thumb.")})
		
	end
end
