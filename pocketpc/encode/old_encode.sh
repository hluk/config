#!/bin/bash
# converts video using mencoder
# @author: Lukas Holecek
# @e-mail: hluk@email.cz

# USER variables#{{{
## gamma correction
: ${GAMMA:=1.0}
## resolution
: ${XRES:=320}
: ${YRES:=240}
## pixels to crop
: ${CROP:=0}
## extra parameters
: ${XPARMS:=""}
## output file prefix and postfix
: ${OUTPREFIX:="PPC_"}
: ${OUTPOSTFIX:=""}
## skip over n seconds from beginning
: ${SKIP:=0}
## define endpos
: ${ENDPOS:=0}
## subtitle ID
: ${SID:=""}
## video codec
: ${VC:="lavc"}
: ${VCOPTS:="-lavcopts vcodec=mpeg4:vbitrate=300:vhq:keyint=250 -ofps 16"}
## audio codec
: ${AC:="copy"}
: ${ACOPTS:=""}
## video filter
: ${VF:="scale=$(($XRES+$CROP)):-2,crop=$XRES:$YRES,eq2=$GAMMA"}
## audio filter
: ${AF:=""}
## subtitle file encoding
: ${SUBCP:=cp1250}
## font for subtitles
: ${FONT:=~/.mplayer/fonts/arialbd.ttf}
## subtitle text scale
: ${SUBSCALE:=3}
## subtitle language
: ${SLANG:=""}
#}}}

# colors#{{{
CGREEN="\033[1;32m"
CYELLOW="\033[1;33m"
CRED="\033[1;31m"
CBLUE="\033[1;34m"
CEND="\033[0m"
#}}}

# print help#{{{
if [ -z "$@" ]
then
	echo "Encoder parameters"
	echo "------------------"
	echo "GAMMA       gamma correction"
	echo "            (GAMMA=$GAMMA)"
	echo "XRES        resolution"
	echo "            (XRES=$XRES)"
	echo "YRES"
	echo "            (YRES=$YRES)"
	echo "CROP        pixels to crop"
	echo "            (CROP=$CROP)"
	echo "FONT        font for subtitles"
	echo "            (FONT=$FONT)"
	echo "XPARMS      extra parameters"
	echo "            (XPARMS=$XPARMS)"
	echo "OUTPREFIX   output file prefix"
	echo "            (OUTPREFIX=$OUTPREFIX)"
	echo "OUTPOSTFIX  output file postfix"
	echo "            (OUTPOSTFIX=$OUTPOSTFIX)"
	echo "SKIP        skip over n seconds from beginning"
	echo "            (SKIP=$SKIP)"
	echo "ENDPOS      define endpos"
	echo "            (ENDPOS=$ENDPOS)"
	echo "SID         subtitle ID"
	echo "            (SID=$SID)"
	echo "VC          video codec"
	echo "            (VC=$VC)"
	echo "VCOPTS      video codec options"
	echo "            (VCOPTS=$VCOPTS)"
	echo "AC          audio codec"
	echo "            (AC=$AC)"
	echo "ACOPTS      audio codec options"
	echo "            (ACOPTS=$ACOPTS)"
	echo "VF          video filter"
	echo "            (VF=$VF)"
	echo "AF          audio filter"
	echo "            (AF=$AF)"
	echo "SUBCP       subtitle file encoding"
	echo "            (SUBCP=$SUBCP)"
	echo "SUBSCALE    subtitle text scale"
	echo "            (SUBSCALE=$SUBSCALE)"
	echo "SLANG       subtitle language (used only when no subtitle file was detected)"
	echo "            (SLANG=$SLANG)"
fi
#}}}

