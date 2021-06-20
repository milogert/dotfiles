{ pkgs, ... }:

{
  xdg.desktopEntries = {
    ranger = {
      name = "Ranger - Home Manager";
      icon = "org.gnome.Nautilus";
      type = "Application";
      exec = "alacritty -c ranger";
      terminal = false;
      categories = [
        "ConsoleOnly"
        "System"
        "FileTools"
        "FileManager"
      ];
    };
  };
}
