//
// JFGuidUtil.m
// JFCommon
//
// Created by Jason Fuerstenberg on 2012/04/02.
// Copyright 2012 Jason Fuerstenberg
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

#import "JFGuidUtil.h"


@implementation JFGuidUtil

/*
 * Returns a GUID with the last section masked with bullet marks (Japanese maru characters).
 * If the original GUID is invalid nil is returned.
 *
 * This method is intended for logging GUIDs which may be sensitive/private in such a way
 * that they can be compared with a reasonable degree of certainty by someone in possession
 * of both the full GUID and the masked one.
 *
 * The masked GUID in and of itself cannot help an unauthorized person relearn the original
 * GUID as the bulletized portion is lost information.
 */
+ (NSString *) maskedGuidWithOriginalGuid: (NSString *) originalGuid {
	
	NSUInteger length = [originalGuid length];
	if (length != 36) {
		// The length is not the expected 36 characters so this is an invalid GUID.
		return nil;
	}
	
	NSRange rangeOfLastHyphen = [originalGuid rangeOfString: @"-"
													options: NSBackwardsSearch];
	if (rangeOfLastHyphen.location != length - 13) {
		// This GUID has no hyphen in front of the last 12 digits, so it is invalid.
		return nil;
	}
	
	// Replace all the characters after the last hyphen with a maru...
	NSUInteger replacementIndex = rangeOfLastHyphen.location + 1;
	NSRange replacementRange = NSMakeRange(replacementIndex, length - replacementIndex);
	/*
	 * NOTE: The below bullets may not display as expected if your log is not in UTF8.
	 * You may change it to any character that suits your purpose though.
	 */
	NSString *maskedGuid = [originalGuid stringByReplacingCharactersInRange: replacementRange
																 withString: @"●●●●●●●●●●●●"];
	
	return maskedGuid;
}

@end
