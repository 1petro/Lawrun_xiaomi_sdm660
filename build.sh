#!/bin/bash
rm .version

clear

#Requirments
#apt-get install libncurses-dev openssl libssl-dev llvm-dev binutils-dev bash gcc-9 gcc-10 gcc clang-9 clang-10 clang-11 clang build-essential zip curl git wget ccache lld-dev lld bc bison flex

# Resources
THREAD="-j8"
KERNEL="Image"
DTBIMAGE="dtb"
KERNEL_NAME=$(pwd)
ver=12
Device_Name=Xiaomi_Sdm660
KER_DIR=$(pwd)
Kernel_Work=/sdcard/kernel_work/$Device_Name
#Default CC-tool
out=out-clang && Cc=clang-$ver

echo -e " \e[36m"
echo "Welcome To Build Script"
echo -e "Instructions \n\nUse g to Use Gcc And c To Use Clang And E To Exit ANd M For More!"
echo "Default Is Clang10!"
echo -e "\nMade By Petro"



#export CROSS_COMPILE_ARM32=${HOME}/toolchains/arm-linux-androideabi-4.9/bin/arm-linux-androideabi-
#chmod 777 AnyKernel3.zip

#Dir
mkdir -p /sdcard/kernel_work
mkdir -p /sdcard/kernel_work/$Device_Name
#cp AnyKernel3.zip -r /sdcard/AnyKernel3.zip

#Backup
cp build.sh -r /sdcard/kernel_work


DEFCONFIG="lavender_defconfig"



# Kernel Details
VER=".1.0"

# Vars
export ARCH=arm64
export SUBARCH=arm64
export DTC_EXT=dtc
export KBUILD_BUILD_USER=Petro
export KBUILD_BUILD_HOST=Ubuntu18.04

#Interface
echo -e " \e[32m"
echo -e "\n[1] Build Kernel"
	echo -e "[2] Regenerate defconfig"
    echo -e "[3] Edit config"
	echo -e "[4] Source cleanup"
	echo -e "[5] Create Flashable Zip"
	echo -e "[6] Build DTB"
	echo -e "[7] View Status ,Last Changes and Updates"
	echo -e "[8] Modify Paths/Vars"
	echo -e "[9] Edit Changelog"
	echo -ne "\n(i) Please enter a choice[1-10]: "

echo -e " \e[31m"
for i in 1 2 3 4 5 6 7 8 9 10 11 
do
  echo -ne "\n"
done

#CC_Tool Switch
gcc () {
    out=out-gcc && Cc=gcc-$ver
}
clang () {
    out=out-clang && Cc=clang-$ver
}
$1

echo "       _________________________________________________________________"
echo "                                 Status"
echo "       Current Kernel Dir                        $KERNEL_NAME"
echo "       Current CC_Tool                           $Cc"
echo "       Out Directory                             $out"
echo "       Defconfig                                 $DEFCONFIG"
echo "       _________________________________________________________________"


	read -n 1 choice


	if [ "$choice" == "1" ]; then
clear
DATE_START=$(date +"%s")
#Logo
echo -e " \e[34m"
echo "____________________ __"
echo "___  /___  __ \__  //_/"
echo "__  / __  /_/ /_  ,<   "
echo "_  /___  _, _/_  /| |  "
echo "/_____/_/ |_| /_/ |_|  "
echo -e " \e[36m"
echo "Build Start"
date +"%m-%d-%y-%r"
echo -e "------------- \e[31m"
echo "Made By Petro"
echo -e " \e[35m"
echo "-------------------"
echo "Making Kernel:"
echo "-------------------"
echo -e "${restore}"


echo -e " \e[32m"
echo "Do U Want Build with Ccache Or Not [Y,n]"
read input
if [[ $input == "Y" || $input == "y" ]];then
make CC="ccache $Cc" O=$out $THREAD 2>&1 | tee kernel.log
clear
cp kernel.log $Kernel_Work
ccache -s
echo -e " \e[31m"
echo -e "${green}"
echo "-------------------"
echo "Build Completed in:"
echo "-------------------"
echo -e "${restore}"

