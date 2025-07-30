{ config, pkgs, ... }:

{
  # 安装 fcitx5 及相关插件
  home.packages = with pkgs; [
    fcitx5
    fcitx5-rime
    fcitx5-configtool
    fcitx5-chinese-addons
    librime
  ];

  # 设置环境变量
  home.sessionVariables = {
    GTK_IM_MODULE = "fcitx";
    QT_IM_MODULE = "fcitx";
    XMODIFIERS = "@im=fcitx";
    INPUT_METHOD = "fcitx";
    SDL_IM_MODULE = "fcitx";
    GLFW_IM_MODULE = "fcitx";
  };

  # 批量导入 rime 目录
  home.file.".local/share/fcitx5/rime" = {
    source = ./rime;
    recursive = true; # 递归整个文件夹
    force = true; # 强制覆盖现有文件
  };

  # 配置 rime.conf
  home.file.".config/fcitx5/conf/rime.conf" = {
    text = ''
      # 预编辑模式
      PreeditMode="Do not show"
      # 共享输入状态
      InputState=All
      # 将嵌入式预编辑文本的光标固定在开头
      PreeditCursorPositionAtBeginning=True
      # 切换输入法时的行为
      SwitchInputMethodBehavior="Commit raw input"
      # 重新部署
      Deploy=
      # 同步
      Synchronize=
    '';
    force = true;
  };
}
