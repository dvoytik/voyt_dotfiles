#!/bin/bash
#
#   This file echoes a bunch of 24-bit color codes
#   to the terminal to demonstrate its functionality.
#   The foreground escape sequence is ^[38;2;<r>;<g>;<b>m
#   The background escape sequence is ^[48;2;<r>;<g>;<b>m
#   <r> <g> <b> range from 0 to 255 inclusive.
#   The escape sequence ^[0m returns output to default

setBackgroundColor()
{
    echo -en "\x1b[48;2;$1;$2;$3""m"
}

resetOutput()
{
    echo -en "\x1b[0m\n"
}

# Gives a color $1/255 % along HSV
# Who knows what happens when $1 is outside 0-255
# Echoes "$red $green $blue" where
# $red $green and $blue are integers
# ranging between 0 and 255 inclusive
rainbowColor()
{ 
    let h=$1/43
    let f=$1-43*$h
    let t=$f*255/43
    let q=255-t

    if [ $h -eq 0 ]
    then
        echo "255 $t 0"
    elif [ $h -eq 1 ]
    then
        echo "$q 255 0"
    elif [ $h -eq 2 ]
    then
        echo "0 255 $t"
    elif [ $h -eq 3 ]
    then
        echo "0 $q 255"
    elif [ $h -eq 4 ]
    then
        echo "$t 0 255"
    elif [ $h -eq 5 ]
    then
        echo "255 0 $q"
    else
        # execution should never reach here
        echo "0 0 0"
    fi
}

for i in `seq 0 127`; do
	echo -en $(($i % 100 / 10))
done
echo
for i in `seq 0 127`; do
	echo -en $(($i % 10))
done
echo
for i in `seq 0 127`; do
    if [ $i -eq 100 ]; then
        echo "100"
        break
    fi
    echo -en ' '
done

for i in `seq 0 127`; do
    setBackgroundColor $i 0 0
    echo -en " "
done
resetOutput
for i in `seq 255 128`; do
    setBackgroundColor $i 0 0
    echo -en " "
done
resetOutput

for i in `seq 0 127`; do
    setBackgroundColor 0 $i 0
    echo -n " "
done
resetOutput
for i in `seq 255 128`; do
    setBackgroundColor 0 $i 0
    echo -n " "
done
resetOutput

for i in `seq 0 127`; do
    setBackgroundColor 0 0 $i
    echo -n " "
done
resetOutput
for i in `seq 255 128`; do
    setBackgroundColor 0 0 $i
    echo -n " "
done
resetOutput

for i in `seq 0 127`; do
    setBackgroundColor `rainbowColor $i`
    echo -n " "
done
resetOutput
for i in `seq 255 128`; do
    setBackgroundColor `rainbowColor $i`
    echo -n " "
done
resetOutput

echo -e "regualr:     AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz 0123456789"
echo -e "bold:        \e[1mAaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz 0123456789\e[0m"
echo -e "italic:      \e[3mAaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz 0123456789\e[0m"
echo -e "bold italic: \e[3m\e[1mAaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz 0123456789\e[0m"

echo regular
echo -e "\e[1mbold\e[0m"
echo -e "\e[3mitalic\e[0m"
echo -e "\e[3m\e[1mbold italic\e[0m"
echo -e "\e[4munderline\e[0m"
echo -e "\e[9mstrikethrough\e[0m"

printf "|039| \033[39mDefault \033[m  |049| \033[49mDefault \033[m  |037| \033[37mLight gray \033[m     |047| \033[47mLight gray \033[m\n"
printf "|030| \033[30mBlack \033[m    |040| \033[40mBlack \033[m    |090| \033[90mDark gray \033[m      |100| \033[100mDark gray \033[m\n"
printf "|031| \033[31mRed \033[m      |041| \033[41mRed \033[m      |091| \033[91mLight red \033[m      |101| \033[101mLight red \033[m\n"
printf "|032| \033[32mGreen \033[m    |042| \033[42mGreen \033[m    |092| \033[92mLight green \033[m    |102| \033[102mLight green \033[m\n"
printf "|033| \033[33mYellow \033[m   |043| \033[43mYellow \033[m   |093| \033[93mLight yellow \033[m   |103| \033[103mLight yellow \033[m\n"
printf "|034| \033[34mBlue \033[m     |044| \033[44mBlue \033[m     |094| \033[94mLight blue \033[m     |104| \033[104mLight blue \033[m\n"
printf "|035| \033[35mMagenta \033[m  |045| \033[45mMagenta \033[m  |095| \033[95mLight magenta \033[m  |105| \033[105mLight magenta \033[m\n"
printf "|036| \033[36mCyan \033[m     |046| \033[46mCyan \033[m     |096| \033[96mLight cyan \033[m     |106| \033[106mLight cyan \033[m\n"
