//
// JFBoxDefines.h
// JFCommon
//
// Created by Jason Fuerstenberg on 12/03/19.
// Copyright (c) 2012 Jason Fuerstenberg. All rights reserved.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//


#import <Foundation/Foundation.h>


/*
 * The BOX format version starts at 1 and increments with each format change.
 */
#define JFBoxFormatVersion				(UInt16) 1	// Created 2012-03-19

#define JFBoxFormat1HeaderLength		5


#define JFBoxNilObjectValue				(UInt8)	0x00
#define JFBoxNotNilObjectValue			(UInt8) 0xff

enum {
	JFBoxTypeUnknown = 0,
	JFBoxTypeNil = 1,
	JFBoxTypeBool = 2,
	JFBoxTypeSInt8 = 3,
	JFBoxTypeSInt16 = 4,
	JFBoxTypeSInt32 = 5,
	JFBoxTypeSInt64 = 6,
	JFBoxTypeUInt8 = 7,
	JFBoxTypeUInt16	= 8,
	JFBoxTypeUInt32 = 9,
	JFBoxTypeUInt64 = 10,
	JFBoxTypeFloat = 11,
	JFBoxTypeDouble = 12,
	JFBoxTypeString = 13,
	JFBoxTypeNumber	= 14,
	JFBoxTypeDate = 15,
	JFBoxTypeData = 16,
	JFBoxTypeArray = 17,
	JFBoxTypeDictionary	= 18,
	
	// NOTE: TYPES 19-254 RESERVED FOR FUTURE USE.
	
	JFBoxTypeBoxEncodable = 255
};
typedef UInt8 JFBoxType;





#define JFBoxTypeEncodingLength			1
#define JFBoxBoolEncodingLength			1
#define JFBoxSInt8EncodingLength		sizeof(SInt8)
#define JFBoxSInt16EncodingLength		sizeof(SInt16)
#define JFBoxSInt32EncodingLength		sizeof(SInt32)
#define JFBoxSInt64EncodingLength		sizeof(SInt64)
#define JFBoxUInt8EncodingLength		sizeof(UInt8)
#define JFBoxUInt16EncodingLength		sizeof(UInt16)
#define JFBoxUInt32EncodingLength		sizeof(UInt32)
#define JFBoxUInt64EncodingLength		sizeof(UInt64)
#define JFBoxFloatEncodingLength		sizeof(float)
#define JFBoxDoubleEncodingLength		sizeof(double)
#define JFBoxDateEncodingLength			sizeof(NSTimeInterval)

#define JFBoxNilOrNotFlagEncodingLength	sizeof(UInt8)
