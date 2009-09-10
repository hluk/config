Config { font = "xft:Aller:size=14:style=bold"
       , bgColor = "#303030"
       , fgColor = "#c0f0f0"
       , position = Bottom
       , lowerOnStart = True
       , commands = [ Run Network "eth0" ["--template","<rx>   <tx>","-L","1","-H","1000","--low","aquamarine3","--normal","#f0e050","--high","#ff9a50"] 30
                    , Run Cpu ["--template","cpu <total>","-L","10","-H","90","--low","aquamarine3","--normal","#f0e050","--high","#ff9a50"] 10
                    , Run Com "~/dev/xmobar/uptime/uptime" [] "uptime" 100
                    , Run Com "uname" ["-r"] "" 36000
                    , Run Com "~/dev/xmobar/mpd/mpdinfo" [] "music" 20
                    , Run Date "%m/%_d %H:%M:%S" "date" 100
                    , Run StdinReader
                    , Run Com "df" ["--no-sync", "-h", "/","|awk 'NR==2 {print $4\"/\"$2}'"] "" 100
                    ]
       , sepChar = "%"
       , alignSep = "}{"
       , template = "%StdinReader% }{ %music%    •    %uptime%  %cpu%    •    %eth0%    •    %df%    •    <fc=#ee9a50>%date%</fc>  %uname%                         "
       }
