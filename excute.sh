#!/bin/bash
# testVideo="test/test.mp4"
testVideo="test/a2.mp4"
outVideo="test/out.mp4"
ffmpegPath="/Users/wangdi/projects/ffmpeg/ffmpeg"
place=4.4
PWD=$(pwd)
# 添加盲水印
# 获取4.4s的图片(后面考虑优化为第多少帧)
$ffmpegPath -i $testVideo -y -f image2 -ss 00:00:${place} -vframes 1 test/test.jpg
# 加载用于生成盲水印的docker
# docker pull radrupt/blind-watermark:v1.0.0
# 生成盲水印
docker run --volume ${PWD}/test:/root/image radrupt/blind-watermark:v1.0.0  convert /root/image/test.jpg -fft /root/image/fft.png
docker run --volume ${PWD}/test:/root/image radrupt/blind-watermark:v1.0.0  convert /root/image/mark.png -rotate 180 /root/image/mark1.png
docker run --volume ${PWD}/test:/root/image radrupt/blind-watermark:v1.0.0  convert /root/image/fft-1.png /root/image/mark.png -gravity northwest -geometry +330+360 -composite /root/image/fft-2.png
docker run --volume ${PWD}/test:/root/image radrupt/blind-watermark:v1.0.0  convert /root/image/fft-2.png /root/image/mark1.png -gravity southeast -geometry +330+360 -composite /root/image/fft-1.png
# 得到盲水印test1.jpg
docker run --volume ${PWD}/test:/root/image radrupt/blind-watermark:v1.0.0  convert /root/image/fft-0.png /root/image/fft-1.png -ift -crop 1280x720+0+0 /root/image/test1.jpg
# 放回原视频
$ffmpegPath -i $testVideo -i test/test1.jpg -filter_complex "[1]setpts=${place}/TB[im];[0][im]overlay=eof_action=pass" -c:a copy -y $outVideo

# 恢复盲水印
# 从视频中获取4.4图片
$ffmpegPath -i $outVideo -y -f image2 -ss 00:00:${place} -vframes 1 test/daoban.jpg

docker run --volume ${PWD}/test:/root/image radrupt/blind-watermark:v1.0.0  convert /root/image/daoban.jpg -fft /root/image/盗版视频中的水印.png