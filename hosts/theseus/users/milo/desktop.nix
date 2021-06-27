{ pkgs, ... }:

{
  xdg.desktopEntries = {
    ripasso = {
      name = "ripasso";
      #icon = "org.gnome.Nautilus";
      type = "Application";
      exec = "alacritty -e ripasso-cursive";
      terminal = false;
      categories = [
        "ConsoleOnly"
        "X-Security"
        "X-Passwords"
      ];
    };
    ranger = {
      name = "Ranger";
      icon = "org.gnome.Nautilus";
      type = "Application";
      exec = "alacritty -e ranger";
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
