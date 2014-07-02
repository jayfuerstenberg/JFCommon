//
//  JFAes256Codec.m
//  JFCommon
//
//  Created by Jason Fuerstenberg on 10/04/12.
//  Copyright 2010 Jason Fuerstenberg. All rights reserved.
//
//	Licensed under the Apache License, Version 2.0 (the "License");
//	you may not use this file except in compliance with the License.
//	You may obtain a copy of the License at
//
//	http://www.apache.org/licenses/LICENSE-2.0
//
//	Unless required by applicable law or agreed to in writing, software
//	distributed under the License is distributed on an "AS IS" BASIS,
//	WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//	See the License for the specific language governing permissions and
//	limitations under the License.

#import "JFAes256Codec.h"


@implementation JFAes256Codec

/*
 * Encrypts an NSData instance with the provided key.
 *
 * Params
 *		data	The data instance to be encrypted.
 *				Must be non-nil and not empty.
 *		key		The key against which the data will be encrypted.
 *				Must be non-nil and not empty.
 *
 * Return
 *		An encrypted NSData instance if successful, nil otherwise. 
 */
+ (NSData *) encryptData: (NSData *) data withKey: (NSString *) key {
	
	if (data == nil) {
		// data was nil so return nil.
		return nil;
	}
	
	if (key == nil) {
		// key was nil so return nil.
		return nil;
	}
	
	NSUInteger dataLength = [data length];
	if (dataLength == 0) {
		// data was empty so return nil.
		return nil;
	}
	
	NSUInteger keyLength = [key length];
	if (keyLength == 0) {
		// key was empty so return nil.
		return nil;
	}
	
	// 'key' should be 32 bytes for AES256, will be null-padded otherwise
	char keyPtr[kCCKeySizeAES256 + 1]; // room for terminator (unused)
	bzero(keyPtr, sizeof(keyPtr)); // fill with zeroes (for padding)
	
	// fetch key data
	[key getCString: keyPtr maxLength: sizeof(keyPtr) encoding: NSUTF8StringEncoding];
	size_t bufferSize = dataLength + kCCBlockSizeAES128;
	void *buffer = malloc(bufferSize);
	
	size_t numBytesEncrypted = 0;
	CCCryptorStatus result = CCCrypt(kCCEncrypt,
									 kCCAlgorithmAES128,
									 kCCOptionPKCS7Padding, 
									 keyPtr,
									 kCCKeySizeAES256,
									 nil, /* initialization vector (optional) */
									 [data bytes],
									 dataLength, /* input */
									 buffer,
									 bufferSize, /* output */
									 &numBytesEncrypted);
	if (result != kCCSuccess) {
		// Encryption failed so return nil.
		free(buffer);
		return nil;
	}
	
	NSData *val = [NSData dataWithBytes: buffer length: numBytesEncrypted];
	free(buffer);
	return val;
}


/*
 * Decrypts an NSData instance with the provided key.
 *
 * Params
 *		data	The data instance to be decrypted.
 *				Must be non-nil and not empty.
 *		key		The key against which the data will be decrypted.
 *				Must be non-nil and not empty.
 *
 * Return
 *		A decrypted NSData instance if successful, nil otherwise.
 */
+ (NSData *) decryptData: (NSData *) data withKey: (NSString *) key {
    
    return [JFAes256Codec decryptData: data
                              withKey: key
                 initializationVector: nil
                        actualKeySize: kCCKeySizeAES256];
}

/*
 * Decrypts an NSData instance with the provided key.
 *
 * Params
 *		data	The data instance to be decrypted.
 *				Must be non-nil and not empty.
 *		keyData The key against which the data will be decrypted.
 *				Must be non-nil and not empty.
 *
 * Return
 *		A decrypted NSData instance if successful, nil otherwise.
 */
+ (NSData *) decryptData: (NSData *) data withKeyData: (NSData *) keyData {
    
    return [JFAes256Codec decryptData: data
                          withKeyData: keyData
                 initializationVector: nil
                        actualKeySize: kCCKeySizeAES256];
}

/*
 * Decrypts an NSData instance with the provided key.
 *
 * Params
 *		data                    The data instance to be decrypted.
 *                              Must be non-nil and not empty.
 *		key                     The key against which the data will be decrypted.
 *                              Must be non-nil and not empty.
 *      initializationVector    The IV header for making the AES algorithm more secure.
 *      actualKeySize           The number of bytes used for the AES key.
 *
 * Return
 *		A decrypted NSData instance if successful, nil otherwise. 
 */
