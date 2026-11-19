{ pkgs, ... }:
{
  networking.networkmanager.enable = true;
  environment.systemPackages = with pkgs; [
    nmap tcpdump iperf3 dnsutils
  ];
}
