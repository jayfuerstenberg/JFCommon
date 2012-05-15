//
// JFRandom.h
//
// Created by Jason Fuerstenberg on 10/05/03.
// Copyright 2010 Jason Fuerstenberg
//
// http://www.jayfuerstenberg.com
// jay@jayfuerstenberg.com
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


#import <Foundation/Foundation.h>


/*
 * Utility class for generating random data.
 */
@interface JFRandom : NSObject

+ (BOOL) generateNumberBetweenLow: (NSInteger) low andHigh: (NSInteger) high intoReceiver: (NSInteger *) receiver;
+ (BOOL) generateNumberSequenceOfLength: (NSUInteger) length into: (NSInteger[]) sequence betweenLow: (NSInteger) low andHigh: (NSInteger) high withOnlyUniqueValues: (BOOL) onlyUniqueValues;
+ (BOOL) chooseNumberFromSequence: (NSInteger[]) sequence ofLength: (NSUInteger) length intoReceiver: (NSInteger *) receiver;
+ (BOOL) isNumber: (NSInteger) number inSequence: (NSInteger[]) sequence ofLength: (NSUInteger) length;
+ (NSData *) generateRandomSignedDataOfLength: (NSUInteger) length;
+ (NSData *) generateRandomDataOfLength: (NSUInteger) length;
+ (NSString *) generateRandomStringOfLength: (NSUInteger) length;

@end