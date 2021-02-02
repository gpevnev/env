{ shell, parseYaml }:
{
  font = {
    normal = {
      family = ''Hack'';
    };
    size = 9;
  };
  shell = {
    program = shell;
  };
  colors = parseYaml ./gruvbox.yaml;
}
