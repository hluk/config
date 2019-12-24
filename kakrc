set-option global scrolloff 5,5

source "%val{config}/plugins/plug.kak/rc/plug.kak"
plug "lePerdu/kakboard" %{
    hook global WinCreate .* %{ kakboard-enable }
}
