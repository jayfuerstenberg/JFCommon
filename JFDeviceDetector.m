//
// JFDeviceDetector.m
// JFCommon
//
// Created by Jason Fuerstenberg on 2011/02/09.
// Copyright 2011 Jason Fuerstenberg. All rights reserved.
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

#import "JFDeviceDetector.h"


@implementation JFDeviceDetector

+ (BOOL) isDeviceAnIPodTouch {

	NSString *deviceType = [JFDeviceDetector deviceTypeCode];
	NSRange iPodRange = [deviceType rangeOfString: @"iPod"];
	
	return iPodRange.length != 0;
}

+ (BOOL) isDeviceAnIPad {
	
	NSString *model = [[UIDevice currentDevice] model];
	
	BOOL isIPad = [model isEqualToString: @"iPad"];
	BOOL isIPadSimulator = [model isEqualToString: @"iPad Simulator"];
	
	return isIPad || isIPadSimulator;
	
	// On iPhone this = "iPhone"
	// On iPad this = "iPad"
	// On iPod touch this = "iPod touch"
}

+ (NSString *) deviceTypeCode {
	
	size_t size;
	sysctlbyname("hw.machine", NULL, &size, NULL, 0);
	
	// Allocate the space to store name
	char *name = malloc(size);
	
	// Get the platform name
	sysctlbyname("hw.machine", name, &size, NULL, 0);
	
	// Place name into a string
	NSString *deviceTypeCode = [NSString stringWithCString: name
												  encoding: NSUTF8StringEncoding];
	// Done with this
	free(name);
	
	return deviceTypeCode;
}

+ (NSString *) deviceType {
	
	NSString *devTypeCode = [JFDeviceDetector deviceTypeCode];
	
	if ([devTypeCode isEqualToString: @"i386"]) {
		return @"iPhone Simulator";
	}
	else if ([devTypeCode isEqualToString: @"iPhone1,1"]) {
		return @"iPhone";
	}
	else if ([devTypeCode isEqualToString: @"iPhone1,2"]) {
		return @"3G iPhone";
	}
	else if ([devTypeCode isEqualToString: @"iPhone2,1"]) {
		return @"3GS iPhone";
	}
	else if ([devTypeCode isEqualToString: @"iPhone4,1"]) {
		return @"4S iPhone";
	}
	else if ([devTypeCode isEqualToString: @"iPod1,1"]) {
		return @"1st Gen iPod";
	}
	else if ([devTypeCode isEqualToString: @"iPod2,1"]) {
		return @"2nd Gen iPod";
	}
	else if ([devTypeCode isEqualToString: @"iPod3,1"]) {
		return @"3nd Gen iPod";
	}
	else if ([devTypeCode isEqualToString: @"iPod4,1"]) {
		return @"4th Gen iPod";
	}
	else if ([devTypeCode isEqualToString: @"iPod5,1"]) {
		return @"5th Gen iPod";
	}
	else if ([devTypeCode isEqualToString: @"iPod6,1"]) {
		return @"6th Gen iPod";
	}
	
	else {
		return @"CCTypeUnknown";
	}
}

+ (BOOL) isLowMemoryDevice {
	return ([[JFDeviceDetector deviceType] isEqualToString: @"iPhone"]       ||
			[[JFDeviceDetector deviceType] isEqualToString: @"3G iPhone"]    ||
			[[JFDeviceDetector deviceType] isEqualToString: @"1st Gen iPod"]);
}
@end



