#!/bin/bash
#
# zobrazí zmenìný PDF dokument na stranì velikosti A4 (k ulo¾eni, tisku)
# ZÁVISLOSTI: Python, KGhostView
#
# POU®ITÍ: pdfscale dokument.pdf pomer_zmenseni
#
# AUTOR: Luká¹ Holeèek, holeceklukas@seznam.cz
#

IN_PDF=$1
OUT_PS=~/print.ps
OUT_PS2=~/print2.ps # soubor k tisku
SCALE=`python -c print\(float\($2\)\)`
OFFSET=`python -c print\(\(1-float\($SCALE\)\)/2\)` # OFFSET = (1 - SCALE)/2

touch $OUT_PS && touch $OUT_PS2 && \
# prevod pdf -> ps
pdftops $IN_PDF $OUT_PS && \
# zmena parametru stranky
pstops 0@${SCALE}\(${OFFSET}w,${OFFSET}h\) $OUT_PS $OUT_PS2 && \
# tisk dokumentu
kghostview $OUT_PS2

# vycisteni
rm $OUT_PS $OUT_PS2 2> /dev/null

