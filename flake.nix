{
  description = "flake for Arma3Helper";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
  };

  outputs = { self, nixpkgs }:
  let
    lib = nixpkgs.lib;
  in {
    nixosModules = {
      default = { config , lib, pkgs , ... }: {
        options.programs.arma3helper = {
          enable = lib.mkEnableOption "Enable the Arma 3 helper script";

          proton_offical_version = lib.mkOption {
            default = "8.0";
            type = lib.types.enum [ "8.0" "7.0" "6.3" "5.13" "5.0" "4.11" "4.2" "3.16" "3.7" "Proton Experimental" "Experimental" ];
            description = ''
              From script comments:

              MAKE SURE YOU CHOOSE THE SAME PROTON VERSION AS FOR ARMA IN STEAM!!!
              Set this to the proton Version you are using with Arma!
              Available versions: "8.0", "7.0", "6.3", "5.13", "5.0", "4.11", "4.2", "3.16", "3.7", "Proton Experimental", "Experimental"
              Defaults to: 8.0
            '';
          };

          proton_custom_version = lib.mkOption {
            default = "";
            type = lib.types.str;
            description = ''
              From script comments:

              If you are using a custom proton build, then put its folder name (from inside compatibilitytools.d) here
              Leave empty if proton 
            '';
          };

          compat_data_path = lib.mkOption {
            default = "";
            type = lib.types.str;
            description = ''
              From script comments:

              Path to Arma's compatdata (wineprefix)
              Leave empty if Arma is installed in Steams default library
            '';
          };

          steam_library_path = lib.mkOption {
            type = lib.types.str;
            default = "";
            description = ''
              From script comments:

              If you have proton in a different steam library, then put the path to its steamapps folder here
              Leave empty if Proton is installed in Steams default library
            '';
          };

          esync = lib.mkOption {
            type = lib.types.bool;
            default = true;
            description = ''
              From script comments:

              IMPORTANT: Make sure that Esync and Fsync settings MATCH for both Arma and TeamSpeak(here)
              If you havent explicitly turned it off for Arma, leave it on here!
            '';
          };

          fsync = lib.mkOption {
            type = lib.types.bool;
            default = true;
            description = ''
              From script comments:

              IMPORTANT: Make sure that Esync and Fsync settings MATCH for both Arma and TeamSpeak(here)
              If you havent explicitly turned it off for Arma, leave it on here!
            '';
          };
        };

        config = let
          opts = config.programs.arma3helper;
        in lib.mkIf config.programs.arma3helper.enable {
          environment.systemPackages = [
            (pkgs.stdenv.mkDerivation {
              pname = "arma3helper";
              version = "1v18-9";
              
              src = pkgs.fetchFromGitHub {
                owner = "ninelore";
                repo = "armaonlinux";
                rev = "28c871ac8a5a21dab1435143648d9f6bb5264aec";
                hash = "sha256-7WfNrAYjUUkaQnQogLKCU2pM+iPTB5CWUDikzKL93OI=";
              };

              configurePhase = ''
                substituteInPlace Arma3Helper.sh \
                  --replace 'PROTON_OFFICIAL_VERSION=""' 'PROTON_OFFICIAL_VERSION="${opts.proton_offical_version}"' \
                  --replace 'COMPAT_DATA_PATH=""' 'COMPAT_DATA_PATH="${opts.compat_data_path}"' \
                  --replace 'STEAM_LIBRARY_PATH=""' 'STEAM_LIBRARY_PATH="${opts.steam_library_path}"' \
                  --replace 'PROTON_CUSTOM_VERSION=""' 'PROTON_CUSTOM_VERSION="${opts.proton_custom_version}"' \
                  --replace 'ESYNC=true' 'ESYNC=${lib.boolToString opts.esync}' \
                  --replace 'FSYNC=true' 'FSYNC=${lib.boolToString opts.fsync}'
              '';

              installPhase = ''
                # make out path
                mkdir -p $out/bin

                # move script
                mv Arma3Helper.sh $out/bin/arma3helper
                # make exec
                chmod +x $out/bin/arma3helper
              '';
            })
          ];
        };
      };
    };
  };
}
