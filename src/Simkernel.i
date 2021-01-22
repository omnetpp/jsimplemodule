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

%module Simkernel

%{
#include <omnetpp.h>
#include "JSimpleModule.h"
#include "JMessage.h"

// for debugging:
#include <stdio.h>
#define LOG_JNI_CALL() (void)0
//#define LOG_JNI_CALL() {printf("DEBUG: entered JNI method %s, jarg1=%lx\n", __FUNCTION__, (long)jarg1);fflush(stdout);}
//jlong jarg1 = -1; // fallback for LOG_JNI_CALL() in JNI functions with no jarg1 arg
%}

%pragma(java) jniclasscode=%{
  static {
    // get classes for System.out.println() loaded now (needed if we want to log in startup code)
    System.out.println("Simkernel.jar loaded.");
  }
%}

%exception {
    try {
        $action
    } catch (std::exception& e) {
        SWIG_JavaThrowException(jenv, SWIG_JavaRuntimeException, const_cast<char*>(e.what()));
        return $null;
    }
}

%include "std_common.i"
%include "std_string.i"
%include "std_map.i"    // cXMLElement
%include "std_vector.i" // cXMLElement

%include commondefs.i
%include "PlainMemoryManagement.i"

%include "Reflection.i"

// hide some macros from swig (copied from nativelibs/common.i)
#define COMMON_API
#define ENVIR_API
#define OPP_DLLEXPORT
#define OPP_DLLIMPORT

#define NAMESPACE_BEGIN
#define NAMESPACE_END
#define USING_NAMESPACE
#define OPP

#define _OPPDEPRECATED

#pragma SWIG nowarn=516;  // "Overloaded method x ignored. Method y used."

// ignore/rename some operators (some have method equivalents)
%rename(set) operator=;
%rename(incr) operator++;
%ignore operator +=;
%ignore operator [];
%ignore operator <<;
%ignore operator ();

// ignore conversion operators (they all have method equivalents)
%ignore operator bool;
%ignore operator const char *;
%ignore operator char;
%ignore operator unsigned char;
%ignore operator short;
%ignore operator unsigned short;
%ignore operator int;
%ignore operator unsigned int;
%ignore operator long;
%ignore operator unsigned long;
%ignore operator double;
%ignore operator long double;
%ignore operator void *;
%ignore operator omnetpp::cOwnedObject *;
%ignore operator omnetpp::cXMLElement *;
%ignore omnetpp::cSimulation::operator=;
%ignore omnetpp::cEnvir::printf;

// ignore methods that are useless from Java
%ignore omnetpp::processMessage;  //cChannel
%ignore omnetpp::cChannel::processMessage;  //cChannel
%ignore omnetpp::netPack;
%ignore omnetpp::netUnpack;
%ignore omnetpp::doPacking;
%ignore omnetpp::doUnpacking;
%ignore omnetpp::saveToFile;
%ignore omnetpp::loadFromFile;
%ignore omnetpp::createWatch;
%ignore omnetpp::opp_typename;

// ignore non-inspectable classes and those that cause problems
%ignore eMessageKind;
%ignore cLinkedList;
%ignore cCommBuffer;
%ignore cContextSwitcher;
%ignore cContextTypeSwitcher;
%ignore cOutputVectorManager;
%ignore cOutputScalarManager;
%ignore cSnapshotManager;
%ignore cScheduler;
%ignore cRealTimeScheduler;
%ignore cParsimCommunications;
%ignore ModNameParamResolver;
%ignore StringMapParamResolver;
%ignore cStackCleanupException;
%ignore cTerminationException;
%ignore cEndModuleException;
%ignore cStaticFlag;
%ignore ExecuteOnStartup;

%typemap(javacode) omnetpp::cModule %{
  public static cEnvir ev = Simkernel.getEv();
%};

%typemap(javacode) omnetpp::Simkernel %{
  public static cEnvir ev = getEv();
%};

%ignore omnetpp::cObject::getDescriptor;
%ignore omnetpp::cObject::createDescriptor;
%ignore omnetpp::cObject::info(char *buf);

%ignore omnetpp::cOwnedObject::cmpbyname;
%ignore omnetpp::cOwnedObject::removeFromOwnershipTree;
%ignore omnetpp::cOwnedObject::setDefaultOwner;

