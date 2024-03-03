{ pkgs, ... }:

{
  xdg.desktopEntries = {
    ranger = {
      name = "Ranger";
      icon = "org.gnome.Nautilus";
      type = "Application";
      exec = "${pkgs.kitty} -e ranger";
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
