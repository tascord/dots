{config, pkgs}: 
let 

 config = builtins.fromJSON (builtins.readFile ../map.json);
 

in
{


 home.file = builtins.listToAttrs  (builtins.mapAttrsToList (source: output: {
name = 
		 "${output}"; 
value = {
	source = "../files/${source}";
		recursive = true;
};
}) config.files);

	








}