%ignore omnetpp::cMsgPar::setDoubleValue(ExprElem *, int);
%ignore omnetpp::cMsgPar::setDoubleValue(cStatistic *);
%ignore omnetpp::cMsgPar::setDoubleValue(MathFuncNoArg);
%ignore omnetpp::cMsgPar::setDoubleValue(MathFunc1Arg, double);
%ignore omnetpp::cMsgPar::setDoubleValue(MathFunc2Args, double, double);
%ignore omnetpp::cMsgPar::setDoubleValue(MathFunc3Args, double, double, double);
%ignore omnetpp::cMsgPar::setDoubleValue(MathFunc4Args, double, double, double, double);
%ignore omnetpp::cMsgPar::setPointerValue;
%ignore omnetpp::cMsgPar::getPointerValue;
%ignore omnetpp::cMsgPar::configPointer;
%ignore omnetpp::cMsgPar::operator=(void *);
%ignore omnetpp::cMsgPar::operator=(long double);
%ignore omnetpp::cMsgPar::cmpbyvalue;

%ignore omnetpp::cDefaultList::doGC;

%ignore omnetpp::cComponent::setRNGMap;
%ignore omnetpp::cComponent::addPar;
%ignore omnetpp::cComponent::getSignalMask;

%ignore omnetpp::cModule::pause_in_sendmsg;
%ignore omnetpp::cModule::lastmodulefullpath;
%ignore omnetpp::cModule::lastmodulefullpathmod;
%ignore omnetpp::cModule::gatev;
%ignore omnetpp::cModule::paramv;
%ignore omnetpp::cModule::setRNGMap;
%ignore omnetpp::cModule::rng;
%ignore omnetpp::cModule::getParentModule;

%ignore omnetpp::cSimpleModule::pause;
%ignore omnetpp::cSimpleModule::receive;
%ignore omnetpp::cSimpleModule::hasStackOverflow;
%ignore omnetpp::cSimpleModule::getStackSize;
%ignore omnetpp::cSimpleModule::getStackUsage;

%ignore omnetpp::cMessage::setContextPointer;
%ignore omnetpp::cMessage::getContextPointer;
%ignore omnetpp::cMessage::getInsertOrder;

%ignore omnetpp::cChannel::cChannel(const char *, cChannelType *);
%ignore omnetpp::cChannel::channelType;

%ignore omnetpp::cQueue::setup;
%ignore omnetpp::cQueue::cQueue(const char *, CompareFunc);
%ignore omnetpp::cQueue::cQueue(const char *, CompareFunc, bool);

%ignore omnetpp::cOutVector::setCallback;

%ignore omnetpp::cSimulation::msgQueue;
%ignore omnetpp::cSimulation::getMessageQueue;
%ignore omnetpp::cSimulation::setScheduler;
%ignore omnetpp::cSimulation::getScheduler;
%ignore omnetpp::cSimulation::getHasher;
%ignore omnetpp::cSimulation::setHasher;
%ignore omnetpp::cSimulation::setupNetwork;
%ignore omnetpp::cSimulation::startRun;
%ignore omnetpp::cSimulation::callFinish;
%ignore omnetpp::cSimulation::endRun;
%ignore omnetpp::cSimulation::deleteNetwork;
%ignore omnetpp::cSimulation::transferTo;
%ignore omnetpp::cSimulation::transferToMain;
%ignore omnetpp::cSimulation::setGlobalContext;
%ignore omnetpp::cSimulation::setContext;
%ignore omnetpp::cSimulation::getNetworkType;
%ignore omnetpp::cSimulation::registerModule;
%ignore omnetpp::cSimulation::deregisterModule;
%ignore omnetpp::cSimulation::setSystemModule;
%ignore omnetpp::cSimulation::loadNedFile;
%ignore omnetpp::cSimulation::setSimTime;
%ignore omnetpp::cSimulation::selectNextModule;
%ignore omnetpp::cSimulation::guessNextEvent;
%ignore omnetpp::cSimulation::guessNextModule;
%ignore omnetpp::cSimulation::guessNextSimtime;
%ignore omnetpp::cSimulation::doOneEvent;
%ignore omnetpp::cSimulation::setContextModule;
%ignore omnetpp::cSimulation::setContextType;

%ignore omnetpp::cStatistic::td;
%ignore omnetpp::cStatistic::ra;
%ignore omnetpp::cStatistic::addTransientDetection;
%ignore omnetpp::cStatistic::addAccuracyDetection;
%ignore omnetpp::cStatistic::getTransientDetectionObject;
%ignore omnetpp::cStatistic::getAccuracyDetectionObject;
%ignore omnetpp::cStatistic::getWeights; //ignore as this throws an error

