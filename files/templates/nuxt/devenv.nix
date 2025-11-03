{
  pkgs,
  lib,
  config,
  inputs,
  ...
}:

{
  env.GREET = "ship";
  packages = [
    pkgs.git
    pkgs.nodejs
  ];

  enterShell = ''
    git --version
  '';
  
}