# MAIN LOOP#{{{
for INFILE in "$@"
do
	# set xterm title
	python -c "from output import xtermTitle; xtermTitle('Converting \"' + '$INFILE\"')"

	# create output filename
	OUTFILE="${OUTPREFIX}${INFILE##/*/}${OUTPOSTFIX}.avi"

	# subtitle file or subtitle language
	## detect subtitle file using midentify
	SUBFILE=$(/usr/bin/midentify "$INFILE" | egrep '^ID_FILE_SUB_FILENAME=' | sed 's/^ID_FILE_SUB_FILENAME=//')

	## create subtitle parameters
	if [ -n "$SUBFILE" ]
	then
		SUB="-sub $SUBFILE ${FONT:+"-font \"$FONT\""} ${SUBCP:+"-subcp $SUBCP"} ${SUBSCALE:+"-subfont-text-scale $SUBSCALE"} -ffactor 1 -subpos 100"
	else
		if [ -n "$SID" ]
		then
				SUB="-sid $SID ${FONT:+"-font \"$FONT\""} ${SUBCP:+"-subcp $SUBCP"} ${SUBSCALE:+"-subfont-text-scale $SUBSCALE"} -ffactor 1 -subpos 100"
		else
			if [ -n "$SLANG" ]
			then
				SUB="-slang $SLANG ${FONT:+"-font \"$FONT\""} ${SUBCP:+"-subcp $SUBCP"} ${SUBSCALE:+"-subfont-text-scale $SUBSCALE"} -ffactor 1 -subpos 100"
			fi
		fi
	fi

	# expand movie area and move subtitles to bottom
	if [ -n "$SUB" ]
	then
		VF="${VF:+"$VF,"}expand=:${YRES:-""}:0:0:1"
	fi

	# endpos
	if [ ! $ENDPOS ]
	then
		ENDPOS_PARM="-endpos $ENDPOS";
	fi

	# create command
	COMMAND="/usr/bin/mencoder ${VC:+"-ovc $VC"} ${AC:+"-oac $AC"} ${VF:+"-vf $VF"} $VCOPTS $ACOPTS $AF $SUB $XPARMS -zoom -xy $XRES -ss $SKIP $ENDPOS_PARM \"$INFILE\" -o \"$OUTFILE.part\""

	# print info
	echo -e "\n\n********************"
	echo -e "* ${CGREEN}Converting${CEND} \"$INFILE\" ${CGREEN}to${CEND} \"$OUTFILE\""
	## subtitles
	if [ -n "$SID" ]
	then
			echo -e "* ${CYELLOW}Subtitle ID:${CEND} $SID"
	else
		if [ -n "$SUBFILE" ]
		then
			echo -e "* ${CYELLOW}Subtitle file:${CEND} \"$SUBFILE\""
		else
			if [ -n "$SLANG" ]
			then
				echo -e "* ${CYELLOW}Subtitle language:${CEND} $SLANG"
			fi
		fi
	fi
	## print parameters
	### resolution
	if [ ! $CROP ]
	then
		echo -e "* ${CBLUE}Resolution:${CEND} ${XRES}x${YRES}"
	else
		echo -e "* ${CBLUE}Resolution:${CEND} ${XRES}x${YRES} ($CROP pixels cropped)"
	fi
	### gamma
	if [ $GAMMA != 1.0 ]
	then
		echo -e "* ${CBLUE}Gamma correction:${CEND} $GAMMA"
	fi

	### skip
	if [ ! $SKIP ]
	then
		echo -e "* ${CBLUE}Skipping over${CEND} $SKIP seconds from beginning."
	fi

	### endpos
	if [ ! $ENDPOS ]
	then
		echo -e "* ${CBLUE}Endpos:${CEND} $ENDPOS seconds"
	fi

	## print command
	echo -e "* ${CGREEN}Command:${CEND} $COMMAND\n"

	# evaluate command
	eval $COMMAND
	if [ ! $? ]
	then
		echo -e "${CRED}Interrupted!${CEND}"
		rm -f "$OUTFILE.part"
		exit 1
	fi
	
	mv -f "$OUTFILE.part" "$OUTFILE"

	echo -e "\n********************"
done
#}}}

echo -e "* ${CGREEN}ALL DONE!${CEND}"
exit 0