%ignore omnetpp::cDisplayString::setRoleToConnection;
%ignore omnetpp::cDisplayString::setRoleToModule;
%ignore omnetpp::cDisplayString::setRoleToModuleBackground;

%ignore omnetpp::cXMLElement::getDocumentElementByPath;
%ignore omnetpp::cXMLElement::getElementByPath;

%ignore omnetpp::cObjectFactory::cObjectFactory;


// ignore deprecated methods
%ignore omnetpp::cChannelType::createIdealChannel;
%ignore omnetpp::cChannelType::createDelayChannel;
%ignore omnetpp::cChannelType::createDatarateChannel;
%ignore omnetpp::cMsgPar::getAsText;
%ignore omnetpp::cMsgPar::setFromText;
%ignore omnetpp::cMsgPar::setFromText;

// ignore cEnvir methods that are not for model code
%ignore omnetpp::cEnvir::disable_tracing;
%ignore omnetpp::cEnvir::suppress_notifications;
%ignore omnetpp::cEnvir::debug_on_errors;
%ignore omnetpp::cEnvir::objectDeleted;
%ignore omnetpp::cEnvir::simulationEvent;
%ignore omnetpp::cEnvir::messageSent_OBSOLETE;
%ignore omnetpp::cEnvir::messageScheduled;
%ignore omnetpp::cEnvir::messageCancelled;
%ignore omnetpp::cEnvir::beginSend;
%ignore omnetpp::cEnvir::messageSendDirect;
%ignore omnetpp::cEnvir::messageSendHop;
%ignore omnetpp::cEnvir::endSend;
%ignore omnetpp::cEnvir::messageDeleted;
%ignore omnetpp::cEnvir::moduleReparented;
%ignore omnetpp::cEnvir::componentMethodBegin;
%ignore omnetpp::cEnvir::componentMethodEnd;
%ignore omnetpp::cEnvir::moduleCreated;
%ignore omnetpp::cEnvir::moduleDeleted;
%ignore omnetpp::cEnvir::gateCreated;
%ignore omnetpp::cEnvir::gateDeleted;
%ignore omnetpp::cEnvir::connectionCreated;
%ignore omnetpp::cEnvir::connectionDeleted;
%ignore omnetpp::cEnvir::displayStringChanged;
%ignore omnetpp::cEnvir::undisposedObject;
%ignore omnetpp::cEnvir::bubble;
%ignore omnetpp::cEnvir::readParameter;
%ignore omnetpp::cEnvir::isModuleLocal;
%ignore omnetpp::cEnvir::getRNGMappingFor;
%ignore omnetpp::cEnvir::registerOutputVector;
%ignore omnetpp::cEnvir::deregisterOutputVector;
%ignore omnetpp::cEnvir::setVectorAttribute;
%ignore omnetpp::cEnvir::recordInOutputVector;
%ignore omnetpp::cEnvir::recordScalar;
%ignore omnetpp::cEnvir::recordStatistic;
%ignore omnetpp::cEnvir::getStreamForSnapshot;
%ignore omnetpp::cEnvir::releaseStreamForSnapshot;
%ignore omnetpp::cEnvir::getArgCount;
%ignore omnetpp::cEnvir::getArgVector;
%ignore omnetpp::cEnvir::idle;
%ignore omnetpp::cEnvir::getOStream;
%ignore omnetpp::cEnvir::getConfig;
%ignore omnetpp::cEnvir::getConfigEx;

%ignore omnetpp::cCoroutine;
%ignore omnetpp::cRunnableEnvir;
%ignore omnetpp::cConfiguration;
%ignore omnetpp::cConfigurationEx;

%ignore omnetpp::cPar::setImpl;
%ignore omnetpp::cPar::impl;
%ignore omnetpp::cPar::copyIfShared;

%ignore omnetpp::cRNG::initialize;
%ignore omnetpp::cLCG32;
%ignore omnetpp::cMersenneTwister;


namespace std {
   specialize_std_map_on_both(std::string,,,,std::string,,,);
   //specialize_std_vector(omnetpp::cXMLElement*);

   %template(StringMap) map<string,string>;