+ (NSData *) decryptData: (NSData *) data withKey: (NSString *) key initializationVector: (NSData *) initializationVector actualKeySize: (NSUInteger) actualKeySize {
	
	if (data == nil) {
		// data was nil so return nil.
		return nil;
	}
	
	if (key == nil) {
		// key was nil so return nil.
		return nil;
	}
	
	NSUInteger dataLength = [data length];
	if (dataLength == 0) {
		// data was empty so return nil.
		return nil;
	}
	
	NSUInteger keyLength = [key length];
	if (keyLength == 0) {
		// key was empty so return nil.
		return nil;
	}
	
	// 'key' should be at most 32 bytes for AES256, will be null-padded otherwise
	char keyPtr[kCCKeySizeAES256 + 1]; // room for terminator (unused)
	bzero(keyPtr, sizeof(keyPtr)); // fill with zeroes (for padding)
	
	// fetch key data
	[key getCString: keyPtr maxLength: sizeof(keyPtr) encoding: NSUTF8StringEncoding];
	size_t bufferSize = dataLength + kCCBlockSizeAES128;
    void *buffer = malloc(bufferSize);
	
	size_t numBytesDecrypted = 0;
	CCCryptorStatus result = CCCrypt(kCCDecrypt,
									 kCCAlgorithmAES128,
									 kCCOptionPKCS7Padding, 
									 keyPtr,
                                     actualKeySize,
									 [initializationVector bytes], /* initialization vector (optional) */
									 [data bytes],
									 dataLength, /* input */
									 buffer,
									 bufferSize, /* output */
									 &numBytesDecrypted);
	
	if (result != kCCSuccess) {
		// Decryption failed so return nil.
		free(buffer);
		return nil;
	}
	
	NSData *val = [NSData dataWithBytes: buffer
                                 length: numBytesDecrypted];
	free(buffer);
	return val;
}

/*
 * Decrypts an NSData instance with the provided key.
 *
 * Params
 *		data                    The data instance to be decrypted.
 *                              Must be non-nil and not empty.
 *		keyData                 The key against which the data will be decrypted.
 *                              Must be non-nil and not empty.
 *      initializationVector    The IV header for making the AES algorithm more secure.
 *      actualKeySize           The number of bytes used for the AES key.
 *
 * Return
 *		A decrypted NSData instance if successful, nil otherwise.
 */
+ (NSData *) decryptData: (NSData *) data withKeyData: (NSData *) keyData initializationVector: (NSData *) initializationVector actualKeySize: (NSUInteger) actualKeySize {
	
	if (data == nil) {
		// data was nil so return nil.
		return nil;
	}
	
	if (keyData == nil) {
		// key was nil so return nil.
		return nil;
	}
	
	NSUInteger dataLength = [data length];
	if (dataLength == 0) {
		// data was empty so return nil.
		return nil;
	}
	
	NSUInteger keyLength = [keyData length];
	if (keyLength == 0) {
		// key was empty so return nil.
		return nil;
	}
	
	// 'key' should be at most 32 bytes for AES256, will be null-padded otherwise
	char keyPtr[kCCKeySizeAES256 + 1]; // room for terminator (unused)
	bzero(keyPtr, sizeof(keyPtr)); // fill with zeroes (for padding)
	
	// fetch key data
    const char *keyDataBytes = [keyData bytes];
    memcpy(keyPtr, keyDataBytes, sizeof(keyPtr));
	size_t bufferSize = dataLength + kCCBlockSizeAES128;
    void *buffer = malloc(bufferSize);
	
	size_t numBytesDecrypted = 0;
	CCCryptorStatus result = CCCrypt(kCCDecrypt,
									 kCCAlgorithmAES128,
									 kCCOptionPKCS7Padding,
									 keyPtr,
                                     actualKeySize,
									 [initializationVector bytes], /* initialization vector (optional) */
									 [data bytes],
									 dataLength, /* input */
									 buffer,
									 bufferSize, /* output */
									 &numBytesDecrypted);
	
	if (result != kCCSuccess) {
		// Decryption failed so return nil.
		free(buffer);
		return nil;
	}
	
	NSData *val = [NSData dataWithBytes: buffer
                                 length: numBytesDecrypted];
	free(buffer);
	return val;
}


@end
