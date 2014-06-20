//
// JFUserDefaults.m
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


#import "JFUserDefaults.h"


@implementation JFUserDefaults

+ (BOOL) boolWithKey: (NSString *) key defaultValue: (BOOL) defaultValue {
	
	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
	NSString *value = [userDefaults stringForKey: key];
	if (value == nil) {
		return defaultValue;
	}
	
	return ([value isEqualToString: @"1"]);
}

+ (NSInteger) integerWithKey: (NSString *) key defaultValue: (NSInteger) defaultValue {
	
	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
	NSNumber *value = [userDefaults objectForKey: key];
	if (value == nil) {
		return defaultValue;
	}
	
	return [value integerValue];
}

+ (float) floatWithKey: (NSString *) key defaultValue: (float) defaultValue {
	
	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
	NSNumber *value = [userDefaults objectForKey: key];
	if (value == nil) {
		return defaultValue;
	}
	
	return [value floatValue];
}

+ (NSString *) stringWithKey: (NSString *) key defaultValue: (NSString *) defaultValue {
	
	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
	NSString *value = [userDefaults stringForKey: key];
	if (value == nil) {
		return defaultValue;
	}
	
	return value;
}

+ (NSDate *) dateWithKey: (NSString *) key defaultValue: (NSDate *) defaultValue {
	
	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
	NSDate *value = [userDefaults objectForKey: key];
	if (value == nil) {
		return defaultValue;
	}
	
	return value;
}

+ (void) setBool: (BOOL) value withKey: (NSString *) key {
	
	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
	NSString *booleanValue = (value ? @"1" : @"0");
	[userDefaults setObject: booleanValue
					 forKey: key];
	[userDefaults synchronize];
}

+ (void) setInteger: (NSInteger) value withKey: (NSString *) key {
	
	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
	NSString *integerValue = [[NSNumber numberWithInt: value] stringValue];
	[userDefaults setObject: integerValue
					 forKey: key];
	[userDefaults synchronize];
}

+ (void) setFloat: (float) value withKey: (NSString *) key {
	
	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
	NSString *floatValue = [[NSNumber numberWithFloat: value] stringValue];
	[userDefaults setObject: floatValue
					 forKey: key];
	[userDefaults synchronize];
}

+ (void) setString: (NSString *) value withKey: (NSString *) key {
	
	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
	[userDefaults setObject: value
					 forKey: key];
	[userDefaults synchronize];
}

+ (void) setDate: (NSDate *) value withKey: (NSString *) key {
	
	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
	[userDefaults setObject: value
					 forKey: key];
	[userDefaults synchronize];
}

@end
