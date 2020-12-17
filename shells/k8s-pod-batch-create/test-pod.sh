#!/bin/sh

FEQ=$1
NUM=$2
TOTAL=$((FEQ*NUM))

echo "创建 $FEQ 次，每次 $NUM 个，总计 $TOTAL 个"
echo "开始"


function createPod()
{
  cp -f busybox.yaml busybox-exec-$1.yaml
  sed -i "s/>placeholder/$1/g" busybox-exec-$1.yaml
  kubectl apply -f busybox-exec-$1.yaml
  rm -f busybox-exec-$1.yaml
}


for((i=1;i<=$FEQ;i++))
do   
echo "第 $i 批 开始 $(date +'%H:%M:%S')"
start=`date +%s`
    for((j=1;j<=$NUM;j++))
    do
        createPod "$i-$j" &
    done
    wait
echo "第 $i 批 完成 耗时:$((`date +%s`-$start))s"
sleep 2
done  
