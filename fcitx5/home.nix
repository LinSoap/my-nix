{ config, pkgs, ... }:

{
  # 配置 fcitx5 输入法
  i18n.inputMethod = {
    enable = true;
    type = "fcitx5";
    fcitx5.addons = with pkgs; [
      fcitx5-rime
      fcitx5-configtool
      fcitx5-chinese-addons
    ];
  };

  # 装输入法相关包
  home.packages = with pkgs; [
    librime
  ];

  # 设置环境变量
  home.sessionVariables = {
    GTK_IM_MODULE = "fcitx";
    QT_IM_MODULE = "fcitx";
    XMODIFIERS = "@im=fcitx";
    INPUT_METHOD = "fcitx";
    SDL_IM_MODULE = "fcitx";
    GLFW_IM_MODULE = "ibus";
  };

  home.file.".config/fcitx5/conf/rime.conf".text = ''
    # 预编辑模式
    PreeditMode="Composing text"
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

  # 强制覆盖文件，不备份
  home.file.".config/fcitx5/conf/rime.conf".force = true;
}
