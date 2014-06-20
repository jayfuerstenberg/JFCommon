//
// JFSocketWriter.m
// JFCommon
//
// Created by Jason Fuerstenberg on 11/12/19.
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


#import "JFSocketWriter.h"


@implementation JFSocketWriter

/*
 * Writes bytes from the data into the provided socket.
 * Returns the number of bytes successfully written.
 */
+ (NSInteger) writeData: (NSData *) data fromOffset: (NSUInteger) offset intoSocket: (NSInteger) socket {
	
	if (socket < 0) {
		// There is nowhere to write the data.
		return 0;
	}
	
	NSUInteger length = [data length];
	if (length == 0) {
		// There is no data to write.
		return 0;
	}
	
	if (offset >= length) {
		// There is no more data to write.
		return 0;
	}
	
	char *buffer = (char *) [data bytes];
	NSUInteger remainingLength = length - offset;
	
	return write((int) socket, &buffer[offset], remainingLength);
}

@end
