#!/bin/bash

function main() {
	yad --button=从视频中提取音频:1 --button=音频格式转换:2 --button=视频格式转换:3 --button=feedplot:4 --button=burn_image:5 --button=退出:0
	case $? in
	0)
		return 255
		;;
	1)
		while extract_audio; do
			echo "完成"
		done
		;;
	2)
		while audio_convert; do
			echo "完成"
		done
		;;

	3)
		while video_convert; do
			echo "完成"
		done
		;;
    4)  while feedplot.sh; do
            echo "done"
        done
        ;;
    5) burn_image 
        ;;
	esac
}

function select_disk() {
    IFS=$'\n' disks=$(zenity --list --title="select" --column "selection" $(lsblk -no path,vendor,size,type /dev/sd*  2> /dev/null| grep disk))
    if [[ $? == 0 ]]; then
        selected_disk=$(echo $disks | awk '{print $1;}')
        echo $selected_disk
        return 0
    fi
    return -1
}

function input_url() {
    url=$(zenity --title="win" --entry --text="input url")
    if [[ $? != 0 ]]; then
        echo "nothing"
        return -1
    else
        echo $url
        return 0
    fi
}

function burn_image() {
    command -v zenity || sudo apt -y install zenity
    disk=$(select_disk) && url=$(input_url) && echo "dd if=$url of=$disk" \
    && curl -u zhangfuwen:zhangfuwen --silent $url | \
    sudo dd conv=noerror,sync iflag=fullblock oflag=direct,sync status=progress bs=1M of=$disk
}


function extract_audio() {
	ans=$(yad --title=提取音频 --form --field="选择一个视频文件":FL --field="音频文件保存为" --button=确定:0 --button=直接退出:2)
	ret=$?
	case $ret in
		0)
			echo $ans
			file1=$(echo $ans | awk 'BEGIN {FS="|" } { print $1 }')
			file2=$(echo $ans | awk 'BEGIN {FS="|" } { print $2 }')
			echo "file1 $file1"
			echo "file2 $file2"
			if [[ $file2 != *mp3 ]]; then
				file2=$file2.mp3
			fi
			if ffmpeg -i $file1 $file2; then
				yad --title "完成" --text  "$(realpath $file2)"
			else
				yad --title "失败了"
			fi
		;;
		2)
			exit 0
		;;
		*)
			return 1;
		;;
	esac
}

function audio_convert() {
	ans=$(yad --title=音频转换 --form --field="选择一个音频文件":FL --field="格式:CB"  --field="转换后的音频文件保存为" --field="格式:CB" "" '^自动!wav!pcm!mp3!opus' "" '^wav!pcm!mp3!opus' --button=确定:0 --button=直接退出:2 )
	ret=$?
	case $ret in
		0)
			echo $ans
			file1=$(echo $ans | awk 'BEGIN {FS="|" } { print $1 }')
			format1=$(echo $ans | awk 'BEGIN {FS="|" } { print $2 }')
			file2=$(echo $ans | awk 'BEGIN {FS="|" } { print $3 }')
			format=$(echo $ans | awk 'BEGIN {FS="|" } { print $4 }')
			echo "file1 $file1"
			echo "format1 $format1"
			echo "file2 $file2"
			echo "format2 $format"
			case $format1 in
				自动)
					format1=""
					;;
				pcm) 
					format1=" -f s16le ";
					;;
				*)
					format1=" -f $format1 "
					;;
			esac
			case $format in
				wav)
					format=" -f wav "
					if [[ $file2 != *wav ]]; then file2=$file2.wav; fi
				;;
				pcm)
					format=" -f s16le "
					if [[ $file2 != *pcm ]]; then file2=$file2.s16le.pcm; fi
				;;
				mp3)
					format=" -f mp3 "
					if [[ $file2 != *mp3 ]]; then file2=$file2.mp3; fi
				;;
				*)
					format=" -f $format "
				;;
			esac
			if ffmpeg $foramt1 -i $file1 $format $file2; then
				if yad --title "完成" --text  "$(realpath $file2)" --button=播放:0 --button=退出:1; then
					ffplay $format $file2
				fi
			else
				yad --title "失败了"
			fi
		;;
		2)
			exit 0
		;;
		*)
			return 1;
		;;
	esac
}

function video_convert() {
	ans=$(yad --title=视频格式转换 --form --field="选择一个视频文件":FL --field="转换后的视频文件保存为" --button=确定:0 --button=直接退出:2 )
	if [[ $? == 0 ]] ; then
		echo $ans
	else	
		return 1;
	fi
}

while main; do
	echo "ok"
done
