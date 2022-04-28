{ fetchFromGitHub, python3Packages, lib, pkgs, python }:

{ 
  pyeconet = python3Packages.buildPythonPackage rec {
    pname = "pyeconet";
    version = "0.1.14";

    src = fetchFromGitHub {
      owner = "w1ll1am23";
      repo = pname;
      rev = version;
      sha256 = "03mb2qcvaz7f9cxbck25rc843xwzadqzqhgf7fwgydfma431v5az";
    };

    # buildPhase = "${python.interpreter} src/setup.py bdist_wheel";

    # propagatedBuildInputs = with python3Packages; [
    #   dateutil
    #   falcon
    #   gunicorn
    #   isodate
    #   jinja2
    #   markdown
    #   rdflib
    #   rdflib-jsonld
    #   requests
    #   six
    #   beautifulsoup4
    # ];
  };

  pylitterbot = python3Packages.buildPythonApplication rec {
    pname = "pylitterbot";
    version = "2021.9.0";

    src = fetchFromGitHub {
      owner = "natekspencer";
      repo = pname;
      rev = version;
      sha256 = "1mpiimzvizc5h3px2l7x6jx96rjisn9wnydd4vk0j1xg9vv72vjb";
    };

    propagatedBuildInputs = with python3Packages; [
      pytz
      authlib
      httpx
    ];

    checkInputs = with python3Packages; [
      pytest
    ];
  };
}
