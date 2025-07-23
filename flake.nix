{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { nixpkgs, flake-utils, ... }: flake-utils.lib.eachDefaultSystem(system: 
    with import nixpkgs {inherit system; config.allowUnfree = true;}; {
      devShells.default = mkShell {
        nativeBuildInputs = [
          androidenv.androidPkgs.platform-tools
          android-studio
        ];

        shellHook = if !stdenv.isDarwin then ''
          #!/bin/bash
          $(awk -F: -v user=$USER 'user == $1 { print $NF }' /etc/passwd)
          exit 
        '' else ''
          #!/bin/bash
          $(dscl . -read $HOME 'UserShell' | grep --only-matching '/.*')
          exit
        '';
      };
  });
}
