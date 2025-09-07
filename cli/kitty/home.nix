{ config, pkgs, ... }:

{

  home.file.".config/kitty/kitty.conf" = {
    text = ''
      include current-theme.conf

      background_opacity 0.98
      font_size 15.0

      tab_bar_style powerline
      tab_bar_min_tabs 1

      wayland_titlebar_color #232537

    '';
    force = true;
  };

  home.file.".config/kitty/current-theme.conf" = {
    text = ''
      # vim:ft=kitty

      ## name: Base2Tone Suburb Dark (Modified for VSCode Theme Match)
      ## author: Bram de Haan (https://github.com/atelierbram)
      ## license: MIT
      ## upstream: https://github.com/atelierbram/Base2Tone-kitty/blob/main/themes/base2tone-suburb-dark.conf
      ## blurb: duotone theme | warm blue - bright pink (adapted to match VSCode theme)


      #: The basic colors

      foreground #f6f0ff
      background #27273a
      selection_foreground #25313e
      selection_background #42557b


      #: Cursor colors

      cursor #97ee91
      cursor_text_color #27273a


      #: URL underline color when hovering with mouse

      url_color #40afee


      #: kitty window border colors and terminal bell colors

      active_border_color #24e8d8
      inactive_border_color #0f1320
      bell_border_color #e34f8c
      visual_bell_color none


      #: OS Window titlebar colors

      wayland_titlebar_color #1f2330
      macos_titlebar_color #1f2330


      #: Tab bar colors

      active_tab_foreground #fbf9fa
      active_tab_background #7586f5
      inactive_tab_foreground #b0a6aa
      inactive_tab_background #3b4a6b
      tab_bar_background #27273a
      tab_bar_margin_color none


      #: Colors for marks (marked text in the terminal)

      mark1_foreground #27273a
      mark1_background #6375ee
      mark2_foreground #27273a
      mark2_background #8d8186
      mark3_foreground #27273a
      mark3_background #e44e8c


      #: The basic 16 colors

      #: black
      color0 #353551
      color8 #919cb9

      #: red
      color1 #e34f8c
      color9 #f36f98

      #: green
      color2 #97f36d
      color10 #affa90

      #: yellow
      color3 #f8c275
      color11 #fafaa0

      #: blue
      color4 #c7adfb
      color12 #74d6e9

      #: magenta
      color5 #e752a1
      color13 #f799c7

      #: cyan
      color6 #24e8d8
      color14 #8df9f9

      #: white
      color7 #fbd3e1
      color15 #d7d6df
    '';
    force = true;
  };
}
