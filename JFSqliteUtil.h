//
//  JFSqliteUtil.h
//  JFCommon
//
//  Created by Jay Fuerstenberg on 2014/12/11.
//  Copyright (c) 2014 Jay Fuerstenberg Creative. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

#import "JFMacros.h"

@interface JFSqliteUtil : NSObject

+ (void) populateObject: (id <NSObject>) object member: (NSString *) memberName withBoolAtColumn: (NSInteger) columnNo ofStatement: (sqlite3_stmt *) statement;
+ (void) populateObject: (id <NSObject>) object member: (NSString *) memberName withIntegerAtColumn: (NSInteger) columnNo ofStatement: (sqlite3_stmt *) statement;
+ (void) populateObject: (id <NSObject>) object member: (NSString *) memberName withStringAtColumn: (NSInteger) columnNo ofStatement: (sqlite3_stmt *) statement;
+ (void) populateObject: (id <NSObject>) object member: (NSString *) memberName withDateAtColumn: (NSInteger) columnNo ofStatement: (sqlite3_stmt *) statement;
+ (void) populateObject: (id <NSObject>) object member: (NSString *) memberName withSetAtColumn: (NSInteger) columnNo ofStatement: (sqlite3_stmt *) statement usingSeparator: (NSString *) separator;


#pragma mark -

+ (void) setSetColumn: (NSInteger) columnNo ofStatement: (sqlite3_stmt *) statement toValueOfMember: (NSString *) memberName inObject: (id <NSObject>) object usingSeparator: (NSString *) separator;
+ (void) setIntegerColumn: (NSInteger) columnNo ofStatement: (sqlite3_stmt *) statement toValueOfMember: (NSString *) memberName inObject: (id <NSObject>) object;
+ (void) setStringColumn: (NSInteger) columnNo ofStatement: (sqlite3_stmt *) statement toValueOfMember: (NSString *) memberName inObject: (id <NSObject>) object;
+ (void) setDateColumn: (NSInteger) columnNo ofStatement: (sqlite3_stmt *) statement toValueOfMember: (NSString *) memberName inObject: (id <NSObject>) object;
+ (void) setBoolColumn: (NSInteger) columnNo ofStatement: (sqlite3_stmt *) statement toValueOfMember: (NSString *) memberName inObject: (id <NSObject>) object;


#pragma mark -

+ (void) setBoolColumn: (NSInteger) columnNo ofStatement: (sqlite3_stmt *) statement toValue: (BOOL) value;
+ (void) setIntegerColumn: (NSInteger) columnNo ofStatement: (sqlite3_stmt *) statement toValue: (NSInteger) value;
+ (void) setStringColumn: (NSInteger) columnNo ofStatement: (sqlite3_stmt *) statement toValue: (NSString *) value;
+ (void) setDateColumn: (NSInteger) columnNo ofStatement: (sqlite3_stmt *) statement toValue: (NSDate *) value;

@end
