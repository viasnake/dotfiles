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

## 初回セットアップ（dot）

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

### 2. 初回セットアップを実行（ワンコマンド）

```bash
make setup
```

`make setup` は次を順番に実行します。

- `make link`
- `make install`
- `make dot-bootstrap`

### 3. 主要ターゲット

- `make dot-bootstrap`

### 4. Codex CLI を使う

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

### 5. opencode を起動

```bash
script/opencode/run-with-secrets
```

Playwright は MCP ではなく repo 管理の `playwright-cli` skill で扱います。

### 6. 最低限の動作確認

```bash
make opencode_validate
make dot-bootstrap
```

非破壊のスモークテストだけをまとめて実行する場合は、次を使います。

```bash
make test-smoke
```

`make test-smoke` は次を実行します。

- `./script/dot help`
- `make opencode_validate`
- `make -n dot-bootstrap`

環境に `bats` がある場合は、単体テストを含めて次も実行できます。

```bash
make test
```

`make test` は `test-smoke` と `test-unit` を順番に実行します。
`test-unit` は `bats` が未インストールならスキップされます。
ただし CI 環境では `bats` が見つからない場合にエラーで終了します。
`bats` は `mise` で導入できます。

```bash
mise install bats
```

現在の `test-unit` は次を対象にしています。

- `script/lib/load-secrets-env`
- `script/dot` の非破壊 CLI パス（`help`、不正コマンド、不正引数）
- `script/opencode/validate` の正常系/異常系（fixture ベース）

GitHub Actions では `pull_request` と `master` への push で `make test` を実行します。

Codex 側は次も確認できます。

```bash
test -L ~/.codex/config.toml
test -L ~/.codex/AGENTS.md
codex mcp --help
```

### 7. トラブルシュート

`make dot-bootstrap` が失敗する場合:

- `./script/dot help` でコマンドが実行可能か確認
- `make link` を再実行してシンボリックリンクを更新
- `make -n dot-bootstrap` で実行内容を確認

## アンインストール

```bash
make uninstall
```
