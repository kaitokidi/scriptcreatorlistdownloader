#!/bin/bash

if [ "$1" == "help" ] || [ "$1" == "--help" ]
then
    echo " Execute this as ./ScriptCreator.sh URL amountOfSongs [NameOfList]"
    echo " this will download in the current folder"
    echo " from the youtube List of the URL, "
    echo " the minimum from the amountOfSongs and the amount of songs on the list."
    echo " "
    echo " Without parameters it will just generate the scripts."
    exit 0
fi

AMOUNT=$2
if [ -z $2 ]
then
 AMOUNT=1
fi

URL=$1

FILENAME="auto$3.txt"
    
echo " Creating Scripts :)"

GETLINKS="auto_script.py"
DOWNLOADLAUNCHER="auto_downloadLauncher"
YOUTUBEDOWNLOADER="auto_downloadYoutubeSong.sh"

if [ "$1" == "clean" ] || [ "$1" == "clear" ]
then
    echo " ------let me just $1 this mess-------"
    rm $GETLINKS $DOWNLOADLAUNCHER $DOWNLOADLAUNCHER.cpp $DOWNLOADLAUNCHER.o $YOUTUBEDOWNLOADER $FILENAME
    exit 0
fi
echo " ------------------------------"

echo " :O)0>  $GETLINKS  "
touch $GETLINKS

echo "
import re
import urllib.request
import urllib.error
import sys
import time
 
def crawl(url):
    sTUBE = ''
    cPL = ''
    amp = 0
    final_url = []
    
    if 'list=' in url:
        eq = url.rfind('=') + 1
        cPL = url[eq:]
            
    else:
        print('Incorrect Playlist.')
        exit(1)
    
    try:
        yTUBE = urllib.request.urlopen(url).read()
        sTUBE = str(yTUBE)
    except urllib.error.URLError as e:
        print(e.reason)
    
    tmp_mat = re.compile(r'watch\?v=\S+?list=' + cPL)
    mat = re.findall(tmp_mat, sTUBE)
 
    if mat:
          
        for PL in mat:
            yPL = str(PL)
            if '&' in yPL:
                yPL_amp = yPL.index('&')
            final_url.append('http://www.youtube.com/' + yPL[:yPL_amp])
 
        all_url = list(set(final_url))
 
        i = 0
        while i < len(all_url):
            sys.stdout.write(all_url[i] + '\n')
            time.sleep(0.04)
            i = i + 1
        
    else:
        print('No videos found.')
        exit(1)
        
if len(sys.argv) < 2 or len(sys.argv) > 2:
    print('USAGE: python3 youParse.py YOUTUBEurl')
    exit(1)
    
else:
    url = sys.argv[1]
    if 'http' not in url:
        url = 'http://' + url
    crawl(url)

" > $GETLINKS


echo " ------------------------------"


echo "now $DOWNLOADLAUNCHER <0(O:"
touch $DOWNLOADLAUNCHER.cpp

echo -e "
#include <iostream>
#include <stdio.h>
#include <stdlib.h>
#include <string>

int main(){

    std::string link;
    std::string command = \"./$YOUTUBEDOWNLOADER \";
    int i = 0;
    std::cin >> link;
    while(i < $AMOUNT && link != \"END\")
    {
                std::cout <<  std::endl;
        std::cout << \"======= \"<< i << \" download   \" << link << \"========\" << std::endl;
        std::cout << std::endl;
        system((command+link).c_str());
        ++i;
        std::cin >> link;
    }
}


" > $DOWNLOADLAUNCHER.cpp

echo " compiling ...  "
g++ -c $DOWNLOADLAUNCHER.cpp 
g++ -o $DOWNLOADLAUNCHER $DOWNLOADLAUNCHER.o


echo " done : )"

echo " ------------------------------"

echo " Create last, $YOUTUBEDOWNLOADER"
touch $YOUTUBEDOWNLOADER

echo -e "
#!/bin/bash
echo \" Downloading -> $URL\"

youtube-dl --extract-audio --audio-format mp3 $URL
" > $YOUTUBEDOWNLOADER

echo " -------ALL CREATED---------"

echo " "
echo " "
echo " "

README="auto_readme"
if [[ $# -eq 0 ]] ; then
    echo 'no listURL and nameOfFile, fuck it'
    touch $README
    echo -e "
    instructions 

    0 - Coppy the files in the folder you want the mp3 files.

    1 - python3 script.py url name.txt 

    E - For convinience plot, execute this
    F - echo \"END\" >> name.txt 
    
    2 - If need changes, nano downloadLauncher (i.e amount of songs)
    3 - g++ -c downloadLauncher.cpp; g++ -o  downloadLauncher downloadLauncher.o  
    
    4 - ./downloadLauncher < name.txt 

    5 - If you have the scripts saved somewhere else, remove them from this folder
    6 - rm script.py download* name.txt
    " > $README

    echo "i even made a readme for you so don t cry"
    exit 1
fi

echo " --------I see you want me to do all the dirty work... ok-----------"
echo " using $URL as URL and $FILENAME as fileName"

python3 $GETLINKS $URL > $FILENAME

LIST=$( cat $FILENAME )

if [ "$LIST" == "Incorrect Playlist." ]
then
    echo "wrong playlist URL"
    exit 1
fi

echo "END" >> $FILENAME
echo " ------------------------------"

./$DOWNLOADLAUNCHER < $FILENAME

echo " ------------------------------"

echo " "
echo " "

echo " -----this should be done--------"

echo "Have an  amazing day : ) "
echo "  //*//  "
