![Logo](https://github.com/mawastk/mtxoid/blob/main/image/benner.png?raw=true)

# Mtxoid
Androidで動作するMTX変換ツール

![Screenshot](https://github.com/mawastk/mtxoid/blob/main/image/screenshot.png?raw=true)

# インストール方法
Mtxoidは単一のapkで動作します、そのままインストールすることが可能です

| 制限 | 対応バージョン |
|:-----------|:------------:|
| 最小     | Android 7.0 ~       |

# 使い方

UIは２個のボタンだけで構成されます、mtxとpngの相互変換が可能です

Androidのネイティブファイル選択ダイアログを呼び出しています、もしメモリに余裕がない場合、あまり長く開かないであげてくださいね（コールバックで問題が発生する可能性があります）

# 対応フォーマット

mtxoidは透過MTXとpngのエクスポート、インポートに対応しています

| 種類 | インポート | エクスポート |
|:-----------|:------------:|:------------:|
| MTXv0 |✅|❌|
| MTXv1 |✅|✅|
| MTXv2 |❌|❌|
| PNG |✅|✅|

# このプロジェクトはmtxconvを利用していますか？

いいえ、mtxconvは利用していません
