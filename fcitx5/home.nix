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
}
