{ mkShell, rnix-lsp, terraform-ls, tree-sitter }:

mkShell {
  buildInputs = [
    terraform-ls
    tree-sitter
  ];
}
