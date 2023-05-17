# 開發過程提醒事項

> Reference to Howard Guo

## 動工前

**同步進度**
先執行 `git pull` 將其他人最新的進度同步進來本機

**切換/建立分支**
分支命名範例：

```
feat/navbar
docs/README
```

## 提交前

1. 執行 `pnpm lint`
2. 上一步有出現紅字的話可以透過 `pnpm lint --fix` 修復，修復後再執行一次 `pnpm lint`
3. `pnpm lint` 沒問題就可以著手進行提交

## 提交訊息

撰寫 commit message 時須遵守 [Conventional Commits](https://www.conventionalcommits.org/en/v1.0.0/)

範例：

```text
docs(README): fix chown argument
feat(navbar): Add i18n language switch
```

**格式概觀**

```text
<類別>[影響範圍（選填）]: <敘述>

[內文（選填）]

[腳註（選填）]
```

常見類別：

- fix
- feat
- BREAKING CHANGE
- build
- chore
- docs
- style
- refactor
- perf
- test

如果需要填寫內文及腳註，git commit 時不要加 `-m "<COMMIT MESSAGE>"` 選項，git 會開啟文字編輯器讓你填寫，慣用的文字編輯器可以透過 `git config --global core.editor <想要用的文字編輯器>` 來設定。

HI
