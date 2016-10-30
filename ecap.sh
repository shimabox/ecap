#!/bin/bash

TARGET=$(cd $(dirname $0) && pwd)

OLD_IFS=$IFS
IFS=","

FILE_CNT=0
SUCCESS_CNT=0
ERROR_CNT=0

# Shift_JISをUTF-8に変換 | 改行コードをLFに変換 | 2行目から読み込み
exec < <(iconv -f SHIFT-JIS -t UTF-8 $TARGET/url.csv | tr -d \\r | tail -n +2)
while read LINE
do

  FILE_CNT=$(( FILE_CNT + 1 ))

  row=(`echo "$LINE"`)

  url=${row[0]}
  file_name=${row[1]}
  type=${row[2]}

  echo "----- [start] output ${type} ${url} -----"

  if test ${type} = "pdf" || test ${type} = "img"; then

    if test ${type} = "pdf"; then

      if [ ! -d "${TARGET}/pdf" ]; then
        mkdir "${TARGET}/pdf"
      fi

      wkhtmltopdf \
      --margin-top 0 \
      --margin-bottom 0 \
      ${url} \
      "${TARGET}/pdf/${file_name}.pdf"

    else

      if [ ! -d "${TARGET}/img" ]; then
        mkdir "${TARGET}/img"
      fi

      wkhtmltoimage \
      ${url} \
      "${TARGET}/img/${file_name}.jpg"
    fi

    SUCCESS_CNT=$(( SUCCESS_CNT + 1 ))

    echo "----- [ end ] output ${type} ${url} -----"

  else
    ERROR_CNT=$(( ERROR_CNT + 1 ))
    echo "----- [error] output type please specify the pdf or img -----"
  fi

done
IFS=$OLD_IFS

echo "----- [finish] file_count : ${FILE_CNT} success : ${SUCCESS_CNT} error : ${ERROR_CNT} -----"
