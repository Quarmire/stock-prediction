let
  # pkgs = import <nixpkgs> { };
  pkgs = import (fetchTarball "https://github.com/NixOS/nixpkgs/archive/5461b7fa65f3ca74cef60be837fd559a8918eaa0.tar.gz") {};
  python = pkgs.python312;
  pythonPackages = python.pkgs;
  lib-path = with pkgs; lib.makeLibraryPath [
    stdenv.cc.cc
  ];
in with pkgs; mkShell {

  packages = [
    (python3.withPackages (p: with p; [
      yfinance
      numpy
      pandas
      requests
      (hmmlearn.overridePythonAttrs (old: { doCheck = false; }))
      matplotlib
      seaborn
      pykalman
      scipy
      scikit-learn
      pymc
    ]))
  ];

  buildInputs = [

  ];

  shellHook = ''
    SOURCE_DATE_EPOCH=$(date +%s)
    export "LD_LIBRARY_PATH=$LD_LIBRARY_PATH:${lib-path}"
    VENV=.venv

    if test ! -d $VENV; then
      python3.12 -m venv $VENV
    fi
    source ./$VENV/bin/activate
    export PYTHONPATH=`pwd`/$VENV/${python.sitePackages}/:$PYTHONPATH
  '';
}
