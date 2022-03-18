let
  pkgs = import <nixpkgs> {};
in

{
  # https://processing.org/ 4 beta
  processing4 = pkgs.callPackage ./processing4 {};
  # can run .NET CLI tools
  fhs-run     = pkgs.callPackage ./fhs-run {};
  # xournal++ for note-taking
  xournalpp   = pkgs.libsForQt5.callPackage ./xournalpp {};
}