function n --description 'Run nixos package' $prog
	nix-shell -p $prog --run $prog
end
