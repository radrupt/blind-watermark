# 用于生成数字盲水印

# dependency
1. ffmpeg

# usage
```
# 添加盲水印
# 获取4.4s的图片(后面考虑优化为第多少帧)
ffmpeg -i test/test.mp4 -y -f image2 -ss 00:00:4.4 -vframes 1 test/test.jpg
# 加载用于生成盲水印的docker
docker pull radrupt/blind-watermark:v1.0.0
# 生成盲水印
docker run --volume /Users/wangdi/projects/blind-watermark/test:/root/image radrupt/blind-watermark:v1.0.0  convert /root/image/test.jpg -fft /root/image/fft.png
docker run --volume /Users/wangdi/projects/blind-watermark/test:/root/image radrupt/blind-watermark:v1.0.0  convert /root/image/mark.png -rotate 180 /root/image/mark1.png
docker run --volume /Users/wangdi/projects/blind-watermark/test:/root/image radrupt/blind-watermark:v1.0.0  convert /root/image/fft-1.png /root/image/mark.png -gravity northwest -geometry +330+360 -composite /root/image/fft-2.png
docker run --volume /Users/wangdi/projects/blind-watermark/test:/root/image radrupt/blind-watermark:v1.0.0  convert /root/image/fft-2.png /root/image/mark1.png -gravity southeast -geometry +330+360 -composite /root/image/fft-1.png
# 得到盲水印test1.jpg
docker run --volume /Users/wangdi/projects/blind-watermark/test:/root/image radrupt/blind-watermark:v1.0.0  convert /root/image/fft-0.png /root/image/fft-1.png -ift -crop 1280x720+0+0 /root/image/test1.jpg
# 放回原视频
ffmpeg -i test/test.mp4 -i test/test1.jpg -filter_complex "[1]setpts=4.40/TB[im];[0][im]overlay=eof_action=pass" -c:a copy test/out.mp4

# 恢复盲水印
# 从视频中获取图片
ffmpeg -i test/out.mp4 -y -f image2 -ss 00:00:4.4 -vframes 1 test/daoban.jpg
# 获取盗版视频中加上的盲水印
docker run --volume /Users/wangdi/projects/blind-watermark/test:/root/image radrupt/blind-watermark:v1.0.0  convert /root/image/daoban.jpg -fft /root/image/盗版视频中的水印.png
```

# excute
`sh excute.sh`

# 