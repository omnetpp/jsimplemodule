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

#ifndef _JUTIL_H_
#define _JUTIL_H_

#include <jni.h>
#include <stdio.h>
#include <assert.h>
#include <omnetpp.h>

/**
 * Convenience methods for working with JNI.
 */
namespace JUtil
{
  extern JavaVM *vm;
  extern JNIEnv *jenv;

  void initJVM();
  std::string fromJavaString(jstring stringObject);
  jmethodID findMethod(jclass clazz, const char *clazzName, const char *methodName,
                       const char *methodSig);
  void checkExceptions();
  template<typename T> T checkException(T a)  {checkExceptions(); return a;}
};


/**
 * Makes it convenient to access members of a Java class from C++.
 */
class JObjectAccess
{
  protected:
    jobject javaPeer;
    mutable jmethodID toStringMethod;

  protected:
    void getMethodOrField(const char *fieldName, const char *methodPrefix,
                          const char *methodsig, const char *fieldsig,
                          jmethodID& methodID, jfieldID& fieldID) const;

  public:
    explicit JObjectAccess(jobject object=0);
    void setObject(jobject object);
    std::string toString() const;

    jboolean getBooleanJavaField(const char *fieldName) const;
    jbyte getByteJavaField(const char *fieldName) const;
    jchar getCharJavaField(const char *fieldName) const;
    jshort getShortJavaField(const char *fieldName) const;
    jint getIntJavaField(const char *fieldName) const;
    jlong getLongJavaField(const char *fieldName) const;
    jfloat getFloatJavaField(const char *fieldName) const;
    jdouble getDoubleJavaField(const char *fieldName) const;
    std::string getStringJavaField(const char *fieldName) const;

    void setBooleanJavaField(const char *fieldName, jboolean value);
    void setByteJavaField(const char *fieldName, jbyte value);
    void setCharJavaField(const char *fieldName, jchar value);
    void setShortJavaField(const char *fieldName, jshort value);
    void setIntJavaField(const char *fieldName, jint value);
    void setLongJavaField(const char *fieldName, jlong value);
    void setFloatJavaField(const char *fieldName, jfloat value);
    void setDoubleJavaField(const char *fieldName, jdouble value);
    void setStringJavaField(const char *fieldName, const char *value);
};

#endif


