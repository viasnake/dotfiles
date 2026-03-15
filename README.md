# dotfiles

## 対応 OS

- Debian
- Raspbian
- Ubuntu
- Zorin OS
- macOS
- Windows Subsystem for Linux (WSL1)
- Windows Subsystem for Linux 2 (WSL2)

> [!TIP]
> 対応可否は `/etc/os-release` で判定します。
> 実装: `script/bootstrap`

## インストール

### 前提

- git
- make
- sudo

### 手順

```bash
git clone https://github.com/viasnake/dotfiles.git
cd dotfiles
make setup
```

> [!TIP]
> Git の user 情報は `~/.config/git` を編集して設定します。
> ```
> [user]
>     name = <your-name>
>     email = <your-email>
> ```

## 初回セットアップ（dot + Bitwarden + SSH）

この章だけ見れば、初回セットアップが完了するようにしています。

### 1. 共通 secrets ファイルを作成（任意）

```bash
mkdir -p ~/.config/secrets
chmod 700 ~/.config/secrets
cat > ~/.config/secrets/runtime.env.secret <<'EOF'
CONTEXT7_API_KEY=<context7-api-key>
EOF
chmod 600 ~/.config/secrets/runtime.env.secret
```

- 形式は `KEY=VALUE`
- 空行と `#` で始まる行は無視される
- `SECRETS_ENV_FILE` を指定すると別パスを使える
- secrets ファイルは Git 管理しない

### 2. Bitwarden CLI をセットアップ

```bash
bw login
export BW_SESSION="$(bw unlock --raw)"
```

`BW_SESSION` は同一シェルで `make setup` や `make dot-ssh-sync` 実行時に利用されます。

### 3. 初回セットアップを実行（ワンコマンド）

```bash
make setup
```

`make setup` は次を順番に実行します。

- `make link`
- `make install`
- `make dot-bootstrap`

### 4. 主要ターゲット

- `make dot-bootstrap`
- `make dot-work-enable` / `make dot-work-disable` / `make dot-work-sync` / `make dot-work-status`
- `make dot-ssh-sync` / `make dot-ssh-status` / `make dot-ssh-test`

仕事用プロファイルを同時に使う場合は次の順で実行します。

```bash
make dot-work-enable
DOT_WORK_REPO_URL=<ghec-repo-url> make dot-work-sync
make dot-bootstrap
```

### 5. Codex CLI を使う

`make link` 後、Codex の設定は `~/.codex/config.toml` に、グローバル指示は `~/.codex/AGENTS.md` に配置されます。

Context7 を使う場合は、Codex 起動前に必要な環境変数を shell で設定します。

```bash
export CONTEXT7_API_KEY=<context7-api-key>
codex
```

MCP の確認:

```bash
codex mcp --help
```

TUI では `/mcp` でも確認できます。

### 6. opencode を起動

```bash
script/opencode/run-with-secrets
```

Playwright は MCP ではなく repo 管理の `playwright-cli` skill で扱います。

### 7. 最低限の動作確認

```bash
make opencode_validate
make dot-ssh-status
ssh -G github
```

Codex 側は次も確認できます。

```bash
test -L ~/.codex/config.toml
test -L ~/.codex/AGENTS.md
codex mcp --help
```

### 8. 鍵ローテーション

Bitwarden のアイテム更新後に次を実行します。

```bash
make dot-ssh-sync
```

Bitwarden のアイテムは `SSH キー` タイプを使います。

- item type: `SSH キー`
- personal key item name: `personal-ssh`
- work key item name: `work-ssh`

デフォルトでは次のアイテム名で検索します。

- personal: `personal-ssh`
- work: `work-ssh`

必要なら環境変数で上書きできます。

```bash
DOT_SSH_PERSONAL_ITEM=<item-id-or-name> DOT_SSH_WORK_ITEM=<item-id-or-name> make dot-ssh-sync
```

### 9. work 設定の更新

```bash
make dot-work-sync
```

### 10. トラブルシュート

`Permission denied (publickey)` が出る場合:

- `make dot-ssh-status` で鍵ファイルと権限を確認
- `export BW_SESSION="$(bw unlock --raw)"` を再実行
- `make dot-ssh-sync` を再実行

## アンインストール

```bash
make uninstall
```
