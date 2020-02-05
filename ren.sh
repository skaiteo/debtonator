if [ $1 == d ]
# Attempt change to debug mode
then
  if [ -e "android/app/Dbuild.gradle" ] && [ -e "android/app/src/main/dAndroidManifest.xml" ]
  then
    # echo "Yeap, DebugAM exists, will change them"
    mv "android/app/build.gradle" "android/app/Pbuild.gradle"
    mv "android/app/Dbuild.gradle" "android/app/build.gradle"
    mv "android/app/src/main/AndroidManifest.xml" "android/app/src/main/pAndroidManifest.xml"
    mv "android/app/src/main/dAndroidManifest.xml" "android/app/src/main/AndroidManifest.xml"
    echo "Changed to debug files"
  elif [ -e android/app/Pbuild.gradle ] && [ -e "android/app/src/main/pAndroidManifest.xml" ]
  then
    echo "Already in debug mode"
  else
    echo "Something's wrong with the files"
  fi
elif [ $1 == p ]
# Attempt change to production mode
then
  if [ -e "android/app/Pbuild.gradle" ] && [ -e "android/app/src/main/pAndroidManifest.xml" ]
  then
    # echo "Yeap, ProdAM exists, will change them"
    mv "android/app/build.gradle" "android/app/Dbuild.gradle"
    mv "android/app/Pbuild.gradle" "android/app/build.gradle"
    mv "android/app/src/main/AndroidManifest.xml" "android/app/src/main/dAndroidManifest.xml"
    mv "android/app/src/main/pAndroidManifest.xml" "android/app/src/main/AndroidManifest.xml"
    echo "Changed to production files"
  elif [ -e "android/app/Dbuild.gradle" ] && [ -e "android/app/src/main/dAndroidManifest.xml" ]
  then
    echo "Already in production mode"
  else
    echo "Something's wrong with the files"
  fi
else
  echo "No parameter given"
fi