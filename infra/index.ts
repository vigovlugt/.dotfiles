import * as pulumi from "@pulumi/pulumi";
import * as cloudflare from "@pulumi/cloudflare";
import * as healthchecksio from "@pulumi/healthchecksio";
import * as b2 from "@pulumi/b2";
import { execFileSync } from "node:child_process";
import * as path from "node:path";

// Subdomains served by Caddy on anakin, read from the NixOS config so DNS stays in sync with it.
function anakinSubdomains(domain: string): string[] {
  const flake = path.resolve(__dirname, "..");
  const hosts: string[] = JSON.parse(
    execFileSync(
      "nix",
      [
        "eval",
        "--json",
        `${flake}#nixosConfigurations.anakin.config.services.caddy.virtualHosts`,
        "--apply",
        "builtins.attrNames",
      ],
      { encoding: "utf8", stdio: ["ignore", "pipe", "inherit"] }
    )
  );
  return hosts.map((host) => {
    if (!host.endsWith(`.${domain}`)) {
      throw new Error(`Caddy host ${host} is not under ${domain}`);
    }
    return host.slice(0, -(domain.length + 1));
  });
}

function setupCloudflare() {
  const cfConfig = new pulumi.Config("cloudflare");
  const apiToken = cfConfig.requireSecret("apiToken");

  const cfProvider = new cloudflare.Provider("cloudflare", {
    apiToken: apiToken,
  });

  const zoneId = "606507539cbba31bf73aa0199da9edc1"; // vigovlugt.com
  const aliases = anakinSubdomains("vigovlugt.com");

  for (const alias of aliases) {
    new cloudflare.DnsRecord(
      alias,
      {
        zoneId: zoneId!,
        name: alias,
        type: "A",
        content: "100.89.17.34",
        ttl: 1, // automatic
        proxied: false, // DNS only
      },
      { provider: cfProvider }
    );
  }
}
setupCloudflare();

function setupHealthchecksIO() {
  const hcConfig = new pulumi.Config("healthchecksio");
  const hcApiKey = hcConfig.requireSecret("apiKey");

  const hcProvider = new healthchecksio.Provider("healthchecksio", {
    apiKey: hcApiKey,
  });

  const anakinBackup = new healthchecksio.Check(
    "anakin-backup",
    {
      name: "Anakin Backup",
      slug: "anakin-backup",
      schedule: "0 4 * * *",
      grace: 3600,
    },
    { provider: hcProvider }
  );

  const anakinBackupPrune = new healthchecksio.Check(
    "anakin-backup-prune",
    {
      name: "Anakin Backup Prune",
      slug: "anakin-backup-prune",
      schedule: "weekly",
      grace: 3600,
    },
    { provider: hcProvider }
  );

  const anakinBackupCheck = new healthchecksio.Check(
    "anakin-backup-check",
    {
      name: "Anakin Backup Check",
      slug: "anakin-backup-check",
      schedule: "monthly",
      grace: 3600,
    },
    { provider: hcProvider }
  );
}
setupHealthchecksIO();

function setupBackblazeB2() {
  const backblazeConfig = new pulumi.Config("backblaze");
  const applicationKeyId = backblazeConfig.requireSecret("applicationKeyId");
  const applicationKey = backblazeConfig.requireSecret("applicationKey");

  const b2Provider = new b2.Provider("b2", {
    applicationKeyId,
    applicationKey,
  });

  const bucket = new b2.Bucket(
    "anakin-backup",
    {
      bucketName: "anakin-backup",
      bucketType: "allPrivate",
    },
    { provider: b2Provider, protect: true }
  );
}
setupBackblazeB2();
