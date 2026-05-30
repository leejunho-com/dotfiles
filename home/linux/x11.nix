{ pkgs, config, ... }:

let
  dotfiles = "${config.home.homeDirectory}/code/dotfiles";
  link = path: config.lib.file.mkOutOfStoreSymlink "${dotfiles}/${path}";
in
{
  imports = [ ./gui.nix ];

  home.file.".xinitrc".source = link "i3/xinitrc";
  home.file.".config/i3/config".source = link "i3/config";
  home.file.".Xresources".source = link "i3/Xresources";

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
