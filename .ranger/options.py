from ranger.api.options import *

column_ratios = (1, 1, 5, 5)

def colorscheme_overlay(context, fg, bg, attr):
	if context.selected:
		if context.main_column:
			fg, bg = color.white, color.default
		elif context.directory:
			bg = color.white

	return fg, bg, attr

