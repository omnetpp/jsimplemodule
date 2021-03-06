//
// This file is part of the OMNeT++ JSimpleModule project.
//
// Copyright 2009-2021 OpenSim Ltd and Andras Varga.
//
// Redistribution and use in source and binary forms, with or without
// modification, are permitted provided that the following conditions are met:
//
// 1. Redistributions of source code must retain the above copyright notice,
//    this list of conditions and the following disclaimer.
//
// 2. Redistributions in binary form must reproduce the above copyright notice,
//    this list of conditions and the following disclaimer in the documentation
//    and/or other materials provided with the distribution.
//
// THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
// AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
// IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
// ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
// LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
// CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
// SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
// INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
// CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
// ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
// POSSIBILITY OF SUCH DAMAGE.
//

#include "JUtil.h"
#include "JSimpleModule.h"

//#define DEBUGPRINTF printf
#define DEBUGPRINTF (void)

#ifdef _WIN32
#define PATH_SEP ";"
#else
#define PATH_SEP ":"
#endif

using namespace omnetpp;

// This will come from the generated SimkernelJNI_registerNatives.cc
void SimkernelJNI_registerNatives(JNIEnv *jenv);

JavaVM *JUtil::vm;
JNIEnv *JUtil::jenv;


void JUtil::initJVM()
{
    DEBUGPRINTF("Starting JVM...\n");
    JavaVMInitArgs vm_args;
    JavaVMOption options[10];

    int n = 0;
    const char *classpath = getenv("CLASSPATH");
    if (!classpath)
        throw cRuntimeError("CLASSPATH environment variable is not set");
    // FIXME remove hack once IDE builds the classpath corretcly
    const char *classpath2 = getenv("CLASSPATH2");
    std::string classpathOption = std::string("-Djava.class.path=")+(classpath2 ? classpath2 : "")+PATH_SEP+(classpath ? classpath : "");
    options[n++].optionString = (char *)classpathOption.c_str(); /* user classes */
    options[n++].optionString = (char *)"-Djava.library.path=."; /* set native library path */
    //options[n++].optionString = "-Djava.compiler=NONE";    /* disable JIT */
    //options[n++].optionString = "-verbose:jni";            /* print JNI-related messages */
    //options[n++].optionString = "-verbose:class";          /* print class loading messages */

    vm_args.version = JNI_VERSION_1_2;
    vm_args.options = options;
    vm_args.nOptions = n;
    vm_args.ignoreUnrecognized = true;

    int res = JNI_CreateJavaVM(&vm, (void **)&jenv, &vm_args);
    if (res<0)
        throw cRuntimeError("Could not create Java VM: JNI_CreateJavaVM returned %d", res);

    DEBUGPRINTF("Registering native methods...\n");
    SimkernelJNI_registerNatives(jenv);
    DEBUGPRINTF("Done.\n");
}

std::string JUtil::fromJavaString(jstring stringObject)
{
    if (!stringObject)
        return "<null>";
    jboolean isCopy;
    const char *buf = JUtil::jenv->GetStringUTFChars(stringObject, &isCopy);
    std::string str = buf ? buf : "";
    JUtil::jenv->ReleaseStringUTFChars(stringObject, buf);
    return str;
}

void JUtil::checkExceptions()
{
    jthrowable exceptionObject = JUtil::jenv->ExceptionOccurred();
    if (exceptionObject)
    {
        DEBUGPRINTF("JObjectAccess: exception occurred:\n");
        JUtil::jenv->ExceptionDescribe();
        JUtil::jenv->ExceptionClear();

        jclass throwableClass = JUtil::jenv->GetObjectClass(exceptionObject);
        jmethodID method = JUtil::jenv->GetMethodID(throwableClass, "toString", "()Ljava/lang/String;");
        jstring msg = (jstring)JUtil::jenv->CallObjectMethod(exceptionObject, method);
        throw cRuntimeError(E_CUSTOM, fromJavaString(msg).c_str());
    }
}

jmethodID JUtil::findMethod(jclass clazz, const char *clazzName, const char *methodName, const char *methodSig)
{
    jmethodID ret = jenv->GetMethodID(clazz, methodName, methodSig);
    jenv->ExceptionClear();
    if (!ret)
        throw cRuntimeError("No `%s' %s method in Java class `%s'", methodName, methodSig, clazzName);
    return ret;
}

