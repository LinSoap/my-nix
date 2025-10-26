{ config, pkgs, ... }:

{
  # 批量导入 rime 目录
  home.file.".local/share/fcitx5/rime" = {
    source = ./rime;
    recursive = true; # 递归整个文件夹
    force = true; # 强制覆盖现有文件
  };

  home.file.".local/share/fcitx5/themes" = {
    source = ./themes;
    recursive = true;
    force = true;
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

  # 配置 quickphrase.conf，禁用快捷输入功能
  home.file.".config/fcitx5/conf/quickphrase.conf" = {
    text = ''
      # 选词修饰键
      Choose Modifier=None
      # 启用拼写检查
      Spell=True
      # 备选拼写检查语言
      FallbackSpellLanguage=en

      [TriggerKey]
      # 禁用快捷输入快捷键 (原来是 Super+semicolon)
    '';
    force = true;
  };
  home.file.".config/fcitx5/conf/classicui.conf" = {
    text = ''
      # 垂直候选列表
      Vertical Candidate List=False
      # 使用鼠标滚轮翻页
      WheelForPaging=True
      # 字体
      Font="Sans 10"
      # 菜单字体
      MenuFont="Sans 10"
      # 托盘字体
      TrayFont="Sans Bold 10"
      # 托盘标签轮廓颜色
      TrayOutlineColor=#000000
      # 托盘标签文本颜色
      TrayTextColor=#ffffff
      # 优先使用文字图标
      PreferTextIcon=True
      # 在图标中显示布局名称
      ShowLayoutNameInIcon=True
      # 使用输入法的语言来显示文字
      UseInputMethodLanguageToDisplayText=True
      # 主题
      Theme=plasma
      # 深色主题
      DarkTheme=plasma
      # 跟随系统浅色/深色设置
      UseDarkTheme=True
      # 当被主题和桌面支持时使用系统的重点色
      UseAccentColor=True
      # 在 X11 上针对不同屏幕使用单独的 DPI
      PerScreenDPI=True
      # 固定 Wayland 的字体 DPI
      ForceWaylandDPI=0
      # 在 Wayland 下启用分数缩放
      EnableFractionalScale=True
    '';
    force = true;
  };
}
