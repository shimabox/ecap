# ecap

**Easy Capture** - 簡単キャプチャツール -  
略してecap (イーキャプ) です

- CSVファイルに書かれている値 (<code>URL,ファイル名(拡張子無し),出力タイプ(pdf or img)</code>) を見て、画面キャプチャします
- 画面キャプチャは **pdf** or **jpg** で出力します
- [wkhtmltopdf](http://wkhtmltopdf.org/index.html "wkhtmltopdf") に依存します
- See also [wkhtmltopdf / wkhtmltoimageを使って画面キャプチャするバッチスクリプトを書いた | Shimabox Blog](https://blog.shimabox.net/2016/10/31/wkhtmltopdf-wkhtmltoimage-batch/ "wkhtmltopdf / wkhtmltoimageを使って画面キャプチャするバッチスクリプトを書いた | Shimabox Blog")

## このキャプチャツールを使う前の設定

### [wkhtmltopdf](http://wkhtmltopdf.org/index.html "wkhtmltopdf") のインストール

- [wkhtmltopdf](http://wkhtmltopdf.org/index.html "wkhtmltopdf") に依存していますのでインストールが必要です

#### Windows(64bit) でのインストール手順
- [wkhtmltopdf downloads](http://wkhtmltopdf.org/downloads.html "wkhtmltopdf") のStableから自分のプラットフォームにあったバイナリー(Windows / 64-bit)を選択してインストールします
- インストールが終わったらパスを通します
- wkhtmltopdfのパスを通す
    - コンピューター -> 右クリック -> プロパティを選択 -> システムの詳細設定を選択
    - 環境変数を選択 -> システム環境変数のPathを選択 -> 編集ボタンを選択
    - 一番最後に、
    ```
    ;C:\Program Files\wkhtmltopdf\bin
    ```
    を入力(各自ダウンロード先を確認してください)
    - PCの再起動
    - コマンドプロンプト (cmd) で以下を入力します
    ```
    wkhtmltopdf -V
    ```
    - こんな感じでバージョンが出たらおｋです

    ```
    wkhtmltopdf 0.12.3.2 (with patched qt)
    ```

#### Mac(macOs Sierra 10.12) の手順
- [wkhtmltopdf downloads](http://wkhtmltopdf.org/downloads.html "wkhtmltopdf") のStableから自分のプラットフォームにあったバイナリー(OS X / 64-bit)を選択してインストールします。
- インストールするときに **開発元が未確認のため開けません** みたいに怒られたら、システム環境設定 -> セキュリティとプライバシー -> 一般 -> ダウンロードしたアプリケーションの実行許可で **このまま開く** を選択してください
- インストールが終わったら以下コマンドをターミナルで実行します
```
$ wkhtmltopdf -V
```
- こんな感じでバージョンがでたらおｋです
```
wkhtmltopdf 0.12.3 (with patched qt)
```

### 動作環境

- Windows (64bit), Mac (macOs Sierra 10.12) で動作確認済みです
    - Windowsは<code>ecap.bat</code>, Macは<code>ecap.sh</code>を使ってください
- Windowsでの利用を想定して作ったのでCSVファイルの形式は以下となります
    - 文字コードは**Shift_JIS**
    - 改行コードは**CRLF**  
- 後述しますがシェル<code>ecap.sh</code>を修正すれば、<code>UTF-8, LF</code> のファイルも利用できます

### 使い方

- example.url.csv をコピーして url.csv を作ってください
```
cp example.url.csv url.csv
```
- url.csv **※ 必ず最後の行に改行を入れてください!!**
```
URL,ファイル名(拡張子無し),出力タイプ(pdf or img)
https://www.google.co.jp/,google,pdf
http://www.yahoo.co.jp/,yahoo,img
https://www.google.co.jp/,google,img
https://ja.wikipedia.org/wiki/日本語ドメイン,日本語ドメイン,pdf
```
上記にある通り、文字コードはShift_JIS, 改行コードはCRLFとなります。  
※ 空行とかの考慮はしていませんのであしからず

- 実行
    - Windowsの場合
    ```
    ecap.bat
    ```
    - Macの場合
    ```
    bash ecap.sh
    ```
- 結果
    - 出力タイプでpdfを指定した場合
        - pdf/ 以下に 指定したファイル名.pdf が出力される
    - 出力タイプでimgを指定した場合
        - img/ 以下に 指定したファイル名.jpg が出力される
- 出力後のディレクトリ構成
```sh
ecap
|--README.md
|--.gitignor
|--ecap.bat
|--ecap.sh
|--example.url.csv
|--img # 出力タイプでimgを指定した場合はここに出力される
|  |--.gitkeep
|  |--ファイル名.jpg
|--pdf # 出力タイプでpdfを指定した場合はここに出力される
|  |--.gitkeep
|  |--ファイル名.pdf
|--url.csv
```

### MACとかで UTF-8, LF のCSVを扱いたい場合

<code>ecap.sh</code>の9行目辺りを修正します。

- 修正箇所 (9行目あたり)
```
# Shift_JISをUTF-8に変換 | 改行コードをLFに変換 | 2行目から読み込み
exec < <(iconv -f SHIFT-JIS -t UTF-8 $TARGET/url.csv | tr -d \\r | tail -n +2)
```
- 以下に修正
```
exec < <(tail -n +2 $TARGET/url.csv)
```

上記を行なってから実行してください。
```
bash ecap.sh
```

### その他

- wkhtmltopdf, wkhtmltoimage ともに色々なオプションを指定できますのでこちらを参考にしてください
    - [http://wkhtmltopdf.org/usage/wkhtmltopdf.txt](http://wkhtmltopdf.org/usage/wkhtmltopdf.txt "")
- 以下に、一例を書きます

#### ヘッダーを付与したい

独自ヘッダーとかUserAgentとかを送れたら使い勝手がいいですよね。  
(自社 / 自分のサイトとかのキャプチャをとる場合とか)  

それも簡単に設定できます。

- <code>--custom-header <name> <value> </code>をオプションで設定してください
    - <code>--custom-header-propagation</code> もつける
- 以下は、<code>EXEC_CAPTURE = "running"</code>、<code>iOS 10のユーザーエージェント</code>を設定した例です

**ecap.bat**
```sh
wkhtmltopdf ^
--margin-top 0 ^
--margin-bottom 0 ^
--custom-header "EXEC_CAPTURE" "running" ^
--custom-header "User-Agent" "Mozilla/5.0 (iPhone; CPU iPhone OS 10_0_1 like Mac OS X) AppleWebKit/602.1.50 (KHTML, like Gecko) Version/10.0 Mobile/14A403 Safari/602.1" ^
--custom-header-propagation ^
%URL% ^
%TARGET%\pdf\%FILE_NAME%.pdf
```

**ecap.sh**
```sh
wkhtmltopdf \
--margin-top 0 \
--margin-bottom 0 \
--custom-header "EXEC_CAPTURE" "running" \
--custom-header "User-Agent" "Mozilla/5.0 (iPhone; CPU iPhone OS 10_0_1 like Mac OS X) AppleWebKit/602.1.50 (KHTML, like Gecko) Version/10.0 Mobile/14A403 Safari/602.1" \
--custom-header-propagation \
${url} \
"${TARGET}/pdf/${file_name}.pdf
```

PHPですいませんが、サーバー側ではこんな感じで取得可能です。
```php
if (isset($_SERVER['HTTP_EXEC_CAPTURE']) && $_SERVER['HTTP_EXEC_CAPTURE'] === 'running') {
    // キャプチャツールからのアクセス
}
```

## License
- MIT License
