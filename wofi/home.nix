{ ... }:
{
  programs.wofi = {
    enable = true;
    settings = {
      show_all = true;
      location = "center";
      allow_markup = true;
      allow_images = true;
      term = "kitty";
      hide_scroll = true;
      close_on_focus_loss = true;
      single_click = true;
      layer = "top";
      width = 600;
      height = 400;
      # 移除 normal_window 设置，避免 GTK 默认装饰
    };
    style = ''
      /* 全局重置 */
      * {
        border: none;
        border-radius: 0;
        box-shadow: none;
        text-shadow: none;
        outline: none;
        background-image: none;
        background-color: transparent;
      }

      /* 主窗口 */
      window {
        margin: 0px;
        padding: 0px;
        background-color: rgba(40, 42, 54, 0.95);
        border-radius: 12px;
        border: 2px solid rgba(68, 71, 90, 0.8);
        box-shadow: 0 4px 12px rgba(0, 0, 0, 0.4);
      }

      #input {
        margin: 8px;
        padding: 8px 12px;
        border-radius: 8px;
        color: #f8f8f2;
        background-color: rgba(68, 71, 90, 0.8);
        font-size: 14px;
      }

      #inner-box {
        margin: 0px;
        background-color: transparent;
      }

      #outer-box {
        margin: 0px;
        padding: 0px;
        background-color: transparent;
        border-radius: 12px;
      }

      #scroll {
        margin: 0px;
        padding: 0px;
        background-color: transparent;
        border-radius: 12px;
      }

      #text {
        margin: 4px 8px;
        padding: 4px 8px;
        color: #f8f8f2;
        background-color: transparent;
        border-radius: 6px;
      }

      #entry {
        margin: 2px 4px;
        padding: 6px 12px;
        border-radius: 8px;
        background-color: transparent;
        color: #f8f8f2;
        transition: all 0.2s ease;
      }

      #entry:hover {
        background-color: rgba(68, 71, 90, 0.6);
        border-radius: 8px;
      }

      #entry:selected {
        background-color: rgba(117, 134, 245, 0.8);
        border-radius: 8px;
        color: #282a36;
        font-weight: bold;
      }

      #entry:selected #text {
        color: #282a36;
      }
    '';
  };
}
