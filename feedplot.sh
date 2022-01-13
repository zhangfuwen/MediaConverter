
function feedplot()
{
    local file=$1
    local nrecs=$2
        (
          echo "plot '< tail -n$nrecs $file' using 1 with lines";
          while :; do sleep .4; echo replot; done
        ) | gnuplot -persist
}

if [[ $# == 2 ]]; then
    feedplot $1 $2
    exit 0
fi

ans=$(yad --form --field="数据文件":FL --field="显示记录数":NUM --button="cancel":1 --button="ok":0)
case $? in
    1)
        file=$(echo $ans | awk 'BEGIN {FS="|"} { print $1}')
        nrecs=$(echo $ans | awk 'BEGIN {FS="|"} { print $2}')
        echo "ans $ans"
        echo "file $file"
        echo "nrecs $nrecs"
        exit 1
        ;;
    0)
        file=$(echo $ans | awk 'BEGIN {FS="|"} { print $1}')
        nrecs=$(echo $ans | awk 'BEGIN {FS="|"} { print $2}')
        echo "ans $ans"
        echo "file $file"
        echo "nrecs $nrecs"
        feedplot $file $nrecs
        ;;
esac

