//
// JFBoxEncodable.h
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


#import <Foundation/Foundation.h>


@class JFBoxEncoder;
@class JFBoxDecoder;

@protocol JFBoxEncodable <NSObject>

/*
 * Encodes the receiver object to the provided box encoder.
 * This method should return the format version of the encoded
 * object which will be provided at decoding time to distinguish
 * between versions of this object format.
 */
- (UInt16) encodeWithBoxEncoder: (JFBoxEncoder *) boxEncoder;

/*
 * Decodes the data with which the receiver object will be populated.
 * The format version indicates which version of the object was encoded
 * and assists the decoder in anticipating the various format fields used in each.
 * If error is not nil the implemented method is expected to fill in details upon error.
 */
- (void) decodeWithBoxDecoder: (JFBoxDecoder *) boxDecoder formatVersion: (UInt16) formatVersion error: (NSError **) error;

@end
