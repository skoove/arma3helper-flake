# arma3helper-flake
nix flake for [Arma3Helper](https://github.com/ninelore/armaonlinux).

## usage
> [!WARNING]
> # ***DONT USE IT!!***
>
> do not even bother vro, i made a guide on how to run arma, it works on nix, i know this because i use nix https://skoove.dev/blog/arma-3-on-linux

~~add flake as an input:~~
```nix
arma3helper = {
  url = "/home/zie/development/arma-3-helper-flake";
  inputs.nixpkgs.follows = "nixpkgs";
};
```

~~use the provided module:~~

```nix
{ inputs , ... }:
{
  imports = [
    inputs.arma3helper.nixosModules.default
  ];

  programs.arma3helper = {
    enable = true;
    compat_data_path = "comtp andata opath";
    steam_library_path = "steam library path";
    proton_custom_version = "custom versoon";
    esync = false;
    fsync = false;
  };
}

```
