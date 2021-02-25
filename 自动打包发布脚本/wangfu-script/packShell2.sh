#!/bin/bash
# V-0.2
# Autor Lizhiwei

##################   打 包 参 数   #####################
# # 项目名称： ‘网付.xcodeproj’就使用网付
SCHEME_NAME="网付"
# # 项目路径   ‘网付.xcodeproj’所在的目录
SOURCE_PATH="/Users/YiMi/Desktop/网付"
# # 打包环境，1＝ad-hoc  2=Appstore  3=仅生成ipa
PACKAGE_TYPE=1

# # PACKAGE_TYPE = 1 ad-hoc
##################   上 传 fir 参 数   #####################
# # 需要安装fir-cli  安装方法：$gem install fir-cli
# # token获取方法：http://fir.im/apps/apitoken
FIR_LOGIN_TOCKEN="d2c0fe82fa30e6b24fc197fa36bb0ade"
# # fir.im上的短连接
FIR_PROCECT_SHORT_LINK="wangfu"


# # PACKAGE_TYPE = 2 Appstore
##################   上 传 Appstore 参 数   #####################
# # 上传的appleId账号
AppleID_Account="2313243242@qq.com"
# # 上传的appleId账号密码
AppleID_Password="d2c0fe82fa30e6b24fc197fa36bb0ade"



#################################################
##################  script ######################
#发布确认
echo -e "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~\n"
if [ $PACKAGE_TYPE -eq 1 ]; then
echo -e "~~~~~ 当前选择发布至 :  ad-hoc ~~~~~~~~~~~\n"
fi
if [ $PACKAGE_TYPE -eq 2 ]; then
echo -e "~~~~~ 当前选择发布至 :  Appstore ~~~~~~~~~~\n"
fi

read -t 5 -p "1：ad-hoc  2：Appstore  是否修改？(5s)" word
if [ $word -eq 1 ]; then
PACKAGE_TYPE=1
fi
if [ $word -eq 2 ]; then
PACKAGE_TYPE=2
fi


if [ $PACKAGE_TYPE -eq 1 ]; then
    # # 打包后存放ipa文件的文件名
    BRANCH_NAME="ad-hoc"
    # # 打包至adhoc的配置参数 可通过手动打包后使用系统创建的
    ConfigurationBuildDir="./AdHocExportOptions.plist"
fi

if [ $PACKAGE_TYPE -eq 2 ]; then
    # # 打包后存放ipa文件的文件名
    BRANCH_NAME="appStore"
    # # 打包至Appstore的配置参数 可通过手动打包后使用系统创建的
    ConfigurationBuildDir="./AdHocExportOptions.plist"
fi
# # 时间戳
#DATE=`date +%Y%m%d_%H%M`
DATE=`123456`
IPAPATH="./${SCHEME_NAME}/${BRANCH_NAME}/"

# # 归档最终文件
ArchiveName="${IPAPATH}/${SCHEME_NAME}.xcarchive"
# # 最终ipa文件
IPAName="${IPAPATH}/${SCHEME_NAME}.ipa"




# # 创建项目文件夹
mkdir ./${SCHEME_NAME}
mkdir ./${SCHEME_NAME}/${BRANCH_NAME}
mkdir ./${SCHEME_NAME}/${BRANCH_NAME}/${DATE}

## # 清理 避免出现一些莫名的错误
echo "~~~~~~~~~~~~~~~~开始清理~~~~~~~~~~~~~~~~~~~"
xcodebuild clean -configuration Release -alltargets

# # archive
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


#if [ $PACKAGE_TYPE -eq 1 ]; then
#    # # 上传至 Fir内测平台
#    read -t 10 -p "输入版本更新说明（10s内输入） :" word
#    if  [ ! -n "$word" ] ;then
#        word=""
#    fi
#
#    fir publish "${IPAName}" -T "${FIR_LOGIN_TOCKEN}" -Q  -c "${word}" -s "${FIR_PROCECT_SHORT_LINK}"
#
#    echo -e "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~\n"
#    echo -e "              上 传 完 毕                 \n"
#    echo -e "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~\n"
#fi

#if [ $PACKAGE_TYPE -eq 2 ]; then
#    # # 上传至 appStore
#    altoolPath="/Applications/Xcode.app/Contents/Applications/Application Loader.app/Contents/Frameworks/ITunesSoftwareService.framework/Versions/A/Support/altool"
#"$altoolPath" --validate-app -f ${IPAName} -u ${AppleID_Account} -p ${AppleID_Password} -t ios --output-format xml
#    "$altoolPath" --upload-app -f ${IPAName} -u  ${AppleID_Account} -p ${AppleID_Password} -t ios --output-format xml
#
#fi




