 #!/bin/bash

雷霄骅的博客
https://blog.csdn.net/leixiaohua1020/article/list/3
罗索实验室 
http://www.rosoo.net/a/index_strm.html
中文社区
http://bbs.chinaffmpeg.com/forum.php?mod=viewthread&tid=1361&extra=


简易安装
brew install ffmpeg
全量安装
brew install ffmpeg --with-fdk-aac --with-tools --with-ffplay --with-freetype --with-libass --with-libvorbis --with-opus --with-libvpx --with-x265
brew install ffmpeg --with-fdk-aac --with-tools --with-ffplay --with-libass --with-libvorbis --with-opus --with-libvpx --with-x265
brew install ffmpeg --with-fdk-aac --with-tools --with-x265



ffmpeg [options] -i [输入文件名] [参数选项] -f [格式] [输出文件]

查看某一项参数的可选值，例如：
# 查看pix_fmts 可选的 颜色模式
ffmpeg -pix_fmts 


ffmpeg主要参数	意义
----------------------------
-i		设置输入文件名。
-f		设置输出格式。
-y		若输出文件已存在时则覆盖文件。
-fs		超过指定的文件大小时则结束转换。
-ss		从指定时间开始转换。	可以缩写（ -ss 1 -t 10）（单位秒）
-t		从ss开始的t秒。 		也可写全（ -ss 00:00:01.00 -t 00:00:10.00）
-to		从ss开始到to秒。 	
-title	设置标题。
-timestamp	设置时间戳。
-vsync	增减Frame使影音同步。
-pix_fmt 设置颜色样式,

ffmpeg视频参数	意义		以下参数都在输入文件之后
----------------------------
-b:v		设置视频比特率，默认200Kbit/秒。 	例： -b:v 500k
-r			设置帧率值，默认为25。			例： -r 29.97
-s			设置画面的宽与高。				例： -s 640x480
-aspect		设置画面的比例。
-vn			不处理视频，于仅针对声音做处理时使用。
-c:v		设置视频视频编解码器，未设置时则使用与输入文件相同之编解码器。
-vf 		视频frame编辑 	例： -vf rotate=PI/2（旋转90度） -vf scale=iw/2:-1（iw 是输入的宽度，iw/2就是一半; -1 为保持宽高比）
-filter:v 	速度编辑		例： -filter:v setpts=0.5*PTS

ffmpeg声音参数	意义		通常a开头
----------------------------
-b:a		设置音频比特率。	例： -ab 48k
-ar		设置采样率。		
-ac		设置声音的Channel数。	例： -ac 2
-c:a 	设置声音编解码器，未设置时与视频相同，使用与输入文件相同之编解码器。
-an		不处理声音，于仅针对视频做处理时使用。an = audio none
-vn		不处理视频，提取音频。vn = video none
-vol		设置音量大小，256为标准音量。（要设置成两倍音量时则输入512，依此类推。）
-filter:a 	速度编辑		例： -filter:a atempo=2.0



ffprobe 意义 # http://ffmpeg.org/ffprobe.html
----------------------------
-show_frames 查看文件的信息
ffprobe -show_frames

Input_FILE="/Users/yimi/Desktop/test.mp4"
Output_Loc="/Users/yimi/Desktop/"



/Users/yimi/Desktop/ffmpeg

# 查看文件的信息
ffmpeg -i /Users/yimi/Desktop/ym.mp4

# 格式转换（文件格式 或者 编码格式）
----------------------
ffmpeg -i /Users/yimi/Desktop/ym.mp4 -c copy /Users/yimi/Desktop/ym2.mp4

# mp4->mov 	参数中 Input #0 为原素材的一些属性 可适当修改码率等
ffmpeg -i /Users/yimi/Desktop/ym.mp4 -f mov /Users/yimi/Desktop/out1.mov

# 转换视频参数 500k采样率 25帧 720x308  libx264编码 的视频
ffmpeg -i /Users/yimi/Desktop/ym.mp4 -b:v 1000k -r 25 -c:v libx264 /Users/yimi/Desktop/out2.mp4

# 注意⚠️ 如果吧视频压缩为 H.265 必须添加参数  -tag:v hvc1 否则无法被mac的QuicTime直接预览  h.265的码率可以更具画面复杂度在h.264素材的码率的0.55～0.7之间选择 
ffmpeg -i /Users/yimi/Desktop/ym.mp4 -b:v 600k -r 25 -c:v libx265 -tag:v hvc1 /Users/yimi/Desktop/out3.mp4

# 视频转gif    关于gif的优化⚠️  https://www.jianshu.com/p/a11bbf804e75
/Users/lee/Desktop/ffmpeg -i /Users/lee/Desktop/cut.mp4 -r 15 -vf scale=300:-1 -pix_fmt rgb24 -f gif /Users/lee/Desktop/my.gif


「
# 手动生存全局调色盘  /Users/yimi/Desktop/mypalettegen.png
/Users/yimi/Desktop/ffmpeg -v warning \
-i /Users/yimi/Desktop/cut2.mp4 \
-vf "fps=15,scale=300:-1:flags=lanczos,palettegen" \
-y /Users/yimi/Desktop/mypalettegen.png

# 利用自定义调色盘 生成gif
ffmpeg -v warning -ss 0 -t 3 \
-i /Users/yimi/Desktop/cut.mp4 -i /Users/yimi/Desktop/mypalettegen.png \
-lavfi "fps=15,scale=720:-1:flags=lanczos [x]; [x][1:v] paletteuse" \
-y /Users/yimi/Desktop/my.gif

