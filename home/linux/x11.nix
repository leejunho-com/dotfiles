{ pkgs, ... }:

{
  imports = [ ./common.nix ];

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
