#! /bin/bash
					      	
                                              ############################################
                                             ### Simple bash script for automatically ###
                                            ###  setting up correctly the build      ###
				                           ### envoirment machine                   ###
                                          ############################################    
					                                                 # Creator: rez_23 
					                                                ## Version: 1.0


					                                           
					                                           
##########################################################
### Variabiles ############################################
##########################################################
LOCAL_DIR=$(pwd)
CCACHE_DIRECTORY=$LOCAL_DIR/ccache_dir
ANDROID_VERSION_FILE=$LOCAL_DIR/.android_version
# Text color vars
red_text=$(tput setaf 1)
green_text=$(tput setaf 2)
orange_text=$(tput setaf 2000)
blue_text=$(tput setaf 20000000)
blue2_text=$(tput setaf 6)
normal_text=$(tput sgr0)
brown_text=$(tput setaf 3)
###########################################################
### Functions ##############################################
###########################################################
configBuildTarget() {
	printf  "${blue_text}\nInsert device model name:${blue2_text}"
	read TARGET_DEVICE
}
configBuildType() {
	printf  "${blue_text}\nChoice build type between:${orange_text}\n1)user\n2)userdebug\n3)eng:${blue2_text}"
	read type
	case $type in 
		"1")
			BUILD_TYPE=user
			;;
		"2")
			BUILD_TYPE=userdebug
			;;
		"3")
			BUILD_TYPE=eng
			;;
		*)
			printf  "${red_text}wrong build type.${blue_text}\nChoice one of the supported build type between:${orange_text}\n1)user\n2)userdebug\n3)eng:${blue2_text}"
			read type
			configBuildType
			;;
	esac
}
configAndroidVersion() {
	if [ -e "$ANDROID_VERSION_FILE" ]; then
		ANDROID_VERSION=$(cat $ANDROID_VERSION_FILE)
	else	
		printf  "${brown_text}The android version autodetect file not exist!${blue_text}\nWrite the version of android that you are going to build:${blue2_text}"
		read ANDROID_VERSION
		echo "$ANDROID_VERSION" >> $ANDROID_VERSION_FILE
	fi
}
		

doneMessage() {
	if [ "$?" = "0" ]; then
		 printf  "\n${green_text}Done!${normal_text}\n\n"
	else
		printf  "${red_text}\nError!\nSome error as occuring during the process. Exiting... :(\n\n${normal_text}"
	fi
}
############################################################
### Main ####################################################
############################################################
if [[  -e "venv/bin/activate ]] && [[ $? = 1 ]]; then
    printf "Creating the virtual python 2 envoirment\n"
    virtualenv2 venv
    if [[ $? = 1 ]; the
        printf "impossible create python 2 virtual env\n plese install the python2-virtualenv package"
     fi
fi
printf "Entering in the virtual python2 envoirment..\n\n"
source venv/bin/activate
printf "Setting up of envoirment...\n\n"
source build/envsetup.sh
export PATH=$LOCAL_DIR/prebuilts/sdk/tools:$PATH
doneMessage
printf   "${blue_text}\nCCACHE memory ammount(GB):${blue2_text}"
read  CCACHE_SIZE
prebuilts/misc/linux-x86/ccache/ccache -M "$CCACHE_SIZE"G
doneMessage
printf  "${brown_text}\nSetting-up ccache directory...\n${normal_text}"  
if [ -d "$CCACHE_DIRECTORY" ]; then
	export CCACHE_DIR="$CCACHE_DIRECTORY"
	printf  "${green_text}\nDone!\nThe ccache directory is sected to %s now!\n${normal_text}" $CCACHE_DIR
	
else
	printf "\n Creating "$CCACHE_DIRECTORY" directory\n"
	mkdir $CCACHE_DIRECTORY
	if [ "$?" = "0" ]; then
		export CCACHE_DIR="$CCACHE_DIRECTORY"
		printf  "${green_text}\nDone!\nThe ccache directory is sected to %s now!\n${normal_text}" $CCACHE_DIR
	fi
	doneMessage
fi
configAndroidVersion
configBuildTarget
configBuildType
printf  "${brown_text}\nSetting-up build variabiles for "$ANDROID_VERSION"_"$TARGET_DEVICE" variant:\n\n\n"
lunch "$ANDROID_VERSION"_"$TARGET_DEVICE"-"$BUILD_TYPE"
if [ "$?" = "0" ]; then
	printf  "${green_text}\nDone! Now is possible build android for "$TARGET_DEVICES"\n\n${normal_text}"
else
        printf  "\n${red_text}Error!\nSome error as occured during setting up of envoirment. \nExiting\n${normal_text}"
fi