//---

using namespace JUtil;

JObjectAccess::JObjectAccess(jobject object)
{
    javaPeer = object;
    toStringMethod = 0;
}

void JObjectAccess::setObject(jobject object)
{
    javaPeer = object;
    toStringMethod = 0;
}

std::string JObjectAccess::toString() const
{
    if (!toStringMethod)
    {
        jclass clazz = jenv->GetObjectClass(javaPeer);
        toStringMethod = jenv->GetMethodID(clazz, "toString", "()Ljava/lang/String;");
        checkExceptions();
    }
    jstring stringObject = (jstring)jenv->CallObjectMethod(javaPeer, toStringMethod);
    checkExceptions();
    return fromJavaString(stringObject);
}


void JObjectAccess::getMethodOrField(const char *fieldName, const char *methodPrefix,
                                const char *methodsig, const char *fieldsig,
                                jmethodID& methodID, jfieldID& fieldID) const
{
    if (!fieldName || !fieldName[0] || strlen(fieldName)>80)
        throw cRuntimeError("field name empty or too long: `%s'", fieldName);
    char methodName[100];
    strcpy(methodName, methodPrefix);
    char *p = methodName + strlen(methodName);
    *p = toupper(fieldName[0]);
    strcpy(p+1, fieldName+1);

    jclass clazz = jenv->GetObjectClass(javaPeer);
    checkExceptions();
    fieldID = 0;
    methodID = jenv->GetMethodID(clazz, methodName, methodsig);
    if (methodID)
        return;
    jenv->ExceptionClear();
    fieldID = jenv->GetFieldID(clazz, fieldName, fieldsig);
    if (fieldID)
        return;
    jenv->ExceptionClear();
    throw cRuntimeError("Java object has neither method `%s' nor field `%s' with the given type",
              methodName, fieldName);
}

#define GETTER_SETTER(Type, jtype, CODE)  \
  jtype JObjectAccess::get##Type##JavaField(const char *fieldName) const \
  { \
      jmethodID methodID; jfieldID fieldID; \
      getMethodOrField(fieldName, "get", "()" CODE, CODE, methodID, fieldID); \
      return checkException(methodID ? jenv->Call##Type##Method(javaPeer, methodID) : jenv->Get##Type##Field(javaPeer, fieldID)); \
  } \
  void JObjectAccess::set##Type##JavaField(const char *fieldName, jtype value) \
  { \
      jmethodID methodID; jfieldID fieldID; \
      getMethodOrField(fieldName, "set", "(" CODE ")V", CODE, methodID, fieldID); \
      if (methodID) jenv->Call##Type##Method(javaPeer, methodID, value); else jenv->Set##Type##Field(javaPeer, fieldID, value); \
      checkExceptions(); \
  }

GETTER_SETTER(Boolean, jboolean, "Z")
GETTER_SETTER(Byte,    jbyte,    "B")
GETTER_SETTER(Char,    jchar,    "C")
GETTER_SETTER(Short,   jshort,   "S")
GETTER_SETTER(Int,     jint,     "I")
GETTER_SETTER(Long,    jlong,    "J")
GETTER_SETTER(Float,   jfloat,   "F")
GETTER_SETTER(Double,  jdouble,  "D")

#define JSTRING "Ljava/lang/String;"

std::string JObjectAccess::getStringJavaField(const char *fieldName) const
{
    jmethodID methodID; jfieldID fieldID;
    getMethodOrField(fieldName, "get", "()" JSTRING, JSTRING, methodID, fieldID);
    jstring str = (jstring) checkException(methodID ? jenv->CallObjectMethod(javaPeer, methodID) : jenv->GetObjectField(javaPeer, fieldID));
    return fromJavaString(str);
}

void JObjectAccess::setStringJavaField(const char *fieldName, const char *value)
{
    jmethodID methodID; jfieldID fieldID;
    getMethodOrField(fieldName, "set", "(" JSTRING ")V", JSTRING, methodID, fieldID);
    jstring str = jenv->NewStringUTF(value);
    if (methodID)
        jenv->CallObjectMethod(javaPeer, methodID, str);
    else
        jenv->SetObjectField(javaPeer, fieldID, str);
    checkExceptions();
}



