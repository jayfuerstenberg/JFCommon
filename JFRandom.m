//
// JFRandom.m
//
// Created by Jason Fuerstenberg on 10/04/26.
// Copyright 2010 Jason Fuerstenberg
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

#import "JFRandom.h"


@implementation JFRandom

/*
 * Generates a random number between low and high and places it into the receiver.
 *
 * Params
 *		low			The low number.
 *					Must be lower or equal to high.
 *		high		The high number.
 *					Must be equal or higher than low.
 *		receiver	The receiver for the random number.
 *					Must not be nil.
 *
 * Return
 *		YES if successful, NO otherwise.
 */
+ (BOOL) generateNumberBetweenLow: (NSInteger) low andHigh: (NSInteger) high intoReceiver: (NSInteger *) receiver {
	
	if (low > high) {
		return NO;
	}
	
	if (receiver == nil) {
		return NO;
	}
	
	*receiver = (arc4random() % ((high + 1) - low)) + low;
	return YES;
}


/*
 * Generates an optionally unique sequence of random numbers between low and high and places them into the sequence.
 *
 * Params
 *		length				The length of the sequence.
 *							Must be at least 1.
 *		sequence			The receiving sequence.
 *							Must not be nil and must accomodate at least 'length' numbers.
 *		low					The low number.
 *							Must be lower or equal to high.
 *		high				The high number.
 *							Must be equal or higher than low.
 *		onlyUniqueValues	YES if only unique values are to be generated, NO otherwise.
 *
 * Return
 *		YES if successful, NO otherwise.
 */
+ (BOOL) generateNumberSequenceOfLength: (NSUInteger) length into: (NSInteger[]) sequence betweenLow: (NSInteger) low andHigh: (NSInteger) high withOnlyUniqueValues: (BOOL) onlyUniqueValues {
	
	if (length < 1) {
		return NO;
	}
	
	if (sequence == nil) {
		return NO;
	}
	
	if (low > high) {
		return NO;
	}
	
	if (onlyUniqueValues && length > (high - low) + 1) {
		return NO;
	}
	
	NSInteger number;
	
	if (onlyUniqueValues) {
		for (NSUInteger loop = 0; loop < length; loop++) {
			// Only unique values are allowed.
			if (![JFRandom generateNumberBetweenLow: low
											andHigh: high
									   intoReceiver: &number]) {
				return NO;
			}
			
			if ([JFRandom isNumber: number
						inSequence: sequence
						  ofLength: loop]) {
				// This is not a unique number so skip adding it to the sequence.
				loop--;
				continue;
			} else {
				// This is a unique number so add it to the sequence.
				sequence[loop] = number;
			}
		}
	} else {
		// Repetitive values are allowed.
		for (NSUInteger loop = 0; loop < length; loop++) {
			// Only unique values are allowed.
			if (![JFRandom generateNumberBetweenLow: low
											andHigh: high
									   intoReceiver: &number]) {
				return NO;
			}
			
			sequence[loop] = number;
		}
	}
	
	return YES;
}


/*
 * Randomly chooses a number from the provided sequence and places it into the receiver.
 *
 * Params
 *		sequence	The receiving sequence.
 *					Must not be nil and must be of at least 'length' numbers.
 *		length		The length of the sequence.
 *					Must be at least 1.
 *		receiver	The receiver for the random number.
 *					Must not be nil.
 *
 * Return
 *		YES if successful, NO otherwise.
 */
+ (BOOL) chooseNumberFromSequence: (NSInteger[]) sequence ofLength: (NSUInteger) length intoReceiver: (NSInteger *) receiver {
	
	if (length < 1) {
		return NO;
	}
	
	if (sequence == nil) {
		return NO;
	}
	
	if (receiver == nil) {
		return NO;
	}
	
	NSInteger number;
	
	// Generate a random index into the sequence...
	if (![JFRandom generateNumberBetweenLow: 0
									andHigh: length - 1
							   intoReceiver: &number]) {
		return NO;
	}
	
	*receiver = sequence[number];
	return YES;
}


/*
 * Returns YES if the provided number appears within the sequence.
 *
 * Params
 *		number		The number to test.
 *		sequence	The sequence within which to test.
 *					Must not be nil and must be of at least 'length' numbers.
 *		length		The length of the sequence.
 *					Must be at least 1.
 *
 * Return
 *		YES if the number was found, NO otherwise.
 */
+ (BOOL) isNumber: (NSInteger) number inSequence: (NSInteger[]) sequence ofLength: (NSUInteger) length {
	
	if (length < 1) {
		return NO;
	}
	
	if (sequence == nil) {
		return NO;
	}
	
	for (NSUInteger check = 0; check < length; check++) {
		
		if (sequence[check] == number) {
			// The number was found so return YES.
			return YES;
		}
	}
	
	// The number was not found.
	return NO;
}


/*
 * Returns an NSData populated with bytes whose values range from 0 to 255.
 *
 * Params
 *		length		The length of the resulting NSData.
 *					Must be 1 or greater or nil will be returned.
 *
 * Returns
 *		An NSData instance containing random bytes.
 */
+ (NSData *) generateRandomDataOfLength: (NSUInteger) length {
	
	if (length == 0) {
		return nil;
	}
	
	NSInteger *sequence = malloc(sizeof(NSInteger) * length);
	[JFRandom generateNumberSequenceOfLength: length
										into: sequence
								  betweenLow: 0
									 andHigh: 255
						withOnlyUniqueValues: NO];
	
	char *randData = malloc(length);
	for (NSUInteger loop = 0; loop < length; loop++) {
		randData[loop] = (char) sequence[loop];
	}
	
	free(sequence);
	NSData *data = [NSData dataWithBytes: randData
								  length: length];
	free(randData);
	
	return data;
}


/*
 * Returns an NSData populated with bytes whose values range from -128 to 127.
 *
 * Params
 *		length		The length of the resulting NSData.
 *					Must be 1 or greater or nil will be returned.
 *
 * Returns
 *		An NSData instance containing random signed bytes.
 */
+ (NSData *) generateRandomSignedDataOfLength: (NSUInteger) length {
	
	if (length == 0) {
		return nil;
	}
	
	NSInteger *sequence = malloc(sizeof(NSInteger) * length);
	[JFRandom generateNumberSequenceOfLength: length
										into: sequence
								  betweenLow: -128
									 andHigh: 127
						withOnlyUniqueValues: NO];
	
	signed char *randData = malloc(length);
	for (NSUInteger loop = 0; loop < length; loop++) {
		randData[loop] = (signed char) sequence[loop];
	}
	
	free(sequence);
	NSData *data = [NSData dataWithBytes: randData
								  length: length];
	free(randData);
	
	return data;
}


/*
 *
 * Returns a string populated with random characters.
 *
 * Params
 *		length		The length of the resulting string.
 *					Must be 1 or greater or nil will be returned.
 *
 * Returns
 *		An ASCII encoded NSString instance.
 */
+ (NSString *) generateRandomStringOfLength: (NSUInteger) length {
	
	if (length == 0) {
		return nil;
	}
	
	NSInteger *sequence = malloc(sizeof(NSInteger) * length);
	[JFRandom generateNumberSequenceOfLength: length
										into: sequence
								  betweenLow: 0
									 andHigh: 255
						withOnlyUniqueValues: NO];
	
	char *randData = malloc(length);
	for (NSUInteger loop = 0; loop < length; loop++) {
		randData[loop] = (char) sequence[loop];
	}
	
	free(sequence);
	NSString *string = [NSString stringWithCString: randData
										  encoding: NSASCIIStringEncoding];
	free(randData);
	
	return string;
}

@end