set history save on
set history size 10000
set history remove-duplicates 1
set history filename ~/.config/gdb/gdb_history

set debuginfod enabled off

# Do not stop on SIGPIPE
handle SIGPIPE nostop noprint pass

python import sys, types
python module = types.ModuleType('~/dev/qt-creator/share/qtcreator/debugger/gdbbridge.py')
