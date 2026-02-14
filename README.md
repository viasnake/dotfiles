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
make install
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

### 2. dot 管理コマンドを有効化

```bash
make link
```

以降の dot 管理操作はすべて `make` ターゲット経由で実行します。

主要ターゲット:

- `make dot-bootstrap`
- `make dot-work-enable` / `make dot-work-disable` / `make dot-work-sync` / `make dot-work-status`
- `make dot-ssh-sync` / `make dot-ssh-status` / `make dot-ssh-test`

### 3. Bitwarden CLI をセットアップ

```bash
bw login
export BW_SESSION="$(bw unlock --raw)"
```

`BW_SESSION` は同一シェルで `make dot-ssh-sync` 実行時に利用されます。

### 4. bootstrap を実行

```bash
make dot-bootstrap
```

仕事用プロファイルを同時に使う場合は次の順で実行します。

```bash
make dot-work-enable
DOT_WORK_REPO_URL=<ghec-repo-url> make dot-work-sync
make dot-bootstrap
```

### 5. opencode を起動

個人プロファイル（外部 MCP 利用）:

```bash
OPENCODE_PROFILE=personal script/opencode/run-with-secrets
```

仕事プロファイル（外部 MCP 無効）:

```bash
OPENCODE_PROFILE=work script/opencode/run-with-secrets
```

### 6. 最低限の動作確認

```bash
script/opencode/validate personal
make dot-ssh-status
ssh -G github
```

### 7. 鍵ローテーション

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

### 8. work 設定の更新

```bash
make dot-work-sync
```

### 9. トラブルシュート

`Permission denied (publickey)` が出る場合:

- `make dot-ssh-status` で鍵ファイルと権限を確認
- `export BW_SESSION="$(bw unlock --raw)"` を再実行
- `make dot-ssh-sync` を再実行

## アンインストール

```bash
make uninstall
```
