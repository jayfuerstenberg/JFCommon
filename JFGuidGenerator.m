//
// JFGuidGenerator.m
// JFCommon
//
// Created by Jason Fuerstenberg on 10/12/28.
// Copyright 2010 Jason Fuerstenberg. All rights reserved.
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

#import "JFGuidGenerator.h"


@implementation JFGuidGenerator

/*
 * Generates and returns a GUID.
 *
 * NOTE: Based on logic from:  http://cocoabugs.blogspot.com/2010/12/gereateing-unique-uuiduinique-id-in.html
 */
+ (NSString *) generateGuid {
	
    CFUUIDRef uuid = CFUUIDCreate(NULL);
    CFStringRef uuidStr = CFUUIDCreateString(NULL, uuid);
    CFRelease(uuid);
	
#if __has_feature(objc_arc)
	// Using ARC so just return...
	return (__bridge NSString *) uuidStr;
#else
	// Autorelease the instance then return...
	[(NSString *) uuidStr autorelease];
	return (NSString *) uuidStr;
#endif
}

@end
