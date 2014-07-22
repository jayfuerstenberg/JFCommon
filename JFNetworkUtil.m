//
// JFNetworkUtil.m
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


#import "JFNetworkUtil.h"


@implementation JFNetworkUtil

/*
 * Returns YES if the device is connected to the network, be it 3G or Wi-Fi.
 */
+ (BOOL) isConnectedToNetwork {
	
	struct sockaddr_in zeroAddress;
	bzero(&zeroAddress, sizeof(zeroAddress));
	zeroAddress.sin_len = sizeof(zeroAddress);
	zeroAddress.sin_family = AF_INET;
	
	SCNetworkReachabilityRef defaultRouteReachability = SCNetworkReachabilityCreateWithAddress(NULL, (struct sockaddr *) &zeroAddress);
	SCNetworkReachabilityFlags flags;
	
	BOOL didRetrieveFlags = SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags);
	CFRelease(defaultRouteReachability);
	
	if (!didRetrieveFlags) {
		return NO;
	}
	
	BOOL isReachable = flags & kSCNetworkFlagsReachable;
	BOOL needsConnection = flags & kSCNetworkFlagsConnectionRequired;
	
#if TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR
	// 3G/LTE network support
	BOOL nonWiFi = flags & kSCNetworkReachabilityFlagsTransientConnection;
#else
	BOOL nonWiFi = NO;
#endif
	
	BOOL result = (isReachable && !needsConnection) || nonWiFi;
	return result;
}

+ (BOOL) isConnectedToWifi {

	struct sockaddr_in zeroAddress;
	bzero(&zeroAddress, sizeof(zeroAddress));
	zeroAddress.sin_len = sizeof(zeroAddress);
	zeroAddress.sin_family = AF_INET;
	
	SCNetworkReachabilityRef defaultRouteReachability = SCNetworkReachabilityCreateWithAddress(NULL, (struct sockaddr *) &zeroAddress);
	SCNetworkReachabilityFlags flags;
	
	BOOL didRetrieveFlags = SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags);
	CFRelease(defaultRouteReachability);
	
	if (!didRetrieveFlags) {
		return NO;
	}
	
	BOOL isReachable = flags & kSCNetworkFlagsReachable;
	BOOL needsConnection = flags & kSCNetworkFlagsConnectionRequired;
	BOOL nonWiFi = flags & kSCNetworkReachabilityFlagsTransientConnection;
	
	return (isReachable && !needsConnection) && !nonWiFi;
}

+ (NSString *) getIPAddress {
    
	NSString *address = @"error";
	struct ifaddrs *interfaces = NULL;
	struct ifaddrs *temp_addr = NULL;
	int success = 0;
	
	// retrieve the current interfaces - returns 0 on success
	success = getifaddrs(&interfaces);
	if (success == 0) {
		// Loop through linked list of interfaces
		temp_addr = interfaces;
		while (temp_addr != NULL) {
			if (temp_addr->ifa_addr->sa_family == AF_INET) {
				// Check if interface is en0 which is the wifi connection on the iPhone
				if ([[NSString stringWithUTF8String: temp_addr->ifa_name] isEqualToString: @"en0"]) {
					// Get NSString from C String
					address = [NSString stringWithUTF8String: inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
				}
			}
			
			temp_addr = temp_addr->ifa_next;
		}
	}
	
	// Free memory
	freeifaddrs(interfaces);
	
	return address;
}


+ (NSString *) localIpAddress {
	
	NSString *ipAddress = [self getIPAddress];
	
	if (![ipAddress isEqualToString: @"error"]) {
		return ipAddress;
	}
	
	char baseHostName[255];
	gethostname((char *) baseHostName, 255);
	
	char hn[255];
	char *hn2 = NULL;
	
	if (strstr(baseHostName, ".local") == NULL) {
		sprintf(hn, "%s.local", baseHostName);
		hn2 = hn;
	} else {
		hn2 = baseHostName;
	}
	
	struct hostent *host = gethostbyname(hn2);
	if (host == NULL) {
		return nil;
	}
	
	struct in_addr **list = (struct in_addr **) host->h_addr_list;
	
	return [NSString stringWithUTF8String: inet_ntoa(*list[0])];
}


#if TARGET_OS_IPHONE && !TARGET_IPHONE_SIMULATOR

+ (NSString *) wifiNetworkName {
    
    NSString *networkName = nil;

    CFArrayRef myArray = CNCopySupportedInterfaces();
    CFDictionaryRef captiveNtwrkDict = CNCopyCurrentNetworkInfo(CFArrayGetValueAtIndex(myArray, 0));
    NSDictionary *dict = (__bridge NSDictionary *) captiveNtwrkDict;
    NSString *ssid = [dict objectForKey: @"SSID"];
    if ([ssid length] > 0) {
        networkName = ssid;
    }
    
    return networkName;
}

#elif TARGET_IPHONE_SIMULATOR

+ (NSString *) wifiNetworkName {
    
    return @"Not detectable from iOS Simulator";
}

#else

+ (NSString *) wifiNetworkName {

    CWInterface *wif = [CWInterface interface];
    NSString *networkName = nil;

   if (wif != nil && wif.ssid != nil) {
       networkName = wif.ssid;
   }

    return networkName;
}

#endif

@end
