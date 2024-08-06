function cph --wraps='history -z | hread -n 1 | wl-copy' --description 'alias cph=history -z | hread -n 1 | wl-copy'
	
	set count $argv
	set -q count[1] || set count "1"

	set out $(history | sed "$count!d")
	echo "> $out"
	echo $out | wl-copy

end
