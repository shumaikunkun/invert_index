#!/bin/bash
#UNIX & Linux コマンド・シェルスクリプト リファレンス  https://shellscript.sunone.me/about.html
#arrayという変数にtxtファイルの文字列を配列として代入する．@を使えばコマンドライン引数を全て処理できる．xargsを使わないとダブルコーテーションが消えない．
array=(`cat $@|xargs`)
#環境変数を保存しておく．
IFS_BACKUP=$IFS
#環境変数「IFS」の区切り文字を¥nに変える．ソートするためには区切りが改行でなければならない．
IFS=$'\n'
#マージした配列をソートして重複した要素を-uで消す．@ではなく，*を使うことに注意．＠では一つの要素として処理される．
array=(`echo "${array[*]}"|sort -u`)
#環境変数を元に戻す．
IFS=$IFS_BACKUP
#単語の配列をループで回す．ダブルコーテーションはつけておくべきだが，配列の中に空白がないので今回はいらない．
for i in ${array[@]}; do
  #出力用の変数を作成し，配列として単語を代入する．
  output=($i)
  #コマンドラインの引数の数だけループ処理を行う．例のごとくダブルコーテーションはいらない．そもそも$@は省略できる．
  for x in $@; do
    #コマンドライン引数でtxtファイルを引っ張り，catコマンドで中身を見る．ファイルの中身の一部が単語の配列の要素に含まれている場合.
    if [[ $(cat $x) =~ $i ]]; then
      #出力用の配列にファイル名を代入する．
      output+=($x)
    fi
  done
  #出力．
  echo ${output[@]}
done