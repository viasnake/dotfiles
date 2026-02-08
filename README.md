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

## 初回セットアップ（Bitwarden + opencode + SSH）

この章だけ見れば、初回セットアップが完了するようにしています。

### 1. Bitwarden CLI の認証情報を取得

#### BW_CLIENTID / BW_CLIENTSECRET

1. Bitwarden Web Vault を開く
2. `Settings` -> `Security` -> `Keys` -> `API Key`
3. API key を作成または表示
4. 以下を控える
   - `client_id` -> `BW_CLIENTID`
   - `client_secret` -> `BW_CLIENTSECRET`

#### BW_PASSWORD

- Bitwarden のマスターパスワード

#### BW_CONTEXT7_ITEM_ID / BW_SSH_KEY_ITEM_ID

1. Bitwarden で対象アイテムを用意
   - Context7 API key 用アイテム
   - SSH private key 用アイテム
2. CLI で一度ログイン・アンロック

```bash
bw login --apikey
export BW_PASSWORD='<your-master-password>'
export BW_SESSION="$(bw unlock --passwordenv BW_PASSWORD --raw)"
```

3. アイテム ID を検索

```bash
bw list items --search "context7" --session "$BW_SESSION"
bw list items --search "ssh" --session "$BW_SESSION"
```

4. 各アイテムの `id` を控える

### 2. 共通 secrets ファイルを作成

```bash
mkdir -p ~/.config/secrets
chmod 700 ~/.config/secrets
cat > ~/.config/secrets/runtime.env.secret <<'EOF'
BW_CLIENTID=<bitwarden-api-client-id>
BW_CLIENTSECRET=<bitwarden-api-client-secret>
BW_PASSWORD=<bitwarden-master-password>
BW_CONTEXT7_ITEM_ID=<bitwarden-item-id-for-context7>
BW_SSH_KEY_ITEM_ID=<bitwarden-item-id-for-ssh-key>
EOF
chmod 600 ~/.config/secrets/runtime.env.secret
```

- 形式は `KEY=VALUE`
- 空行と `#` で始まる行は無視される
- `SECRETS_ENV_FILE` を指定すると別パスを使える
- secrets ファイルは Git 管理しない

### 3. opencode を起動

個人プロファイル（外部 MCP 利用）:

```bash
OPENCODE_PROFILE=personal script/opencode/run-with-secrets
```

仕事プロファイル（外部 MCP 無効）:

```bash
OPENCODE_PROFILE=work script/opencode/run-with-secrets
```

### 4. サーバで SSH コマンドを実行

```bash
script/ssh/with-agent-secrets -- ssh -T git@github.com
```

- 一時 `ssh-agent` を起動
- Bitwarden から鍵を読み込み `ssh-add -` で投入
- コマンド終了時に agent を停止

### 5. 最低限の動作確認

```bash
bw --version
script/opencode/validate personal
ssh -G github -F config/ssh/config
```

### 6. トラブルシュート

`[WARNING] SSH_AUTH_SOCK is not set. Bitwarden SSH Agent is required.` が出る場合:

- ローカル端末: Bitwarden Desktop の SSH Agent を有効化し、新しいターミナルを開く
- サーバ作業: `script/ssh/with-agent-secrets -- <command>` で実行する

## アンインストール

```bash
make uninstall
```
