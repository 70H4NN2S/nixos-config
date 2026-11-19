{ ... }:
{
  services.openssh = {
    enable = true;
    settings.PermitRootLogin = "no";
  };
  networking.firewall.enable = true;
  # Authentication policy is deliberately unchanged by this refactor.
  # Configure and test key-based login before disabling password access.
}
