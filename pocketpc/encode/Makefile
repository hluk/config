# {{{
# output dir
DIR = /home/lukas/down/_encoded
# source files
SRC = $(shell ls *.mkv)
# output file suffix
SUFFIX = _pda.mkv
# output files
OUT = $(patsubst %,$(DIR)/%$(SUFFIX),$(SRC))
# 1st and 2nd pass mencoder options
PASS1 = -x264encopts pass=1:turbo=1:psnr
PASS2 = -x264encopts pass=2:subq=5:frameref=3
# OPTS: common mencoder options in 1st and 2nd pass
OPTS = \
-msglevel all=1:statusline=5 -msgcolor \
-ovc x264 -oac mp3lame \
-ofps 15 \
-alang jpn \
-slang eng \
-sws 9 -vf scale=390:-10,crop=320:240 \
-af channels=2:volume=20 \
-x264encopts threads=auto:qcomp=0.7:qp=20 \
-lameopts vbr=2:q=9:mode=0 \
-lavfopts format=matroska \
-font "Aller:bold" \
-subpos 100 \
-subcp cp1250 \
-subfont-text-scale 3 \
-sub-fuzziness 0 \
-subfont-blur 0.5 \
-subfont-outline 1.6
# colors
C_END=\033[0m
C_FILE=\033[0;33m
C_PASS=\033[0;36m
# }}}

.PHONY: all %.1 %.2

all: $(OUT)

$(DIR)/%$(SUFFIX): %
	make $^.1 $^.2

# 1st pass
%.1: %
	@echo -e "\n\n$(C_FILE)$^ $(C_PASS)[1st pass]$(C_END)"
	mencoder $(OPTS) $(PASS1) -o /dev/null $^

# 2nd pass
%.2: %
	@echo -e "\n\n$(C_FILE)$^ $(C_PASS)[2nd pass]$(C_END)"
	mencoder $(OPTS) $(PASS2) -o $(DIR)/$^$(SUFFIX) $^
	rm -f divx2pass.log*

clean:
	rm -f $(OUT)

