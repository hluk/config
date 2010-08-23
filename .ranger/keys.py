from ranger.api.keys import *

map = KeyMapWithDirections()

# select images
map('Mi', fm.open_console(cmode.COMMAND, 'mark (jpg|png|gif)$'))

# shell in current directory
map('<C-x>', fm.execute_command('tmux new-window'))
map('<C-y>', fm.execute_command('tmux split-window'))

# rename file: A

keymanager.merge_all(map)

