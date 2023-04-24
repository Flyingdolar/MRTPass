# 後端環境部署

[![回首頁](https://img.shields.io/badge/回首頁-gray?style=for-the-badge)](../README.md)

## 一、在 VS code 中安裝拓展包

1. Extension Pack for Java
2. SQLite
3. Gradle for Java

## 二、安裝 Java JDK

1. 安裝java JDK
2. 設定環境變數 path -> `java\jdk\bin`
3. 完成後 在 terminal 中輸入 java 會出現 `usage` 表示成功

## 三、安裝 SQLite

1. 安裝sqlite3
2. 設定環境變數 path -> `sqlite3`
3. 完成後 在 terminal 中輸入 sqlite3 會看到 `sqlite>` 表示成功
4. 安裝 `sqlite-jdbc-3.41.2.1.jar`  [安裝連結](https://github.com/xerial/sqlite-jdbc/releases)
5. 放到專案中的 `lib` 資料夾

## 四、安裝 Gradle

1. 安裝 gradle
2. 設定環境變數 path->gradle\bin
3. 完成後 在 terminal 中輸入 `gradle -v` 會看到版本 表示成功
4. 根目錄建立 `build.gradle`

    ```json
    plugins {
        id 'java'
    }

    repositories {
        jcenter()
    }

    dependencies {
        implementation 'org.xerial:sqlite-jdbc:3.41.2.1'
    }
    ```

## 五、建立專案

專案下設置 src 資料夾，下面放 `Main.java`

```java
package src;
import java.sql.*;

public class Main {
    public static void main(String[] args) {
        Connection conn = null;
        try {
            // 註冊 JDBC 驅動器
            Class.forName("org.sqlite.JDBC");

            // 開啟一個連接到 SQLite 資料庫的連接
            conn = DriverManager.getConnection("jdbc:sqlite:test.db");

            // 建立一個 Statement 物件
            Statement stmt = conn.createStatement();

            // 建立一個 user 資料表
            stmt.execute("CREATE TABLE IF NOT EXISTS user (id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT NOT NULL, age INTEGER NOT NULL)");

            // 插入一些資料
            stmt.executeUpdate("INSERT INTO user (name, age) VALUES ('John', 25)");
            stmt.executeUpdate("INSERT INTO user (name, age) VALUES ('Mary', 30)");
            stmt.executeUpdate("INSERT INTO user (name, age) VALUES ('Tom', 20)");

            // 查詢資料
            ResultSet rs = stmt.executeQuery("SELECT * FROM user");
            while (rs.next()) {
                System.out.println("id = " + rs.getInt("id") + ", name = " + rs.getString("name") + ", age = " + rs.getInt("age"));
            }

            // 更新資料
            stmt.executeUpdate("UPDATE user SET age = 35 WHERE name = 'Mary'");

            // 刪除資料
            stmt.executeUpdate("DELETE FROM user WHERE name = 'Tom'");

            // 關閉資源
            rs.close();
            stmt.close();
            conn.close();
        } catch (Exception e) {
            System.err.println(e.getClass().getName() + ": " + e.getMessage());
        }
    }
}
```
