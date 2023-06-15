# 前端環境部署

> 記錄一下如何配置一個前端開發環境（Vue + Electron）

[![回首頁](https://img.shields.io/badge/回首頁-gray?style=for-the-badge)](../README.md)

## 一、 安裝 Node.js

> Node 是用來執行 JavaScript 的環境，根據 ChatGPT 有做詳細的介紹（詳見註解）
> <!-- Node.js是一個開源的JavaScript運行環境，可以在伺服器端運行JavaScript程式碼，它使用了Google的V8 JavaScript引擎來解釋和執行JavaScript程式碼。Node.js具有高效的I/O操作和事件驅動的特性，可以很好地處理高併發的情況，因此被廣泛用於編寫伺服器端應用程式。 -->

### 1. Mac 安裝

可以直接使用 Homebrew 安裝：

```bash
brew install node
```

### 2. Linux 安裝

可以直接使用 apt 安裝：

```bash
sudo apt install nodejs
```

#### 可能產生的 Issue

> 如果說你安裝完 nodejs ，使用 `node --version` 發現版本只有 `v10.19.0`
> 你會需要以下的方法來將 nodejs 更新到更新的版本

先安裝 npm （可能要先更新一下 apt get）

```bash
sudo apt update
sudo apt upgrade
sudo apt install npm
```

接著裝 n （n 是一個 Node.js 版本管理工具），並使用 n 來安裝最新的版本

```bash
sudo npm install -g n
sudo n latest
# 或者是 sudo n stable 可以裝比較穩定的版本（但應該都會比 10.19.0 新）
```

> 備注：我們的專案要求至少 node version 需要在 v16.0.0 以上

### 3. Windows 安裝

可以直接到 [Node.js 官網](https://nodejs.org/en/) 下載安裝檔，安裝完後可以在命令列中使用 `node` 指令。

### 4. 檢查是否安裝成功

```bash
node -v
```

如果有顯示版本號，就代表安裝成功了。

## 二、 安裝 pnpm

> pnpm 是一個 Node.js 的套件管理工具，可以用來安裝、更新、移除套件，並且可以管理套件之間的相依性（詳見註解）
> <!-- 除了 pnpm 之外，一般比較常聽到的是 npm 跟 yarn 作為套件管理工具。相較於兩者，pnpm 可以節省大量的硬碟空間，並且可以加快安裝套件的速度。 -->

### 1. Mac 安裝

可以直接使用 Homebrew 安裝：

```bash
brew install pnpm
```

### 2. Linux 安裝

~~可以直接使用 apt 安裝~~ 使用 -curl 安裝（或者是 -wget）：
> \[FIX\] apt 裏面沒有 pnpm，只有 npm，故此方法不可行

```bash
curl -fsSL https://get.pnpm.io/install.sh | sh -
```

安裝完畢之後，記得使用 source 你的 shell 來讓 pnpm 指令生效
> （備注：會顯示在你的安裝訊息）

```bash
source /home/{username}/.bashrc
```

### 3. Windows 安裝

可以直接到 [pnpm 官網](https://pnpm.io/installation) 下載安裝檔，安裝完後可以在命令列中使用 `pnpm` 指令

### 4. 檢查是否安裝成功

```bash
pnpm -v
```

如果有顯示版本號，就代表安裝成功了。

## 三、 安裝 Vue CLI

> Vue CLI 是一個 Vue.js 的開發工具，可以用來快速建立 Vue.js 的專案，並且可以在專案中使用 Vue 的相關工具（詳見註解）
> <!-- 最吸引人的地方莫過於他會有一個選擇的介面，你就不用一個一個手動慢慢裝 -->

### 1. Mac 安裝

可以直接使用 Homebrew 安裝：

```bash
brew install vue-cli
```

### 2. Linux 安裝

可以直接使用 apt 安裝：

```bash
sudo apt install vue-cli
```

### 3. Windows 安裝

可以直接到 [Vue CLI 官網](https://cli.vuejs.org/zh/guide/installation.html) 下載安裝檔，安裝完後可以在命令列中使用 `vue` 指令。

### 4. 檢查是否安裝成功

```bash
vue -V
```

如果有顯示版本號，就代表安裝成功了。

## 四、 使用 Vue CLI 建立專案

### 1. 建立專案

```bash
vue create frontend
```

### 2. 接著，依照提示進行以下的選擇

``` bash
Vue CLI v5.0.8
? Please pick a preset: Manually select features
? Check the features needed for your project: Babel, TS, Router, Linter
? Choose a version of Vue.js that you want to start the project with 3.x
? Use class-style component syntax? Yes // 通常寫 Vue3 都習慣用 Component 這個寫法
? Use Babel alongside TypeScript ? No
? Use history mode for router?  No // 一定要選 No，不然裝 Electron 會出問題
? Pick a linter / formatter config: Prettier
? Pick additional lint features: Lint on save, Lint and fix on commit
? Where do you prefer placing config for Babel, ESLint, etc.? In dedicated config files
```

講解一些上面選的插件是在幹嘛：

| 插件 | 描述 |
| --- | --- |
| Babel | 用來支援一些新的 JavaScript 語法在舊的瀏覽器上執行（向下兼容的概念） |
| TS | 撰寫 typescript 需要用到的插件 |
| Router | 用來做路由的插件（製作多頁面的網頁就會用到） |
| Linter | 用來檢查程式碼是否符合規範的插件（Formatter） |

### 3. 安裝完後，會出現以下的提示

```bash
Vue CLI v5.0.8

? Please pick a preset: vue_TS ([Vue 3] typescript, router, eslint)

Vue CLI v5.0.8
✨  Creating project in /Users/flydoco/Documents/111學習檔案/3_資料庫/MRTPass/frontend.
⚙️  Installing CLI plugins. This might take a while...

🚀  Invoking generators...
📦  Installing additional dependencies...

⚓  Running completion hooks...

📄  Generating README.md...


🎉  Successfully created project frontend.
👉  Get started with the following commands:

$ cd frontend
$ pnpm run serve
```

這時你會有一個 `frontend` 的資料夾，裡面就是你部署的前端了。

可以使用 `pnpm run serve` 來啟動前端伺服器， Run 起來長這樣

```bash
DONE  Compiled successfully in 1237ms                                                                                                                      上午1:46:45

App running at:

- Local:   <http://localhost:8080/>
- Network: <http://192.168.50.163:8080/>

Note that the development build is not optimized.
To create a production build, run pnpm run build.

No issues found.
```

接著就可以在瀏覽器中輸入 `http://localhost:8080` 來看到你的前端網頁了。

## 五、 安裝 Electron

> 剛剛前面講到的事情，都是在做一個網頁，但是如果我們要製作一個 APP 的話，就需要使用 Electron 來幫我們製作

### 1. 從 Vue 安裝 Electron

```bash
vue add electron-builder
```

### 2. 接著，你就可以嘗試啟動專案了 （APP 的樣式）

```bash
pnpm run electron:serve
```

啟動成功之後，會出現這樣的一個畫面：

![vue-electron](https://imgur.com/a/XEfLyGZ)

#### <span style="color:red">※ 特別注意：</span>

1. 如果你在選擇 Vue CLI 的時候，選擇了 `history mode for router`，那麼你就必須要在 `vue.config.js` 中加入以下的設定：

    ```js
    module.exports = {
    pluginOptions: {
        electronBuilder: {
        nodeIntegration: true,
        },
    },
    };
    ```

2. 如果你在啟動時發生了任何錯誤，請確認一下你的 `package.json` 是否正確安裝最新版本到 `node_modules`

     ```bash
     pnpm install
     ```

3. 不太確定是不是 Bug ，但 `ts-loader` 似乎版本太新會導致無法正常啟動，所以建議目前先降版本到 `ts-loader@8.2.0`

     ```bash
     pnpm install ts-loader@8.2.0 --save-dev
     ```

## 六、 啟動錯誤 BUG

實際操作時，出現兩個錯誤：

1. 無法讀取 `VUEJS3_DEVTOOLS`

    ![vue-electron-error](https://imgur.com/15MHx1A)

    將上面的程式碼改成

    ```typescript
    import installExtension, { VUEJS_DEVTOOLS as VUEJS3_DEVTOOLS } from "electron-devtools-installer";
    ```

2. 無法定義 e 的型別

    ![vue-electron-error2](https://imgur.com/Aija141)

    將上面的程式碼改成

    ```typescript
    console.error("Vue Devtools failed to install:", e as string);
    ```
