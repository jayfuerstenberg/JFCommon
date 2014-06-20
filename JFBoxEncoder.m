//
// JFBoxEncoder.m
// JFCommon
//
// Created by Jason Fuerstenberg on 12/03/19.
// Copyright (c) 2012 Jason Fuerstenberg. All rights reserved.
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


#import "JFBoxEncoder.h"


@interface JFBoxEncoder (PrivateMethods) // TODO: try to get rid of this now that Xcode 4.3.2 doesn't require it.

- (void) appendHeader;
+ (JFBoxType) boxTypeForNumber: (NSNumber *) number;

@end


@implementation JFBoxEncoder


#pragma mark - Properties

@synthesize data = _data;


#pragma mark - Object lifecycle methods

+ (id) boxEncoderWithData: (NSMutableData *) data {
	
	id boxEncoder = [[JFBoxEncoder alloc] initWithData: data];
	
	#if  __has_feature(objc_arc)
		// Using ARC so do nothing
	#else
		// Autorelease the instance
		[boxEncoder autorelease];
	#endif
	
	return boxEncoder;
}

/*
 * Instantiates a box encoder with a mutale data to populate.
 */
- (id) initWithData: (NSMutableData *) data {
	
	self = [super init];
	if (self != nil) {
		#if __has_feature(objc_arc)
			_data = data;
		#else
			[data retain];
			[_data release];
			_data = data;
		#endif
		[self appendHeader];
	}
	
	return self;
}

#if __has_feature(objc_arc)
// Using ARC so do nothing
- (void) dealloc {
	
    _data = nil;
}
#else
- (void) dealloc {
	
    [_data release];
    [super dealloc];
}
#endif


#pragma mark - Encoding methods

- (void) encodeNil {
	
	JFBoxType type = JFBoxTypeNil;
	
	[_data appendBytes: &type length: 1];
}

- (void) encodeBool: (BOOL) value {
	
	JFBoxType type = JFBoxTypeBool;
	SInt8 internalValue = value;
	
	[_data appendBytes: &type length: 1];
	[_data appendBytes: &internalValue length: sizeof(SInt8)];
}

- (void) encodeSInt8: (SInt8) value {
	
	JFBoxType type = JFBoxTypeSInt8;
	SInt8 internalValue = value;
	
	[_data appendBytes: &type length: 1];
	[_data appendBytes: &internalValue length: sizeof(SInt8)];
}

- (void) encodeSInt16: (SInt16) value {
	
	JFBoxType type = JFBoxTypeSInt16;
	SInt16 internalValue = value;
	
	[_data appendBytes: &type length: 1];
	[_data appendBytes: &internalValue length: sizeof(SInt16)];
}

- (void) encodeSInt32: (SInt32) value {
	
	JFBoxType type = JFBoxTypeSInt32;
	SInt32 internalValue = value;
	
	[_data appendBytes: &type length: 1];
	[_data appendBytes: &internalValue length: sizeof(SInt32)];
}

- (void) encodeSInt64: (SInt64) value {
	
	JFBoxType type = JFBoxTypeSInt64;
	SInt64 internalValue = value;
	
	[_data appendBytes: &type length: 1];
	[_data appendBytes: &internalValue length: sizeof(SInt64)];
}

- (void) encodeUInt8: (UInt64) value {
	
	JFBoxType type = JFBoxTypeUInt8;
	UInt8 internalValue = value;
	
	[_data appendBytes: &type length: 1];
	[_data appendBytes: &internalValue length: sizeof(UInt8)];
}

- (void) encodeUInt16: (UInt16) value {
	
	JFBoxType type = JFBoxTypeUInt16;
	UInt16 internalValue = value;
	
	[_data appendBytes: &type length: 1];
	[_data appendBytes: &internalValue length: sizeof(UInt16)];
}

- (void) encodeUInt32: (UInt32) value {
	
	JFBoxType type = JFBoxTypeUInt32;
	UInt32 internalValue = value;
	
	[_data appendBytes: &type length: 1];
	[_data appendBytes: &internalValue length: sizeof(UInt32)];
}

- (void) encodeUInt64: (UInt64) value {
	
	JFBoxType type = JFBoxTypeUInt64;
	UInt64 internalValue = value;
	
	[_data appendBytes: &type length: 1];
	[_data appendBytes: &internalValue length: sizeof(UInt64)];
}

