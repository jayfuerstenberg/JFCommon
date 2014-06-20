//
// JFSocketReader.m
// JFCommon
//
// Created by Jason Fuerstenberg on 11/12/18.
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


#import "JFSocketReader.h"


@implementation JFSocketReader

/*
 * Reads as many as 200,000 bytes from the provided socket into the passed data.
 * Returns the actual numbers of bytes read.
 */
+ (NSInteger) readByteCount: (NSUInteger) byteCount fromSocket: (NSInteger) socket intoData: (NSMutableData *) data {
    
	NSUInteger limit = 200000;
    char buffer[limit];
	if (byteCount > 200000) {
		byteCount = limit;
	}
    ssize_t bytesRead = read((int) socket, buffer, byteCount);
    
    if (bytesRead > 0) {
        [data appendBytes: buffer length: bytesRead];
    }
    
    return bytesRead;
}

@end
