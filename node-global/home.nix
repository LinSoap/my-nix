{ config, pkgs, ... }:

# 这个模块使用 node2nix 管理全局 Node.js 包
#
# 使用方法:
# 1. 编辑 package.json 添加/删除你需要的依赖
# 2. 运行: nix-shell -p nodePackages.node2nix --run "node2nix -i package.json"
# 3. 运行: home-manager switch
#
# 当前安装的包在 package.json 中定义

let
  # 导入 node2nix 生成的包
  nodePackages = import ./default.nix {
    inherit pkgs;
    inherit (pkgs) system;
  };
in
{
  home.packages = [
    # 使用 nodeDependencies 来获取所有包的可执行文件
    # 这会将 package.json 中的所有包的 bin 目录添加到 PATH
    nodePackages.nodeDependencies
  ];
}
