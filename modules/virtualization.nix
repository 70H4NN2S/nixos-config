{ pkgs, ... }:
{
  services.qemuGuest.enable = true;
  virtualisation.docker.enable = true;
  environment.systemPackages = [ pkgs.docker-compose ];
}
