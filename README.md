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

## 初回セットアップ（opencode + SSH）

この章だけ見れば、初回セットアップが完了するようにしています。

### 1. 共通 secrets ファイルを作成

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

### 2. opencode を起動

個人プロファイル（外部 MCP 利用）:

```bash
OPENCODE_PROFILE=personal script/opencode/run-with-secrets
```

仕事プロファイル（外部 MCP 無効）:

```bash
OPENCODE_PROFILE=work script/opencode/run-with-secrets
```

### 3. SSH 鍵をローカル配置する

```bash
chmod 700 ~/.ssh
chmod 600 ~/.ssh/snake
```

`config/ssh/config` は GitHub に対して `IdentityFile ~/.ssh/snake` を使います。

### 4. 最低限の動作確認

```bash
script/opencode/validate personal
ssh -G github -F config/ssh/config
ssh -T git@github.com
```

### 5. トラブルシュート

`Permission denied (publickey)` が出る場合:

- `~/.ssh/snake` が存在するか確認
- `chmod 600 ~/.ssh/snake` を再実行
- `ssh -G github -F config/ssh/config | grep identityfile` で反映確認

## アンインストール

```bash
make uninstall
```