   %ignore vector<omnetpp::cXMLElement*>::vector;
   %ignore vector<omnetpp::cXMLElement*>::resize;
   %ignore vector<omnetpp::cXMLElement*>::reserve;
   %ignore vector<omnetpp::cXMLElement*>::capacity;
   %ignore vector<omnetpp::cXMLElement*>::clear;
   %ignore vector<omnetpp::cXMLElement*>::add;  //XXX this one doesn't work (because it was added later in Java)
   %ignore vector<omnetpp::cXMLElement*>::set;
   %template(cXMLElementVector) vector<omnetpp::cXMLElement*>;

   // std::vector<const char*> is only used as return value --> ignore setters
   %extend vector<const char *> {
       const char *get(int i) {return self->at(i);}
   }
   %ignore vector<const char *>::vector;
   %ignore vector<const char *>::resize;
   %ignore vector<const char *>::reserve;
   %ignore vector<const char *>::capacity;
   %ignore vector<const char *>::clear;
   %ignore vector<const char *>::add;  //XXX this one doesn't work (because it was added later in Java)
   %ignore vector<const char *>::set;
   %ignore vector<const char *>::get;
   %template(StringVector) vector<const char *>;
};

%extend omnetpp::SimTime {
   const SimTime add(const SimTime& x) {return *self + x;}
   const SimTime substract(const SimTime& x) {return *self - x;}
   const SimTime add(double x) {return *self + x;}
   const SimTime substract(double x) {return *self - x;}
}

%typemap(javacode) omnetpp::cEnvir %{
  public void print(String s) {
    puts(s);
  }

  public void println(String s) {
    puts(s+"\n");
  }
%}

%extend omnetpp::cEnvir
{
    void puts(const char *s) {printf("%s", s);}
};

omnetpp::cEnvir *getEv();
%{ inline omnetpp::cEnvir *getEv() {return omnetpp::cSimulation::getActiveEnvir();} %}

// ignore/rename some operators (some have method equivalents)
%ignore cPar::operator=;
%rename(assign) operator=;
%rename(plusPlus) operator++;
%ignore operator +=;
%ignore operator [];
%ignore operator <<;
%ignore operator ();

// ignore conversion operators (they all have method equivalents)
%ignore operator bool;
%ignore operator const char *;
%ignore operator char;
%ignore operator unsigned char;
%ignore operator int;
%ignore operator unsigned int;
%ignore operator long;
%ignore operator unsigned long;
%ignore operator double;
%ignore operator long double;
%ignore operator void *;
%ignore operator cObject *;
%ignore operator cXMLElement *;
%ignore cSimulation::operator=;

%ignore cEnvir::printf;
%ignore cGate::setChannel;

// ignore methods that are useless from Java
%ignore parsimPack;
%ignore parsimUnpack;

// ignore non-inspectable and deprecated classes
%ignore cCommBuffer;
%ignore cContextSwitcher;
%ignore cContextTypeSwitcher;
%ignore cOutputVectorManager;
%ignore cOutputScalarManager;
%ignore cOutputSnapshotManager;
%ignore cScheduler;
%ignore cRealTimeScheduler;
%ignore cParsimCommunications;
%ignore ModNameParamResolver;
%ignore StringMapParamResolver;
%ignore cSubModIterator;
%ignore cLinkedList;

// ignore global variables but add accessors for them
%ignore defaultList;
%ignore componentTypes;
%ignore nedFunctions;
%ignore classes;
%ignore enums;
%ignore classDescriptors;
%ignore configOptions;

%{
omnetpp::cDefaultList& getDefaultList() {return omnetpp::defaultList;}
omnetpp::cRegistrationList *getRegisteredComponentTypes() {return omnetpp::componentTypes.getInstance();}
omnetpp::cRegistrationList *getRegisteredNedFunctions() {return omnetpp::nedFunctions.getInstance();}
omnetpp::cRegistrationList *getRegisteredClasses() {return omnetpp::classes.getInstance();}
omnetpp::cRegistrationList *getRegisteredEnums() {return omnetpp::enums.getInstance();}
omnetpp::cRegistrationList *getRegisteredClassDescriptors() {return omnetpp::classDescriptors.getInstance();}
omnetpp::cRegistrationList *getRegisteredConfigOptions() {return omnetpp::configOptions.getInstance();}
%}
omnetpp::cDefaultList& getDefaultList();
omnetpp::cRegistrationList *getRegisteredComponentTypes();
omnetpp::cRegistrationList *getRegisteredNedFunctions();
omnetpp::cRegistrationList *getRegisteredClasses();
omnetpp::cRegistrationList *getRegisteredEnums();
omnetpp::cRegistrationList *getRegisteredClassDescriptors();
omnetpp::cRegistrationList *getRegisteredConfigOptions();

