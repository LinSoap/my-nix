# NixOS 多主机配置

这个配置支持两台电脑的 NixOS 系统管理。

## 目录结构

```
├── flake.nix                    # Flake 配置文件
├── home.nix                     # Home Manager 配置
├── hosts/                       # 主机特定配置
│   ├── common.nix              # 通用配置
│   ├── desktop/                # 台式机配置
│   │   ├── configuration.nix   # 台式机特定配置
│   │   └── hardware-configuration.nix
│   └── laptop/                 # 笔记本配置
│       ├── configuration.nix   # 笔记本特定配置
│       └── hardware-configuration.nix
├── fcitx5/                     # 输入法配置
└── gnome/                      # GNOME 配置
```

## 使用方法

### 构建和切换系统配置

**台式机:**
```bash
sudo nixos-rebuild switch --flake .#desktop
```

**笔记本:**
```bash
sudo nixos-rebuild switch --flake .#laptop
```

### 测试配置（不切换）

**台式机:**
```bash
sudo nixos-rebuild test --flake .#desktop
```

**笔记本:**
```bash
sudo nixos-rebuild test --flake .#laptop
```

### 构建配置（不安装）

**台式机:**
```bash
nix build .#nixosConfigurations.desktop.config.system.build.toplevel
```

**笔记本:**
```bash
nix build .#nixosConfigurations.laptop.config.system.build.toplevel
```

## 配置说明

### 通用配置 (hosts/common.nix)
包含两台机器共同的配置，如：
- 启动加载器
- 网络设置
- 桌面环境 (GNOME)
- 输入法 (fcitx5)
- 用户配置
- 基础软件包

### 台式机特定配置 (hosts/desktop/)
- 主机名: `nixos-desktop`
- 可以添加台式机特有的硬件配置
- 性能优化配置

### 笔记本特定配置 (hosts/laptop/)
- 主机名: `nixos-laptop`
- 电源管理 (TLP)
- 触摸板配置
- 亮度控制
- 蓝牙支持

## 添加新主机

1. 在 `hosts/` 下创建新目录
2. 复制硬件配置文件到该目录
3. 创建 `configuration.nix` 导入通用配置和硬件配置
4. 在 `flake.nix` 中添加新的 `nixosConfigurations` 条目

## 注意事项

- 每台机器的硬件配置文件是独立的，由 `nixos-generate-config` 生成
- 通用配置可以随时修改，影响所有主机
- 特定主机的配置只影响对应的机器
- 使用 `git` 管理配置变更，方便在两台机器间同步
