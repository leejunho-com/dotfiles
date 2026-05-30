{ pkgs, config, ... }:

let
  dotfiles = "${config.home.homeDirectory}/code/dotfiles";
  link = path: config.lib.file.mkOutOfStoreSymlink "${dotfiles}/${path}";
in
{
  imports = [ ./gui.nix ];

  home.file.".xinitrc".source = link "i3/xinitrc";

  home.packages = with pkgs; [
    xclip
    (pkgs.st.overrideAttrs (old: {
      postPatch = (old.postPatch or "") + ''
        sed -i 's/pixelsize=[0-9]*/pixelsize=25/' config.def.h
      '';
    }))
  ];

  services.xremap.withX11 = true;
}
