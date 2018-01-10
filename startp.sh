#!/bin/bash
if [ ! -d Anime ]
then
	mkdir Anime
fi
cd Anime
IFS=$'\n'
if [ $# -ne 1 ]
then
	echo Enter link from https://twist.moe/
	read link
else
	link=$1
fi
di=$(echo $link | cut -d "/" -f5)
if [ ! -d $di ]
then
echo Creating $di
mkdir $di
fi
if [ -f $di/.t.txt ]
then
rm $di/.t.txt
fi
if [ -f $di/list.txt ]
then
rm $di/list.txt
fi
string=$link
char="/"
sla=$(echo "${string}" | awk -F"${char}" '{print NF-1}')
x=$( echo $link | cut -d "/" -f6 )
if [[ $x == "" ]]
then
if [ $sla -eq 4 ]
then
one='/1'
link=$link$one
echo making it $link
fi
if [ $sla -eq 5 ]
then
one='1'
link=$link$one
echo making it $link
fi
fi
echo Fetching info...
curl -s $link > .temp.txt 
if [ 0 -eq $? ]
then
	echo Fetching succesful by CURL
cat .temp.txt | sed 's/\"/\n/g' | tr -s " " | egrep 'mp4|mkv|avi|ogg' | sed -e 's/^[ \t]*//' | sort -n | uniq | grep -E '(\.mp4$)' > $di/.t.txt
else
	echo CURL didn\'t respond. Trying WGET
	wget -q -O .temp.txt $link
	cat .temp.txt | tr "\"" "\n" | sed -e 's/^[ \t]*//' | grep -E '(\.mp4$)|(\.avi$)|(\.ogg$)|(\.mkv$)' > $di/.t.txt
fi
echo Creating $di/list.txt
for i in $(cat $di/.t.txt)
do
j='https://twist.moe'
j=$j$i
echo $j >> $di/list.txt 
done
echo copying download.sh to $di
cp ../download.sh $di/
echo Done
echo Check the Anime folder
echo Enjoy
rm .temp.txt
rm $di/.t.txt
cd ../
chmod 777 list.sh
./list.sh $di
