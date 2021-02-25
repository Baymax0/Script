#!/bin/bash
# V-0.1
# Autor Lizhiwei
##################   打 包 参 数   #####################
# # 打包
# # 项目名称： ‘网付.xcodeproj’就使用网付
SCHEME_NAME="网付"
# # 项目路径   ‘网付.xcodeproj’所在的目录
SOURCE_PATH="/Users/yimi/Desktop/网付/网付"


APPLEID_ID="wz_zbkj@163.com"
APPLEID_PWD="Weidian,2017"

##################  可能会修改的参数   #####################

# # 时间戳
DATE=`date +%Y%m%d_%H%M`
BRANCH_NAME="appstore"
BASE_PATH=$(cd `dirname $0`; pwd)
IPAPATH="${BASE_PATH}/${BRANCH_NAME}/${DATE}"

# # 归档最终文件
ArchiveName="${IPAPATH}/${SCHEME_NAME}.xcarchive"
# # 最终ipa文件
IPAName="${IPAPATH}/${SCHEME_NAME}.ipa"

# # 打包的配置参数 可通过手动打包后使用系统创建的
ConfigurationBuildDir="${BASE_PATH}/AppstoreExportOptions.plist"

#################################################
##################  script ######################

# # 创建项目文件夹
mkdir ./${BRANCH_NAME}
mkdir ./${BRANCH_NAME}/${DATE}
mkdir ${IPAPATH}

# # 清理 避免出现一些莫名的错误
echo "~~~~~~~~~~~~~~~~开始清理~~~~~~~~~~~~~~~~~~~"
xcodebuild clean \
    -workspace ${SOURCE_PATH}/${SCHEME_NAME}.xcworkspace \
    -configuration Release -alltargets

# # build
echo " "
echo "~~~~~~~~~~~~~~~~开始构建~~~~~~~~~~~~~~~~~~~"
 xcodebuild archive \
     -workspace ${SOURCE_PATH}/${SCHEME_NAME}.xcworkspace \
     -scheme ${SCHEME_NAME} \
     -configuration Release \
     -archivePath ${ArchiveName}

echo " "
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
echo " "
echo "~~~~~~~~~~~~~~~~导出ipa~~~~~~~~~~~~~~~~~~~"
xcodebuild -exportArchive \
     -archivePath ${ArchiveName} \
     -exportOptionsPlist ${ConfigurationBuildDir} \
     -exportPath ${IPAPATH} \
     -allowProvisioningUpdates

echo " "
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

# # 上传
echo " "
echo "~~~~~~~~~~~~~~~~ 校验ipa 及 appleId~~~~~~~~~~~~~~~~~~~"
xcrun altool --validate-app -f ${IPAName} -t iOS -u ${APPLEID_ID} -p ${APPLEID_PWD}
echo " "
echo "~~~~~~~~~~~~~~~~ 上传ipa ~~~~~~~~~~~~~~~~~~~"
xcrun altool --update-app -f ${IPAName} -t iOS -u ${APPLEID_ID} -p ${APPLEID_PWD}

#xcrun altool --validate-app -f /Users/yimi/Desktop/wangfuAgent\ 2019-12-02\ 14-59-02/wangfuAgent.ipa -t iOS -u wz_zbkj@163.com -p Weidian,2017


