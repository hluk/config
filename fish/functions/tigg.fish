function tigg
  git log --pretty='format:commit %h %s' -G $argv | tig
end
