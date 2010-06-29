from ranger.api.keys import *

map = KeyMapWithDirections()
map('<C-c>', fm.execute_command('screen'))
keymanager.merge_all(map)

