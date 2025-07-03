{ runCommandNoCC
, makeWrapper
, types
, lib
, root
}:
let
  inherit (types)
    submodule
    attrsOf
    package
    listOf
    path
    str
    ;
  inherit (lib)
    concatStringsSep
    mapAttrsToList
    makeBinPath
    evalModules
    mapAttrs
    mkOption
    pipe
    ;

  baseModule = {
    options.scripts = mkOption {
      type = pipe ({ name, ... }: {
        options = {
          src = mkOption {
            type = path;
            default = root + /${name}.bash;
          };
          aliases = mkOption {
            type = listOf str;
            default = [];
            apply = concatStringsSep " ";
          };
          paths = mkOption {
            type = listOf package;
            default = [];
            apply = makeBinPath;
          };
          substitutions = mkOption {
            type = attrsOf str;
            default = {};
          };
        };
      }) [ submodule attrsOf ];
      apply = mapAttrs (name: { src, paths, aliases, substitutions }:
        runCommandNoCC "${name}-script"
          { nativeBuildInputs = [ makeWrapper ]; }
          ''
            mkdir -p "$out"/bin
            ${if substitutions == {} then ''
              install -m755 "${src}" "$out"/bin/"${name}"
            '' else ''
              substitute "${src}" "$out"/bin/"${name}" \
              ${pipe substitutions [ (mapAttrsToList (key: replacement: ''
                --subst-var-by "${key}" "${replacement}"
              '')) (concatStringsSep "\\\n") ]}
              chmod 755 "$out"/bin/"${name}"
            ''}
            patchShebangs "$out"/bin/"${name}"
            if [ -n "${paths}" ]; then
              wrapProgram "$out"/bin/"${name}" --prefix PATH : "${paths}"
            fi
            if [ -n "${aliases}" ]; then
              for i in ${aliases}; do
                ln -s "${name}" "$out"/bin/"$i"
              done
            fi
          ''
      );
    };
  };
in {
  defsModule = baseModule;
  evalDefs = x: (evalModules { modules = [ baseModule x ]; }).config.scripts;
}