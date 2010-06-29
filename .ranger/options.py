from ranger.api.options import *

def colorscheme_overlay(context, fg, bg, attr):
	if context.selected:
		if context.main_column:
			fg, bg = color.white, color.default
		elif context.directory:
			bg = color.white

	return fg, bg, attr

