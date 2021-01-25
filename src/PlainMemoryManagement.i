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

//
// Simple memory management:
//    no object identity, no polymorphic return types, explicit deletion.
//
// swigCMemOwn got removed, Java proxy objects never delete anything in
// finalize(). All C++ objects have to be explicitly deallocated:
// msg.delete(), queue.delete().
//
// Object identity testing can be done via one.sameAs(other).
//
// Casts can be done with the cast() method: msg = cMessage.cast(obj).
//

%typemap(javabody) SWIGTYPE %{
  private long swigCPtr;

  protected $javaclassname(long cPtr, boolean dummy) {
    swigCPtr = cPtr;
  }

  public static long getCPtr($javaclassname obj) {
    return obj==null ? 0 : obj.swigCPtr;
  }

  public long getBaseCPtr() {
    return swigCPtr;
  }

  public boolean sameAs($javaclassname obj) {
    return getBaseCPtr() == obj.getBaseCPtr();
  }

  public boolean equals(Object obj) {
    return (obj instanceof $javaclassname) && sameAs(($javaclassname)obj);
  }

  @Override
  public int hashCode() {
    return (int)swigCPtr;
  }

  protected void setCPtr(long cPtr) {
    swigCPtr = cPtr;
  }
%}

%typemap(javabody_derived) SWIGTYPE %{
  private long swigCPtr;

  protected $javaclassname(long cPtr, boolean dummy) {
    super(SimkernelJNI.$javaclassname_SWIGUpcast(cPtr), false);
    swigCPtr = cPtr;
  }

  public static long getCPtr($javaclassname obj) {
    return obj==null ? 0 : obj.swigCPtr;
  }

  protected void setCPtr(long cPtr) {
    swigCPtr = cPtr;
    super.setCPtr(cPtr==0 ? 0 : SimkernelJNI.$javaclassname_SWIGUpcast(cPtr));
  }
%}

%typemap(javaconstruct) SWIGTYPE {
    this($imcall, false);
  }

%typemap(javafinalize) SWIGTYPE %{
%}

%typemap(javadestruct, methodname="delete", methodmodifiers="public") SWIGTYPE {
    if (swigCPtr != 0) {
      if (true)
         $jnicall;
      setCPtr(0);
    }
  }

%typemap(javadestruct_derived, methodname="delete", methodmodifiers="public") SWIGTYPE {
    if (swigCPtr != 0) {
      if (true)
         $jnicall;
      setCPtr(0);
    }
  }

// The following BASECLASS(), DERIVEDCLASS() macros are applied in Simkernel.i:
%define BASECLASS(CLASS)
%ignore CLASS::CLASS(const CLASS&);
%ignore CLASS::operator=(const CLASS&);
%enddef

%define DERIVEDCLASS(CLASS,BASECLASS)
%ignore CLASS::CLASS(const CLASS&);
%ignore CLASS::operator=(const CLASS&);
%extend CLASS {
  static CLASS *cast(BASECLASS *obj) {return dynamic_cast<CLASS *>(obj);}
}
%enddef


