//
// JFBase64.h
// JFCommon
//
// Created by Jason Fuerstenberg on 11/01/08.
// Copyright 2011 Jason Fuerstenberg. All rights reserved.
//
// Implementation based on: http://www.cocoadev.com/index.pl?BaseSixtyFour
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


@interface JFBase64 : NSObject

+ (void) initialize;
+ (NSString *) encode: (const uint8_t *) input length: (NSInteger) length;
+ (NSString *) encode: (NSData *) rawBytes;
+ (NSData *) decode: (const char *) string length: (NSInteger) inputLength;
+ (NSData *) decode: (NSString *) string;

@end
