{ ... }:

{
  programs.zellij.enable = false;
  programs.zellij.enableZshIntegration = true;
  # programs.zellij.package
  programs.zellij.attachExistingSession = true;
  # programs.zellij.exitShellOnExit
  programs.zellij.extraConfig =
    ''
      keybinds {
          // keybinds are divided into modes
          normal {
              // bind instructions can include one or more keys (both keys will be bound separately)
              // bind keys can include one or more actions (all actions will be performed with no sequential guarantees)
              bind "Ctrl g" { SwitchToMode "locked"; }
              bind "Ctrl p" { SwitchToMode "pane"; }
              bind "Alt n" { NewPane; }
              bind "Alt h" "Alt Left" { MoveFocusOrTab "Left"; }
          }
          pane {
              bind "h" "Left" { MoveFocus "Left"; }
              bind "l" "Right" { MoveFocus "Right"; }
              bind "j" "Down" { MoveFocus "Down"; }
              bind "k" "Up" { MoveFocus "Up"; }
              bind "p" { SwitchFocus; }
          }
          locked {
              bind "Ctrl g" { SwitchToMode "normal"; }
          }
      }
    '';

  # programs.zellij.layouts = {
  #   dev = {
  #     layout = {
  #       _children = [
  #         {
  #           default_tab_template = {
  #             _children = [
  #               {
  #                 pane = {
  #                   size = 1;
  #                   borderless = true;
  #                   plugin = {
  #                     location = "zellij:tab-bar";
  #                   };
  #                 };
  #               }
  #               { "children" = { }; }
  #               {
  #                 pane = {
  #                   size = 2;
  #                   borderless = true;
  #                   plugin = {
  #                     location = "zellij:status-bar";
  #                   };
  #                 };
  #               }
  #             ];
  #           };
  #         }
  #         {
  #           tab = {
  #             _props = {
  #               name = "Project";
  #               focus = true;
  #             };
  #             _children = [
  #               {
  #                 pane = {
  #                   command = "nvim";
  #                 };
  #               }
  #             ];
  #           };
  #         }
  #         {
  #           tab = {
  #             _props = {
  #               name = "Git";
  #             };
  #             _children = [
  #               {
  #                 pane = {
  #                   command = "lazygit";
  #                 };
  #               }
  #             ];
  #           };
  #         }
  #         {
  #           tab = {
  #             _props = {
  #               name = "Files";
  #             };
  #             _children = [
  #               {
  #                 pane = {
  #                   command = "yazi";
  #                 };
  #               }
  #             ];
  #           };
  #         }
  #         {
  #           tab = {
  #             _props = {
  #               name = "Shell";
  #             };
  #             _children = [
  #               {
  #                 pane = {
  #                   command = "zsh";
  #                 };
  #               }
  #             ];
  #           };
  #         }
  #       ];
  #     };
  #   };
  # };

  # programs.zellij.settings = {
  #   theme = "custom";
  #   themes.custom.fg = "#ffffff";
  #   keybinds._props.clear-defaults = true;
  #   keybinds.pane._children = [
  #     {
  #       bind = {
  #         _args = [ "e" ];
  #         _children = [
  #           { TogglePaneEmbedOrFloating = { }; }
  #           { SwitchToMode._args = [ "locked" ]; }
  #         ];
  #       };
  #     }
  #     {
  #       bind = {
  #         _args = [ "left" ];
  #         MoveFocus = [ "left" ];
  #       };
  #     }
  #   ];
  # };

  programs.zellij.themes = { };
}
