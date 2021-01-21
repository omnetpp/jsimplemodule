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

#include <omnetpp.h>

// swig cannot handle inner classes, so wrap the ones we need in global classes

class cModule_GateIterator
{
  private:
    cModule::GateIterator it;
  public:
    cModule_GateIterator(const cModule *m) : it(m) {}
    cGate *get() const {return it();}
    bool end() const {return it.end();}
    void next() {it++;}
    void advance(int k) {it+=k;}
};

class cModule_SubmoduleIterator
{
  private:
    cModule::SubmoduleIterator it;
  public:
    cModule_SubmoduleIterator(const cModule *m) : it(m) {}
    cModule *get() const {return it();}
    bool end() const {return it.end();}
    void next() {it++;}
};

class cModule_ChannelIterator
{
  private:
    cModule::ChannelIterator it;
  public:
    cModule_ChannelIterator(const cModule *m) : it(m) {}
    cChannel *get() const {return const_cast<cModule_ChannelIterator*>(this)->it();}
    bool end() const {return it.end();}
    void next() {it++;}
};



