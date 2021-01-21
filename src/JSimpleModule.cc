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

#include <assert.h>
#include <string.h>
#include <algorithm>
#include "JSimpleModule.h"
#include "JUtil.h"

using namespace omnetpp;
using namespace JUtil;  // for jenv, checkExceptions(), findMethod(), etc


//#define DEBUGPRINTF(...) printf(__VA_ARGS__)
#define DEBUGPRINTF(...) ((void)0)

Define_Module(JSimpleModule);


JSimpleModule::JSimpleModule()
{
    // Note: we cannot call createJavaModuleObject() here, because the module
    // type object (cModuleType) is not yet set on the module
    javaPeer = 0;
}

JSimpleModule::~JSimpleModule()
{
    if (javaPeer && finishMethod)
        jenv->DeleteGlobalRef(javaPeer);
}

int JSimpleModule::numInitStages() const
{
    if (javaPeer==0)
        const_cast<JSimpleModule *>(this)->createJavaModuleObject();

    int n = jenv->CallIntMethod(javaPeer, numInitStagesMethod);
    checkExceptions();
    return n;
}

void JSimpleModule::initialize(int stage)
{
    if (javaPeer==0)
        createJavaModuleObject();
    DEBUGPRINTF("Invoking initialize(%d) on new instance...\n", stage);
    jenv->CallVoidMethod(javaPeer, initializeStageMethod, stage);
    checkExceptions();
}

void JSimpleModule::createJavaModuleObject()
{
    // create VM if needed
    if (!jenv)
         initJVM();

    // find class and method IDs (note: initialize() and finish() are optional)
    std::string className = getNedTypeName();
    replace(className.begin(), className.end(), '.', '/');
    const char *clazzName = className.c_str();
    DEBUGPRINTF("Finding class %s...\n", clazzName);
    jclass clazz = jenv->FindClass(clazzName);
    checkExceptions();

    DEBUGPRINTF("Finding initialize()/handleMessage()/finish() methods for class %s...\n", clazzName);
    numInitStagesMethod = findMethod(clazz, clazzName, "numInitStages", "()I");
    initializeStageMethod = findMethod(clazz, clazzName, "initialize", "(I)V");
    doHandleMessageMethod = findMethod(clazz, clazzName, "doHandleMessage", "()V");
    finishMethod = findMethod(clazz, clazzName, "finish", "()V");

    // create Java module object
    DEBUGPRINTF("Instantiating class %s...\n", clazzName);

    jmethodID setCPtrMethod = jenv->GetMethodID(clazz, "setCPtr", "(J)V");
    jenv->ExceptionClear();
    if (setCPtrMethod)
    {
        jmethodID ctor = findMethod(clazz, clazzName, "<init>", "()V");
        javaPeer = jenv->NewObject(clazz, ctor);
        checkExceptions();
        jenv->CallVoidMethod(javaPeer, setCPtrMethod, (jlong)this);
    }
    else
    {
        jmethodID ctor = findMethod(clazz, clazzName, "<init>", "(J)V");
        javaPeer = jenv->NewObject(clazz, ctor, (jlong)this);
        checkExceptions();
    }
    javaPeer = jenv->NewGlobalRef(javaPeer);
    checkExceptions();
    JObjectAccess::setObject(javaPeer);
}

void JSimpleModule::handleMessage(cMessage *msg)
{
    msgToBeHandled = msg;
    jenv->CallVoidMethod(javaPeer, doHandleMessageMethod);
    checkExceptions();
}

void JSimpleModule::finish()
{
    jenv->CallVoidMethod(javaPeer, finishMethod);
    checkExceptions();
}

jobject JSimpleModule::swigJavaPeerOf(cModule *object)
{
    JSimpleModule *mod = dynamic_cast<JSimpleModule *>(object);
    return mod ? mod->swigJavaPeer() : 0;
}

