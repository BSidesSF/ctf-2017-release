#include <jni.h>
#include <string>

extern "C"
jstring
Java_com_flagstore_ctf_flagstore_CTFReceiver_getPhrase(
        JNIEnv* env,
        jobject thiz, jstring str1, jstring str2, jstring str3 /* this */) {
    char activityArray[77], nameArray[77], partArray[77], resultArray[77];
    char *result;
    int i = 0;
    char *part1 = (*env)->GetStringUTFChars(env, str1, NULL);
    char *activity = (*env)->GetStringUTFChars(env, str2, NULL);
    char *name = (*env)->GetStringUTFChars(env, str3, NULL);
    char *part2 = "";
    strcat(part1, part2);
    strncpy(partArray, part1, 76);
    strncpy(activityArray, activity, 76);
    strncpy(nameArray, name, 76);
    for(i=0; i<76; i++){
        resultArray[i] = (char)(activityArray[i] ^ nameArray[i] ^ partArray[i]);
        printf("%c\n",resultArray[i]);
    }
    resultArray[76] = 0;
    printf("Here is your Reply: %s", resultArray);
    return (*env)->NewStringUTF(env, resultArray);
}

jstring
Java_com_flagstore_ctf_flagstore_CTFReceiver_getFlag(
        JNIEnv* env,
        jobject /* this */) {
    std::string hello = "Here is the flag...or not";
    return env->NewStringUTF(hello.c_str());
}