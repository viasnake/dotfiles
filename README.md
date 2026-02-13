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

### 2. `dot` コマンドを有効化

```bash
make link
```

`~/.local/bin/dot` にシンボリックリンクが作成されます。

### 3. Bitwarden CLI をセットアップ

```bash
bw login
export BW_SESSION="$(bw unlock --raw)"
```

`BW_SESSION` は同一シェルで `dot ssh sync` 実行時に利用されます。

### 4. bootstrap を実行

```bash
dot bootstrap
```

仕事用プロファイルを同時に使う場合は次の順で実行します。

```bash
dot work enable
DOT_WORK_REPO_URL=<ghec-repo-url> dot work sync
dot bootstrap
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
dot ssh status
ssh -G github
```

### 7. 鍵ローテーション

Bitwarden のアイテム更新後に次を実行します。

```bash
dot ssh sync
```

デフォルトでは次のアイテム名を検索します。

- personal: `personal-ssh`
- work: `work-ssh`

必要なら環境変数で上書きできます。

```bash
DOT_SSH_PERSONAL_ITEM=<item-id-or-name> DOT_SSH_WORK_ITEM=<item-id-or-name> dot ssh sync
```

### 8. work 設定の更新

```bash
dot work sync
```

### 9. トラブルシュート

`Permission denied (publickey)` が出る場合:

- `dot ssh status` で鍵ファイルと権限を確認
- `export BW_SESSION="$(bw unlock --raw)"` を再実行
- `dot ssh sync` を再実行

## アンインストール

```bash
make uninstall
```
