{ pkgs, config, ... }:

let
  dotfiles = "${config.home.homeDirectory}/code/dotfiles";
  link = path: config.lib.file.mkOutOfStoreSymlink "${dotfiles}/${path}";
in
{
  imports = [ ./gui.nix ];

  home.file.".xinitrc".source = link "i3/xinitrc";
  home.file.".config/i3/config".source = link "i3/config";
  home.file.".config/i3status/config".source = link "i3/i3status.conf";

  home.packages = with pkgs; [
    xclip
    rofi
    alttab
    picom
    (pkgs.st.overrideAttrs (old: {
      postPatch = (old.postPatch or "") + ''
        sed -i 's/font = "[^"]*"/font = "D2CodingLigature Nerd Font,Noto Sans CJK KR:pixelsize=25:antialias=true:autohint=true"/' config.def.h
        sed -Ei 's/\{ TERMMOD,[[:space:]]+XK_Prior,[[:space:]]+zoom,[[:space:]]+\{\.f = \+1\} \}/{ Mod4Mask, XK_equal, zoom,      {.f = +1} }/' config.def.h
        sed -Ei 's/\{ TERMMOD,[[:space:]]+XK_Next,[[:space:]]+zoom,[[:space:]]+\{\.f = -1\} \}/{ Mod4Mask, XK_minus, zoom,      {.f = -1} }/' config.def.h
        sed -Ei 's/\{ TERMMOD,[[:space:]]+XK_Home,[[:space:]]+zoomreset,[[:space:]]+\{\.f =[[:space:]]+0\} \}/{ Mod4Mask, XK_0,     zoomreset, {.f =  0} }/' config.def.h
        awk '
        /^static const char \*colorname/ { skip=1
          print "static const char *colorname[] = {"
          print "\t\"#000000\", \"#c6341b\", \"#a9e15d\", \"#c9ae38\","
          print "\t\"#749fe7\", \"#83668b\", \"#46a4a8\", \"#cccccc\","
          print "\t\"#808080\", \"#e15140\", \"#ccfd7e\", \"#f9eb77\","
          print "\t\"#588df6\", \"#b595b4\", \"#73e2e6\", \"#e1e1e1\","
          print "\t[255] = 0,"
          print "\t\"#a9e15d\","
          print "\t\"#555555\","
          print "\t\"#feffff\","
          print "\t\"#000000\","
          next
        }
        /^};/ && skip { skip=0; print; next }
        skip { next }
        { print }
        ' config.def.h > tmp && mv tmp config.def.h
      '';
    }))
  ];

  services.xremap.withX11 = true;
}
