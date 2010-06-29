from ranger.api.commands import *

alias('w', 'webview')
alias('blend', 'blender')
alias('un', 'unpack')

class webview(Command):
	"""
	:w <string>

	Creates and browse gallery with selected files (images/fonts)
	"""

	def execute(self):
		line = parse(self.line)
		action = ['/home/lukas/dev/gallery/mkgallery.py']
		if line.rest(1):
			action.extend([line.rest(1)])
		action.extend(f.path for f in self.fm.env.get_selection())
		self.fm.execute_command(action, flags="w")

class blender(Command):
	"""
	:blender <string>

	Run blender
	"""

	def execute(self):
		line = parse(self.line)
		action = ['/home/lukas/apps/blender/blender']
		if line.rest(1):
			action.extend([line.rest(1)])
		action.extend(f.path for f in self.fm.env.get_selection())
		self.fm.execute_command(action, flags="d")

class unpack(Command):
	"""
	:unpack <string>

	Unpack file
	"""

	def execute(self):
		line = parse(self.line)
		action = ['/home/lukas/dev/bin/unpack.sh']
		if line.rest(1):
			action.extend([line.rest(1)])
		action.extend(f.path for f in self.fm.env.get_selection())
		self.fm.execute_command(action, flags="w")

