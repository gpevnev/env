{ config, pkgs, ... }:

{
  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages =
    [ pkgs.vim
    ];

  # Use a custom configuration.nix location.
  # $ darwin-rebuild switch -I darwin-config=$HOME/.config/nixpkgs/darwin/configuration.nix
  # environment.darwinConfig = "$HOME/.config/nixpkgs/darwin/configuration.nix";

  # Auto upgrade nix package and the daemon service.
  services.nix-daemon.enable = true;
  nix.package = pkgs.nixFlakes;
  nixpkgs.config.allowUnfree = true; 
  nix = {
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };

  # Create /etc/bashrc that loads the nix-darwin environment.
  programs.zsh.enable = true;  # default shell on catalina
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  homebrew.enable = true;
  homebrew.casks = [
    "tunnelblick"
    "docker"
    "postman"
  ];

  nix.binaryCaches = [
    "https://cache.nixos.org"
    # "s3://serokell-private-cache?endpoint=s3.eu-central-1.wasabisys.com&profile=serokell-private-cache"
    # "s3://serokell-private-nix-cache?endpoint=s3.us-west-000.backblazeb2.com&profile=serokell-private-nix-cache-read"
  ];

  nix.binaryCachePublicKeys = [
    "serokell-1:aIojg2Vxgv7MkzPJoftOO/I8HKX622sT+c0fjnZBLj0="
  ];
  
  # Not wrokign for some reason
  # services.postgresql = {
  #   enable = true;
  #   package = pkgs.postgresql_12;
  # };

  # fonts = {
  #   enableFontDir = true;
  #   fonts = [ pkgs.hack-font ];
  # };

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 4;
}
