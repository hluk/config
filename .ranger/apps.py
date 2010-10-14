from ranger.defaults.apps import CustomApplications as DefaultApps
from ranger.api.apps import *

class CustomApplications(DefaultApps):
	def app_smplayer(self, c):
		c.flags += 'd'
		return tup('smplayer', *c)

	def app_gallery(self, c):
		c.flags += 'd'
		return tup('/home/lukas/dev/gallery/mkgallery.py', '--local', '--force', '--title=view', '--resolution=0', *c)

	def app_editor(self, c):
		c.flags += 'd'
		return tup('gvim', *c)

	def app_default(self, c):
		f = c.file #shortcut
		if f.video or f.audio:
			return self.app_smplayer(c)

		if f.image and c.mode == 0:
			return self.app_gallery(c)

		if f.extension is not None:
			if f.extension in ('html', 'htm', 'xhtml'):
				return self.either(c, 'chromium-browser', 'firefox', 'opera', 'elinks')
			if f.extension in ('swf', ):
				return self.either(c, 'chromium-browser', 'firefox', 'opera')
			if f.extension in ('exe', ):
				c.flags += 'd'
				return tup('wine', *c)
			if f.extension in ('nds', ):
				c.flags += 'd'
				return tup('/home/lukas/apps/desmume/src/gtk/desmume', *c)
			if f.extension in ('ttf', 'otf'):
				return self.app_gallery(c)

		return DefaultApps.app_default(self, c)