DATE_END=$(date +"%s")
DIFF=$(($DATE_END - $DATE_START))
echo "Time: $(($DIFF / 60)) minute(s) and $(($DIFF % 60)) seconds."
echo
echo "Build End :)"
echo "Do u WanT To Check Kernel Log [Y,n]"
read input
if [[ $input == "Y" || $input == "y" ]];then
nano kernel.log
./build.sh
else
./build.sh
fi
else
make CC=$Cc O=$out $THREAD 2>&1 | tee kernel.log
clear
cp kernel.log $Kernel_Work
echo -e " \e[31m"
echo -e "${green}"
echo "-------------------"
echo "Build Completed in:"
echo "-------------------"
echo -e "${restore}"

DATE_END=$(date +"%s")
DIFF=$(($DATE_END - $DATE_START))
echo "Time: $(($DIFF / 60)) minute(s) and $(($DIFF % 60)) seconds."
echo
echo "Build End :)"
echo "Do u WanT To Check Kernel Log [Y,n]"
read input
if [[ $input == "Y" || $input == "y" ]];then
nano kernel.log
./build.sh
else
./build.sh
fi
fi
fi
if [ "$choice" == "2" ]; then
clear
echo -e " \e[34m"
make CC="ccache $Cc" O=$out $DEFCONFIG $THREAD
sleep 3
./build.sh
fi
if [ "$choice" == "3" ]; then
clear
echo -e " \e[31m"
echo -e "[1] Edit using Default Menuconfig"
echo -e "[2] Edit Using Nano"
echo -ne "\n(i) Make your choice[1-2]: "
read chos
if [ "$chos" == "1" ]; then
clear
make CC="ccache $Cc" O=$out menuconfig $THREAD
./build.sh 
fi
if [ "$chos" == "2" ]; then
nano arch/$ARCH/configs/$DEFCONFIG
./build.sh
fi
fi
if [ "$choice" == "4" ]; then
clear
echo "Cleaning Source In Progress..."
rm -r $out
./build.sh
fi
if [ "$choice" == "6" ]; then
clear
echo -e "[1] make DTS only"
echo -e "[2] make DTBO with Overlay"
echo -ne "\n(i) Make your choice[1-2]: "
read Pl
if [ "$Pl" == "1" ]; then
make CC="ccache $Cc" O=$out dtbs $THREAD
./build.sh 
fi
if [ "$Pl" == "2" ]; then
echo "Making DTBO"
python /root/libufdt/utils/src/mkdtboimg.py create $Kernel_Work/dtbo.img $KER_DIR/$out/arch/arm64/boot/dts/qcom/*.dtbo
sleep 2
./build.sh
fi
fi
if [ "$choice" == "5" ]; then
echo -e " \e[36m"
echo "Making Flashaple Zip In Progress...."
cp $out/arch/arm64/boot/Image.gz-dtb -r /sdcard
cd /sdcard
zip -ur AnyKernel3.zip Image.gz-dtb
    echo "Rename Your Kernel"
read namechange 
mv AnyKernel3.zip $namechange.zip
cp $namechange.zip $Kernel_Work
mv $namechange.zip AnyKernel3.zip
cd $KER_DIR
fi
if [ "$choice" == "7" ]; then
echo "Calculating Changes..."
git status
echo "Back To Menu? [Y,n]"
read S
if [[ $S == "Y" || $S == "y" ]];then
./build.sh
fi
fi
if [ "$choice" == "8" ]; then
echo -e " \e[31m"
sed -n -e 7p -e 8p -e 9p -e 10p -e 11p -e 12p -e 13p -e 14p build.sh
echo -e " \e[34m"
echo "\nDo U Want To Edit Vars [Y,n]"
read pp
if [[ $pp == "Y" || $pp == "y" ]];then
nano +10,10 build.sh
./build.sh
else
./build.sh
fi
fi
if [ "$choice" == "9" ]; then
nano Changelog_v-2
./build.sh
fi
if [ "$choice" == "e" ]; then
exit
fi
if [ "$choice" == "g" ]; then
./build.sh gcc 
fi
if [ "$choice" == "c" ]; then
./build.sh clang
fi