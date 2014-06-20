//
// JFBoxEncoder.h
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


/*
 * BOX format encoder.
 */
@interface JFBoxEncoder : NSObject {
	
@private
	NSMutableData *_data;
}


#pragma mark - Properties

@property (readonly) NSMutableData *data; // TODO: check that not including "strong" is okay for readonly here.


#pragma mark - Object lifecycle methods

+ (id) boxEncoderWithData: (NSMutableData *) data;
- (id) initWithData: (NSMutableData *) data;


#pragma mark - Encoding methods

- (void) encodeNil;
- (void) encodeBool: (BOOL) value;
- (void) encodeSInt8: (SInt8) value;
- (void) encodeSInt16: (SInt16) value;
- (void) encodeSInt32: (SInt32) value;
- (void) encodeSInt64: (SInt64) value;
- (void) encodeUInt8: (UInt64) value;
- (void) encodeUInt16: (UInt16) value;
- (void) encodeUInt32: (UInt32) value;
- (void) encodeUInt64: (UInt64) value;
- (void) encodeFloat: (float) value;
- (void) encodeDouble: (double) value;
- (void) encodeString: (NSString *) value;
- (void) encodeNumber: (NSNumber *) value;
- (void) encodeDate: (NSDate *) value;
- (void) encodeData: (NSData *) value;
- (void) encodeArray: (NSArray *) value;
- (void) encodeDictionary: (NSDictionary *) value;
- (void) encodeBoxEncodable: (__weak id <JFBoxEncodable>) value;

@end
