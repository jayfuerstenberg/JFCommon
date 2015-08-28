//
// JFMacros.h
// JFCommon
//
// Created by Jason Fuerstenberg on 2014/03/10.
// Copyright (c) 2014 Jason Fuerstenberg. All rights reserved.
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


#define JFReturnIfAlreadyInitialized(a) { if (a != nil) { return; } }

#define JFReturnIfNotInitialized(a) { if (a == nil) { return; } }
#define JFReturnIfNil(a) { if (a == nil) { return; } }
#define JFReturnIfNotNil(a) { if (a != nil) { return; } }

#define JFReturnNilIfNotInitialized(a) { if (a == nil) { return nil; } }
#define JFReturnNilIfNil(a) { if (a == nil) { return nil; } }
#define JFReturnNilIfYes(a) { if (a == YES) { return nil; } }
#define JFReturnNilIfNo(a) { if (a == NO) { return nil; } }
#define JFReturnNilIfNan(a) { if (isnan(a)) { return nil; } }

#define JFReturnYesIfYes(a) { if (a == YES) { return YES; } }

#define JFReturnIfYes(a) { if (a == YES) { return; } }
#define JFReturnIfNo(a) { if (a == NO) { return; } }
#define JFReturnYesIfNil(a) { if (a == nil) { return YES; } }
#define JFReturnNoIfNo(a) { if (a == NO) { return NO; } }
#define JFReturnNoIfYes(a) { if (a == YES) { return NO; } }
#define JFReturnNoIfNil(a) { if (a == nil) { return NO; } }
#define JFReturnNoIfNan(a) { if (isnan(a)) { return NO; } }
#define JFReturnNoIfEmptyString(a) { if ([a length] == 0) { return NO; } }
#define JFReturnNoIfNotEmptyString(a) { if ([a length] > 0) { return NO; } }


#define JFReturnZeroIfYes(a) { if (a == YES) { return 0; } }
#define JFReturnZeroIfNo(a) { if (a == NO) { return 0; } }
#define JFReturnZeroIfNil(a) { if (a == nil) { return 0; } }
#define JFReturnZeroIfEmptyString(a) { if ([a length] == 0) { return 0; } }
#define JFReturnZeroIfEmptyArray(a) { if ([a count] == 0) { return 0; } }

#define JFReturnIfEmptyString(a) { if ([a length] == 0) { return; } }
#define JFReturnNilIfEmptyString(a) { if ([a length] == 0) { return nil; } }
#define JFReturnIfEmptyArray(a) { if ([a count] == 0) { return; } }
#define JFReturnNilIfEmptyArray(a) { if ([a count] == 0) { return nil; } }

#define JFReturnIfEqualBooleans(a, b) { if ([a boolValue] == [b boolValue]) { return; } }
#define JFReturnIfEqualIntegers(a, b) { if ([a integerValue] == [b integerValue]) { return; } }
#define JFReturnIfEqualStrings(a, b) { if ([a isEqualToString: b]) { return; } }
#define JFReturnIfEqualDates(a, b) { if ([a isEqualToDate: b]) { return; } }
#define JFReturnIfEqualArrays(a, b) { if ([a isEqualToArray: b]) { return; } }

#define JFReturnIfFirstDateIsLater(a, b) { float at = [a timeIntervalSince1970]; float bt = [b timeIntervalSince1970]; if (at > bt) { return; } }
#define JFReturnNoIfFirstDateIsLater(a, b) { float at = [a timeIntervalSince1970]; float bt = [b timeIntervalSince1970]; if (at > bt) { return NO; } }
#define JFReturnIfFirstDateIsLaterWithSecondAccuracy(a, b) { float at = floorf([a timeIntervalSince1970]); float bt = floorf([b timeIntervalSince1970]); if (at > bt) { return; } }
#define JFReturnIfFirstDateIsEqualOrLater(a, b) { float at = [a timeIntervalSince1970]; float bt = [b timeIntervalSince1970]; if (at >= bt) { return; } }
#define JFReturnIfFirstDateIsEqualOrLaterWithSecondAccuracy(a, b) { float at = floorf([a timeIntervalSince1970]); float bt = floorf([b timeIntervalSince1970]); if (at >= bt) { return; } }
#define JFReturnNoIfFirstDateIsEqualOrLaterWithSecondAccuracy(a, b) { float at = floorf([a timeIntervalSince1970]); float bt = floorf([b timeIntervalSince1970]); if (at >= bt) { return NO; } }

#define JFSkipIfYes(a) { if (a == YES) { continue; } }
#define JFSkipIfNo(a) { if (a == NO) { continue; } }
#define JFSkipIfNil(a) { if (a == nil) { continue; } }
#define JFSkipIfEmptyString(a) { if ([a length] == 0) { continue; } }


#define JFZeroIfNan(a) if (isnan(a)) { a = 0.0f; } // Zeroes a number if it happens to be a non-number.
#define JFSafeDivide(a, b) if (b == 0.0f) { return 0.0f } else { return a / b; } // Divides a by b, taking into consideration that it might be 0 and not allowing a divide by zero scenario.