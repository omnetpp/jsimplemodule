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

// modified version of nativelibs/common.i

%exception {
    try {
        $action
    } catch (std::exception& e) {
        SWIG_JavaThrowException(jenv, SWIG_JavaRuntimeException, const_cast<char*>(e.what()));
        return $null;
    }
}

/*--------------------------------------------------------------------------
 * integer mappings
 *--------------------------------------------------------------------------*/
%include "omnetpp/platdep/intlimits.h"

%define INT_TYPEMAP(intNN_t, javatype, jnitype)
  %typemap(jni)     intNN_t "jnitype"
  %typemap(jtype)   intNN_t "javatype"
  %typemap(jstype)  intNN_t "javatype"
  %typemap(javain)  intNN_t "$javainput"
  %typemap(javaout) intNN_t { return $jnicall; }
  %typemap(in)      intNN_t { $1 = (intNN_t)$input; } // note: cast is only needed for the "void *" case
  %typemap(out)     intNN_t { $result = (jnitype)$1; } // ditto
%enddef

// note: some of these don't seem to take effect
INT_TYPEMAP(int8_t, byte, jbyte)
INT_TYPEMAP(uint8_t, byte, jbyte) // caveat: becomes signed
INT_TYPEMAP(int16_t, short, jshort)
INT_TYPEMAP(uint16_t, char, jchar) // Java char is unsigned 16-bit
INT_TYPEMAP(int32_t, int, jint)
INT_TYPEMAP(uint32_t, int, jint)  // caveat: becomes signed
INT_TYPEMAP(int64_t, long, jlong)
INT_TYPEMAP(uint64_t, long, jlong) // caveat: becomes signed

INT_TYPEMAP(void*, long, jlong) // caveat: DRAGONS!!! (also: this rule can be removed for OMNeT++6)

/*
 * Macro to add equals() and hashCode() to generated Java classes
 */
%define ADD_CPTR_EQUALS_AND_HASHCODE(CLASS)
%typemap(javacode) CLASS %{
  public boolean equals(Object obj) {
    if (this == obj)
      return true;
    if (obj == null || this.getClass() != obj.getClass())
      return false;
    return getCPtr(this) == getCPtr((CLASS)obj);
  }

  public int hashCode() {
    return (int)getCPtr(this);
  }
%}
%enddef
