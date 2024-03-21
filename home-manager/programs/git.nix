{ config, ... }:

{
  programs.git = {
    enable = true;

    # TODO: Move these details to user-entries
    userName = "Dennis James Stelmach";
    userEmail = "dj@dstelmach.com";
    signing = {
      signByDefault = true;
      key = "E1A18DF6B4F919E4";
    };

    aliases = {
      gone = "!f() { git fetch --all --prune; git branch -vv | awk '/: gone]/{print $1}' | xargs git branch -D; }; f";
    };

    extraConfig = {
      core = {
        editor = config.my.settings.default.editor;
        pager = "delta";
      };

      color = {
        ui = true;
      };

      interactive = {
        diffFitler = "delta --color-only";
      };

      delta = {
        enable = true;
        navigate = true;
        light = false;
        side-by-side = false;
        options.syntax-theme = "catppuccin";
      };

      pull = {
        ff = "only";
      };

      push = {
        default = "current";
        autoSetupRemote = true;
      };

      init = {
        defaultBranch = "main";
      };
    };
  };

  programs.lazygit = {
    enable = true;
    settings = {
      git = {
        paging = {
          colorArg = "always";
          pager = "delta --color-only --dark --paging=never";
          useConfig = false;
        };
      };
      gui.theme = {
        lightTheme = false;
        activeBorderColor = [ "#${config.colorScheme.palette.base0B}" "bold" ];
        inactiveBorderColor = [ "#${config.colorScheme.palette.base05}" ];
        optionsTextColor = [ "#${config.colorScheme.palette.base0D}" ];
        selectedLineBgColor = [ "#${config.colorScheme.palette.base02}" ];
        selectedRangeBgColor = [ "#${config.colorScheme.palette.base02}" ];
        cherryPickedCommitBgColor = [ "#${config.colorScheme.palette.base0C}" ];
        cherryPickedCommitFgColor = [ "#${config.colorScheme.palette.base0D}" ];
        unstagedChangesColor = [ "#${config.colorScheme.palette.base08}" ];
      };
      customCommands = [
        {
          key = "W";
          command = "git commit -m '{{index .PromptResponses 0}}' --no-verify";
          description = "commit without verification";
          context = "global";
          subprocess = true;
        }
        {
          key = "S";
          command = "git commit -m '{{index .PromptResponses 0}}' --no-gpg-sign";
          description = "commit without gpg signing";
          context = "global";
          subprocess = true;
        }
      ];
    };
  };
}
