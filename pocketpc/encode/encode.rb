#!/usr/bin/env ruby
# parse mencoder options from encode.conf
# TODO: take image to view the video quality
require 'fileutils'
require 'optparse'
#require 'thread'

# parse options {{{
opt = {}
OptionParser.new do |opts|
	opts.banner = "Usage: encode.rb [options] VIDEO_FILES"
	opt[:search] = []
	
	opts.on("-c", "--color", "Colorize output") do |i|
		opt[:color] = i
	end
	opts.on("-t", "--test TIME", "View part of encoded video.") do |t|
		opt[:test] = t
	end
	opts.on("-l", "--length TIME", "Length in frames of encoded videopart (see option -t).") do |i|
		opt[:length] = i
	end
	opts.on("-i", "--identify", "Identify videos") do |i|
		opt[:identify] = i
	end
	opts.on("-a", "Audio codec list") do |i|
		opt[:audio_list] = i
	end
	opts.on("-v", "Video codec list") do |i|
		opt[:video_list] = i
	end
	opts.on("-o", "Overwrite existing files") do |i|
		opt[:overwrite] = i
	end
	opts.on("-s", "--search x,y,z", Array, "Search for alternate codecs") do |a|
		opt[:search] = a
	end
	opts.on_tail("-h", "--help", "Show this message") do
		puts opts
		exit
	end
end.parse! # }}}

# colors {{{
if opt[:color]
	# colors on win
	if PLATFORM =~ /win32/
		require 'rubygems'
		require 'Win32/Console/ANSI'
	end
	# TODO: add colors
	C_end = "\e[0m"
	C_id = "\e[31m"
	C_val = "\e[32m"
	C_grp = "\e[33m"
	C_info = "\e[33m"
	C_hilite = "\e[32m"
	C_warn = "\e[31m"
else
	C_end = C_id = C_val = C_grp = C_info = C_hilite = C_warn = ""
end # }}}

# paths {{{
Mencoder = "mencoder"
Mplayer = "mplayer"
mencoder_conf = (File.exist? "./encode.conf") ? "./encode.conf" :
			File.expand_path("~/dev/pocketpc/encode/encode.conf")
#Video_root = "/tmp/video/"
Video_root = "/mnt/pc2/down/_encoded/"
# }}}

# print audio or video codecs {{{
if opt[:audio_list]
	system(Mplayer, '-ac', 'help')
elsif opt[:video_list]
	system(Mplayer, '-vc', 'help')
end # }}}

# search for alternate codecs {{{
if not opt[:search].empty?
	[['ac', 'audio'], ['vc', 'video']].each do |avopt, type|
		puts C_info + "Searching for " + type + " codecs:" + C_end
		IO.popen(Mplayer + ' -' + avopt + ' help') do |io|
			io.each do |line|
				opt[:search].each do |expr|
					if line =~ /#{expr}/i
						# hilight search
						line.gsub!(/#{expr}/i, C_hilite+expr+C_end) if opt[:color]
						puts '    ' + line
					end
				end
			end
		end
	end
	exit
end # }}}

ARGV.sort.each_with_index do |filename, i|
	puts C_info + "--- " + filename + " (" + (i+1).to_s + "/" + ARGV.size.to_s + ")" + C_end

	# identify file {{{
	if opt[:identify]
		# TODO: print also alternative audio and video codecs
		ids = {}
		IO.popen(Mplayer + ' -identify -vo null -ao null -frames 0 -really-quiet ' + filename) do |io|
			io.each do |line|
				ln = line.split '='
				ids[ln[0]] = ln[1]
			end
		end
		
		# reformat output
		group=0
		output = {}
		id = nil
		ids.sort.each do |arr|
			if arr[0] =~ /^ID_(.*)/
				arr[0]=$1
				if arr[0] =~ /^([^_]*)_(.*)/
					arr[0]=$2
					id = $1
				else
					id = "OTHER"
				end
				output[id] = (output[id] or "") + sprintf("%s%11s%s = %s%s%s", C_id, arr[0], C_end , C_val, arr[1], C_end)
			end
		end

		output.each_pair do |k, v|
			puts( C_grp + "-- " + k + C_end + "\n" + v )
		end
	# }}}
	elsif opt[:test] # test video {{{
		FileUtils::mkpath Video_root
		ofilename=Video_root + '/' + filename.gsub(/.*[\\\/]/,"") + '.tmp.mp4'

		if File.exist?(ofilename) and !opt[:overwrite]
			puts C_info + "--- Skipping: file already exists!" + C_end
			next
		end
		
		t=Time.now
		if system(Mencoder, '-include', mencoder_conf,
			'-ss', opt[:test], '-frames', (opt[:length] or '250'),
			'-o', ofilename, filename)
			t=Time.now-t.to_f
			puts C_info + "--- DONE " + C_hilite + sprintf("(in %02d:%02d:%02d)", (t.hour-1), t.min, t.sec) + C_end
		else
			puts C_warn + "--- FAILED!" + C_end
		end

		system(Mplayer, ofilename)
		File.delete(ofilename)
	# }}}
	else # encode video {{{
		FileUtils::mkpath Video_root
		ofilename=Video_root + '/' + filename.gsub(/.*[\\\/]/,"") + '.mp4'

		if File.exist?(ofilename) and !opt[:overwrite]
			puts C_info + "--- Skipping: file already exists!"
			next
		end
		# convert
		t=Time.now
		if system(Mencoder, '-include', mencoder_conf,
		'-o', ofilename + '.part', filename)
			t=t-Time.now.to_f
			File.rename(ofilename + '.part', ofilename)
			puts C_info + "--- DONE (in " + t.hour.to_s + ":" + t.min.to_s + ":" + t.sec.to_s + ")" + C_end
		else
			puts C_warn + "--- FAILED!" + C_end
			exit 1
		end
	end # }}}
end

