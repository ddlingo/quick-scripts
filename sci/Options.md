# Option A (Recommended): Vault SSH CA with 2-hour certs

No public key stays on the server; the cert just expires.

**On Vault (once):**

```bash
# Enable CA and create a signing key
vault secrets enable -path=ssh-client-signer ssh
vault write ssh-client-signer/config/ca generate_signing_key=true

# Create a 2h role
vault write ssh-client-signer/roles/breakglass \
  allowed_users="cloud-user" \
  default_user="cloud-user" \
  ttl=2h max_ttl=2h
```

**On every target host (once):**

```bash
# Fetch the CA public key from Vault
vault read -field=public_key ssh-client-signer/config/ca > /etc/ssh/trusted-user-ca-keys.pem

# Tell sshd to trust Vault's CA, then restart
echo 'TrustedUserCAKeys /etc/ssh/trusted-user-ca-keys.pem' >> /etc/ssh/sshd_config
systemctl restart sshd
```

**To grant 2h access (each use):**

```bash
# Use any existing SSH public key for the operator (no private key in Vault)
vault write -field=signed_key ssh-client-signer/sign/breakglass \
  public_key=@~/.ssh/id_rsa.pub > ~/.ssh/id_rsa-cert.pub

# Log in using your key + the short-lived cert
ssh -i ~/.ssh/id_rsa -o CertificateFile=~/.ssh/id_rsa-cert.pub cloud-user@<host>
```

After 2 hours the cert is invalid—no server-side cleanup required.

---

# Option B: Inject a key and auto-remove after 2 hours (cloud-init)

Use OpenStack “User Data” to add a user/key **and** a systemd timer that deletes it.

Paste this into the **User Data** field when creating the instance:

```yaml
#cloud-config
users:
  - name: breakglass
    sudo: ALL=(ALL) NOPASSWD:ALL
    groups: sudo
    shell: /bin/bash
    ssh_authorized_keys:
      - ssh-rsa AAAAB3...REPLACE_WITH_PUBLIC_KEY...

write_files:
  - path: /usr/local/sbin/remove-breakglass.sh
    permissions: '0750'
    owner: root:root
    content: |
      #!/usr/bin/env bash
      set -euo pipefail
      userdel -r breakglass 2>/dev/null || true
      sed -i '/BREAKGLASS-KEY/d' /home/*/.ssh/authorized_keys || true
      sed -i '/BREAKGLASS-KEY/d' /root/.ssh/authorized_keys || true
      systemctl disable --now breakglass-expire.timer || true
  - path: /etc/systemd/system/breakglass-expire.service
    permissions: '0644'
    content: |
      [Unit]
      Description=Remove breakglass user and key

      [Service]
      Type=oneshot
      ExecStart=/usr/local/sbin/remove-breakglass.sh
  - path: /etc/systemd/system/breakglass-expire.timer
    permissions: '0644'
    content: |
      [Unit]
      Description=Trigger removal of breakglass user after 2h

      [Timer]
      OnBootSec=2h
      AccuracySec=1min
      Persistent=true

      [Install]
      WantedBy=timers.target

runcmd:
  - sed -i '1s/^/## BREAKGLASS-KEY ##\n/' /home/breakglass/.ssh/authorized_keys
  - systemctl daemon-reload
  - systemctl enable --now breakglass-expire.timer
```

Notes:

* Replace the `ssh-rsa AAAAB3…` with your public key.
* The timer runs once, ~2h after boot, and removes the user/key.
* If you relaunch or rebuild, the timer resets (which is fine for “break-glass”).

---

## Which to choose?

* **Vault SSH CA (Option A)**: Best. Truly ephemeral, no server changes per event (after initial CA trust). Automatic expiry—no cleanup.
* **Cloud-init timer (Option B)**: Works anywhere, but you *do* place a key on the box and rely on a timer to remove it.

If you’d like, I can give you a minimal **Ansible play** to push the Vault CA trust to existing hosts, or a tiny **make target** for issuing 2h certs from Vault.