- (void) encodeFloat: (float) value {
	
	JFBoxType type = JFBoxTypeFloat;
	float internalValue = value;
	
	[_data appendBytes: &type length: 1];
	[_data appendBytes: &internalValue length: sizeof(float)];
}

- (void) encodeDouble: (double) value {
	
	JFBoxType type = JFBoxTypeDouble;
	double internalValue = value;
	
	[_data appendBytes: &type length: 1];
	[_data appendBytes: &internalValue length: sizeof(double)];
}

/*
 * If nil, nothing is encoded.
 */
- (void) encodeString: (NSString *) value {
	
	JFBoxType type = JFBoxTypeString;
	[_data appendBytes: &type length: 1];
	[self appendNilOrNotNilForObject: value];
	
	if (value == nil) {
		return;
	}
	
	const char *internalValue = [value UTF8String];
	UInt64 valueLength = [value lengthOfBytesUsingEncoding: NSUTF8StringEncoding];

	
	// Write the length in bytes first...
	[_data appendBytes: &valueLength length: sizeof(UInt64)];
	
	// Write the string value...
	[_data appendBytes: internalValue length: valueLength];
}

/*
 * If nil, nothing is encoded.
 */
- (void) encodeNumber: (NSNumber *) value {
		
	JFBoxType type = JFBoxTypeNumber;
	[_data appendBytes: &type length: 1];
	[self appendNilOrNotNilForObject: value];
	
	if (value == nil) {
		return;
	}
	
	JFBoxType numberType = [JFBoxEncoder boxTypeForNumber: value];
	if (numberType == JFBoxTypeUnknown) {
		return;
	}
	
	switch (numberType) {
		case JFBoxTypeBool:
			[self encodeBool: [value boolValue]];
			break;
		case JFBoxTypeSInt8:
			[self encodeSInt8: [value integerValue]];
			break;
		case JFBoxTypeSInt16:
			[self encodeSInt16: [value integerValue]];
			break;
		case JFBoxTypeSInt32:
			[self encodeSInt32: [value longValue]]; // TODO: is this right?  Unit test has some encoded data size issues to resolve.
			break;	
		case JFBoxTypeSInt64:
			[self encodeSInt64: [value longLongValue]];
			break;
		case JFBoxTypeUInt8:
			[self encodeUInt8: [value integerValue]];
			break;
		case JFBoxTypeUInt16:
			[self encodeUInt16: [value integerValue]];
			break;
		case JFBoxTypeUInt32:
			[self encodeUInt32: [value longValue]];
			break;
		case JFBoxTypeUInt64:
			[self encodeUInt64: [value longLongValue]];
			break;
		case JFBoxTypeFloat:
			[self encodeFloat: [value floatValue]];
			break;
		case JFBoxTypeDouble:
			[self encodeDouble: [value doubleValue]];
			break;
		default:
			break;
	}
}

/*
 * Encodes the provided date.
 * NOTE: This method encodes the date since Jan 1st 1970 as an NSTimeInterval (double).
 * If this does not agree with your application's date logic you are advised to convert your
 * NSDate instances manually using a different reference date.
 * If nil, nothing is encoded.
 */
- (void) encodeDate: (NSDate *) value {
	
	JFBoxType type = JFBoxTypeDate;
	[_data appendBytes: &type length: 1];
	[self appendNilOrNotNilForObject: value];
	
	if (value == nil) {
		return;
	}
	
	if (![value isKindOfClass: [NSDate class]]) {
		// Append nil.
		[self appendNilOrNotNilForObject: nil];
		return;
	}
	
	NSTimeInterval internalValue = [value timeIntervalSince1970];
	[_data appendBytes: &internalValue length: sizeof(NSTimeInterval)];
}

- (void) encodeData: (NSData *) value {
		
	JFBoxType type = JFBoxTypeData;	
	[_data appendBytes: &type length: 1];
	[self appendNilOrNotNilForObject: value];
	
	if (value == nil) {
		return;
	}
	
	if (![value isKindOfClass: [NSData class]]) {
		// Append nil.
		[self appendNilOrNotNilForObject: nil];
		return;
	}
	
	UInt64 valueLength = [value length];
	
	// Write the length in bytes first...
	[_data appendBytes: &valueLength length: sizeof(UInt64)];
	
	// Write the data value...
	if (valueLength > 0) {
		[_data appendData: value];
	}
}

/*
 * NOTE: If any element of the Array is not a supported type (not scalar, date, array, dictionary or Box encodable) it will be omitted from the encoding.
 *
 * If nil, nothing is encoded.
 */
