Config { font = "xft:Aller:size=13:bold"
       , bgColor = "black"
       , fgColor = "#c0f0f0"
       , position = Top
       , lowerOnStart = True
       , commands = [ Run Network "eth0" ["--template","<rx> | <tx>","-L","1","-H","1000","--low","aquamarine3","--normal","yellow","--high","red"] 10
                    , Run Cpu ["--template","CPU <total>","-L","10","-H","90","--low","aquamarine3","--normal","yellow","--high","red"] 10
                    , Run Com "uptime" ["-s","-r"] "" 36000
                    , Run Com "uname" ["-s","-r"] "" 36000
                    , Run Com "mpc" ["-f", "\"[<fc=##80e0ff>[%artist% - ]%title%</fc> ]\"",
                        "| awk 'NR==1 {printf $0} NR==2 {printf \"<fc=#ee9a00>\"$1\"</fc> <fc=aquamarine3>\"$3\"</fc>\"; exit}' || true"] "music" 30
                    , Run Date "%m/%_d %H:%M:%S" "date" 100
                    , Run StdinReader
                    ]
       , sepChar = "%"
       , alignSep = "}{"
       , template = "   %StdinReader%    %music%    •    %cpu%    •    %eth0% }{ %uname%  <fc=#ee9a00>%date%</fc>   "
       }
