{ doom-emacs, doom-config }: { pkgs, config, lib, ... }:
let 
  pythonPackages = python-packages: with python-packages; [
    pandas
    scikitlearn
  ];
in rec {
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  # home.username = "gevnev";
  # home.homeDirectory = "/Users/gpevnev";
 
  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "20.09";

  imports = [ doom-emacs.hmModule ];

  home.activation = {
    copyApplications = let
      apps = pkgs.buildEnv {
	name = "home-manager-applications";
	paths = config.home.packages;
	pathsToLink = "/Applications";
      }; 
      in lib.hm.dag.entryAfter [ "writeBoundary" ] ''
	baseDir="$HOME/Applications/Home Manager Apps"
	if [ -d "$baseDir" ]; then
	  rm -rf "$baseDir"
	fi
	mkdir -p "$baseDir"
	for appFile in ${apps}/Applications/*; do
	  target="$baseDir/$(basename "$appFile")"
	  $DRY_RUN_CMD cp ''${VERBOSE_ARG:+-v} -fHRL "$appFile" "$baseDir"
	  $DRY_RUN_CMD chmod ''${VERBOSE_ARG:+-v} -R +w "$target"
	done
      '';
  };

  home.packages = with pkgs; [
    coreutils
    hack-font
    bat
    tldr
    htop
    pgcli
    stack
    _1password
    nodejs
    # nodejs
    #spectacle
    # ngrok
    #tdesktop
    # Doom Emacs dependencies
    #ripgrep
    #coreutils # basic GNU utilities
    #fd
    #clang
    #cmake
    #gnumake
    #(python3.withPackages pythonPackages)
    #python37Packages.sqlparse
    #stylish-haskell
  ];

  home.sessionVariables = {
    EDITOR = "nvim";
    GOPATH="/Users/gpevnev/go";
  };

  home.sessionPath = [
    "/Users/gpevnev/go/bin"
  ];

  programs.zsh = {
    enable = true;
    oh-my-zsh = {
      enable = true;
      theme = "bira";
      plugins = [
        "git" 
        "sudo" 
        "npm"
        "stack"
        "cabal"
        "tmux"
      ];
    };
    plugins = [
      { 
        name = "zsh-vi-mode";
	file = "zsh-vi-mode.plugin.zsh";
	src = pkgs.fetchFromGitHub {
	  owner = "jeffreytse";
	  repo = "zsh-vi-mode";
	  rev = "v0.8.3";
	  sha256 = "sha256-xpwRk7Om286kFpWf3c621zDoghxWYHFbeFUk1ReaTI0=";
	};
        
      }
    ];
  };

  programs.vscode = {
    enable = true;
    extensions = with pkgs.vscode-extensions; [
      bbenoist.Nix
      # enable after bumping nixpkgs
      # haskell.haskell
    ];

  };

  programs.direnv = {
    enable = true;
    enableNixDirenvIntegration = true;
  };

  programs.gpg = {
    enable = true;
  };

  programs.git = {
    enable = true;
    delta.enable = true;
    ignores = [ "*~" "result*" ".direnv" ".envrc"];
    extraConfig = {
      core.askPass = "";
    };
    userName = "Grigory Pevnev";
    userEmail = "gpevnev@gmail.com";
    signing = {
      key = "E5C03C8C1286D865";
      signByDefault = true;
    };
    includes = [
      { condition = "gitdir:~/code/serokell/";
        contents = { user.email = "grigory.pevnev@serokell.io"; };
      }
      { condition = "gitdir:~/code/atlantic/";
        contents = { user.email = "greg@atlantic.money"; };
      }
    ];
  };

  programs.go.enable = true;

  programs.tmux = {
    enable = true;
    baseIndex = 1;
    clock24 = true;
    escapeTime = 0;
    keyMode = "vi";
    historyLimit = 5000;
    newSession = true;
    extraConfig = ''
      set-option -g default-shell ${pkgs.zsh}/bin/zsh
    '';
    plugins = with pkgs; [
      tmuxPlugins.cpu
      { plugin = tmuxPlugins.resurrect;
      }
      tmuxPlugins.gruvbox
      tmuxPlugins.vim-tmux-navigator
      { plugin = tmuxPlugins.continuum;
        extraConfig = ''
        set -g @continuum-restore 'on'
	set-option -g renumber-windows on
        '';
      }
    ];
  };

  programs.neovim = {
    enable = true;
    plugins = with pkgs.vimPlugins; [
      coc-nvim
      gruvbox
      airline
      vim-addon-nix
      vim-tmux-navigator
      emmet-vim
      coc-emmet
      vim-go
      vim-surround
    ];
    withNodeJs = true; 
    extraConfig = ''
      " Enable Gruvbox
      autocmd vimenter * colorscheme gruvbox

      " toggle hybrid line numbers
      :set number! relativenumber!
    '';
  };

  fonts.fontconfig.enable = true;
  
  programs.alacritty.enable = true;
  programs.alacritty.settings = {
    font = {
      normal = {
        family = ''Hack'';
     };
      size = 14;
    };
    window = {
      startup_mode = ''Maximized'';
    };
    shell = {
      program = ''${pkgs.zsh}/bin/zsh'';
      args = [ "--login" "-c" "tmux" ];
    };
    # Colors (Gruvbox dark)
    colors = {
      # Default colors
      primary = {
        # hard contrast: background = '#1d2021'
        background = ''#282828'';
        # soft contrast: background = '#32302f'
        foreground = ''#ebdbb2'';
      };

      # Normal colors
      normal = {
        black   = ''#282828'';
        red     = ''#cc241d'';
        green   = ''#98971a'';
        yellow  = ''#d79921'';
        blue    = ''#458588'';
        magenta = ''#b16286'';
        cyan    = ''#689d6a'';
        white   = ''#a89984'';
      };

      # Bright colors
      bright = {
        black   = ''#928374'';
        red     = ''#fb4934'';
        green   = ''#b8bb26'';
        yellow  = ''#fabd2f'';
        blue    = ''#83a598'';
        magenta = ''#d3869b'';
        cyan    = ''#8ec07c'';
        white   = ''#ebdbb2'';
      };
    };
  };

  programs.doom-emacs = {
    enable = true;
    doomPrivateDir = doom-config;
  };

  # programs.chromium.enable = true;
  # programs.firefox.enable = true;
}
