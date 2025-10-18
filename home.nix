{ config, pkgs, lib, username, ... }:
let
  isLinux = pkgs.stdenv.hostPlatform.isLinux;
  isDarwin = pkgs.stdenv.hostPlatform.isDarwin;
  unsupported = builtins.abort "Unsupported platform";
in
{
  home.username = username;
  home.homeDirectory =
    if isLinux then "/home/${username}" else
    if isDarwin then "/Users/${username}" else unsupported;

  home.stateVersion = "23.05";
  programs.home-manager.enable = true;

  home.packages = with pkgs; ([
    # Platform-agnostic dependencies
  ] ++ lib.optionals isLinux [
    # Linux-only dependencies
  ] ++ lib.optionals isDarwin [
    # Mac-only dependencies
  ]);

  # Shell configuration
  programs.zsh = {
    enable = true;
    shellAliases = {
      hm-switch = "home-manager switch";
    };
  };

  # Git configuration
  programs.git = {
    enable = true;
    userEmail = "vincent@vwong.dev";
    userName = "Vincent Wong";
    extraConfig = {
      init.defaultBranch = "main";
      push.autoSetupRemote = true;
    };
  };
}