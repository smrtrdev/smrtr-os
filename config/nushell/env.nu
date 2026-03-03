# smrtr-os nushell environment

$env.EDITOR = "nvim"
$env.VISUAL = "nvim"

# Generate cached shell integrations
def --env ensure-cache [name: string, cmd: string] {
    let cache_dir = ($env.HOME | path join ".cache" $name)
    let cache_file = ($cache_dir | path join "init.nu")
    if not ($cache_dir | path exists) { mkdir $cache_dir }
    if not ($cache_file | path exists) {
        ^bash -c $cmd | save -f $cache_file
    }
}

ensure-cache "starship" "starship init nu"
ensure-cache "zoxide" "zoxide init nushell"
ensure-cache "carapace" "carapace _carapace nushell"
ensure-cache "mise" "mise activate nu"
