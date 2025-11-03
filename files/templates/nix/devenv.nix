
{
pkgs,
lib,
config,
inputs,
...
}:

{
env.GREET = "Nix";
packages = [
pkgs.git
];

enterShell = ''
git --version
'';

}
