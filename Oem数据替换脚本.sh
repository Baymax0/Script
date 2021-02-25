#!/bin/bash
# sudo chmod -R 777 <name>


# wangfuAgent.xcworkspace 所在路径   /  结尾！！！！
LOCATION=""
# LOCATION="/Users/yimi/Desktop/网付合伙人2/wangfuAgent/"

OEM_ID="2312"
OEM_NAME="街口"

# --------------------------
echo -e "${LOCATION}"
CONST_FILE="${LOCATION}wangfuAgent/support/Const.swift"
INFO_FILE="${LOCATION}wangfuAgent/support/Info.plist"
Image_Dir="${LOCATION}wangfuAgent/Assets.xcassets"

# 包含5张图 + 启动图
image_from="${LOCATION}/合伙人oem"
# 启动图
applogo_from="${LOCATION}/AppIcon.appiconset"


# 包含5张图 + 启动图

# // oemId
# var oemInstitutionNo:String? = nil
# // oem 版本号 "1.0"
# var oemVersions:String? = nil
# // App名称
# var oemAppName:String = "网付"

# 替换oemInstitutionNo (-i 表示编辑文本  s替换)
echo -e "     1.  Const.swift 内容替换         \n"
sed -i  "" "s/oemInstitutionNo:String? = nil/oemInstitutionNo:String? = \"${OEM_ID}\"/g" "${CONST_FILE}"
sed -i  "" "s/oemAppName:String = \"网付\"/oemAppName:String = \"${OEM_NAME}\"/g" "${CONST_FILE}"


echo -e "     2.  Info.plist  内容替换         \n"
sed -i  "" "s/网付合伙人/${OEM_NAME}合伙人/g" "${INFO_FILE}"


echo -e "     3.  粘贴新Oem图片            \n"
cp -rf ${image_from} ${Image_Dir}


echo -e "     4.  粘贴新Applogo图片            \n"
cp -rf ${applogo_from} ${Image_Dir}
echo -e "    -------- over --------         \n"