// ignore macros that confuse swig
/*
#define GATEID_LBITS  20
#define GATEID_HBITS  (8*sizeof(int)-GATEID_LBITS)   // usually 12
#define GATEID_HMASK  ((~0)<<GATEID_LBITS)           // usually 0xFFF00000
#define GATEID_LMASK  (~GATEID_HMASK)                // usually 0x000FFFFF
*/
%ignore MAX_VECTORGATES;
%ignore MAX_SCALARGATES;
%ignore MAX_VECTORGATESIZE;


// ignore problematic methods/class
%ignore omnetpp::cDynamicExpression::evaluate; // returns inner type (swig is not prepared to handle them)
%ignore omnetpp::cDensityEstBase::getCellInfo; // returns inner type (swig is not prepared to handle them)
%ignore omnetpp::cKSplit;  // several methods are problematic
%ignore omnetpp::cPacketQueue;  // Java compile problems (cMessage/cPacket conversion)
%ignore omnetpp::cTopology; // would need to wrap its inner classes too
%ignore omnetpp::cDynamicExpression;
%ignore omnetpp::cAccuracyDetection;
%ignore omnetpp::cADByStddev;
%ignore omnetpp::cTransientDetection;
%ignore omnetpp::cTDExpandingWindows;

%ignore omnetpp::critfunc_const;
%ignore omnetpp::critfunc_depth;
%ignore omnetpp::divfunc_const;
%ignore omnetpp::divfunc_babak;

%ignore omnetpp::SimTime::ttoa;
%ignore omnetpp::SimTime::str(char *buf);
%ignore omnetpp::SimTime::parse(const char *, const char *&);

%ignore omnetpp::cMsgPar::operator=(void*);

%typemap(javacode) omnetpp::cClassDescriptor %{
  public static long getCPtr(cObject obj) { // make method public
    return cObject.getCPtr(obj);
  }
%}

%extend omnetpp::cClassDescriptor {
   cObject *getFieldAsCObject(void *object, int field, int index) {
       return self->getFieldIsCObject(field) ? (omnetpp::cObject *)self->getFieldStructValuePointer(object,field,index) : NULL;
   }
}

// prevent generating setSimulation() method
%ignore ::simulation;
// getSimulation is natively defined in Omnet 5.0
//omnetpp::cSimulation *omnetpp::getSimulation();
//%{ inline omnetpp::cSimulation *omnetpp::getSimulation() {return &(omnetpp::simulation);} %}


// JSimpleModule
%newobject omnetpp::JSimpleModule::retrieveMsgToBeHandled;
%ignore omnetpp::JSimpleModule::JSimpleModule;
%ignore omnetpp::JSimpleModule::vm;
%ignore omnetpp::JSimpleModule::jenv;

%javamethodmodifiers omnetpp::JSimpleModule::swigSetJavaPeer "private";
%javamethodmodifiers omnetpp::JSimpleModule::swigJavaPeerOf "protected";

%typemap(javacode) omnetpp::JSimpleModule %{

  public JSimpleModule() {
    this(0, false);  // and C++ code will call setCPtr() later
  }

  protected int numInitStages() {
    return 1;
  }

  protected void initialize(int stage) {
    if (stage==0)
      initialize();
  }

  protected void initialize() {
    // can be overridden by the user
  }

  private void doHandleMessage() {
    cMessage msg = retrieveMsgToBeHandled();
    handleMessage(msg);
  }

  protected void handleMessage(cMessage msg) {
    error("handleMessage() should be overridden in module classes");
  }

  protected void finish() {
    // can be overridden by the user
  }

  protected SimTime simTime() {
    return Simkernel.simTime();
  }

  public static JSimpleModule cast(cModule object) {
    return (JSimpleModule) JSimpleModule.swigJavaPeerOf(object);
  }
%}

%ignore JSimpleModule::swigJavaPeer;


// JMessage
%javamethodmodifiers JMessage::JMessage "private";
%javamethodmodifiers JMessage::swigSetJavaPeer "private";
%javamethodmodifiers JMessage::swigJavaPeerOf "protected";

