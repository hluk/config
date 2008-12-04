#!/usr/bin/env python
import urllib2
import sys, HTMLParser, re
from optparse import OptionParser

class GoogleParser (HTMLParser.HTMLParser):
	def __init__(self):
		HTMLParser.HTMLParser.__init__(self)
		self.inResult = 0

	def handle_starttag(self, tag, attrs):
		if tag == 'div' and ('id', 'result_box') in attrs:
			self.inResult = 1

	def handle_endtag(self, tag):
		if self.inResult and tag == 'div':
			self.inResult = 0

	def handle_data(self, data):
		if self.inResult:
			sys.stdout.write(data)


class SeznamParser (HTMLParser.HTMLParser):
	def __init__(self):
		HTMLParser.HTMLParser.__init__(self)
		self.inContent = 0
		self.inWords = 0
		self.inCollocations = 0
		self.inWord = 0
		self.inTranslated = 0
		self.word = ''

	def handle_starttag(self, tag, attrs):
		if tag == 'div':
			if ('id', 'content') in attrs:
				self.inContent = 1
				return

		if self.inContent != 1:
			return

		if tag == 'table' and ('id', 'words') in attrs: # slova
			self.word = ''
			self.inWords = 1
		elif tag == 'div' and ('id', 'collocations') in attrs: # slovni spojeni
			self.inCollocations = 1
			if self.word != '':
				self.word = ''
				sys.stdout.write("\n")
		elif self.inWords:
			if tag == 'td':
				if ('class', 'word') in attrs: # slovo
					self.inWord = 1
				elif ('class', 'translated') in attrs: # definice slova
					self.inTranslated = 1
			elif tag == 'a':
				if self.inWord:
					self.inWord = 2
				elif self.inTranslated:
					self.inTranslated = 2
			elif tag == 'tr' and self.word != '':
				self.word = ''
				sys.stdout.write("\n")
		elif self.inCollocations:
			if tag == 'dt': # jedno slovni spojeni
				self.inWord = 1
			elif tag == 'a':
				if self.inWord:
					self.inWord = 2
				elif self.inTranslated:
					self.inTranslated = 2
			elif tag == 'dd': # definice slovniho spojeni
				self.inTranslated = 1



	def handle_endtag(self, tag):
		if self.inContent != 1:
			return

		if tag == 'td' or tag == 'dt':
			self.inWord = 0
			self.inTranslated = 0
		elif tag == 'a':
			if self.inWord == 2:
				self.inWord = 1
			elif self.inTranslated == 2:
				self.inTranslated = 1
		elif tag == 'table':
			self.inWords = 0
		elif tag == 'div':
			self.inContent = 0
			self.word = ''



	def handle_data(self, data):
		if self.inContent != 1:
			return

		if self.inWord == 2:
			self.word = data
		elif self.inTranslated == 2:
			sys.stdout.write("\t%s - %s\n" % (self.word, data))



def translateWords (lang_from, lang_to, words):
	if lang_to == 'cs': lang_to = 'cz'
	if lang_from == 'cs': lang_from = 'cz'

	parser = SeznamParser()
	for word in words:
		sys.stdout.write("<%s>\n" % word)
		html = urllib2.urlopen( 'http://slovnik.seznam.cz/?q=%s&lang=%s_%s' %
				(urllib2.quote(word), urllib2.quote(lang_from), urllib2.quote(lang_to)) )
		parser.feed(html.read())
		sys.stdout.write("</%s>\n\n" % word)
	html.close()


def translateSentence (lang_from, lang_to):
	if lang_to == 'cz': lang_to = 'cs'
	if lang_from == 'cz': lang_from = 'cs'

	parser = GoogleParser()
	data = sys.stdin.read()

	opener = urllib2.build_opener()
	opener.addheaders = [('User-agent', 'Mozilla/5.0')]
	html = opener.open('http://translate.google.com/translate_t', 'hl=%s&sl=%s&ie=UTF8&text=%s' % (lang_to, lang_from, data))

	try:
		data = html.read()
		parser.feed(data)
		html.close()
	except:
		print "Unexpected error:", sys.exc_info()[0]
		raise


if __name__ == "__main__":
	# options
	parser = OptionParser()
	parser.add_option("-f", "--from", dest="lang_from", default='en', help="source language", metavar="LANGUAGE")
	parser.add_option("-t", "--to", dest="lang_to", default='cz', help="destination language", metavar="LANGUAGE")

	(opts, args) = parser.parse_args()

	if len(args) == 0:
		#translate text on stdin
		translateSentence(opts.lang_from, opts.lang_to)
	else:
		#translate all word given as arguments
		translateWords(opts.lang_from, opts.lang_to, args)

