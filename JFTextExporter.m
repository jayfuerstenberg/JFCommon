//
// JFTextExporter.m
// JFCommon
//
// Created by Jason Fuerstenberg on 2013/09/01.
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


#import "JFTextExporter.h"

@implementation JFTextExporter

+ (void) exportBoolean: (BOOL) boo withKey: (NSString *) key toString: (NSMutableString *) outString atIndentation: (NSUInteger) indentation {
	
	[JFTextExporter appendIndentation: indentation
							 toString: outString];
	
	if ([key length] > 0) {
		[outString appendFormat: @"%@: ", key];
	}
	
	NSString *value = (boo ? @"yes" : @"no");
	[outString appendFormat: @"%@\n", value];
}

+ (void) exportInteger: (NSInteger) integer withKey: (NSString *) key toString: (NSMutableString *) outString atIndentation: (NSUInteger) indentation {
	
	[JFTextExporter appendIndentation: indentation
							 toString: outString];
	
	if ([key length] > 0) {
		[outString appendFormat: @"%@: ", key];
	}
	
	[outString appendFormat: @"%i\n", integer]; // TODO: add OSX support here too. (%li)
}

+ (void) exportDouble: (double) dubble withKey: (NSString *) key toString: (NSMutableString *) outString atIndentation: (NSUInteger) indentation {
	
	[JFTextExporter appendIndentation: indentation
							 toString: outString];
	
	if ([key length] > 0) {
		[outString appendFormat: @"%@: ", key];
	}
	
	[outString appendFormat: @"%f\n", dubble];
}

+ (void) exportNumber: (NSNumber *) number withKey: (NSString *) key toString: (NSMutableString *) outString atIndentation: (NSUInteger) indentation {
	
	CFNumberType numberType = CFNumberGetType((CFNumberRef) number);
	
	switch (numberType) {
		case kCFNumberSInt8Type:
		case kCFNumberSInt16Type:
		case kCFNumberSInt32Type:
		case kCFNumberSInt64Type:
		case kCFNumberCharType:
		case kCFNumberShortType:
		case kCFNumberIntType:
		case kCFNumberLongType:
		case kCFNumberLongLongType: {
			NSInteger integer = [number integerValue];
			[JFTextExporter exportInteger: integer
								  withKey: key
								 toString: outString
							atIndentation: indentation];
			break;
		}
		case kCFNumberFloatType:
		case kCFNumberCGFloatType:
		case kCFNumberFloat32Type:
		case kCFNumberFloat64Type:
		case kCFNumberDoubleType: {
			double dubble = [number doubleValue];
			[JFTextExporter exportDouble: dubble
								 withKey: key
								toString: outString
						   atIndentation: indentation];
			break;
        default: break;
		}
	}
}

+ (void) exportString: (NSString *) string withKey: (NSString *) key toString: (NSMutableString *) outString atIndentation: (NSUInteger) indentation {
	
	if ([string length] == 0) {
		string = @"";
	}
	
	[JFTextExporter appendIndentation: indentation
							 toString: outString];
	
	if ([key length] > 0) {
		[outString appendFormat: @"%@: ", key];
	}
	
	[outString appendFormat: @"%@\n", string];
}

+ (void) exportDate: (NSDate *) date withKey: (NSString *) key toString: (NSMutableString *) outString atIndentation: (NSUInteger) indentation {
	
	[JFTextExporter appendIndentation: indentation
							 toString: outString];
	
	if ([key length] > 0) {
		[outString appendFormat: @"%@: ", key];
	}
	
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	[dateFormatter setDateStyle: NSDateFormatterMediumStyle];
	[dateFormatter setTimeStyle: NSDateFormatterShortStyle];
	[dateFormatter setLocale: [NSLocale currentLocale]];
	
	NSString *value = [dateFormatter stringFromDate: date];
	[dateFormatter release];
	
	[outString appendFormat: @"%@\n", value];
}

+ (void) exportObject: (id <NSObject>) object withKey: (NSString *) key toString: (NSMutableString *) outString atIndentation: (NSUInteger) indentation {
	
	if (object == nil) {
		return;
	}
	
	Protocol *protocol = @protocol(JFTextExportable);
	if ([object conformsToProtocol: protocol]) {
		// BOX encodable object...
		id <JFTextExportable> exportable = (id <JFTextExportable>) object;
		[JFTextExporter exportExportable: exportable
								 withKey: key
								toString: outString
						   atIndentation: indentation];
		return;
	}
	
	if ([object isKindOfClass: [NSNumber class]]) {
		// NSNumber...
		NSNumber *number = (NSNumber *) object;
		[JFTextExporter exportNumber: number
							 withKey: key
							toString: outString
					   atIndentation: indentation];
		return;
	}
	
	if ([object isKindOfClass: [NSString class]]) {
		// NSString...
		NSString *string = (NSString *) object;
		[JFTextExporter exportString: string
							 withKey: key
							toString: outString
					   atIndentation: indentation];
		return;
	}
	
	if ([object isKindOfClass: [NSDate class]]) {
		// NSDate...
		NSDate *date = (NSDate *) object;
		[JFTextExporter exportDate: date
						   withKey: key
						  toString: outString
					 atIndentation: indentation];
		return;
	}
	
	if ([object isKindOfClass: [NSArray class]]) {
		// NSArray...
		NSArray *array = (NSArray *) object;
		[JFTextExporter exportArray: array
							withKey: key
						   toString: outString
					  atIndentation: indentation];
		return;
	}
	
	if ([object isKindOfClass: [NSDictionary class]]) {
		// NSDictionary...
		NSDictionary *dictionary = (NSDictionary *) object;
		[JFTextExporter exportDictionary: dictionary
								 withKey: key
								toString: outString
						   atIndentation: indentation];
		return;
	}

}


+ (void) exportArray: (NSArray *) array withKey: (NSString *) key toString: (NSMutableString *) outString atIndentation: (NSUInteger) indentation {
	
	[JFTextExporter appendIndentation: indentation
							 toString: outString];
	
	if ([key length] > 0) {
		[outString appendFormat: @"%@:\n", key];
	}
	
	for (id <NSObject> element in array) {
		[JFTextExporter exportObject: element
							 withKey: nil
							toString: outString
					   atIndentation: indentation + 1];
	}
}
		 
+ (void) exportDictionary: (NSDictionary *) dictionary withKey: (NSString *) key toString: (NSMutableString *) outString atIndentation: (NSUInteger) indentation {
	
	[JFTextExporter appendIndentation: indentation
							 toString: outString];
	
	if ([key length] > 0) {
		[outString appendFormat: @"%@:\n", key];
	}
	
	for (NSString *key in dictionary) {
		id <NSObject> value = [dictionary objectForKey: key];
		[JFTextExporter exportObject: value
							 withKey: key
							toString: outString
					   atIndentation: indentation + 1];
	}
}

+ (void) exportExportable: (id <JFTextExportable>) exportable withKey: (NSString *) key toString: (NSMutableString *) outString atIndentation: (NSUInteger) indentation {
	
	if ([key length] > 0) {
		[outString appendFormat: @"%@:\n", key];
	}
	
	[exportable exportToString: outString
				 atIndentation: indentation];
}

+ (void) appendIndentation: (NSUInteger) indentation toString: (NSMutableString *) outString {
	
	for (NSUInteger index = 0; index < indentation; index++) {
		[outString appendString: @"\t"];
	}
}

@end
