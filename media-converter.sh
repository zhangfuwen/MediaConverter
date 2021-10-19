#!/bin/bash

function main() {
	yad --button=从视频中提取音频:1 --button=音频格式转换:2 --button=视频格式转换:3 --button=退出:0
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
	esac
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
	ans=$(yad --title=音频转换 --form --field="选择一个音频文件":FL --field="转换后的音频文件保存为" --button=确定:0 --button=直接退出:2 )
	if [[ $? == 0 ]] ; then
		echo $ans
	else	
		return 1;
	fi

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
