# 後端環境部署

> 說明如何使用本源碼的後端（ROR ruby on rails）

[![回首頁](https://img.shields.io/badge/回首頁-gray?style=for-the-badge)](../README.md)

後端使用ROR(ruby on rails)開發

## 一、安裝 ruby 及 rails

> 請參考 ref: https://ihower.tw/rails/installation.html
安裝完成後利用以下命令確認版本
```console
rails -v
ruby -v
```
>開發用版本號：Rails 7.0.4.3、ruby 3.1.2p20 (2022-04-12 revision 4491bb740a) [x64-mingw-ucrt]
## 二、專案使用
```console
git clone https://github.com/Flyingdolar/MRTPass.git
```
進入backend資料夾，執行以下命令
```console
bundle 
rails db:create
rails db:migrate
rails db:seed
```
>以上指令會建立預設資料庫，內容由backend/db/seed.rb決定，可依需求修改，預設建構時間約為5~10分鐘，請耐心等候
資料庫建立完畢之後即可使用以下命令啟動後端伺服器
```console
rails s
```
>如果想查看當前資料庫內容，可以利用以下命令
```console
rails c
```
>會進入rails console
>至於各個資料表的設定可以去backend/db/schema.rb查看

## 三、使用套件
- jbuilder
  - 定義輸出的JSON格式

- rspec
  - 單元測試

- simplecov
  - 計算單元測試的覆蓋率
