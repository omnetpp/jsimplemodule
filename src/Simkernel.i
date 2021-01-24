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

using namespace omnetpp;

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
%include "std_map.i"
%include "std_vector.i"

%include commondefs.i
%include "PlainMemoryManagement.i"

%include "Reflection.i"

// hide some macros from swig (copied from nativelibs/common.i)
#define COMMON_API
#define ENVIR_API
#define OPP_DLLEXPORT
#define OPP_DLLIMPORT

#define _OPPDEPRECATED

#pragma SWIG nowarn=516;  // "Overloaded method x ignored. Method y used."
#pragma SWIG nowarn=822;  // "Covariant return types not supported in Java."
#pragma SWIG nowarn=319;  // "No access specifier given for base class 'noncopyable' (ignored)."

// forward declaration helps eliminate generating SWIGTYPE_xxx types for otherwise known classes
namespace omnetpp {
class cRuntimeError;
class cModule;
class cChannelType;
class cCanvas;
class cOsgCanvas;
class cHistogram;
class cGlobalRegistrationList;
class cIListener;
}

// ignore methods that are useless from Java
%ignore omnetpp::cEnvir::printf;
%ignore omnetpp::cEnvir::refOsgNode;
%ignore omnetpp::cEnvir::unrefOsgNode;
%ignore omnetpp::cEnvir::log;
%ignore omnetpp::cEnvir::addLifecycleListener;
%ignore omnetpp::cEnvir::removeLifecycleListener;
%ignore omnetpp::cEnvir::notifyLifecycleListeners;
%ignore omnetpp::cChannel::processMessage;
%ignore omnetpp::cRegistrationList::begin;
%ignore omnetpp::cRegistrationList::end;
%ignore omnetpp::cGlobalRegistrationList::begin;
%ignore omnetpp::cGlobalRegistrationList::end;

// ignore utility functions that have no utility in Java
%ignore omnetpp::intCastError;
%ignore omnetpp::opp_typename;
%ignore omnetpp::opp_appendindex;
%ignore omnetpp::opp_demangle_typename;
%ignore omnetpp::opp_strcmp;
%ignore omnetpp::opp_strcpy;
%ignore omnetpp::opp_strdup;
%ignore omnetpp::opp_strlen;
%ignore omnetpp::opp_strprettytrunc;

// ignore internal classes and those that cause problems
%ignore omnetpp::CodeFragments;
%ignore omnetpp::eMessageKind;
%ignore omnetpp::cContextSwitcher;
%ignore omnetpp::cContextTypeSwitcher;
%ignore omnetpp::cStackCleanupException;
%ignore omnetpp::cTerminationException;
%ignore omnetpp::cEndModuleException;
%ignore omnetpp::cStaticFlag;
%ignore omnetpp::cOsgCanvas;
%ignore omnetpp::cLogEntry;
%ignore omnetpp::cGate::Desc;
%ignore omnetpp::cChannel::MessageSentSignalValue;
%ignore omnetpp::cChannel::result_t;

// no long double in java
%ignore omnetpp::cComponent::emit(omnetpp::simsignal_t, long double, omnetpp::cObject*); //TODO doesn't take effect

// ignore cFigure internal methods
%ignore omnetpp::cFigure::updateParentTransform;
%ignore omnetpp::cFigure::callRefreshDisplay;
%ignore omnetpp::cFigure::getLocalChangeFlags;
%ignore omnetpp::cFigure::getSubtreeChangeFlags;
%ignore omnetpp::cFigure::clearChangeFlags;
%ignore omnetpp::cFigure::refreshTagBitsRec;
%ignore omnetpp::cFigure::getTagBits;
%ignore omnetpp::cFigure::setTagBits;
%ignore omnetpp::cFigure::getHash;
%ignore omnetpp::cFigure::clearCachedHash;

