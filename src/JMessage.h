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

#ifndef _JMESSAGE_H_
#define _JMESSAGE_H_

#include <jni.h>
#include <stdio.h>
#include <assert.h>
#include <omnetpp.h>
#include "JUtil.h"

namespace omnetpp {

/**
 * Implements a message class that can be extended in Java.
 *
 * Data in the Java object can be easily accessed from C++ too,
 * using the methods inherited from JObjectAccess: getIntJavaField(),
 * getLongJavaField(), getStringJavaField(), setIntJavaField(), etc.
 */
class JMessage : public cMessage, public JObjectAccess
{
  protected:
    jobject javaPeer;
    mutable jmethodID cloneMethod;

  public:
    explicit JMessage(const char *name, int kind, int dummy);
    JMessage(const JMessage& msg);
    virtual ~JMessage();

    virtual cMessage *dup() const  {return new JMessage(*this);}
    virtual std::string info() const;
    virtual std::string detailedInfo() const;
    JMessage& operator=(const JMessage& msg);

    void swigSetJavaPeer(jobject msgObject);
    jobject swigJavaPeer() {return javaPeer;}
    static jobject swigJavaPeerOf(cMessage *object);

    // Also note methods inherited from JObjectAccess: getIntJavaField(), etc.
};

}

#endif


