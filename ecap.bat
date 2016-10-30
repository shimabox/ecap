@echo off

rem remって書いているところはコメントだよ

rem カレントディレクトリをセット
set TARGET=%~dp0

set FILE_CNT=0
set SUCCESS_CNT=0
set ERROR_CNT=0

rem 遅延環境変数を有効に
setlocal enabledelayedexpansion

for /f "skip=1 tokens=1,2,3* delims=," %%i in (%TARGET%url.csv) do (

  set /a FILE_CNT+=1

  rem %%i=キャプチャする画面のURL, %%j=ファイル名(拡張子無し), %%k=出力タイプ(pdf or img) が入ってくる

  echo ----- [start] output %%k %%i -----

  set valid=fase
  if %%k == pdf set valid=true
  if %%k == img set valid=true
  if !valid! == true (
    call :OUTPUT_FILE %%i %%j %%k
    set /a SUCCESS_CNT+=1
  ) else (
    echo ----- [error] output type please specify the pdf or img -----
    set /a ERROR_CNT+=1
  )
)

echo ----- [finish] file_count : %FILE_CNT% success : %SUCCESS_CNT% error : %ERROR_CNT% -----

endlocal

exit /b


rem ----- subroutine -----
:OUTPUT_FILE

  setlocal
  set URL=%1
  set FILE_NAME=%2
  set TYPE=%3

  if %TYPE% == pdf (

    rem ### pdf

    if not exist "%TARGET%\pdf\" (
        mkdir "%TARGET%\pdf"
    )

    wkhtmltopdf ^
    --margin-top 0 ^
    --margin-bottom 0 ^
    %URL% ^
    %TARGET%\pdf\%FILE_NAME%.pdf
  )

  if %TYPE% == img (

    rem ### image

    if not exist "%TARGET%\img\" (
        mkdir "%TARGET%\img"
    )

    wkhtmltoimage ^
    %URL% ^
    %TARGET%\img\%FILE_NAME%.jpg
  )

  echo ----- [ end ] output %TYPE% %URL% -----

  endlocal

exit /b

rem ----- /subroutine -----
