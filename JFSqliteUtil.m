//
//  JFSqliteUtil.m
//  JFCommon
//
//  Created by Jay Fuerstenberg on 2014/12/11.
//  Copyright (c) 2014 Jay Fuerstenberg Creative. All rights reserved.
//

#import "JFSqliteUtil.h"

@implementation JFSqliteUtil

+ (void) populateObject: (id <NSObject>) object member: (NSString *) memberName withBoolAtColumn: (NSInteger) columnNo ofStatement: (sqlite3_stmt *) statement {
	
	NSString *setter = [JFSqliteUtil setterSelectorNameForValueName: memberName];
	JFReturnIfEmptyString(setter);
	
	SEL selector = NSSelectorFromString(setter);
	JFReturnIfNo([object respondsToSelector: selector]);
	
	UInt8 flag = sqlite3_column_int(statement, (int) columnNo);
	NSNumber *number = [NSNumber numberWithBool: (flag == 1)];
	
	JFReturnIfNil(number);
	
	[object performSelector: selector
				 withObject: number];
}

+ (void) populateObject: (id <NSObject>) object member: (NSString *) memberName withIntegerAtColumn: (NSInteger) columnNo ofStatement: (sqlite3_stmt *) statement {
	
	NSString *setter = [JFSqliteUtil setterSelectorNameForValueName: memberName];
	JFReturnIfEmptyString(setter);
	
	SEL selector = NSSelectorFromString(setter);
	JFReturnIfNo([object respondsToSelector: selector]);
	
	SInt64 integer = sqlite3_column_int64(statement, (int) columnNo);
	NSNumber *number = [NSNumber numberWithInteger: integer];
	
	JFReturnIfNil(number);
	
	[object performSelector: selector
				 withObject: number];
}

+ (void) populateObject: (id <NSObject>) object member: (NSString *) memberName withStringAtColumn: (NSInteger) columnNo ofStatement: (sqlite3_stmt *) statement {
	
	NSString *setter = [JFSqliteUtil setterSelectorNameForValueName: memberName];
	JFReturnIfEmptyString(setter);
	
	SEL selector = NSSelectorFromString(setter);
	JFReturnIfNo([object respondsToSelector: selector]);
	
	const char *cString = (const char *) sqlite3_column_text(statement, (int) columnNo);
	NSString *string = nil;
	
	JFReturnIfNil(cString);

	string = [NSString stringWithUTF8String: cString];
	JFReturnIfEmptyString(string);
	
	[object performSelector: selector
				 withObject: string];
}

+ (void) populateObject: (id <NSObject>) object member: (NSString *) memberName withDateAtColumn: (NSInteger) columnNo ofStatement: (sqlite3_stmt *) statement {
	
	NSString *setter = [JFSqliteUtil setterSelectorNameForValueName: memberName];
	JFReturnIfEmptyString(setter);
	
	SEL selector = NSSelectorFromString(setter);
	JFReturnIfNo([object respondsToSelector: selector]);
	
	double timestamp = sqlite3_column_double(statement, (int) columnNo);
	NSDate *date = [NSDate dateWithTimeIntervalSince1970: timestamp];
	
	[object performSelector: selector
				 withObject: date];
}

+ (void) populateObject: (id <NSObject>) object member: (NSString *) memberName withSetAtColumn: (NSInteger) columnNo ofStatement: (sqlite3_stmt *) statement usingSeparator: (NSString *) separator {
	
	NSString *setter = [JFSqliteUtil setterSelectorNameForValueName: memberName];
	JFReturnIfEmptyString(setter);
	
	SEL selector = NSSelectorFromString(setter);
	JFReturnIfNo([object respondsToSelector: selector]);
	
	const char *cString = (const char *) sqlite3_column_text(statement, (int) columnNo);
	NSString *string = nil;
	
	JFReturnIfNil(cString);
	
	string = [NSString stringWithUTF8String: cString];
	JFReturnIfEmptyString(string);
	
	
	NSArray *array = [string componentsSeparatedByString: separator];
	NSSet *set = [NSSet setWithArray: array];
	
	[object performSelector: selector
				 withObject: set];
}


#pragma mark -

+ (void) setSetColumn: (NSInteger) columnNo ofStatement: (sqlite3_stmt *) statement toValueOfMember: (NSString *) memberName inObject: (id <NSObject>) object usingSeparator: (NSString *) separator {
	
	NSString *getter = [JFSqliteUtil getterSelectorNameForValueName: memberName];
	JFReturnIfEmptyString(getter);
	
	SEL selector = NSSelectorFromString(getter);
	JFReturnIfNo([object respondsToSelector: selector]);
	
	NSSet *value = [object performSelector: selector];
	
	NSArray *allValues = [value allObjects];
	NSString *allValuesAsString = [allValues componentsJoinedByString: separator];
	
	// Prepend and append additional separators to the field in order to make searching by a specific values possible/easier.
	NSString *dbValue = allValuesAsString == nil ? @""
												 : [NSString stringWithFormat: @"%@%@%@", separator, allValuesAsString, separator];
	[JFSqliteUtil setStringColumn: columnNo
					  ofStatement: statement
						  toValue: dbValue];
}

