{ pkgs, lib, ... }:

pkgs.buildNpmPackage {
  pname = "global-node-packages";
  version = "1.0.0";
  src = ./.;

  # The first time you run this, it will fail and tell you the correct hash.
  # Replace this with the correct hash.
  npmDepsHash = "sha256-IbE3THMSW1blNijNE3s2XmF5zvE+ZvWTA88PJU2HuWc=";

  # The package.json doesn't have a build script, so we disable it.
  dontNpmBuild = true;

  nativeBuildInputs = [ pkgs.pkg-config ];
  buildInputs = [ pkgs.libsecret ];

  postInstall = ''
    mkdir -p $out/bin
    ln -s $out/lib/node_modules/global-node-packages/node_modules/.bin/* $out/bin/
  '';

  meta = with lib; {
    description = "Global Node.js packages managed by Nix";
    license = licenses.mit;
  };
}
