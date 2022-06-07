{ mkShell, rnix-lsp, terraform-ls, tree-sitter }:

mkShell {
  buildInputs = [
    rnix-lsp
    terraform-ls
    tree-sitter
  ];
}
