function cheat
    set query (string replace --all --regex "[^\w\d._-]+" "+" "$argv")
    curl --silent "https://cheat.sh/$query"
end
