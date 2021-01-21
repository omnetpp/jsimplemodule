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

#ifndef _JAVASIMPLEMODULE_H_
#define _JAVASIMPLEMODULE_H_

#include <jni.h>
#include <stdio.h>
#include <assert.h>
#include <omnetpp.h>
#include "JUtil.h"

namespace omnetpp {

/**
 * Implements a Java-based simple module. It instantiates the Java class
 * based on the module's fully qualified name, and delegates handleMessage()
 * and other methods to it.
 *
 * From JObjectAccess it inherits methods that facilitate accessing data
 * members of the Java class, should it become necessary: getIntJavaField(),
 * getLongJavaField(), getStringJavaField(), setIntJavaField(), etc.
 */
class JSimpleModule : public cSimpleModule, public JObjectAccess
{
  protected:
    jobject javaPeer;
    jmethodID numInitStagesMethod;
    jmethodID initializeStageMethod;
    jmethodID doHandleMessageMethod;
    jmethodID finishMethod;
    cMessage *msgToBeHandled;

  protected:
    void createJavaModuleObject();

  public:
    JSimpleModule();
    virtual ~JSimpleModule();
    cMessage *retrieveMsgToBeHandled() {return msgToBeHandled;}  // helper for Java

    jobject swigJavaPeer() {
         if (javaPeer==0) createJavaModuleObject();
         return javaPeer;
    }
    static jobject swigJavaPeerOf(cModule *object);

  protected:
    virtual int numInitStages() const;
    virtual void initialize(int stage);
    virtual void handleMessage(cMessage *msg);
    virtual void finish();
};

}

#endif


