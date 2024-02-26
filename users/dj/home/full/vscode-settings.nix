{ osConfig, lib, ... }:
let
  full-install = osConfig.install-level == "full";
in
{
  config = lib.mkIf full-install
    {
      programs.vscode.userSettings = {
        # Editor settings

        "diffEditor.ignoreTrimWhitespace" = false;
        "editor.fontFamily" = "'Hasklug Nerd Font', 'Hasklug Nerd Font Mono', 'Droid Sans Mono', 'monospace', monospace";
        "editor.fontLigatures" = true;
        "editor.inlineSuggest.enabled" = true;
        "editor.lineNumbers" = "relative";
        "editor.minimap.enabled" = false;
        "editor.stickyScroll.enabled" = true;
        "editor.tabSize" = 2;
        "git.autofetch" = true;
        "git.enableCommitSigning" = true;
        "git.enableSmartCommit" = true;
        "git.ignoreRebaseWarning" = true;
        "git.openRepositoryInParentFolders" = "always";
        "security.workspace.trust.untrustedFiles" = "open";
        "workbench.startupEditor" = "none";
        "workbench.colorTheme" = "Hacker X - Enhanced Material Hacker Theme";
        "workbench.iconTheme" = "material-icon-theme";
        "workbench.editor.empty.hint" = "hidden";
      } // {
        # Plugin settings

        "cmake.showOptionsMovedNotification" = false;
        "cmake.configureOnOpen" = true;
        "codeium.enableConfig" = {
          "*" = true;
          nix = true;
        };
        "githubPullRequests.createOnPublishBranch" = "never";
        "githubPullRequests.pullBranch" = "never";
        "nxConsole.showNodeVersionOnStartup" = false;
        "sql-formatter.uppercase" = true;
      } // (
        {
          # Language settings

          "[python]" = {
            "editor.formatOnType" = true;
          };
        } // (
          # Language formatting settings
          let
            make_formatter_option = (formatter: lang: {
              name = "[${lang}]";
              value = {
                "editor.defaultFormatter" = formatter;
              };
            });
          in
          (
            let
              prettier = [
                "javascript"
                "javascriptreact"
                "typescript"
                "typescriptreact"
                "markdown"
                "html"
                "css"
                "scss"
                "json"
                "jsonc"
                "dockercompose"
              ];
            in
            builtins.listToAttrs (map (make_formatter_option "esbenp.prettier-vscode") prettier)
          ) // (
            builtins.listToAttrs [ ((make_formatter_option "ms-python.black-formatter") "python") ]
          ) // (
            builtins.listToAttrs [ ((make_formatter_option "adpyke.vscode-sql-formatter") "sql") ]
          )
        )
      );
    };
}