- (void) encodeArray: (NSArray *) value {
	
	UInt8 type = JFBoxTypeArray;
	[_data appendBytes: &type length: 1];
	[self appendNilOrNotNilForObject: value];
	
	if (value == nil) {
		return;
	}
	
	UInt64 elementCount = [value count];
	// Write the element count first...
	[_data appendBytes: &elementCount length: sizeof(UInt64)];
	
	NSMutableData *_masterData = _data;
	_data = [NSMutableData dataWithCapacity: elementCount * 100];
	
	@synchronized (value) {
		for (id <NSObject> element in value) {
			
			if (element == nil) {
				[self encodeNil];
				continue;
			}
			
			Protocol *protocol = @protocol(JFBoxEncodable);
			if ([element conformsToProtocol: protocol]) {
				// BOX encodable object...
				id <JFBoxEncodable> boxEncodable = (id <JFBoxEncodable>) element;
				[self encodeBoxEncodable: boxEncodable];
				continue;
			}
			
			if ([element isKindOfClass: [NSNumber class]]) {
				// NSNumber...
				NSNumber *number = (NSNumber *) element;
				[self encodeNumber: number];
				continue;
			}
			
			if ([element isKindOfClass: [NSString class]]) {
				// NSString...
				NSString *string = (NSString *) element;
				[self encodeString: string];
				continue;
			}
			
			if ([element isKindOfClass: [NSDate class]]) {
				// NSDate...
				NSDate *date = (NSDate *) element;
				[self encodeDate: date];
				continue;
			}
			
			if ([element isKindOfClass: [NSData class]]) {
				// NSData...
				NSData *data = (NSData *) element;
				[self encodeData: data];
				continue;
			}
			
			if ([element isKindOfClass: [NSArray class]]) {
				// NSArray...
				NSArray *array = (NSArray *) element;
				[self encodeArray: array];
				continue;
			}
			
			if ([element isKindOfClass: [NSDictionary class]]) {
				// NSDictionary...
				NSDictionary *dictionary = (NSDictionary *) element;
				[self encodeDictionary: dictionary];
				continue;
			}
		}
		
		UInt64 encodedArrayLength = [_data length];
		NSMutableData *encodedArray = _data;
		_data = _masterData;
		
		// Write the array length in bytes...
		[_data appendBytes: &encodedArrayLength length: sizeof(UInt64)];
		[_data appendData: encodedArray];
	}
}

/*
 * Encodes the provided dictionary to this box encoder.
 * If nil, nothing is encoded.
 */
- (void) encodeDictionary: (NSDictionary *) value {
		
	UInt8 type = JFBoxTypeDictionary;
	[_data appendBytes: &type length: 1];
	[self appendNilOrNotNilForObject: value];
	
	if (value == nil) {
		return;
	}
	
	UInt64 elementCount = [value count];
	// Write the element count first...
	[_data appendBytes: &elementCount length: sizeof(UInt64)];
	
	NSMutableData *_masterData = _data;
	_data = [NSMutableData dataWithCapacity: elementCount * 100];
	
	@synchronized (value) {
		for (id <NSObject> key in value) {
			
			if (![key isKindOfClass: [NSString class]]) {
				// All keys must be strings in BOX so continue to the next element...
				continue;
			}
			
			id <NSObject> element = [value objectForKey: key];
			NSString *keyAsString = (NSString *) key;
			const char *internalKey = [keyAsString UTF8String];
			UInt64 keyLength = [keyAsString lengthOfBytesUsingEncoding: NSUTF8StringEncoding];
			
			// Write the key length and value...
			[_data appendBytes: &keyLength length: sizeof(UInt64)];
			[_data appendBytes: internalKey length: keyLength];
			
			
			if (element == nil) {
				[self encodeNil];
				continue;
			}
			
			Protocol *protocol = @protocol(JFBoxEncodable);
			if ([element conformsToProtocol: protocol]) {
				// BOX encodable object...
				id <JFBoxEncodable> boxEncodable = (id <JFBoxEncodable>) element;
				[self encodeBoxEncodable: boxEncodable];
				continue;
			}
			
			if ([element isKindOfClass: [NSNumber class]]) {
				// NSNumber...
				NSNumber *number = (NSNumber *) element;
				[self encodeNumber: number];
				continue;
			}
			
			if ([element isKindOfClass: [NSString class]]) {
				// NSString...
				NSString *string = (NSString *) element;
				[self encodeString: string];
				continue;
			}
			
			if ([element isKindOfClass: [NSDate class]]) {
				// NSDate...
				NSDate *date = (NSDate *) element;
				[self encodeDate: date];
				continue;
			}
			
			if ([element isKindOfClass: [NSData class]]) {
				// NSData...
				NSData *data = (NSData *) element;
				[self encodeData: data];
				continue;
			}
			
			if ([element isKindOfClass: [NSArray class]]) {
				// NSArray...
				NSArray *array = (NSArray *) element;
				[self encodeArray: array];
				continue;
			}
			
			if ([element isKindOfClass: [NSDictionary class]]) {
				// NSDictionary...
				NSDictionary *dictionary = (NSDictionary *) element;
				[self encodeDictionary: dictionary];
				continue;
			}
		}
		
		UInt64 encodedDictionaryLength = [_data length];
		NSMutableData *encodedDictionary = _data;
		_data = _masterData;
		
		// Write the array length in bytes...
		[_data appendBytes: &encodedDictionaryLength length: sizeof(UInt64)];
		[_data appendData: encodedDictionary];
	}
}