%typemap(javacode) omnetpp::JMessage %{
  public JMessage() {this(null, 0, 99); swigSetJavaPeer(this); }
  public JMessage(String name) {this(name, 0, 99); swigSetJavaPeer(this); }
  public JMessage(String name, int kind) {this(name, kind, 99); swigSetJavaPeer(this); }

  public static JMessage cast(cMessage object) {
    return (JMessage) JMessage.swigJavaPeerOf(object);
  }
%}

%ignore JMessage::swigJavaPeer;

// hide toString() C++ methods which call back into Java: we don't want to
// create infinite mutual recursion between them
%ignore JMessage::toString;
%ignore JSimpleModule::toString;

// hide the following JObjectAccess methods (from JMessage and JSimpleModule too)
%ignore getBooleanJavaField;
%ignore getByteJavaField;
%ignore getCharJavaField;
%ignore getShortJavaField;
%ignore getIntJavaField;
%ignore getLongJavaField;
%ignore getFloatJavaField;
%ignore getDoubleJavaField;
%ignore getStringJavaField;
%ignore setBooleanJavaField;
%ignore setByteJavaField;
%ignore setCharJavaField;
%ignore setShortJavaField;
%ignore setIntJavaField;
%ignore setLongJavaField;
%ignore setFloatJavaField;
%ignore setDoubleJavaField;
%ignore setStringJavaField;


// Note: we MUST NOT rename dup() to clone(), because then JMessage's dup()
// would go into infinite mutual recursion between Java clone() and C++ dup()!
//%rename dup clone;


// The BASECLASS(), DERIVEDCLASS() macros should come from the memorymgmt_xxx.i file
BASECLASS(omnetpp::SimTime);
BASECLASS(omnetpp::cObject);
BASECLASS(omnetpp::cDisplayString);
BASECLASS(omnetpp::cEnvir);
BASECLASS(omnetpp::cException);
BASECLASS(omnetpp::cExpression);
BASECLASS(omnetpp::cSubModIterator);
BASECLASS(omnetpp::cVisitor);
BASECLASS(omnetpp::cXMLElement);
BASECLASS(std::vector<omnetpp::cXMLElement*>);
BASECLASS(omnetpp::cObjectFactory);
BASECLASS(omnetpp::cEvent)
//BASECLASS(std::map<std::string,std::string>);
DERIVEDCLASS(omnetpp::cArray, omnetpp::cObject);
DERIVEDCLASS(omnetpp::cComponentType, omnetpp::cObject);
DERIVEDCLASS(omnetpp::cChannelType, omnetpp::cObject);
DERIVEDCLASS(omnetpp::cModuleType, omnetpp::cObject);
DERIVEDCLASS(omnetpp::cComponent, omnetpp::cObject);
DERIVEDCLASS(omnetpp::cChannel, omnetpp::cObject);
DERIVEDCLASS(omnetpp::cIdealChannel, omnetpp::cObject);
DERIVEDCLASS(omnetpp::cDelayChannel, omnetpp::cObject);
DERIVEDCLASS(omnetpp::cDatarateChannel, omnetpp::cObject);
DERIVEDCLASS(omnetpp::cModule, omnetpp::cObject);
DERIVEDCLASS(omnetpp::cSimpleModule, omnetpp::cObject);
DERIVEDCLASS(omnetpp::cDefaultList, omnetpp::cObject);
//DERIVEDCLASS(omnetpp::cDoubleExpression, omnetpp::cExpression);
DERIVEDCLASS(omnetpp::cGate, omnetpp::cObject);
DERIVEDCLASS(omnetpp::cMessage, omnetpp::cObject);
DERIVEDCLASS(omnetpp::cPacket, omnetpp::cObject);
DERIVEDCLASS(omnetpp::cPar, omnetpp::cObject);
DERIVEDCLASS(omnetpp::cObject, omnetpp::cObject);
DERIVEDCLASS(omnetpp::cOutVector, omnetpp::cObject);
DERIVEDCLASS(omnetpp::cMsgPar, omnetpp::cObject);
DERIVEDCLASS(omnetpp::cObject, omnetpp::cObject);
DERIVEDCLASS(omnetpp::cQueue, omnetpp::cObject);
DERIVEDCLASS(omnetpp::cRuntimeError, omnetpp::cException);
DERIVEDCLASS(omnetpp::cSimulation, omnetpp::cObject);
DERIVEDCLASS(omnetpp::cStatistic, omnetpp::cObject);
DERIVEDCLASS(omnetpp::cStdDev, omnetpp::cObject);
DERIVEDCLASS(omnetpp::cProperties, omnetpp::cObject);
DERIVEDCLASS(omnetpp::cProperty, omnetpp::cObject);