+ (void) setStringColumn: (NSInteger) columnNo ofStatement: (sqlite3_stmt *) statement toValueOfMember: (NSString *) memberName inObject: (id <NSObject>) object {
	
	NSString *getter = [JFSqliteUtil getterSelectorNameForValueName: memberName];
	JFReturnIfEmptyString(getter);
	
	SEL selector = NSSelectorFromString(getter);
	JFReturnIfNo([object respondsToSelector: selector]);
	
	NSString *value = [object performSelector: selector];
	if ([value length] == 0) {
		value = @"";
	}
	
	const char *cValue = [value UTF8String];
	NSUInteger cLength = [value lengthOfBytesUsingEncoding: NSUTF8StringEncoding];
	
	sqlite3_bind_text(statement, (int) columnNo, cValue, (int) cLength, SQLITE_STATIC);
	//sqlite3_bind_text(statement, (int) columnNo, cValue, -1, SQLITE_TRANSIENT);
}

+ (void) setDateColumn: (NSInteger) columnNo ofStatement: (sqlite3_stmt *) statement toValueOfMember: (NSString *) memberName inObject: (id <NSObject>) object {
	
	NSString *getter = [JFSqliteUtil getterSelectorNameForValueName: memberName];
	JFReturnIfEmptyString(getter);
	
	SEL selector = NSSelectorFromString(getter);
	JFReturnIfNo([object respondsToSelector: selector]);
	
	NSDate *value = [object performSelector: selector];
	double dateValue = [value timeIntervalSince1970];
	sqlite3_bind_double(statement, (int) columnNo, dateValue);
}

+ (void) setBoolColumn: (NSInteger) columnNo ofStatement: (sqlite3_stmt *) statement toValueOfMember: (NSString *) memberName inObject: (id <NSObject>) object {
	
	NSString *getter = [JFSqliteUtil getterSelectorNameForValueName: memberName];
	JFReturnIfEmptyString(getter);
	
	SEL selector = NSSelectorFromString(getter);
	JFReturnIfNo([object respondsToSelector: selector]);
	
	NSNumber *value = [object performSelector: selector];
	UInt8 intValue = [value boolValue] ? 1 : 0;
	sqlite3_bind_int(statement, (int) columnNo, intValue);
}

+ (void) setIntegerColumn: (NSInteger) columnNo ofStatement: (sqlite3_stmt *) statement toValueOfMember: (NSString *) memberName inObject: (id <NSObject>) object {
	
	NSString *getter = [JFSqliteUtil getterSelectorNameForValueName: memberName];
	JFReturnIfEmptyString(getter);
	
	SEL selector = NSSelectorFromString(getter);
	JFReturnIfNo([object respondsToSelector: selector]);
	
	NSNumber *value = [object performSelector: selector];
	SInt64 intValue = [value integerValue];
	sqlite3_bind_int64(statement, (int) columnNo, intValue);
}


#pragma mark -

+ (void) setBoolColumn: (NSInteger) columnNo ofStatement: (sqlite3_stmt *) statement toValue: (BOOL) value {
	
	UInt8 intValue = value ? 1 : 0;
	sqlite3_bind_int(statement, (int) columnNo, intValue);
}

+ (void) setIntegerColumn: (NSInteger) columnNo ofStatement: (sqlite3_stmt *) statement toValue: (NSInteger) value {
	
	sqlite3_bind_int64(statement, (int) columnNo, (int) value);
}

+ (void) setStringColumn: (NSInteger) columnNo ofStatement: (sqlite3_stmt *) statement toValue: (NSString *) value {
	
	const char *cValue = [value UTF8String];
	sqlite3_bind_text(statement, (int) columnNo, cValue, -1, SQLITE_TRANSIENT);
}

+ (void) setDateColumn: (NSInteger) columnNo ofStatement: (sqlite3_stmt *) statement toValue: (NSDate *) value {
	
	double dateValue = [value timeIntervalSince1970];
	sqlite3_bind_double(statement, (int) columnNo, dateValue);
}


#pragma mark -

+ (NSString *) getterSelectorNameForValueName: (NSString *) valueName {
	
	JFReturnNilIfEmptyString(valueName);
	
	return valueName;
}

+ (NSString *) setterSelectorNameForValueName: (NSString *) valueName {
	
	JFReturnNilIfEmptyString(valueName);
	
	NSString *capitalizedValueName = [valueName stringByReplacingCharactersInRange: NSMakeRange(0,1)
																		withString:[[valueName substringToIndex: 1] capitalizedString]];
	NSString *getter = [@"set" stringByAppendingString: capitalizedValueName];
	
	return [getter stringByAppendingString: @":"];
}

@end
