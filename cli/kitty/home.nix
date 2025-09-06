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

      ## name: Base2Tone Suburb Dark
      ## author: Bram de Haan (https://github.com/atelierbram)
      ## license: MIT
      ## upstream: https://github.com/atelierbram/Base2Tone-kitty/blob/main/themes/base2tone-suburb-dark.conf
      ## blurb: duotone theme | warm blue - bright pink


      #: The basic colors

      foreground #878ba6
      background #27273a
      selection_foreground #878ba6
      selection_background #3b4a6b


      #: Cursor colors

      cursor #87d18d
      cursor_text_color #27273a


      #: URL underline color when hovering with mouse

      url_color #d2d8fe


      #: kitty window border colors and terminal bell colors

      active_border_color #444864
      inactive_border_color #27273a
      bell_border_color #5165e6
      visual_bell_color none


      #: OS Window titlebar colors

      wayland_titlebar_color #3b4a6b
      macos_titlebar_color #3b4a6b


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
      color0 #27273a
      color8 #4f5472

      #: red
      color1 #7586f5
      color9 #fe81b5

      #: green
      color2 #f36f98
      color10 #3b4a6b

      #: yellow
      color3 #ffb3d2
      color11 #444864

      #: blue
      color4 #50dffe
      color12 #5b6080

      #: magenta
      color5 #f36f98
      color13 #d2d8fe

      #: cyan
      color6 #a0acfe
      color14 #f764a1

      #: white
      color7 #878ba6
      color15 #ebedff
    '';
    force = true;
  };
}
