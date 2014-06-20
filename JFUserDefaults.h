//
// JFUserDefaults.h
// JFCommon
//
// Created by Jason Fuerstenberg on 13/10/17.
// Copyright (c) 2013 Jason Fuerstenberg. All rights reserved.
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

@interface JFUserDefaults : NSUserDefaults

+ (BOOL) boolWithKey: (NSString *) key defaultValue: (BOOL) defaultValue;
+ (NSInteger) integerWithKey: (NSString *) key defaultValue: (NSInteger) defaultValue;
+ (float) floatWithKey: (NSString *) key defaultValue: (float) defaultValue;
+ (NSString *) stringWithKey: (NSString *) key defaultValue: (NSString *) defaultValue;
+ (NSDate *) dateWithKey: (NSString *) key defaultValue: (NSDate *) defaultValue;

+ (void) setBool: (BOOL) value withKey: (NSString *) key;
+ (void) setInteger: (NSInteger) value withKey: (NSString *) key;
+ (void) setFloat: (float) value withKey: (NSString *) key;
+ (void) setString: (NSString *) value withKey: (NSString *) key;
+ (void) setDate: (NSDate *) value withKey: (NSString *) key;

@end
