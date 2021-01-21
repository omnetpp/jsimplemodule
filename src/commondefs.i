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

%{
//#include "bigdecimal.h"
//#include "jprogressmonitor.h"
%}

%exception {
    try {
        $action
    } catch (std::exception& e) {
        SWIG_JavaThrowException(jenv, SWIG_JavaRuntimeException, const_cast<char*>(e.what()));
        return $null;
    }
}

/*--------------------------------------------------------------------------
 * int32 <--> int mapping
 *--------------------------------------------------------------------------*/
%include "omnetpp/platdep/intlimits.h"

%typemap(jni)    int32_t "jint"
%typemap(jtype)  int32_t "int"
%typemap(jstype) int32_t "int"
%typemap(javain) int32_t "$javainput"
%typemap(javaout) int32_t {
    return $jnicall;
  }

/*--------------------------------------------------------------------------
 * int64 <--> long mapping
 *--------------------------------------------------------------------------*/
%typemap(jni)    int64_t "jlong"
%typemap(jtype)  int64_t "long"
%typemap(jstype) int64_t "long"
%typemap(javain) int64_t "$javainput"
%typemap(javaout) int64_t {
    return $jnicall;
  }

/*--------------------------------------------------------------------------
 * void* <--> long mapping
 *--------------------------------------------------------------------------*/
%typemap(jni)    void* "jlong"
%typemap(jtype)  void* "long"
%typemap(jstype) void* "long"
%typemap(javain) void* "$javainput"
%typemap(javaout) void* {
    return $jnicall;
  }


/*--------------------------------------------------------------------------
 * add utility methods to std::vector wrappers
 *--------------------------------------------------------------------------*/
namespace std {

%typemap(javacode) vector<int> %{
  public int[] toArray() {
    int[] a = new int[(int)size()];
    for (int i=0; i<a.length; i++)
       a[i] = get(i);
    return a;
  }
%}
%typemap(javacode) vector<string> %{
  public String[] toArray() {
    String[] a = new String[(int)size()];
    for (int i=0; i<a.length; i++)
       a[i] = get(i);
    return a;
  }
%}

}

/*--------------------------------------------------------------------------
 * IProgressMonitor
 *--------------------------------------------------------------------------*/
/*
%typemap(jni)    IProgressMonitor * "jobject"
%typemap(jtype)  IProgressMonitor * "org.eclipse.core.runtime.IProgressMonitor"
%typemap(jstype) IProgressMonitor * "org.eclipse.core.runtime.IProgressMonitor"
%typemap(javain) IProgressMonitor * "$javainput"
%typemap(in) IProgressMonitor * (JniProgressMonitor jProgressMonitor) {
   if ($input)
   {
      jProgressMonitor = JniProgressMonitor($input, jenv);
      $1 = &jProgressMonitor;
   }
   else
   {
      $1 = NULL;
   }
}
*/

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