// ignore internal methods
%ignore omnetpp::cComponent::getLogLevel;
%ignore omnetpp::cComponent::setLogLevel;
%ignore omnetpp::cComponent::setRNGMap;
%ignore omnetpp::cComponent::setComponentType;
%ignore omnetpp::cComponent::addPar;
%ignore omnetpp::cComponent::reallocParamv;
%ignore omnetpp::cComponent::recordParameters;
%ignore omnetpp::cComponent::recordParameterAsScalar;
%ignore omnetpp::cComponent::parametersFinalized;
%ignore omnetpp::cComponent::addResultRecorders;
%ignore omnetpp::cComponent::initialized;
%ignore omnetpp::cComponent::callRefreshDisplay;
%ignore omnetpp::cComponent::callPreDelete;
%ignore omnetpp::cComponent::hasDisplayString;
%ignore omnetpp::cComponent::clearSignalState;
%ignore omnetpp::cComponent::clearSignalRegistrations;
%ignore omnetpp::cComponent::getSignalMask;
%ignore omnetpp::cComponent::setCheckSignals;
%ignore omnetpp::cComponent::getCheckSignals;
%ignore omnetpp::cComponent::getResultRecorders;
%ignore omnetpp::cComponent::invalidateCachedResultRecorderLists;

// ignore methods of histogram strategies that are meant to be called from the owning histogram only
%ignore omnetpp::cIHistogramStrategy::collect;
%ignore omnetpp::cIHistogramStrategy::collectWeighted;
%ignore omnetpp::cIHistogramStrategy::clear;
%ignore omnetpp::cFixedRangeHistogramStrategy::collect;
%ignore omnetpp::cFixedRangeHistogramStrategy::collectWeighted;
%ignore omnetpp::cFixedRangeHistogramStrategy::clear;
%ignore omnetpp::cPrecollectionBasedHistogramStrategy::collect;
%ignore omnetpp::cPrecollectionBasedHistogramStrategy::collectWeighted;
%ignore omnetpp::cPrecollectionBasedHistogramStrategy::clear;
%ignore omnetpp::cAutoRangeHistogramStrategy::collect;
%ignore omnetpp::cAutoRangeHistogramStrategy::collectWeighted;
%ignore omnetpp::cAutoRangeHistogramStrategy::clear;
%ignore omnetpp::cDefaultHistogramStrategy::collect;
%ignore omnetpp::cDefaultHistogramStrategy::collectWeighted;
%ignore omnetpp::cDefaultHistogramStrategy::clear;

// ignore path figure data classes (useless due to lack of mapping the polymorphism)
%ignore omnetpp::cPathFigure::PathItem;
%ignore omnetpp::cPathFigure::MoveTo;
%ignore omnetpp::cPathFigure::MoveRel;
%ignore omnetpp::cPathFigure::LineTo;
%ignore omnetpp::cPathFigure::LineRel;
%ignore omnetpp::cPathFigure::HorizontalLineTo;
%ignore omnetpp::cPathFigure::HorizontalLineRel;
%ignore omnetpp::cPathFigure::VerticalLineTo;
%ignore omnetpp::cPathFigure::VerticalLineRel;
%ignore omnetpp::cPathFigure::ArcTo;
%ignore omnetpp::cPathFigure::ArcRel;
%ignore omnetpp::cPathFigure::CurveTo;
%ignore omnetpp::cPathFigure::CurveRel;
%ignore omnetpp::cPathFigure::SmoothCurveTo;
%ignore omnetpp::cPathFigure::SmoothCurveRel;
%ignore omnetpp::cPathFigure::CubicBezierCurveTo;
%ignore omnetpp::cPathFigure::CubicBezierCurveRel;
%ignore omnetpp::cPathFigure::SmoothCubicBezierCurveTo;
%ignore omnetpp::cPathFigure::SmoothCubicBezierCurveRel;
%ignore omnetpp::cPathFigure::ClosePath;

%ignore omnetpp::cPathFigure::getNumPathItems;
%ignore omnetpp::cPathFigure::getPathItem;

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
%ignore omnetpp::cModule::getOrCreateFirstUnconnectedGatePair;
%ignore omnetpp::cModule::getOsgCanvas;
%ignore omnetpp::cModule::getOsgCanvasIfExists;

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

