//
// JFBoxDecoder.h
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

#import "JFBoxDefines.h"
#import "JFBoxEncodable.h"

// TODO: define error codes up here
// end of data
// type mismatch
#define JFBoxDecoderErrorTypeNone								0
#define JFBoxDecoderErrorTypeUnsupportedFormatVersion			1
#define JFBoxDecoderErrorTypeEndOfData							2
#define	JFBoxDecoderErrorTypeMismatch							3
#define JFBoxDecoderErrorTypeNoData								4
#define JFBoxDecoderErrorTypeInvalidValue						5
#define JFBoxDecoderErrorTypeUnsupportedBoxEncodableClassName	6
#define JFBoxDecoderErrorTypeNotBoxEncodableClass				7
#define JFBoxDecoderErrorTypeOutOfBounds						8
#define JFBoxDecoderErrorEmptyObject                            9


@interface JFBoxDecoder : NSObject {

@private
	NSData *_data;
	
	UInt64 _index;
	
	BOOL _encounteredError;
}


#pragma mark - Properties

@property (nonatomic, readonly) UInt64 index;
@property (nonatomic, readonly, getter=encounteredError) BOOL encounteredError;


#pragma mark - Object lifecycle methods

+ (id) boxDecoderWithData: (NSData *) data;
- (id) initWithData: (NSData *) data;


#pragma mark - Entry methods

- (JFBoxType) nextEntryType;


#pragma mark - Decoding methods

- (void) decodeNilWithError: (NSError **) error;
- (BOOL) decodeBoolWithError: (NSError **) error;
- (SInt8) decodeSInt8WithError: (NSError **) error;
- (SInt16) decodeSInt16WithError: (NSError **) error;
- (SInt32) decodeSInt32WithError: (NSError **) error;
- (SInt64) decodeSInt64WithError: (NSError **) error;
- (UInt8) decodeUInt8WithError: (NSError **) error;
- (UInt16) decodeUInt16WithError: (NSError **) error;
- (UInt32) decodeUInt32WithError: (NSError **) error;
- (UInt64) decodeUInt64WithError: (NSError **) error;
- (float) decodeFloatWithError: (NSError **) error;
- (double) decodeDoubleWithError: (NSError **) error;
- (NSString *) decodeStringWithError: (NSError **) error;
- (NSNumber *) decodeNumberWithError: (NSError **) error;
- (NSDate *) decodeDateWithError: (NSError **) error;
- (NSData *) decodeDataWithError: (NSError **) error;
- (NSArray *) decodeArrayWithError: (NSError **) error;
- (NSDictionary *) decodeDictionaryWithError: (NSError **) error;
- (__strong id <JFBoxEncodable>) decodeBoxEncodableWithError: (NSError **) error;


@end