/*
 * Encodes a JFBoxEncodable implementing class instance to this encoder.
 * If nil, nothing is encoded.
 */
- (void) encodeBoxEncodable: (id <JFBoxEncodable>) value {
	
	JFBoxType type = JFBoxTypeBoxEncodable;
	
	[_data appendBytes: &type length: 1];
	[self appendNilOrNotNilForObject: value];
	
	if (value == nil) {
		return;
	}
	
	NSString *className = NSStringFromClass([value class]);
	const char *internalClassName = [className UTF8String];
	UInt64 classNameLength = [className lengthOfBytesUsingEncoding: NSUTF8StringEncoding];
	
	
	// Write the class name...
	[_data appendBytes: &classNameLength length: sizeof(UInt64)];
	[_data appendBytes: internalClassName length: classNameLength];
	
	NSMutableData *masterData = _data;
	_data = [NSMutableData dataWithCapacity: 1000];
	
	/*
	 * Only the object knows how to encode itself so
	 * let it go to work...
	 */
	UInt16 formatVersion = [value encodeWithBoxEncoder: self];
	
	UInt64 boxEncodableObjectLength = [_data length];
	NSData *boxEncodedObjectData = _data;
	_data = masterData;
	[_data appendBytes: &formatVersion length: sizeof(UInt16)];
	[_data appendBytes: &boxEncodableObjectLength length: sizeof(UInt64)];
	
	[_data appendData: boxEncodedObjectData];
}


- (void) appendNilOrNotNilForObject: (id) object {
	
	UInt8 nilOrNot = JFBoxNotNilObjectValue;
	
	if (object == nil) {
		nilOrNot = JFBoxNilObjectValue;
	}
	
	[_data appendBytes: &nilOrNot length: sizeof(UInt8)];
}


#pragma mark - Private methods

- (void) appendHeader {
	
	UInt16 boxFormatVersion = JFBoxFormatVersion;
	
	// Write the length in bytes first...
	[_data appendBytes: "BOX" length: 3];
	
	// Write the string value...
	[_data appendBytes: &boxFormatVersion length: sizeof(UInt16)];
}

+ (JFBoxType) boxTypeForNumber: (NSNumber *) number {
	
	CFNumberType numberType = CFNumberGetType((CFNumberRef) number);
	
	switch (numberType) {
		case kCFNumberSInt8Type: return JFBoxTypeSInt8;
		case kCFNumberSInt16Type: return JFBoxTypeSInt16;
		case kCFNumberSInt32Type: return JFBoxTypeSInt32;
		case kCFNumberSInt64Type: return JFBoxTypeSInt64;
		case kCFNumberCharType: return JFBoxTypeSInt8;
		case kCFNumberShortType: return JFBoxTypeSInt16;
		case kCFNumberIntType:
		case kCFNumberLongType: return JFBoxTypeSInt32;
		case kCFNumberLongLongType: return JFBoxTypeSInt64;
		case kCFNumberFloatType:
		case kCFNumberCGFloatType:
		case kCFNumberFloat32Type: return JFBoxTypeFloat;
		case kCFNumberFloat64Type:
		case kCFNumberDoubleType: return JFBoxTypeDouble;
        default: break;
                // This is for handling types the compilers seems to warn about, and that I don't much care about.
	}
	
	return JFBoxTypeUnknown;
}

@end
