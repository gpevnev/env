{ yaml2json, runCommand }:
yamlPath: let
  baseName = baseNameOf yamlPath;
  jsonPath = runCommand "${baseName}-yaml" {
    buildInputs = [ yaml2json ];
  } "yaml2json ${yamlPath} > $out";
in builtins.fromJSON jsonPath
