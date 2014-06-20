//
// JFBoxDecoder.m
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

#import "JFBoxDecoder.h"


@interface JFBoxDecoder (PrivateMethods)

- (void) decodeHeader;
+ (void) populateError: (NSError **) error withCode: (SInt64) code;
- (UInt64) copy: (UInt64) numberOfBytes fromIndex: (UInt64) index ofData: (NSData *) data intoBytes: (char *) bytes withError: (NSError **) error;
+ (BOOL) isSupportedNumberType: (JFBoxType) boxType;

@end



@implementation JFBoxDecoder


#pragma mark - Properties

@synthesize index = _index;
@synthesize encounteredError = _encounteredError;


#pragma mark - Object lifecycle methods

+ (id) boxDecoderWithData: (NSData *) data {
	
	id boxDecoder = [[JFBoxDecoder alloc] initWithData: data];
	
	#if __has_feature(objc_arc)
		// Using ARC so do nothing
	#else
		// Autorelease the instance
		[boxDecoder autorelease];
	#endif
	
	return boxDecoder;
}

/*
 * Instantiates a box decoder with data from which to decode.
 * data must not be nil or less than 5 bytes.
 */
- (id) initWithData: (NSData *) data {
	
	if ([data length] < JFBoxFormat1HeaderLength) {
		return nil;
	}
	
	self = [super init];
	if (self != nil) {
		#if __has_feature(objc_arc)
			_data = data;
		#else
			[data retain];
			[_data release];
			_data = data;
		#endif
		
		[self decodeHeader];
		if (_encounteredError) {
			return nil;
		}
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


/*
 * Returns the type of the next entry.
 * NOTE: Calling this method will not advance the decoder's index into the data.
 */
- (JFBoxType) nextEntryType {
		
	NSError *error = nil;
	JFBoxType type;
	[self copy: JFBoxTypeEncodingLength fromIndex: _index ofData:_data intoBytes: (char *) &type withError: &error];

	if ([error code] != 0) {
		_encounteredError = YES;
		return JFBoxTypeUnknown;
	}
	
	return type;
}


#pragma mark - Decoding methods

/*
 * This method ensures that the next entry is nil before advancing the index.
 * If the next entry is not nil a type mismatch error will be assigned.
 */
- (void) decodeNilWithError: (NSError **) error {
    
    [JFBoxDecoder resetError: error];
	
	JFBoxType nextType = [self nextEntryType];
	if (nextType != JFBoxTypeNil) {
		// The type is not nil so return.
		_encounteredError = YES;
		[JFBoxDecoder populateError: error
                           withCode: JFBoxDecoderErrorTypeMismatch];
		return;
	}
	
	_index += JFBoxTypeEncodingLength;
}

- (BOOL) decodeBoolWithError: (NSError **) error {
    
    [JFBoxDecoder resetError: error];
	
	JFBoxType nextType = [self nextEntryType];
	if (nextType != JFBoxTypeBool) {
		// The type is not boolean so return.
		_encounteredError = YES;
		[JFBoxDecoder populateError: error
                           withCode: JFBoxDecoderErrorTypeMismatch];
		return NO;
	}
	
	_index += JFBoxTypeEncodingLength;
	
	BOOL value;
	_index += [self copy: JFBoxBoolEncodingLength
			   fromIndex: _index
				  ofData: _data
			   intoBytes: (char *) &value
			   withError: error];
	
	if (_encounteredError) {
		return NO;
	}
	
	return value;
}

- (SInt8) decodeSInt8WithError: (NSError **) error {
    
    [JFBoxDecoder resetError: error];

	JFBoxType nextType = [self nextEntryType];
	if (nextType != JFBoxTypeSInt8) {
		// The type is not SInt8 so return.
		_encounteredError = YES;
		[JFBoxDecoder populateError: error
                           withCode: JFBoxDecoderErrorTypeMismatch];
		return 0;
	}
	
	_index += JFBoxTypeEncodingLength;
	
	SInt8 value;
	_index += [self copy: JFBoxSInt8EncodingLength
			 fromIndex: _index
				ofData: _data
			 intoBytes: (char *) &value
			 withError: error];
	
	if (_encounteredError) {
		return 0;
	}
	
	return value;
}


- (SInt16) decodeSInt16WithError: (NSError **) error {
    
    [JFBoxDecoder resetError: error];
	
	JFBoxType nextType = [self nextEntryType];
	if (nextType != JFBoxTypeSInt16) {
		// The type is not SInt16 so return.
		_encounteredError = YES;
		[JFBoxDecoder populateError: error
                           withCode: JFBoxDecoderErrorTypeMismatch];
		return 0;
	}
	
	_index += JFBoxTypeEncodingLength;
	
	SInt16 value;
	_index += [self copy: JFBoxSInt16EncodingLength
			   fromIndex: _index
				  ofData: _data
			   intoBytes: (char *) &value
			   withError: error];
	
	if (_encounteredError) {
		return 0;
	}
	
	return value;
}

- (SInt32) decodeSInt32WithError: (NSError **) error {
    
    [JFBoxDecoder resetError: error];
	
	JFBoxType nextType = [self nextEntryType];
	if (nextType != JFBoxTypeSInt32) {
		// The type is not SInt32 so return.
		_encounteredError = YES;
		[JFBoxDecoder populateError: error
                           withCode: JFBoxDecoderErrorTypeMismatch];
		return 0;
	}
	
	_index += JFBoxTypeEncodingLength;
	
	SInt32 value;
	_index += [self copy: JFBoxSInt32EncodingLength
			   fromIndex: _index
				  ofData: _data
			   intoBytes: (char *) &value
			   withError: error];

	if (_encounteredError) {
		return 0;
	}
	
	return value;
}

- (SInt64) decodeSInt64WithError: (NSError **) error {
    
    [JFBoxDecoder resetError: error];
	
	JFBoxType nextType = [self nextEntryType];
	if (nextType != JFBoxTypeSInt64) {
		// The type is not SInt64 so return.
		_encounteredError = YES;
		[JFBoxDecoder populateError: error
                           withCode: JFBoxDecoderErrorTypeMismatch];
		return 0;
	}
	
	_index += JFBoxTypeEncodingLength;
	
	SInt64 value;
	_index += [self copy: JFBoxSInt64EncodingLength
			   fromIndex: _index
				  ofData: _data
			   intoBytes: (char *) &value
			   withError: error];

	if (_encounteredError) {
		return 0;
	}
	
	return value;
}

- (UInt8) decodeUInt8WithError: (NSError **) error {
    
    [JFBoxDecoder resetError: error];

	JFBoxType nextType = [self nextEntryType];
	if (nextType != JFBoxTypeUInt8) {
		// The type is not UInt8 so return.
		_encounteredError = YES;
		[JFBoxDecoder populateError: error
                           withCode: JFBoxDecoderErrorTypeMismatch];
		return 0;
	}
	
	_index += JFBoxTypeEncodingLength;
	
	UInt8 value;
	_index += [self copy: JFBoxUInt8EncodingLength
			   fromIndex: _index
				  ofData: _data
			   intoBytes: (char *) &value
			   withError: error];
	
	if (_encounteredError) {
		return 0;
	}
	
	return value;
}

- (UInt16) decodeUInt16WithError: (NSError **) error {
    
    [JFBoxDecoder resetError: error];
	
	JFBoxType nextType = [self nextEntryType];
	if (nextType != JFBoxTypeUInt16) {
		// The type is not UInt16 so return.
		_encounteredError = YES;
		[JFBoxDecoder populateError: error
                           withCode: JFBoxDecoderErrorTypeMismatch];
		return 0;
	}
	
	_index += JFBoxTypeEncodingLength;
	
	UInt16 value;
	_index += [self copy: JFBoxUInt16EncodingLength
			   fromIndex: _index
				  ofData: _data
			   intoBytes: (char *) &value
			   withError: error];

	if (_encounteredError) {
		return 0;
	}
	
	return value;
}

- (UInt32) decodeUInt32WithError: (NSError **) error {
    
    [JFBoxDecoder resetError: error];

	JFBoxType nextType = [self nextEntryType];
	if (nextType != JFBoxTypeUInt32) {
		// The type is not UInt32 so return.
		[JFBoxDecoder populateError: error
                           withCode: JFBoxDecoderErrorTypeMismatch];
		return 0;
	}
	
	_index += JFBoxTypeEncodingLength;
	
	UInt32 value;
	_index += [self copy: JFBoxUInt32EncodingLength
			   fromIndex: _index
				  ofData: _data
			   intoBytes: (char *) &value
			   withError: error];

	if (_encounteredError) {
		return 0;
	}
	
	return value;
}

- (UInt64) decodeUInt64WithError: (NSError **) error {
    
    [JFBoxDecoder resetError: error];
	
	JFBoxType nextType = [self nextEntryType];
	if (nextType != JFBoxTypeUInt64) {
		// The type is not UInt64 so return.
		_encounteredError = YES;
		[JFBoxDecoder populateError: error
                           withCode: JFBoxDecoderErrorTypeMismatch];
		return 0;
	}
	
	_index += JFBoxTypeEncodingLength;
	
	UInt64 value;
	_index += [self copy: JFBoxUInt64EncodingLength
			   fromIndex: _index
				  ofData: _data
			   intoBytes: (char *) &value
			   withError: error];

	if (_encounteredError) {
		return 0;
	}
	
	return value;
}

- (float) decodeFloatWithError: (NSError **) error {
    
    [JFBoxDecoder resetError: error];

	JFBoxType nextType = [self nextEntryType];
	if (nextType != JFBoxTypeFloat) {
		// The type is not float so return.
		_encounteredError = YES;
		[JFBoxDecoder populateError: error
                           withCode: JFBoxDecoderErrorTypeMismatch];
		return 0;
	}
	
	_index += JFBoxTypeEncodingLength;
	
	float value;
	_index += [self copy: JFBoxFloatEncodingLength
			   fromIndex: _index
				  ofData: _data
			   intoBytes: (char *) &value
			   withError: error];

	if (_encounteredError) {
		return 0;
	}
	
	return value;
}

- (double) decodeDoubleWithError: (NSError **) error {
    
    [JFBoxDecoder resetError: error];
	
	JFBoxType nextType = [self nextEntryType];
	if (nextType != JFBoxTypeDouble) {
		// The type is not double so return.
		_encounteredError = YES;
		[JFBoxDecoder populateError: error
                           withCode: JFBoxDecoderErrorTypeMismatch];
		return 0;
	}
	
	_index += JFBoxTypeEncodingLength;
	
	double value;
	_index += [self copy: JFBoxDoubleEncodingLength
			   fromIndex: _index
				  ofData: _data
			   intoBytes: (char *) &value
			   withError: error];
	
	if (_encounteredError) {
		return 0;
	}
	
	return value;
}

- (NSString *) decodeStringWithError: (NSError **) error {
    
    [JFBoxDecoder resetError: error];

	JFBoxType nextType = [self nextEntryType];
	if (nextType != JFBoxTypeString) {
		// The type is not string so return.
		_encounteredError = YES;
		[JFBoxDecoder populateError: error
                           withCode: JFBoxDecoderErrorTypeMismatch];
		return nil;
	}
	
	_index += JFBoxTypeEncodingLength;
	
	if ([self isNilObject]) {
		return nil;
	}
	
	UInt64 length;
	_index += [self copy: JFBoxUInt64EncodingLength
			   fromIndex: _index
				  ofData: _data
			   intoBytes: (char *) &length
			   withError: error];
	
	if (_encounteredError) {
		return nil;
	}
	
	char *buffer = malloc(length + 1);
	buffer[length] = 0;
	_index += [self copy: length
			   fromIndex: _index
				  ofData: _data
			   intoBytes: (char *) buffer
			   withError: error];
	
	if (_encounteredError) {
		free(buffer);
		return nil;
	}
	
	NSString *value = [NSString stringWithUTF8String: buffer];
	free(buffer);
	
	return value;
}

- (NSNumber *) decodeNumberWithError: (NSError **) error {
    
    [JFBoxDecoder resetError: error];
	
	JFBoxType nextType = [self nextEntryType];
	if (nextType != JFBoxTypeNumber) {
		// The type is not number so return.
		_encounteredError = YES;
		[JFBoxDecoder populateError: error
                           withCode: JFBoxDecoderErrorTypeMismatch];
		return nil;
	}
	
	_index += JFBoxTypeEncodingLength;
	
	if ([self isNilObject]) {
		return nil;
	}
	
	JFBoxType subType;
	_index += [self copy: JFBoxTypeEncodingLength
			   fromIndex: _index
				  ofData: _data
			   intoBytes: (char *) &subType
			   withError: error];
	if (_encounteredError) {
		return nil;
	}
	
	if (![JFBoxDecoder isSupportedNumberType: subType]) {
		_encounteredError = YES;
		[JFBoxDecoder populateError: error
                           withCode: JFBoxDecoderErrorTypeMismatch];
		return nil;
	}
	
	NSNumber *value = nil;
	char buffer[JFBoxUInt64EncodingLength];

	switch (subType) {
		case JFBoxTypeSInt8:
			_index += [self copy: JFBoxSInt8EncodingLength
					   fromIndex: _index
						  ofData: _data
					   intoBytes: (char *) &buffer
					   withError: error];
			value = [NSNumber numberWithChar: *((char *) buffer)];
			break;
		case JFBoxTypeSInt16:
			_index += [self copy: JFBoxSInt16EncodingLength
					   fromIndex: _index
						  ofData: _data
					   intoBytes: (char *) &buffer
					   withError: error];
			value = [NSNumber numberWithShort: *((short *) buffer)];
			break;
		case JFBoxTypeSInt32:
			_index += [self copy: JFBoxSInt32EncodingLength
					   fromIndex: _index
						  ofData: _data
					   intoBytes: (char *) &buffer
					   withError: error];
			value = [NSNumber numberWithLong: *((long *) buffer)];
			break;
		case JFBoxTypeSInt64:
			_index += [self copy: JFBoxSInt64EncodingLength
					   fromIndex: _index
						  ofData: _data
					   intoBytes: (char *) &buffer
					   withError: error];
			value = [NSNumber numberWithLongLong: *((long long*) buffer)];
			break;
		case JFBoxTypeUInt8:
			_index += [self copy: JFBoxUInt8EncodingLength
					   fromIndex: _index
						  ofData: _data
					   intoBytes: (char *) &buffer
					   withError: error];
			value = [NSNumber numberWithUnsignedChar: *((unsigned char *) buffer)];
			break;
		case JFBoxTypeUInt16:
			_index += [self copy: JFBoxUInt16EncodingLength
					   fromIndex: _index
						  ofData: _data
					   intoBytes: (char *) &buffer
					   withError: error];
			value = [NSNumber numberWithUnsignedShort: *((unsigned short *) buffer)];
			break;
		case JFBoxTypeUInt32:
			_index += [self copy: JFBoxUInt32EncodingLength
					   fromIndex: _index
						  ofData: _data
					   intoBytes: (char *) &buffer
					   withError: error];
			value = [NSNumber numberWithUnsignedLong: *((unsigned long *) buffer)];
			break;
		case JFBoxTypeUInt64:
			_index += [self copy: JFBoxUInt64EncodingLength
					   fromIndex: _index
						  ofData: _data
					   intoBytes: (char *) &buffer
					   withError: error];
			value = [NSNumber numberWithUnsignedLongLong: *((unsigned long long *) buffer)];
			break;
		case JFBoxTypeFloat:
			_index += [self copy: JFBoxFloatEncodingLength
					   fromIndex: _index
						  ofData: _data
					   intoBytes: (char *) &buffer
					   withError: error];
			value = [NSNumber numberWithFloat: *((float *) buffer)];
			break;
		case JFBoxTypeDouble:
			_index += [self copy: JFBoxDoubleEncodingLength
					   fromIndex: _index
						  ofData: _data
					   intoBytes: (char *) &buffer
					   withError: error];
			value = [NSNumber numberWithDouble: *((double *) buffer)];
			break;
		default:
			return nil;
	}
	
	if (_encounteredError) {
		return nil;
	}
	
	return value;
}

- (NSDate *) decodeDateWithError: (NSError **) error {
    
    [JFBoxDecoder resetError: error];

	JFBoxType nextType = [self nextEntryType];
	if (nextType != JFBoxTypeDate) {
		// The type is not date so return.
		_encounteredError = YES;
		[JFBoxDecoder populateError: error
                           withCode: JFBoxDecoderErrorTypeMismatch];
		return 0;
	}
	
	_index += JFBoxTypeEncodingLength;
	
	if ([self isNilObject]) {
		return nil;
	}
	
	NSTimeInterval value;
	_index += [self copy: JFBoxDateEncodingLength
			   fromIndex: _index
				  ofData: _data
			   intoBytes: (char *) &value
			   withError: error];
	if (_encounteredError) {
		return 0;
	}
	
	NSDate *dateValue = [NSDate dateWithTimeIntervalSince1970: value];
	if (dateValue == nil) {
		_encounteredError = YES;
		[JFBoxDecoder populateError: error
                           withCode: JFBoxDecoderErrorTypeInvalidValue];
	}
	
	return dateValue;
}

- (NSData *) decodeDataWithError: (NSError **) error {

	JFBoxType nextType = [self nextEntryType];
	if (nextType != JFBoxTypeData) {
		// The type is not data so return.
		_encounteredError = YES;
		[JFBoxDecoder populateError: error
                           withCode: JFBoxDecoderErrorTypeMismatch];
		return nil;
	}
	
	_index += JFBoxTypeEncodingLength;
	
	if ([self isNilObject]) {
		return nil;
	}
	
	UInt64 length;
	_index += [self copy: JFBoxUInt64EncodingLength
			   fromIndex: _index
				  ofData: _data
			   intoBytes: (char *) &length
			   withError: error];
	if (_encounteredError) {
		return nil;
	}
	
	char *buffer = malloc(length);
	_index += [self copy: length
			   fromIndex: _index
				  ofData: _data
			   intoBytes: (char *) buffer
			   withError: error];
	
	if (_encounteredError) {
		free(buffer);
		return nil;
	}
	
	NSData *value = [NSData dataWithBytes: buffer
                                   length: length];
	free(buffer);
	
	return value;
}

- (NSArray *) decodeArrayWithError: (NSError **) error {
    
    [JFBoxDecoder resetError: error];

	JFBoxType nextType = [self nextEntryType];
	if (nextType != JFBoxTypeArray) {
		// The type is not array so return.
		_encounteredError = YES;
		[JFBoxDecoder populateError: error withCode: JFBoxDecoderErrorTypeMismatch];
		return nil;
	}
	
	_index += JFBoxTypeEncodingLength;
	
	if ([self isNilObject]) {
		return nil;
	}
	
	UInt64 elementCount;
	_index += [self copy: JFBoxUInt64EncodingLength
			   fromIndex: _index
				  ofData: _data
			   intoBytes: (char *) &elementCount
			   withError: error];
	if (_encounteredError) {
		return nil;
	}
	
	UInt64 arrayByteLength;
	_index += [self copy: JFBoxUInt64EncodingLength
			   fromIndex: _index
				  ofData: _data
			   intoBytes: (char *) &arrayByteLength
			   withError: error];
	if (_encounteredError) {
		return nil;
	}
	
	NSMutableArray *array = [NSMutableArray arrayWithCapacity: elementCount];
	for (UInt64 element = 0; element < elementCount; element++) {
		
		JFBoxType elementType;
		[self copy: JFBoxTypeEncodingLength
		 fromIndex: _index
			ofData: _data
		 intoBytes: (char *) &elementType
		 withError: error];
		if (_encounteredError) {
			return nil;
		}
		
		id object = nil;
		switch (elementType) {
			case JFBoxTypeString:
				object = [self decodeStringWithError: error];
				break;
			case JFBoxTypeNumber:
				object = [self decodeNumberWithError: error];
				break;
			case JFBoxTypeDate:
				object = [self decodeDateWithError: error];
				break;
			case JFBoxTypeData:
				object = [self decodeDataWithError: error];
				break;
			case JFBoxTypeArray:
				object = [self decodeArrayWithError: error];
				break;
			case JFBoxTypeDictionary:
				object = [self decodeDictionaryWithError: error];
				break;
			case JFBoxTypeBoxEncodable:
				object = [self decodeBoxEncodableWithError: error];
				break;
			default:
				break;
		}
		
		if (_encounteredError) {
			return nil;
		}
		
        if (object != nil) {
            [array addObject: object];
        }
	}
	
	return array;
}

- (NSDictionary *) decodeDictionaryWithError: (NSError **) error {
    
    [JFBoxDecoder resetError: error];
	
	JFBoxType nextType = [self nextEntryType];
	if (nextType != JFBoxTypeDictionary) {
		// The type is not dictionary so return.
		_encounteredError = YES;
		[JFBoxDecoder populateError: error withCode: JFBoxDecoderErrorTypeMismatch];
		return nil;
	}
	
	_index += JFBoxTypeEncodingLength;
	
	if ([self isNilObject]) {
		return nil;
	}
	
	UInt64 elementCount;
	_index += [self copy: JFBoxUInt64EncodingLength
			   fromIndex: _index
				  ofData: _data
			   intoBytes: (char *) &elementCount
			   withError: error];
	if (_encounteredError) {
		// Error is already populated so just return.
		return nil;
	}
	
	UInt64 dictionaryByteLength;
	_index += [self copy: JFBoxUInt64EncodingLength
			   fromIndex: _index
				  ofData: _data
			   intoBytes: (char *) &dictionaryByteLength
			   withError: error];
	if (_encounteredError) {
		// Error is already populated so just return.
		return nil;
	}
	
	NSMutableDictionary *dictionary = [NSMutableDictionary dictionaryWithCapacity: elementCount];
	for (UInt64 element = 0; element < elementCount; element++) {
		
		// Get the key
		UInt64 keyLength;
		_index += [self	copy: JFBoxUInt64EncodingLength
				   fromIndex: _index
					  ofData: _data
				   intoBytes: (char *) &keyLength
				   withError: error];
		if (_encounteredError) {
			// Error is already populated so just return.
			return nil;
		}
		
		char *keyAsCString = malloc(keyLength + 1);
		keyAsCString[keyLength] = 0;
		_index += [self copy: keyLength
				   fromIndex: _index
					  ofData: _data
				   intoBytes: keyAsCString
				   withError: error];
		if (_encounteredError) {
			// Error is already populated so just return.
			free(keyAsCString);
			return nil;
		}
		
		NSString *key = [NSString stringWithUTF8String: keyAsCString];
		free(keyAsCString);
		
		
		JFBoxType elementType;
		[self copy: JFBoxTypeEncodingLength
		 fromIndex: _index
			ofData: _data
		 intoBytes: (char *) &elementType
		 withError: error];
		if (_encounteredError) {
			// Error is already populated so just return.
			return nil;
		}
		
		
		id object = nil;
		switch (elementType) {
			case JFBoxTypeString:
				object = [self decodeStringWithError: error];
				break;
			case JFBoxTypeNumber:
				object = [self decodeNumberWithError: error];
				break;
			case JFBoxTypeDate:
				object = [self decodeDateWithError: error];
				break;
			case JFBoxTypeData:
				object = [self decodeDataWithError: error];
				break;
			case JFBoxTypeArray:
				object = [self decodeArrayWithError: error];
				break;
			case JFBoxTypeDictionary:
				object = [self decodeDictionaryWithError: error];
				break;
			case JFBoxTypeBoxEncodable:
				object = [self decodeBoxEncodableWithError: error];
				break;
			default:
				break;
		}
		
		if (_encounteredError) {
			return nil;
		}
		
		[dictionary setObject: object forKey: key];
	}
	
	return dictionary;
}

- (id <JFBoxEncodable>) decodeBoxEncodableWithError: (NSError **) error {
    
    [JFBoxDecoder resetError: error];

	JFBoxType nextType = [self nextEntryType];
	if (nextType != JFBoxTypeBoxEncodable) {
		// The type is not box encodable so return.
		_encounteredError = YES;
		[JFBoxDecoder populateError: error withCode: JFBoxDecoderErrorTypeMismatch];
		return nil;
	}
	
	_index += JFBoxTypeEncodingLength;
	
	if ([self isNilObject]) {
		return nil;
	}

	UInt64 classNameLength;
	_index += [self copy: JFBoxUInt64EncodingLength
			  fromIndex: _index
				 ofData: _data
			  intoBytes: (char *) &classNameLength
			  withError: error];
	if (_encounteredError) {
		return nil;
	}
	
	char *buffer = malloc(classNameLength + 1);
	buffer[classNameLength] = 0;
	_index += [self copy: classNameLength
			  fromIndex: _index
				 ofData: _data
			  intoBytes: (char *) buffer
			  withError: error];
	if (_encounteredError) {
		// Error is already populated so just return.
		free(buffer);
		return nil;
	}
	
	NSString *className = [NSString stringWithUTF8String: buffer];
	free(buffer);
	
	// Instantiate the class with the name...
	Class boxEncodableClass = NSClassFromString(className);
	if (boxEncodableClass == nil) {
		_encounteredError = YES;
		[JFBoxDecoder populateError: error
						   withCode: JFBoxDecoderErrorTypeUnsupportedBoxEncodableClassName];
		return nil;
	}
	
	id instance = [[boxEncodableClass alloc] init];
	[instance autorelease];
	
	Protocol *protocol = @protocol(JFBoxEncodable);
	if (![instance conformsToProtocol: protocol]) {
		_encounteredError = YES;
		[JFBoxDecoder populateError: error
						   withCode: JFBoxDecoderErrorTypeNotBoxEncodableClass];
		return nil;
	}
	
	UInt16 formatVersion;
	_index += [self copy: JFBoxUInt16EncodingLength
			  fromIndex: _index
				 ofData: _data
			  intoBytes: (char *) &formatVersion
			  withError: error];
	if (_encounteredError) {
		return nil;
	}
	
	UInt64 objectLength;
	_index += [self copy: JFBoxUInt64EncodingLength
			  fromIndex: _index
				 ofData: _data
			  intoBytes: (char *) &objectLength
			  withError: error];
	if (_encounteredError) {
		return nil;
	}

	
	id <JFBoxEncodable> boxEncodableInstance = (id <JFBoxEncodable>) instance;
	[boxEncodableInstance decodeWithBoxDecoder: self
								 formatVersion: formatVersion
										 error: error];

    if (error != nil && [*error code] != 0) {
        return nil;
    }
	
	return boxEncodableInstance;
}

- (BOOL) isNilObject {
	
	NSError *error = nil;
		
	UInt8 nilOrNot;
	[self copy: sizeof(UInt8) fromIndex: _index ofData: _data intoBytes: (char *) &nilOrNot withError: &error];
	if ([error code] != 0) {
		_encounteredError = YES;
		return NO;
	}
	
	_index += sizeof(UInt8);

	return nilOrNot == JFBoxNilObjectValue;
}


#pragma mark - Private methods

- (void) decodeHeader {
	
	char box[3];
	
	_index += [self copy: 3
			   fromIndex: _index
				  ofData: _data
			   intoBytes: box
			   withError: nil];
	
	if (_encounteredError) {
		return;
	}
	
	if (box[0] != 'B' || box[1] != 'O' || box[2] != 'X') {
		_encounteredError = YES;
		return;
	}
	
	UInt16 formatVersion;
	_index += [self copy: JFBoxUInt16EncodingLength
			   fromIndex: _index
				  ofData: _data
			   intoBytes: (char *) &formatVersion
			   withError: nil];
	
	if (_encounteredError) {
		return;
	}
	
	if (formatVersion > JFBoxFormatVersion) {
		_encounteredError = YES;
	}
}

+ (void) resetError: (NSError **) error {
    
    if (error == nil) {
        return;
    }
    
    *error = [NSError errorWithDomain: @""
                                 code: 0
                             userInfo: nil];
}

+ (void) populateError: (NSError **) error withCode: (SInt64) code {
	
	NSError *err = [NSError errorWithDomain: @""
									   code: code
								   userInfo: nil];
	if (error != nil) {
		*error = err;
	}
}

- (UInt64) copy: (UInt64) numberOfBytes fromIndex: (UInt64) index ofData: (NSData *) data intoBytes: (char *) bytes withError: (NSError **) error {
	
	if (data == nil) {
		_encounteredError = YES;
		[JFBoxDecoder populateError: error withCode: JFBoxDecoderErrorTypeNoData];
		return 0;
	}
	
	const unsigned char *dataBytes = [data bytes];
	UInt64 dataLength = [data length];
	
	if (dataLength < index + numberOfBytes) {
		_encounteredError = YES;
		[JFBoxDecoder populateError: error withCode: JFBoxDecoderErrorTypeEndOfData];
		return 0;
	}
	
	memcpy(bytes, &dataBytes[index], numberOfBytes);
	
	return numberOfBytes;
}

+ (BOOL) isSupportedNumberType: (JFBoxType) boxType {
	
	switch (boxType) {
		case JFBoxTypeSInt8:
		case JFBoxTypeSInt16:
		case JFBoxTypeSInt32:
		case JFBoxTypeSInt64:
		case JFBoxTypeUInt8:
		case JFBoxTypeUInt16:
		case JFBoxTypeUInt32:
		case JFBoxTypeUInt64:
		case JFBoxTypeFloat:
		case JFBoxTypeDouble:
			return YES;
		default:
			return NO;
	}
	
	return NO;
}

@end