%ignore omnetpp::JMessage::JMessage(const JMessage&);
%ignore omnetpp::JMessage::operator=(const JMessage&);

typedef omnetpp::SimTime simtime_t;

%include "omnetpp/simkerneldefs.h"
%include "omnetpp/simtime.h"
%include "omnetpp/simtime_t.h"
%include "omnetpp/cobject.h"
%include "omnetpp/cnamedobject.h"
%include "omnetpp/cownedobject.h"
%include "omnetpp/cdefaultlist.h"
%include "omnetpp/clistener.h"
%include "omnetpp/ccomponent.h"
%include "omnetpp/cchannel.h"
%include "omnetpp/cdelaychannel.h"
%include "omnetpp/cdataratechannel.h"
%include "omnetpp/cmodule.h"
%include "omnetpp/platdep/platdefs.h"
%include "omnetpp/ccoroutine.h"
%include "omnetpp/csimplemodule.h"
%include "omnetpp/ccomponenttype.h"
%include "omnetpp/carray.h"
//%include "omnetpp/clinkedlist.h"
%include "omnetpp/cqueue.h"
%include "omnetpp/cpacketqueue.h"
//%include "omnetpp/cdetect.h"
%include "omnetpp/cstatistic.h"
%include "omnetpp/cstddev.h"
//%include "omnetpp/cdensityestbase.h"
%include "omnetpp/chistogram.h"
%include "omnetpp/cksplit.h"
%include "omnetpp/cpsquare.h"
%include "omnetpp/cvarhist.h"
%include "omnetpp/ccoroutine.h"
%include "omnetpp/crng.h"
%include "omnetpp/clcg32.h"
%include "omnetpp/cmersennetwister.h"
%include "omnetpp/cobjectfactory.h"
%include "omnetpp/ccommbuffer.h"
//%include "omnetpp/cconfiguration.h"
//%include "omnetpp/cconfigoption.h"
%include "omnetpp/cdisplaystring.h"
//%include "omnetpp/cdynamicexpression.h"
%include "omnetpp/cenum.h"
%include "omnetpp/cenvir.h"
%include "omnetpp/cexception.h"
%include "omnetpp/cexpression.h"
//%include "omnetpp/chasher.h"
%include "omnetpp/cfsm.h"
//%include "omnetpp/cmathfunction.h"
%include "omnetpp/cgate.h"
%include "omnetpp/cmessage.h"
%include "omnetpp/cmsgpar.h"
%include "omnetpp/cevent.h"
%include "omnetpp/ceventheap.h"
//%include "omnetpp/cnedfunction.h"
//%include "omnetpp/cnullenvir.h"
%include "omnetpp/coutvector.h"
%include "omnetpp/cpar.h"
%include "omnetpp/cparsimcomm.h"
%include "omnetpp/cproperty.h"
%include "omnetpp/cproperties.h"
//%include "omnetpp/cscheduler.h"
%include "omnetpp/csimulation.h"
//%include "omnetpp/cstringtokenizer.h"
%include "omnetpp/cclassdescriptor.h"
//%include "omnetpp/ctopology.h"
%include "omnetpp/cvisitor.h"
//%include "omnetpp/cwatch.h"
%include "omnetpp/cstlwatch.h"
%include "omnetpp/cxmlelement.h"
%include "omnetpp/distrib.h"
%include "omnetpp/envirext.h"
%include "omnetpp/errmsg.h"
%include "omnetpp/globals.h"
%include "omnetpp/onstartup.h"
//%include "omnetpp/opp_string.h"
%include "omnetpp/crandom.h"
%include "omnetpp/cregistrationlist.h"
%include "omnetpp/regmacros.h"
%include "omnetpp/simutil.h"
//%include "omnetpp/packing.h"

//%include "index.h"
//%include "mersennetwister.h"
//%include "compat.h"
//%include "cparimpl.h"
//%include "cboolparimpl.h"
//%include "cdoubleparimpl.h"
//%include "clongparimpl.h"
//%include "cstringparimpl.h"
//%include "cstringpool.h"
//%include "cxmlparimpl.h"
//%include "nedsupport.h"

%include "JSimpleModule.h"
%include "JMessage.h"

