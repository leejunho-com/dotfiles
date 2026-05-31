{ ... }:

{
  services.xserver = {
    enable = true;
    displayManager.startx.enable = true;
    windowManager.i3.enable = true;
  };

  services.xserver.libinput.mouse.naturalScrolling = true;
}