%ignore omnetpp::cObjectFactory::cObjectFactory;

// ignore deprecated methods
%ignore omnetpp::cChannelType::createIdealChannel;
%ignore omnetpp::cChannelType::createDelayChannel;
%ignore omnetpp::cChannelType::createDatarateChannel;
%ignore omnetpp::cMsgPar::getAsText;
%ignore omnetpp::cMsgPar::setFromText;
%ignore omnetpp::cMsgPar::setFromText;
%ignore omnetpp::cFigure::addFigureAbove;
%ignore omnetpp::cFigure::addFigureBelow;
%ignore omnetpp::cCanvas::addFigureAbove;
%ignore omnetpp::cCanvas::addFigureBelow;
%ignore omnetpp::cStatistic::getWeights;

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
%ignore omnetpp::cPar::getExpression;
%ignore omnetpp::cPar::setExpression;

%ignore omnetpp::cRNG::initialize;
%ignore omnetpp::cLCG32;
%ignore omnetpp::cMersenneTwister;

// ignore deprecated items:
%ignore omnetpp::cObject::info;
%ignore omnetpp::cObject::detailedInfo;
%ignore omnetpp::cModule::size;
%ignore omnetpp::cQueue::length;
%ignore omnetpp::cQueue::empty;
%ignore omnetpp::cStatistic::collect2;
%ignore omnetpp::cStatistic::random;
%ignore omnetpp::cStatistic::clearResult;
%ignore omnetpp::cWeightedStdDev;
%ignore omnetpp::cAbstractHistogram::isTransformed;
%ignore omnetpp::cAbstractHistogram::transform;
%ignore omnetpp::cAbstractHistogram::getNumCells;
%ignore omnetpp::cAbstractHistogram::getBasepoint;
%ignore omnetpp::cAbstractHistogram::getCellValue;
%ignore omnetpp::cAbstractHistogram::getCellPDF;
%ignore omnetpp::cAbstractHistogram::getUnderflowCell;
%ignore omnetpp::cAbstractHistogram::getOverflowCell;
%ignore omnetpp::cAbstractHistogram::getCellInfo;
%ignore omnetpp::cHistogram::setRangeAuto;
%ignore omnetpp::cHistogram::setRangeAutoLower;
%ignore omnetpp::cHistogram::setRangeAutoUpper;
%ignore omnetpp::cHistogram::setNumCells;
%ignore omnetpp::cHistogram::setCellSize;
%ignore omnetpp::cPar::setLongValue;
%ignore omnetpp::cPar::longValue;
%ignore omnetpp::cGate::size;


namespace std {
  %define ADD_TOARRAY_METHOD(METHODNAME,CPPTYPE,JAVATYPE)
    %typemap(javacode) vector<CPPTYPE> %{
      public JAVATYPE[] METHODNAME() {
        JAVATYPE[] a = new JAVATYPE[(int)size()];
        for (int i = 0; i < a.length; i++)
          a[i] = get(i);
        return a;
      }
    %}
  %enddef
  ADD_TOARRAY_METHOD(toIntArray,int,int);
  ADD_TOARRAY_METHOD(toDoubleArray,double,double);

  %template(IntVector) vector<int>;
  %template(DoubleVector) vector<double>;
  %template(CStringVector) vector<const char *>;
  %template(StringVector) vector<string>;
  %template(StringMap) map<string,string>;
  %template(StringIntMap) map<string,int>;
  %template(PointVector) vector<omnetpp::cFigure::Point>;
  %template(ListenerVector) vector<omnetpp::cIListener*>;
  %template(XMLElementVector) vector<omnetpp::cXMLElement*>;
}

// logging support: EV.println()
%{
#undef EV
class EV {
  public:
    static void print(const char *s) {EV_INFO << s;}
    static void println(const char *s) {EV_INFO << s << endl;}
};
%}

class EV {
  private:
    EV();
  public:
    static void print(const char *s);
    static void println(const char *s);
};

