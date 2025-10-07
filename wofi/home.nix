{ ... }:
{
  programs.wofi = {
    enable = true;
    settings = {
      show_all = true;
      location = "center";
      allow_markup = true;
      allow_images = true;
      nomal_window = true;
      term = "kitty";
      hide_scroll = true;
      close_on_focus_loss = true;
      single_click = true;
      layer = "overlay";
      width = 600;
      height = 400;
    };
    style = ''
      window {
        margin: 0px;
        background-color: #282a36;
        border-radius: 12px;
      }

      #input {
        margin: 5px;
        border: none;
        color: #f8f8f2;
        background-color: #44475a;
      }

      #inner-box {
        margin: 5px;
        border: none;
        background-color: #282a36;
      }

      #outer-box {
        margin: 5px;
        border: none;
        background-color: #282a36;
      }

      #scroll {
        margin: 0px;
        border: none;
        min-height: 280px;
      }

      #text {
        margin: 5px;
        border: none;
        color: #f8f8f2;
      } 

      #entry.activatable #text {
        color: #282a36;
      }

      #entry > * {
        color: #f8f8f2;
      }

      #entry:selected {
        background-color: #44475a;
      }

      #entry:selected #text {
        font-weight: bold;
      }
    '';
  };
}
