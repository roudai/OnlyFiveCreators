#!/bin/sh
URL="https://only-five.jp/creators/"
END="404"
FILENAME="onlyfive.csv"
LOGFILE="onlyfive.log"

echo $(date) "START" | tee -a $LOGFILE
cd $(dirname $0)
rm -f $FILENAME
i=1 
while true
do
  source=$(curl -s ${URL}$i)
  check=$(echo $source | grep -oP '<h1>.*</h1>' | sed 's#<h1>\(.*\)</h1>#\1#')
  if [ "$check" = "$END" ]; then
    break
  fi
  name=$(echo $source | grep -oP '<title>.*</title>' | sed -e 's#<title>\(.*\)</title>#\1#' -e 's/ | Only Five//') 
  birth=$(echo $source | grep -oP '"profile-birthday-text">.*?</h3>' | sed -e 's#"profile-birthday-text">\(.*\)</h3>#\1#' -e 's/誕生日：//') 
  profile=$(echo $source | grep -oP '"creator-bio">.*?</div>' | sed -e 's#"creator-bio">\(.*\)</div>#\1#') 
  price=$(echo $source | grep -oP '"post-price">.*?</div>' | sed -e 's#"post-price">\(.*\)</div>#\1#') 
  echo $i,$name,$birth,'"'$profile'"','"'$price'"' >> ${FILENAME}
  i=`expr $i + 1`
done
echo $(date) "END" | tee -a $LOGFILE 
