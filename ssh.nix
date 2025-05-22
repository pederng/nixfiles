_:{
  programs.ssh = {
    enable = true;
    forwardAgent = true;
    matchBlocks = {
      "asbest" = {
        hostname = "bk.cptr.no";
      };
      "bast1" = {
        hostname = "dora.cptr.no";
        port = 2233;
        proxyCommand = "ssh -q -W %h:%p asbest";
      };
      "bast2" = {
        hostname = "dora.cptr.no";
        port = 2234;
        proxyCommand = "ssh -q -W %h:%p asbest";
      };
      "staging" = {
        hostname = "app9";
        proxyCommand = "ssh -q -W app9:%p bast1";
      };
      "app*" = {
        proxyCommand = "ssh -q -W %h:%p bast1";
      };
      "util1" = {
        proxyCommand = "ssh -q -W %h:%p bast1";
      };
      "search*" = {
        proxyCommand = "ssh -q -W %h:%p bast1";
      };
      "bk-ci**" = {
        proxyCommand = "ssh -q -W %h.dhcp.bk.cptr.no:%p asbest";
      };
      "client" = {
        hostname = "login-client.univex.no";
      };
      "*" = {
        user = "pedernot";
        serverAliveInterval = 60;
        forwardX11 = false;
      };
    };
  };
}
