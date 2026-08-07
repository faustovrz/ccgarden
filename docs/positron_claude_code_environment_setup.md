# Workshop Environment Setup (Session 1)

**Audience:** Lab members on **macOS** or **Windows**, with admin rights on their machine.
**Goal:** Walk out with the full workshop environment — **Positron**, **Claude Code**, **git**/**gh**, and the **`primercrisp`** project — ready for Session 2.

> **How this works:** almost everything is installed by **one bootstrap script** from the `primercrisp` repo. You only create your accounts, install Positron, run the script, and sign in. Follow the **one track that's yours** — macOS or Windows (WSL). The Accounts and Finish-setup sections apply to everyone.
>
> **Before you start:** confirm you have **admin rights** and **~10 GB free disk**. The bootstrap needs roughly **8 GB** — the conda toolchain plus a ~3.5 GB reference genome — so leave headroom.

---

## 1. Accounts (everyone)

Create all three with your `@ncsu.edu` Google sign-in (one login, no new passwords):

- **GitHub** — <https://github.com> — then enable **2FA** in *Settings → Password and authentication* and **save the recovery codes**.
- **Anthropic (Claude)** — <https://claude.ai>
- **Posit** — <https://connect.posit.cloud> (sign in with your GitHub account) — used to publish.

---

## 2a. macOS track

1. **Homebrew** — if you don't have it (the bootstrap uses it for `gh` and R):
   ```bash
   /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
   ```
   Follow the printed instructions to add `brew` to your PATH, then check `brew --version`.

2. **Positron:**
   ```bash
   brew install --cask positron
   ```
   (Or the `.dmg` from <https://positron.posit.co/download.html>.) Launch it once; when it offers to install R, accept.

3. **Run the bootstrap** — installs git, gh, Claude Code, the conda toolchain, and stages the genome (**~3.5 GB, 10–20 min**):
   ```bash
   curl -fsSL https://raw.githubusercontent.com/faustovrz/primercrisp/main/setup/bootstrap.sh | bash
   ```

Then go to **§3 Finish setup**.

---

## 2b. Windows (WSL) track

Every command-line step lives **inside WSL** (Ubuntu), not PowerShell. Positron is the one Windows GUI install; it connects *into* WSL.

1. **Install WSL** — in **PowerShell as administrator**:
   ```powershell
   wsl --install
   ```
   Restart when prompted, then pick a Linux username/password in the Ubuntu window. Verify with `wsl -l -v` (should show `Ubuntu`, `VERSION 2`). Details + Positron↔WSL connection: `set_up_wsl_for_positron_windows.qmd`.

2. **Positron** — install on the **Windows side** (PowerShell):
   ```powershell
   winget install Posit.Positron
   ```

3. **Run the bootstrap in your Ubuntu (WSL) terminal** — installs git, gh, Claude Code, the sandbox deps (bubblewrap/socat), the conda toolchain, and stages the genome (**~3.5 GB, 10–20 min**):
   ```bash
   curl -fsSL https://raw.githubusercontent.com/faustovrz/primercrisp/main/setup/bootstrap.sh | bash
   ```

Then go to **§3 Finish setup** — run those commands in the **Ubuntu (WSL)** terminal.

---

## 3. Finish setup (everyone)

The bootstrap installs the tools but leaves sign-in and identity to you:

1. **Set your Git identity** (once, ever):
   ```bash
   git config --global user.name "Your Name"
   git config --global user.email "you@ncsu.edu"
   ```

2. **Authenticate GitHub:**
   ```bash
   gh auth login
   ```
   Choose **GitHub.com → HTTPS → Login with a web browser**, then paste the 8-character code in the browser.
   *(WSL has no default browser — it prints a URL; open it in any Windows browser.)*

3. **Point Claude Code at Opus 4.8** — launch it and set the model:
   ```bash
   claude
   ```
   ```
   /model claude-opus-4-8
   ```
   Use the full name (the `opus` alias now points to Opus 5). If it isn't offered, run `claude update` first.

---

## 4. Sanity checks

In a fresh terminal (**Ubuntu / WSL** on Windows), from `~/primercrisp`:

```bash
git --version
gh auth status
claude --version
conda activate primercrisp && samtools --version | head -1
```

All should print without errors. In **Positron**, the bottom-right shows `R x.x.x`; on Windows, once connected, the title bar shows `WSL: Ubuntu`.

---

## Troubleshooting

| Symptom | Fix |
|---|---|
| `claude: command not found` | Reopen the terminal (the bootstrap adds `~/.local/bin` to `.bashrc`/`.zshrc`). Still missing? `echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc && source ~/.bashrc` |
| `gh` browser doesn't open (WSL) | Expected — copy the printed URL into a Windows browser and paste the code |
| `wsl --install` needs elevation | Run **PowerShell as administrator**, then restart |
| `brew` not found (Mac) | Install Homebrew first (§2a) — the bootstrap needs it for `gh` and R |
| Files under `/mnt/c/...` very slow (WSL) | Keep the project under your Linux home (`~/`), not the Windows mount — see the WSL guide |
| `gh auth login` fails on NC State VPN | Disconnect VPN, retry, reconnect after |

---

## Reference links

- `primercrisp` starter (bootstrap): <https://github.com/faustovrz/primercrisp>
- WSL setup + Positron connection: `set_up_wsl_for_positron_windows.qmd`
- Claude Code docs: <https://docs.claude.com/en/docs/claude-code>
- Positron: <https://positron.posit.co>
- gh CLI: <https://cli.github.com>
- Homebrew (Mac): <https://brew.sh>
