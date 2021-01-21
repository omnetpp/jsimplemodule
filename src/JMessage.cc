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

#include "JMessage.h"
#include "JUtil.h"

using namespace omnetpp;
using namespace JUtil;  // for jenv, checkExceptions(), findMethod(), etc


//#define DEBUGPRINTF printf
#define DEBUGPRINTF (void)


JMessage::JMessage(const char *name, int kind, int) : cMessage(name, kind)
{
    javaPeer = 0;
    cloneMethod = 0;
}

JMessage::JMessage(const JMessage& msg)
{
    javaPeer = 0;
    cloneMethod = 0;
    operator=(msg);
}

JMessage::~JMessage()
{
    if (jenv && javaPeer)
        jenv->DeleteGlobalRef(javaPeer);
}

std::string JMessage::info() const
{
    // return the first line of toString()
    std::string str = toString();
    const char *s = str.c_str();
    const char *p = strchr(s, '\n');
    if (p)
        str.erase(str.begin()+(p-s), str.end());
    return str;
}

std::string JMessage::detailedInfo() const
{
    return toString();
}

JMessage& JMessage::operator=(const JMessage& msg)
{
    cMessage::operator=(msg);
    if (!jenv)
        return *this;

    if (javaPeer)
        jenv->DeleteGlobalRef(javaPeer);
    javaPeer = 0;
    cloneMethod = 0;
    if (msg.javaPeer)
    {
        // must clone() the other Java object
        javaPeer = msg.javaPeer;  // then we'll clone it
        cloneMethod = msg.cloneMethod;
        if (!cloneMethod)
        {
            jclass clazz = jenv->GetObjectClass(javaPeer);
            cloneMethod = jenv->GetMethodID(clazz, "clone", "()Ljava/lang/Object;");
            const_cast<JMessage&>(msg).cloneMethod = cloneMethod;
            checkExceptions();
        }
        javaPeer = jenv->CallObjectMethod(javaPeer, cloneMethod);
        checkExceptions();
        javaPeer = jenv->NewGlobalRef(javaPeer);
        checkExceptions();
    }
    JObjectAccess::setObject(javaPeer);
    return *this;
}

void JMessage::swigSetJavaPeer(jobject msgObject)
{
    ASSERT(javaPeer==0);
    javaPeer = jenv->NewGlobalRef(msgObject);
    JObjectAccess::setObject(javaPeer);
}

jobject JMessage::swigJavaPeerOf(cMessage *object)
{
    JMessage *msg = dynamic_cast<JMessage *>(object);
    return msg ? msg->swigJavaPeer() : 0;
}



