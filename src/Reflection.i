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

%{
#if OMNETPP_VERSION == 0x0400
#define GET_FIELD_AS_STRING(desc,self,fieldId,index) \
    char buf[200]; desc->getFieldAsString(self, fieldId, index, buf, 200); return buf;
#else
#define GET_FIELD_AS_STRING(desc,self,fieldId,index) \
    return desc->getFieldAsString(self, fieldId, index);
#endif


  static cClassDescriptor *findDescriptor(cObject *p)
  {
      cClassDescriptor *desc = p->getDescriptor();
      if (!desc)
          opp_error("no descriptor for class %s", p->getClassName());
      return desc;
  }

  static int findField(cClassDescriptor *desc, void *object, const char *fieldName)
  {
      int n = desc->getFieldCount(object);
      for (int i=0; i<n; i++)
          if (!strcmp(desc->getFieldName(object, i), fieldName))
              return i;
      return -1;
  }

  static int getFieldID(cClassDescriptor *desc, void *object, const char *fieldName)
  {
      int id = findField(desc, object, fieldName);
      if (id==-1)
          opp_error("no `%s' field in class %s", fieldName, desc->getName());
      return id;
  }
%}

%extend cObject {

  bool hasField(const char *fieldName)
  {
      cClassDescriptor *desc = findDescriptor(self);
      return findField(desc, self, fieldName)!=-1;
  }

  std::string getField(const char *fieldName)
  {
      cClassDescriptor *desc = findDescriptor(self);
      int fieldId = getFieldID(desc, self, fieldName);
      GET_FIELD_AS_STRING(desc,self,fieldId,0);
  }

  std::string getArrayField(const char *fieldName, int index)
  {
      cClassDescriptor *desc = findDescriptor(self);
      int fieldId = getFieldID(desc, self, fieldName);
      GET_FIELD_AS_STRING(desc,self,fieldId,index);
  }

  void setField(const char *fieldName, const char *value)
  {
      cClassDescriptor *desc = findDescriptor(self);
      int fieldId = getFieldID(desc, self, fieldName);
      desc->setFieldAsString(self, fieldId, 0, value);
  }

  void setArrayField(const char *fieldName, int index, const char *value)
  {
      cClassDescriptor *desc = findDescriptor(self);
      int fieldId = getFieldID(desc, self, fieldName);
      desc->setFieldAsString(self, fieldId, index, value); //XXX check out of bounds!!!
  }

  bool isFieldArray(const char *fieldName)
  {
      cClassDescriptor *desc = findDescriptor(self);
      int fieldId = getFieldID(desc, self, fieldName);
      return desc->getFieldIsArray(self, fieldId);
  }

  bool isFieldCompound(const char *fieldName)
  {
      cClassDescriptor *desc = findDescriptor(self);
      int fieldId = getFieldID(desc, self, fieldName);
      return desc->getFieldIsCompound(self, fieldId);
  }
}
