BASEDIR=$(dirname "$0")
# متغير لتحديد مسار المجلد
IPAIN="$BASEDIR"

#مجلد الرئيسي ويكون على سطح المكتب
HomeFolderApp="upplaodPlus"

# مجلد به ادوات بلس
Create_FToolsPlus="ToolsPlus"

# مجلد يكون فيه دايليبات بلس وادواتها
FolderDylibs="dylibs"

# مجلد يكون فيه جميع البرامج الخام العادية التي تكون جاهزه للدمج
AllApps="app"

# متغير لتحيد مجلد البرنامج بعد الانتهاء
EndAppPlus="EndIpaPlus"

# الدخول لمسار المجلد الرئيسي
cd $IPAIN

# اذا لم تكن موجوده المجلدات مسبقاً يتم انشائها
mkdir $Create_FToolsPlus 2> /dev/null
mkdir $FolderDylibs 2> /dev/null
mkdir $AllApps 2> /dev/null
mkdir $EndAppPlus 2> /dev/null

function usage {
cat << USAGE

Version :: 1.0

================= البرامج التي يمكن دمجها  : ==============

Twitter Instagram WhatsApp Facebook Jodel Cercube4 RocketInstagram SnaoChat


USAGE
exit 1
}

[[ $# = 0 ]] && usage

commands=(Twitter Instagram WhatsApp Facebook Jodel Cercube4 RocketInstagram SnaoChat)
[[ ! " ${commands[@]} " =~ " $1 " ]] && usage




function Twitter {
echo " "
echo " ======================= Twitter يتم الان دمج برنامج   ============================= "
#التحقق من وجود البرنامج / اذا كان موجود احذفه لاجل يتم بناء تطبيق بلس جديد
rm -r $EndAppPlus/Twitter_Ok.ipa 2> /dev/null

#الدخول لمجلد البرامج app لاجل يتحقق من وجود البرنامج او لا
cd $AllApps
if [ -e Twitter.ipa ]
then
#حذف مجلد Payload من مجلد البرامج لاجل يتم فك الضغط عن التطبيق
rm -r Payload 2> /dev/null

#فك الضغط عن البرنامج
# هذا الامر > /dev/null يعني اخفاء الارشفه او الاخطاء او الرسالة من الترمنيال
unzip Twitter.ipa > /dev/null
rm -r __MACOSX 2> /dev/null
else
echo " "
echo " =======================  Twitter.ipa البرنامج غير موجود ويجب يكون باسم =======================  "
# اذا لم يكن موجود البرنامج اخرج من التنفيذ
exit 1
fi
# الخروج من مجلد التطبيقات app
cd ../

# حذف مجلد  Payload اذا كان موجود في مجلد ToolsPlus
rm -r $Create_FToolsPlus/Payload 2> /dev/null

# نقل مجلد Payload من مجلد app الى مجلد ToolsPlus
mv $AllApps/Payload $Create_FToolsPlus

# الدخول لمجلد ToolsPlus
cd $Create_FToolsPlus

# حذف اي دايليب موجود مسبقاً
rm -r *.dylib 2> /dev/null; rm -r *.bundle 2> /dev/null

# التحقق من وجود مجلد ادوات بلس قبل التحميل من الانترنت
if [ -e twppsl.zip ]
then
echo " "
# اذا موجود ملفات بلس يتم دمجها مباشره بدون التحميل من الانترنت
echo "======================= ادوات بلس موجوده  ====================== "
else
echo
echo " "
# اذا لم يكن موجود ملفات بلس يتم تحمليها من الانترنت
echo "=======================    تحميل ملفات تويتر بلس    ======================="
curl -O "https://raw.githubusercontent.com/eni9889/pptweaks/master/twppsl.zip"
fi

echo " "
echo "=======================   يتم الان فك الضغط    ====================="
# فك الضغط على مجلد بلس
unzip twppsl.zip > /dev/null

# نسخ ملفات الدايليب الخاصه بهذا التطبيق من مجلد الدايليب dylibs الى مجلد ToolsPlus لاجل الدمج
cp -R ~/Desktop/$HomeFolderApp/dylibs/CrackPlus.dylib $IPAIN/$Create_FToolsPlus
cp -R ~/Desktop/$HomeFolderApp/dylibs/TWSaveDm.dylib $IPAIN/$Create_FToolsPlus

# نقل جميع ملفات بلس الخاص به داخل البرتامج لتجهيزها للدمج
mv *.dylib $IPAIN/$Create_FToolsPlus/Payload/Twitter.app; mv *.bundle $IPAIN/$Create_FToolsPlus/Payload/Twitter.app
echo "  "
echo "=======================  يتم الان دمج الادوات  ====================="
echo "  "
echo "=======================  pptweak.dylib يتم الان دمج  ====================="
# يتم الان دمج البرنامج باداة optool
~/Desktop/$HomeFolderApp/optool install -c load -p "@executable_path/pptweak.dylib" -t ~/Desktop/$HomeFolderApp/$Create_FToolsPlus/Payload/Twitter.app/Twitter
echo "  "
echo "=======================  CrackPlus.dylib يتم الان دمج  ====================="
~/Desktop/$HomeFolderApp/optool install -c load -p "@executable_path/CrackPlus.dylib" -t ~/Desktop/$HomeFolderApp/$Create_FToolsPlus/Payload/Twitter.app/Twitter
echo "  "
echo "=======================  TWSaveDm.dylib يتم الان دمج  ====================="

~/Desktop/$HomeFolderApp/optool install -c load -p "@executable_path/TWSaveDm.dylib" -t ~/Desktop/$HomeFolderApp/$Create_FToolsPlus/Payload/Twitter.app/Twitter

echo
echo "  "
echo "=======================  يتم الان بناء التطبيق   ====================="

# ضغط مجلد Payload الى صغية zip
zip -r Payload.zip Payload > /dev/null

# تحويل Payload الى اسم البرنامج
mv Payload.zip Twitter_Ok.ipa > /dev/null
rm -r Payload 2> /dev/null

# الخروج من مسار المجلد خطوة وراء
cd ../

# نقل البرنامج من مجلد ToolsPlus الى المجلد النهائي وهو  Endipaplus
mv $Create_FToolsPlus/Twitter_Ok.ipa $EndAppPlus
#say "Tank you"
}



function Instagram {

echo " "
echo " ======================= Instagram يتم الان دمج برنامج   ============================= "

rm -r $EndAppPlus/Instagram_Ok.ipa 2> /dev/null
cd $AllApps
if [ -e Instagram.ipa ]
then
rm -r Payload 2> /dev/null
unzip Instagram.ipa > /dev/null
rm -r __MACOSX 2> /dev/null
else
echo " "
echo "=======================   Instagram.ipa البرنامج غير موجود ويجب يكون باسم =======================  "
exit 1
fi

cd ../
rm -r $Create_FToolsPlus/Payload 2> /dev/null
mv $AllApps/Payload $Create_FToolsPlus

cd $Create_FToolsPlus
rm -r *.dylib 2> /dev/null; rm -r *.bundle 2> /dev/null
if [ -e igppsl.zip ]
then
echo " "
echo "=======================  ادوات بلس موجوده يتم الان فك الضغط ====================== "
else
echo
echo " "
echo "================   تحميل ملفات انستقرام بلس    ====================="
curl -O "https://raw.githubusercontent.com/eni9889/pptweaks/master/igppsl.zip"
fi

echo " "
echo "================   يتم الان فك الضغط    ====================="

unzip igppsl.zip > /dev/null
cp -R ~/Desktop/$HomeFolderApp/dylibs/CrackPlus.dylib $IPAIN/$Create_FToolsPlus

mv *.dylib $IPAIN/$Create_FToolsPlus/Payload/Instagram.app; mv *.bundle $IPAIN/$Create_FToolsPlus/Payload/Instagram.app
echo " "
echo "================   يتم الان دمج الادوات  ====================="
echo "  "
echo "================  pptweak.dylib يتم الان دمج  ====================="

~/Desktop/$HomeFolderApp/optool install -c load -p "@executable_path/pptweak.dylib" -t ~/Desktop/$HomeFolderApp/$Create_FToolsPlus/Payload/Instagram.app/Instagram
echo "  "
echo "================  CrackPlus.dylib يتم الان دمج  ====================="

~/Desktop/$HomeFolderApp/optool install -c load -p "@executable_path/CrackPlus.dylib" -t ~/Desktop/$HomeFolderApp/$Create_FToolsPlus/Payload/Instagram.app/Instagram
echo "  "

echo "================  يتم الان بناء التطبيق   ====================="

zip -r Payload.zip Payload > /dev/null

mv Payload.zip Instagram_Ok.ipa > /dev/null
rm -r Payload 2> /dev/null

cd ../
mv $Create_FToolsPlus/Instagram_Ok.ipa $EndAppPlus
#say "Tank you"

}


function WhatsApp {
echo " "
echo " ======================= WhatsApp يتم الان دمج برنامج   ============================= "

rm -r $EndAppPlus/WhatsApp_Ok.ipa 2> /dev/null
cd $AllApps
if [ -e WhatsApp.ipa ]
then
rm -r Payload 2> /dev/null
unzip WhatsApp.ipa > /dev/null
rm -r __MACOSX 2> /dev/null
else
echo " "
echo " =======================  WhatsApp.ipa البرنامج غير موجود ويجب يكون باسم =======================  "
exit 1
fi

cd ../
rm -r $Create_FToolsPlus/Payload 2> /dev/null
mv $AllApps/Payload $Create_FToolsPlus

cd $Create_FToolsPlus
rm -r *.dylib 2> /dev/null; rm -r *.bundle 2> /dev/null
if [ -e wappsl.zip ]
then
echo " "
echo "=======================  ادوات بلس موجوده يتم الان فك الضغط ====================== "
else
echo
echo " "
echo "================   تحميل ملفات انستقرام بلس    ====================="
curl -O "https://raw.githubusercontent.com/eni9889/pptweaks/master/wappsl.zip"
fi

echo " "
echo "================   يتم الان فك الضغط    ====================="

unzip wappsl.zip > /dev/null
cp -R ~/Desktop/$HomeFolderApp/dylibs/CrackPlus.dylib $IPAIN/$Create_FToolsPlus
cp -R ~/Desktop/$HomeFolderApp/dylibs/WhatsAppFix.dylib $IPAIN/$Create_FToolsPlus
cp -R ~/Desktop/$HomeFolderApp/dylibs/UnlimUpload.dylib $IPAIN/$Create_FToolsPlus

mv *.dylib $IPAIN/$Create_FToolsPlus/Payload/WhatsApp.app; mv *.bundle $IPAIN/$Create_FToolsPlus/Payload/WhatsApp.app
echo " "
echo "================   يتم الان دمج الادوات  ====================="
echo "  "
echo "================  pptweak.dylib يتم الان دمج  ====================="

~/Desktop/$HomeFolderApp/optool install -c load -p "@executable_path/pptweak.dylib" -t ~/Desktop/$HomeFolderApp/$Create_FToolsPlus/Payload/WhatsApp.app/WhatsApp

echo "  "
echo "================  CrackPlus.dylib يتم الان دمج  ====================="

~/Desktop/$HomeFolderApp/optool install -c load -p "@executable_path/CrackPlus.dylib" -t ~/Desktop/$HomeFolderApp/$Create_FToolsPlus/Payload/WhatsApp.app/WhatsApp
echo "  "
echo "================  UnlimUpload.dylib يتم الان دمج  ====================="

~/Desktop/$HomeFolderApp/optool install -c load -p "@executable_path/UnlimUpload.dylib" -t ~/Desktop/$HomeFolderApp/$Create_FToolsPlus/Payload/WhatsApp.app/WhatsApp
echo "  "
echo "================  WhatsAppFix.dylib يتم الان دمج  ====================="

~/Desktop/$HomeFolderApp/optool install -c load -p "@executable_path/WhatsAppFix.dylib" -t ~/Desktop/$HomeFolderApp/$Create_FToolsPlus/Payload/WhatsApp.app/WhatsApp

echo " "
echo "================   انتهى الدمج  ====================="
echo " "
echo "================  يتم الان بناء التطبيق   ====================="

zip -r Payload.zip Payload > /dev/null

mv Payload.zip WhatsApp_Ok.ipa > /dev/null
rm -r Payload 2> /dev/null

cd ../
mv $Create_FToolsPlus/WhatsApp_Ok.ipa $EndAppPlus
#say "Tank you"

}

function Facebook {
echo " "
echo " ======================= Facebook يتم الان دمج برنامج   ============================= "

rm -r $EndAppPlus/Facebook_Ok.ipa 2> /dev/null
cd $AllApps
if [ -e Facebook.ipa ]
then
rm -r Payload 2> /dev/null
unzip Facebook.ipa > /dev/null
rm -r __MACOSX 2> /dev/null
else
echo " "
echo " =======================  Facebook.ipa البرنامج غير موجود ويجب يكون باسم =======================  "
exit 1
fi

cd ../
rm -r $Create_FToolsPlus/Payload 2> /dev/null
mv $AllApps/Payload $Create_FToolsPlus

cd $Create_FToolsPlus
rm -r *.dylib 2> /dev/null; rm -r *.bundle 2> /dev/null
if [ -e fbppsl.zip ]
then
echo " "
echo "=======================  ادوات بلس موجوده يتم الان فك الضغط ====================== "
else
echo " "
echo "================   تحميل ملفات انستقرام بلس    ====================="
curl -O "https://raw.githubusercontent.com/eni9889/pptweaks/master/fbppsl.zip"
fi

echo "================   يتم الان فك الضغط    ====================="

unzip fbppsl.zip > /dev/null
cp -R ~/Desktop/$HomeFolderApp/dylibs/CrackPlus.dylib $IPAIN/$Create_FToolsPlus

mv *.dylib $IPAIN/$Create_FToolsPlus/Payload/Facebook.app; mv *.bundle $IPAIN/$Create_FToolsPlus/Payload/Facebook.app
echo " "
echo "================   يتم الان دمج الادوات  ====================="
echo "  "
echo "================  pptweak.dylib يتم الان دمج  ====================="

~/Desktop/$HomeFolderApp/optool install -c load -p "@executable_path/pptweak.dylib" -t ~/Desktop/$HomeFolderApp/$Create_FToolsPlus/Payload/Facebook.app/Facebook
echo "  "
echo "================  CrackPlus.dylib يتم الان دمج  ====================="

~/Desktop/$HomeFolderApp/optool install -c load -p "@executable_path/CrackPlus.dylib" -t ~/Desktop/$HomeFolderApp/$Create_FToolsPlus/Payload/Facebook.app/Facebook

echo " "
echo "================  يتم الان بناء التطبيق   ====================="

zip -r Payload.zip Payload > /dev/null

mv Payload.zip Facebook_Ok.ipa > /dev/null
rm -r Payload 2> /dev/null

cd ../
mv $Create_FToolsPlus/Facebook_Ok.ipa $EndAppPlus
#say "Tank you"
}



function Jodel {
echo " "
echo " ======================= Jodel يتم الان دمج برنامج   ============================= "
rm -r $EndAppPlus/Jodel_Ok.ipa 2> /dev/null
cd $AllApps
if [ -e Jodel.ipa ]
then
rm -r Payload 2> /dev/null
echo " "
echo " =======================  يتم الان فك الضغط عن البرنامج   ============================= "
unzip Jodel.ipa > /dev/null
rm -r __MACOSX 2> /dev/null
else
echo " "
echo " =======================  Jodel.ipa البرنامج غير موجود ويجب يكون باسم ======================= "
exit 1
fi
cd ../
rm -r $Create_FToolsPlus/Payload 2> /dev/null
mv $AllApps/Payload $Create_FToolsPlus
cp -R ~/Desktop/$HomeFolderApp/dylibs/JodelPlus.dylib $IPAIN/$Create_FToolsPlus/Payload/Jodel.app
cp -R ~/Desktop/$HomeFolderApp/dylibs/jodelResources.bundle $IPAIN/$Create_FToolsPlus/Payload/Jodel.app
echo " "
echo "===========================  JodelPlus.dylib يتم الان دمج   ======================================="
echo " "
~/Desktop/$HomeFolderApp/optool install -c load -p "@executable_path/JodelPlus.dylib" -t ~/Desktop/$HomeFolderApp/$Create_FToolsPlus/Payload/Jodel.app/Jodel
echo "   "
echo "===========================   انتهى من الدمج  ======================================="
echo " "
echo "=========================== يتم الان بناء التطبيق   ======================================="
cd $Create_FToolsPlus
zip -r Payload.zip Payload > /dev/null
mv Payload.zip Jodel_Ok.ipa > /dev/null
rm -r Payload 2> /dev/null
cd ../
mv $Create_FToolsPlus/Jodel_Ok.ipa $EndAppPlus
#say "Tank you"
}


function Cercube4 {
echo " "
echo " ======================= Cercube4 يتم الان دمج برنامج   ============================= "

rm -r $EndAppPlus/Cercube4_Ok.ipa 2> /dev/null
cd $AllApps
if [ -e Cercube4.ipa ]
then
rm -r Payload 2> /dev/null
echo " "
echo " =======================  يتم الان فك الضغط عن البرنامج   ============================= "
unzip Cercube4.ipa > /dev/null
rm -r __MACOSX 2> /dev/null
else
echo " "
echo "=======================   Cercube4.ipa البرنامج غير موجود ويجب يكون باسم =======================  "
exit 1
fi
if [ ! -e ~/Desktop/$HomeFolderApp/dylibs/Cercube.dylib ]
then

echo " "
echo "=======================   Cercube.dylib دايليب البرنامج غير موجود ويجب يكون باسم =======================  "
exit 1

else
echo " "
echo " =======================   يتم الان دمج الادوات  ============================= "

fi
cd ../
rm -r $Create_FToolsPlus/Payload 2> /dev/null

mv $AllApps/Payload $Create_FToolsPlus


cp -R ~/Desktop/$HomeFolderApp/dylibs/Cercube.dylib $IPAIN/$Create_FToolsPlus/Payload/YouTube.app
cp -R ~/Desktop/$HomeFolderApp/dylibs/Cercube.bundle $IPAIN/$Create_FToolsPlus/Payload/YouTube.app
cp -R ~/Desktop/$HomeFolderApp/dylibs/libCercube.dylib $IPAIN/$Create_FToolsPlus/Payload/YouTube.app
cp -R ~/Desktop/$HomeFolderApp/dylibs/AdBlocker.dylib $IPAIN/$Create_FToolsPlus/Payload/YouTube.app
cp -R ~/Desktop/$HomeFolderApp/dylibs/CercubeCrack.dylib $IPAIN/$Create_FToolsPlus/Payload/YouTube.app

echo " "
echo "================  Cercube.dylib يتم الان دمج   ====================="
~/Desktop/$HomeFolderApp/optool install -c load -p "@executable_path/Cercube.dylib" -t ~/Desktop/$HomeFolderApp/$Create_FToolsPlus/Payload/YouTube.app/YouTube
echo " "
echo "================  CercubeCrack.dylib يتم الان دمج   ====================="
~/Desktop/$HomeFolderApp/optool install -c load -p "@executable_path/CercubeCrack.dylib" -t ~/Desktop/$HomeFolderApp/$Create_FToolsPlus/Payload/YouTube.app/YouTube
echo "   "
echo "===========================   انتهى من الدمج  ======================================="
echo " "
echo "=========================== يتم الان بناء التطبيق   ======================================="

cd $Create_FToolsPlus
zip -r Payload.zip Payload > /dev/null

mv Payload.zip Cercube4_Ok.ipa > /dev/null
rm -r Payload 2> /dev/null

cd ../
mv $Create_FToolsPlus/Cercube4_Ok.ipa $EndAppPlus
#say "Tank you"
}


function RocketInstagram {
echo " "
echo " ======================= RocketInstagram يتم الان دمج برنامج   ============================= "

rm -r $EndAppPlus/RocketInstagram_Ok.ipa 2> /dev/null
cd $AllApps
if [ -e RocketInstagram.ipa ]
then
rm -r Payload 2> /dev/null
echo " "
echo " =======================  يتم الان فك الضغط عن البرنامج   ============================= "
unzip RocketInstagram.ipa > /dev/null
rm -r __MACOSX 2> /dev/null
else
echo " "
echo "=======================   RocketInstagram.ipa البرنامج غير موجود ويجب يكون باسم =======================  "
exit 1
fi

cd ../
rm -r $Create_FToolsPlus/Payload 2> /dev/null

mv $AllApps/Payload $Create_FToolsPlus

cp -R ~/Desktop/$HomeFolderApp/dylibs/Rocket.dylib $IPAIN/$Create_FToolsPlus/Payload/Instagram.app
cp -R ~/Desktop/$HomeFolderApp/dylibs/Rocket.bundle $IPAIN/$Create_FToolsPlus/Payload/Instagram.app
cp -R ~/Desktop/$HomeFolderApp/dylibs/libRocket.dylib $IPAIN/$Create_FToolsPlus/Payload/Instagram.app

echo " "
echo "================  Rocket.dylib يتم دمج   ====================="
echo " "

~/Desktop/$HomeFolderApp/optool install -c load -p "@executable_path/Rocket.dylib" -t ~/Desktop/$HomeFolderApp/$Create_FToolsPlus/Payload/Instagram.app/Instagram

echo "   "
echo "===========================   انتهى من الدمج  ======================================="

echo
echo " "
echo "=========================== يتم الان بناء التطبيق   ======================================="

cd $Create_FToolsPlus
zip -r Payload.zip Payload > /dev/null

mv Payload.zip RocketInstagram_Ok.ipa > /dev/null
rm -r Payload 2> /dev/null

cd ../
mv $Create_FToolsPlus/RocketInstagram_Ok.ipa $EndAppPlus
#say "Tank you"
}


function SnaoChat {
echo " "
echo " ======================= SnaoChat يتم الان دمج برنامج   ============================= "

rm -r $EndAppPlus/SnaoChat_Ok.ipa 2> /dev/null
cd $AllApps
if [ -e SnaoChat.ipa ]
then
rm -r Payload 2> /dev/null
echo " "
echo " =======================  يتم الان فك الضغط عن البرنامج   ============================= "
unzip SnaoChat.ipa > /dev/null
rm -r __MACOSX 2> /dev/null
else
echo " "
echo "=======================   SnaoChat.ipa البرنامج غير موجود ويجب يكون باسم =======================  "
exit 1
fi

cd ../
rm -r $Create_FToolsPlus/Payload 2> /dev/null

mv $AllApps/Payload $Create_FToolsPlus

cp -R ~/Desktop/$HomeFolderApp/dylibs/SnapPlus.dylib $IPAIN/$Create_FToolsPlus/Payload/Snapchat.app
cp -R ~/Desktop/$HomeFolderApp/dylibs/SnapPlus.bundle $IPAIN/$Create_FToolsPlus/Payload/Snapchat.app

echo " "
echo "================  SnapPlus.dylib يتم دمج   ====================="
echo " "

~/Desktop/$HomeFolderApp/optool install -c load -p "@executable_path/SnapPlus.dylib" -t ~/Desktop/$HomeFolderApp/$Create_FToolsPlus/Payload/Snapchat.app/Snapchat

echo "   "
echo "===========================   انتهى من الدمج  ======================================="

echo
echo " "
echo "=========================== يتم الان بناء التطبيق   ======================================="

cd $Create_FToolsPlus
zip -r Payload.zip Payload > /dev/null

mv Payload.zip Snapchat_Ok.ipa > /dev/null
rm -r Payload 2> /dev/null

cd ../
mv $Create_FToolsPlus/Snapchat_Ok.ipa $EndAppPlus
#say "Tank you"
}




"$1" "${@:2}"
