//
//  JFAes256Codec.h
//  JFCommon
//
//  Created by Jason Fuerstenberg on 10/04/12.
//  Copyright 2010 Jason Fuerstenberg. All rights reserved.
//
//  NOTE: Code samples derived from: http://iphonedevelopment.blogspot.com/2009/02/strong-encryption-for-cocoa-cocoa-touch.html
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

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonCryptor.h>


/*
 * The encryptor and decryptor of NSData instances using AES-256 as
 * provided by the Common Crypto library provided within the iOS platform.
 */
@interface JFAes256Codec : NSObject

+ (NSData *) encryptData: (NSData *) data withKey: (NSString *) key;
+ (NSData *) decryptData: (NSData *) data withKey: (NSString *) key;
+ (NSData *) decryptData: (NSData *) data withKey: (NSString *) key initializationVector: (NSData *) initializationVector actualKeySize: (NSUInteger) actualKeySize;
+ (NSData *) decryptData: (NSData *) data withKeyData: (NSData *) keyData initializationVector: (NSData *) initializationVector actualKeySize: (NSUInteger) actualKeySize;

@end