%typemap(javacode) omnetpp::cModule %{
  public static cEnvir EV = Simkernel.getEnvir();
  public static cEnvir ev = Simkernel.getEnvir();
%};

%extend omnetpp::cEnvir {
  void print(const char *s) {EV_INFO << s;}
  void println(const char *s) {EV_INFO << s << endl;}
};

// ignore/rename some operators (some have method equivalents)
%rename(equals) operator==;
%ignore operator!=;
%rename(lessThan) operator<;
%rename(greaterThan) operator>;
%rename(lessOrEqual) operator<=;
%rename(greaterOrEqual) operator>=;

%rename(set) operator=;
%rename(add) operator+;
%rename(subtract) operator-;
%rename(mul) operator*;
%rename(div) operator/;
%rename(increment) operator++;
%rename(decrement) operator--;

%ignore operator+=;
%ignore operator-=;
%ignore operator*=;
%ignore operator/=;
%ignore operator[];
%ignore operator<<;
%ignore operator<<;
%ignore operator();

%rename(negate) omnetpp::SimTime::operator-(); // unary

%extend omnetpp::SimTime {
  SimTime add(const SimTime& x) {return *self + x;}
  SimTime subtract(const SimTime& x) {return *self - x;}
  SimTime mul(double x) {return *self * x;}
  SimTime div(double x) {return *self / x;}
  double div(const SimTime& x) {return *self / x;}
}


// ignore conversion operators (they all have method equivalents)
%ignore operator bool;
%ignore operator char;
%ignore operator unsigned char;
%ignore operator short;
%ignore operator unsigned short;
%ignore operator int;
%ignore operator unsigned int;
%ignore operator long;
%ignore operator unsigned long;
%ignore operator long long;
%ignore operator unsigned long long;
%ignore operator double;
%ignore operator long double;
%ignore operator const char *;
%ignore operator std::string;
%ignore operator void *;

%ignore operator cObject *;
%ignore operator cOwnedObject *;
%ignore operator cXMLElement *;
%ignore operator Color;
%ignore operator cFigure::Color;

%ignore operator omnetpp::cObject *;
%ignore operator omnetpp::cOwnedObject *;
%ignore operator omnetpp::cXMLElement *;
%ignore operator omnetpp::cFigure::Color;

// remove assignment operator for some classes
%ignore omnetpp::cPar::operator=;
%ignore omnetpp::cSimulation::operator=;

// ignore methods that are useless from Java
%ignore omnetpp::cEnvir::printf;
%ignore omnetpp::cEnvir::getImageSize;
%ignore omnetpp::cEnvir::getTextExtent;
%ignore omnetpp::cGate::setChannel;
%ignore omnetpp::cFigure::Pixmap::buffer;

// ignore internal methods:
%ignore omnetpp::cComponent::getLogLevel;
%ignore omnetpp::cComponent::setLogLevel;
%ignore omnetpp::cCanvas::getAnimationSpeedMap;
%ignore omnetpp::cCanvas::getMinAnimationSpeed;
%ignore omnetpp::cCanvas::getAnimationHoldEndTime;
%ignore omnetpp::cSimulation::getFingerprintCalculator;
%ignore omnetpp::cSimulation::setFingerprintCalculator;

// ignore methods that are useless from Java
%ignore parsimPack;
%ignore parsimUnpack;
%ignore loadFromFile; // works with FILE*
%ignore saveToFile; // ditto
%ignore forEachChild;
%ignore getThisPtr;

%ignore omnetpp::cXMLElement::ParamResolver::resolve;
%ignore omnetpp::ModNameParamResolver::resolve;
%ignore omnetpp::StringMapParamResolver::resolve;

// these methods return const char *[] which don't bother wrapping
%ignore omnetpp::cClassDescriptor::getFieldPropertyNames;
%ignore omnetpp::cClassDescriptor::getPropertyNames;
%ignore omnetpp::cFigure::getAllowedPropertyKeys;
%ignore omnetpp::cXMLElement::setAttributes;

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
%ignore omnetpp::cPacketQueue;  // Java compile problems (cMessage/cPacket conversion)

