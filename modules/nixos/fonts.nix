{ pkgs, ... }:

{
  fonts.packages = with pkgs; [
    noto-fonts-cjk-sans
    font-awesome
    inter
  ];
}
