#!/bin/bash
# V-0.1
# Autor Lizhiwei
##################   打 包 参 数   #####################
# # 打包
# # 项目名称： ‘网付.xcodeproj’就使用网付
SCHEME_NAME="网付"
# # 项目路径   ‘网付.xcodeproj’所在的目录
SOURCE_PATH="/Users/YiMi/Desktop/网付1.1"
# # 打包环境，1＝ad-hoc
PACKAGE_TYPE=1

##################   上 传 参 数   #####################
# # 需要安装fir-cli  安装方法：$gem install fir-cli
# # 是否上传至Fir 0=不上传  1=上传
NEED_TO_UPLOAD=1
# # token获取方法：http://fir.im/apps/apitoken
FIR_LOGIN_TOCKEN="d2c0fe82fa30e6b24fc197fa36bb0ade"
# # fir.im上的短连接
FIR_PROCECT_SHORT_LINK="wangfu"


#################################################
##################  script ######################
if [ $PACKAGE_TYPE -eq 1 ]; then
BRANCH_NAME="ad-hoc"
fi
# # 时间戳
DATE=`date +%Y%m%d_%H%M`
IPAPATH="/Users/YiMi/Desktop/AutoBuildIPA/${SCHEME_NAME}/${BRANCH_NAME}/${DATE}"

# # 归档最终文件
ArchiveName="${IPAPATH}/${SCHEME_NAME}.xcarchive"
# # 最终ipa文件
IPAName="${IPAPATH}/${SCHEME_NAME}.ipa"

# # 打包的配置参数 可通过手动打包后使用系统创建的
ConfigurationBuildDir="/Users/YiMi/Desktop/AutoBuildIPA/AdHocExportOptions.plist"

# # 创建项目文件夹
mkdir ./${SCHEME_NAME}
mkdir ./${SCHEME_NAME}/${BRANCH_NAME}
mkdir ./${SCHEME_NAME}/${BRANCH_NAME}/${DATE}

# # 清理 避免出现一些莫名的错误
echo "~~~~~~~~~~~~~~~~开始清理~~~~~~~~~~~~~~~~~~~"
xcodebuild clean -configuration Release -alltargets

# # build
echo "~~~~~~~~~~~~~~~~开始构建~~~~~~~~~~~~~~~~~~~"
 xcodebuild archive \
     -workspace ${SOURCE_PATH}/${SCHEME_NAME}.xcworkspace \
     -scheme ${SCHEME_NAME} \
     -configuration Release \
     -archivePath ${ArchiveName}

if [ -e ${ArchiveName} ];then
    echo -e "~~~~~~~~~~~~~~~~构建成功~~~~~~~~~~~~~~~~~~~"
    echo ${ArchiveName}
else
    echo -e "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~\n\n"
    echo -e "     error:!!  build failed    \n\n"
    echo -e "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~\n\n"
    echo ${ArchiveName}
    exit 1
fi

# # xcrun .ipa
echo "~~~~~~~~~~~~~~~~导出ipa~~~~~~~~~~~~~~~~~~~"
xcodebuild -exportArchive \
     -archivePath ${ArchiveName} \
     -exportOptionsPlist ${ConfigurationBuildDir} \
     -exportPath ${IPAPATH} \
     -allowProvisioningUpdates


if [ -e ${IPAName} ]; then
    echo -e "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~\n"
    echo -e "     可喜可贺！可喜可贺！ ipa 导出成功     \n"
    echo -e "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~\n"
else
    echo -e "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~\n"
    echo -e "     error:!!  ipa 导出失败            \n"
    echo -e "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~\n"
    echo ${IPAName}
    exit 1
fi


# # 上传至 Fir内测平台
if [ $NEED_TO_UPLOAD -eq 1 ]; then
    read -t 10 -p "输入版本更新说明（10s内输入） :" word
    if  [ ! -n "$word" ] ;then
        word=""
    fi

    fir publish "${IPAName}" -T "${FIR_LOGIN_TOCKEN}" -Q  -c "${word}" -s "${FIR_PROCECT_SHORT_LINK}"

    echo -e "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~\n"
    echo -e "              上 传 完 毕                 \n"
    echo -e "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~\n"
fi