」




# 视频裁剪
----------------------
# ffmpeg 为了加速，会使用关键帧技术， 所以有时剪切出来的结果在起止时间上未必准确。 通常来说，
# 把 -ss 选项放在 -i 之前，会使用关键帧技术； 
# 把 -ss 选项放在 -i 之后，则不使用关键帧技术。 
# 如果要使用关键帧技术又要保留时间戳，可以加上 -copyts 选项
# 截取 0秒～10秒
ffmpeg -i /Users/yimi/Desktop/ym.mp4 -ss 0 -t 10 -copyts /Users/yimi/Desktop/cut.mp4

# 提取 0秒～10秒 的 音频
ffmpeg -i /Users/yimi/Desktop/ym.mp4 -ss 0 -t 10 -copyts -vn -f mp3 /Users/yimi/Desktop/onlySound.mp3

# 提取 0秒～10秒 的 视频
ffmpeg -i /Users/yimi/Desktop/ym.mp4 -ss 0 -t 10 -copyts -an -f mp4 /Users/yimi/Desktop/onlyVideo.mp4

# 裁剪 去除边缘20像素 crop=w:h:x:y
ffmpeg -i /Users/yimi/Desktop/cut.mp4 -filter:v "crop=in_w-40:in_h-40:20:20" /Users/yimi/Desktop/framecut.mp4

# 尺寸缩放为 原来的0.6倍
/Users/yimi/Desktop/ffmpeg -i /Users/yimi/Desktop/ym.mp4 -vf scale=iw/1.6:-1 /Users/yimi/Desktop/framecut.mp4

# 快进4倍 显示1帧的时间刻度为原来的0.25 即速度加快4倍 PTS=Presentation Time Stamp（显示时间戳，单位：一个 time_base）
/Users/yimi/Desktop/ffmpeg -i /Users/yimi/Desktop/ym.mp4 -vf "setpts=0.25*PTS" -af atempo=4.0 /Users/yimi/Desktop/fastVide.mp4

# 截图
/Users/yimi/Desktop/ffmpeg -ss 2.40 -i /Users/yimi/Desktop/cut2.mp4  -vframes 1 -y /Users/yimi/Desktop/a.jpg


# 实例
# 将网络资源下载
/Users/yimi/Desktop/ffmpeg -i https://oss-live-1.videocc.net/record/record/recordf/2196d7af2e20191029141303952/2019-12-06-14-29-35_2019-12-06-15-39-47.m3u8 \
-ss 10 -t 10 \
-c:v libx264 /Users/yimi/Desktop/cut.mp4


# 视频合并
----------------------
# v1 + v2
/Users/yimi/Desktop/ffmpeg -i cut1.mp4 -c copy -bsf:v h264_mp4toannexb -f mpegts input1.ts
/Users/yimi/Desktop/ffmpeg -i cut2.mp4 -c copy -bsf:v h264_mp4toannexb -f mpegts input2.ts
/Users/yimi/Desktop/ffmpeg -i "concat:input1.ts|input2.ts" -c copy -bsf:a aac_adtstoasc -movflags +faststart output.mp4






cut
/Users/yimi/Desktop/ffmpeg -i /Users/yimi/Desktop/cut.mp4 -r 15 -vf scale=300:168 -copyts /Users/yimi/Desktop/cut2.mp4

change to gif 
/Users/yimi/Desktop/ffmpeg -i /Users/yimi/Desktop/cut.mp4 -r 15 -vf scale=300:-1 -pix_fmt rgb24 -f gif /Users/yimi/Desktop/my.gif

# 截图
/Users/yimi/Desktop/ffmpeg -ss 2.40 -i /Users/yimi/Desktop/cut2.mp4  -vframes 1 -y /Users/yimi/Desktop/a.jpg

/Users/yimi/Desktop/ffmpeg -v warning -i /Users/yimi/Desktop/123.mov \
-vf "fps=15,scale=300:-1:flags=lanczos,palettegen" -y /Users/yimi/Desktop/mypalettegen.png

/Users/yimi/Desktop/ffmpeg  -v warning -r 15  -i /Users/yimi/Desktop/123.mov -i /Users/yimi/Desktop/mypalettegen.png \
-lavfi "fps=15,scale=300:-1:flags=lanczos [x]; [x][1:v] paletteuse" -y /Users/yimi/Desktop/my3.gif



/Users/yimi/Desktop/ffmpeg -i /Users/yimi/Desktop/123.mov -ignore_loop 0 -r 15 -vf scale=300:-1 -pix_fmt rgb24 -f gif /Users/yimi/Desktop/my.gif




/Users/yimi/Desktop/ffmpeg -ss 35.0 -i https://cn-videos.dji.net/video_trans/284a91f371a8415c80b3f0d083583472/1080.mp4  -vframes 1 -y /Users/yimi/Desktop/a.jpg


/Users/yimi/Desktop/ffmpeg -i /Users/yimi/Desktop/5_15488489003480.mp4 -vf "setpts=5*PTS" -an /Users/yimi/Desktop/fastVide.mp4



/Users/yimi/Desktop/ffmpeg -i /Users/yimi/Desktop/5_15488489003480.mp4 -vf scale=iw/1.6:-1 /Users/yimi/Desktop/framecut.mp4



/Users/yimi/Desktop/ffmpeg -i "concat:/Users/yimi/Desktop/录音/1.mp3|/Users/yimi/Desktop/录音/2.mp3" -c copy /Users/yimi/Desktop/录音/4.mp3


