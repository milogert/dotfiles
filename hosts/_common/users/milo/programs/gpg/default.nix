{
  ...
}:

{
  programs.gpg = {
    enable = true;

    publicKeys = [
      { source = ./keys/30781D93495C88BBE4B710FE7291258F2B7C086E.txt; trust = 5; }
    ];
  };
}
