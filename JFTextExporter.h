//
// JFTextExporter.h
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


#import <Foundation/Foundation.h>

#import "JFTextExportable.h"

/*
 * Structured text exporter utility class.
 */
@interface JFTextExporter : NSObject

+ (void) exportBoolean: (BOOL) boo withKey: (NSString *) key toString: (NSMutableString *) outString atIndentation: (NSUInteger) indentation;
+ (void) exportInteger: (NSInteger) integer withKey: (NSString *) key toString: (NSMutableString *) outString atIndentation: (NSUInteger) indentation;
+ (void) exportDouble: (double) dubble withKey: (NSString *) key toString: (NSMutableString *) outString atIndentation: (NSUInteger) indentation;
+ (void) exportNumber: (NSNumber *) number withKey: (NSString *) key toString: (NSMutableString *) outString atIndentation: (NSUInteger) indentation;
+ (void) exportString: (NSString *) string withKey: (NSString *) key toString: (NSMutableString *) outString atIndentation: (NSUInteger) indentation;
+ (void) exportDate: (NSDate *) date withKey: (NSString *) key toString: (NSMutableString *) outString atIndentation: (NSUInteger) indentation;
+ (void) exportObject: (id <NSObject>) object withKey: (NSString *) key toString: (NSMutableString *) outString atIndentation: (NSUInteger) indentation;
+ (void) exportArray: (NSArray *) array withKey: (NSString *) key toString: (NSMutableString *) outString atIndentation: (NSUInteger) indentation;
+ (void) exportDictionary: (NSDictionary *) dictionary withKey: (NSString *) key toString: (NSMutableString *) outString atIndentation: (NSUInteger) indentation;
+ (void) exportExportable: (id <JFTextExportable>) exportable withKey: (NSString *) key toString: (NSMutableString *) outString atIndentation: (NSUInteger) indentation;

@end