%ignore omnetpp::critfunc_const;
%ignore omnetpp::critfunc_depth;
%ignore omnetpp::divfunc_const;
%ignore omnetpp::divfunc_babak;

%ignore omnetpp::SimTime::ttoa;
%ignore omnetpp::SimTime::split;
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
    // can be overridden by the user
    return 1;
  }

  protected void initialize(int stage) {
    // can be overridden by the user
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

  protected void refreshDisplay() {
    // can be overridden by the user
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
//BASECLASS(omnetpp::cVisitor);
BASECLASS(omnetpp::cXMLElement);
//BASECLASS(std::vector<omnetpp::cXMLElement*>);
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
%include "omnetpp/platdep/platdefs.h"
%include "omnetpp/simtime.h"
%include "omnetpp/simtime_t.h"
%include "omnetpp/cobject.h"
%include "omnetpp/cnamedobject.h"
%include "omnetpp/cownedobject.h"
%include "omnetpp/ccanvas.h"
//%include "omnetpp/cosgcanvas.h"
%include "omnetpp/cdefaultlist.h"
%include "omnetpp/clistener.h"
%include "omnetpp/ccomponent.h"
%include "omnetpp/cchannel.h"
%include "omnetpp/cdelaychannel.h"
%include "omnetpp/cdataratechannel.h"
%include "omnetpp/cmodule.h"
%include "omnetpp/ccoroutine.h"
%include "omnetpp/csimplemodule.h"
%include "omnetpp/ccomponenttype.h"
%include "omnetpp/carray.h"
%include "omnetpp/cqueue.h"
%include "omnetpp/cpacketqueue.h"
%include "omnetpp/crandom.h"
%include "omnetpp/cstatistic.h"
%include "omnetpp/cstddev.h"
%include "omnetpp/cabstracthistogram.h"
%include "omnetpp/chistogramstrategy.h"
%include "omnetpp/chistogram.h"
//%include "omnetpp/cksplit.h"
%include "omnetpp/cpsquare.h"
//%include "omnetpp/cvarhist.h"
%include "omnetpp/ccoroutine.h"
%include "omnetpp/crng.h"
%include "omnetpp/clcg32.h"
%include "omnetpp/cmersennetwister.h"
%include "omnetpp/cobjectfactory.h"
//%include "omnetpp/ccommbuffer.h"
//%include "omnetpp/cconfiguration.h"
//%include "omnetpp/cconfigoption.h"
%include "omnetpp/cdisplaystring.h"
//%include "omnetpp/cdynamicexpression.h"
%include "omnetpp/cenum.h"
%include "omnetpp/cenvir.h"
%include "omnetpp/cexception.h"
//%include "omnetpp/cexpression.h"
//%include "omnetpp/chasher.h"
%include "omnetpp/cfsm.h"
//%include "omnetpp/cmathfunction.h"
%include "omnetpp/cgate.h"
%include "omnetpp/cevent.h"
%include "omnetpp/cmessage.h"
%include "omnetpp/cmsgpar.h"
%include "omnetpp/cfutureeventset.h"
%include "omnetpp/ceventheap.h"
//%include "omnetpp/cnedfunction.h"
//%include "omnetpp/cnullenvir.h"
%include "omnetpp/coutvector.h"
%include "omnetpp/cpar.h"
//%include "omnetpp/cparsimcomm.h"
%include "omnetpp/cproperty.h"
%include "omnetpp/cproperties.h"
//%include "omnetpp/cscheduler.h"
%include "omnetpp/csimulation.h"
//%include "omnetpp/cstringtokenizer.h"
%include "omnetpp/cclassdescriptor.h"
//%include "omnetpp/ctopology.h"
//%include "omnetpp/cvisitor.h"
//%include "omnetpp/cwatch.h"
//%include "omnetpp/cstlwatch.h"
%include "omnetpp/cxmlelement.h"
%include "omnetpp/distrib.h"
//%include "omnetpp/envirext.h"
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

