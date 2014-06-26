//
// JFViewPositionUtil.h
// JFCommon
//
// Created by Jason Fuerstenberg on 11/07/04.
// Copyright 2011 Jason Fuerstenberg
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


#import <Foundation/Foundation.h>
#if TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR
	#import <UIKit/UIKit.h>
#elif TARGET_OS_MAC
	#import <Cocoa/Cocoa.h>
#endif


enum {
    JFAnchorPointTopLeft		= 1 << 0, // Top left corner
    JFAnchorPointTop			= 1 << 1, // Top side
    JFAnchorPointTopRight		= 1 << 2, // Top right corner
	JFAnchorPointLeft			= 1 << 3, // Left side
	JFAnchorPointCenter			= 1 << 4, // Center point
	JFAnchorPointRight			= 1 << 5, // Right side
	JFAnchorPointBottomLeft		= 1 << 6, // Bottom left corner
	JFAnchorPointBottom			= 1 << 7, // Bottom side
	JFAnchorPointBottomRight	= 1 << 8  // Bottom right corner
};
typedef NSUInteger JFAnchorPoint;


#if TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR
	#define VIEW_TYPE			UIView
	#define RECT_TYPE			CGRect
#elif TARGET_OS_MAC
	#define VIEW_TYPE			NSView
	#define RECT_TYPE			NSRect
#endif



/*
 * This view position utility allows views to snap themselves to other sibling views and/or to the super view with ease.
 *
 * NOTE: When used in OS X development be sure to flip the coordinate system such that 0.0, 0.0 refers to the top left corner of the view.
 *		 To accomplish this, implement the '- (BOOL) isFlipped' method in your view and return YES.
 */
@interface JFViewPositionUtil : NSObject


#pragma mark - Superview centric alignment methods

+ (void) verticallyCenterView: (VIEW_TYPE *) view withinSuperview: (VIEW_TYPE *) superview atX: (CGFloat) x;
+ (void) centerView: (VIEW_TYPE *) view withinSuperView: (VIEW_TYPE *) superView atY: (CGFloat) y;
+ (void) centerView: (VIEW_TYPE *) view withinSuperView: (VIEW_TYPE *) superView;
+ (void) centerView: (VIEW_TYPE *) view withinSuperView: (VIEW_TYPE *) superView belowSiblingView: (VIEW_TYPE *) siblingView withMargin: (CGFloat) margin;


#pragma mark - Sibling view centric alignment methods

+ (void) alignView: (VIEW_TYPE *) view atX: (CGFloat) x belowSiblingView: (VIEW_TYPE *) siblingView withMargin: (CGFloat) margin;
+ (void) leftAlignView: (VIEW_TYPE *) view belowSiblingView: (VIEW_TYPE *) siblingView withMargin: (CGFloat) margin;
+ (void) rightAlignView: (VIEW_TYPE *) view belowSiblingView: (VIEW_TYPE *) siblingView withMargin: (CGFloat) margin;
+ (void) centerView: (VIEW_TYPE *) view belowSiblingView: (VIEW_TYPE *) siblingView withMargin: (CGFloat) margin;
+ (void) verticallyCenterView: (VIEW_TYPE *) view leftOfSiblingView: (VIEW_TYPE *) siblingView withMargin: (CGFloat) margin;
+ (void) verticallyCenterView: (VIEW_TYPE *) view rightOfSiblingView: (VIEW_TYPE *) siblingView withMargin: (CGFloat) margin;


#pragma mark - Lower level snapping methods

+ (void) snapAnchorPoint: (JFAnchorPoint) anchorPoint ofView: (VIEW_TYPE *) view toAnchorPoint: (JFAnchorPoint) siblingAnchorPoint ofSiblingView: (VIEW_TYPE *) siblingView;
+ (void) snapAnchorPoint: (JFAnchorPoint) anchorPoint ofView: (VIEW_TYPE *) view withMargin: (CGPoint) margin fromAnchorPoint: (JFAnchorPoint) siblingAnchorPoint ofSiblingView: (VIEW_TYPE *) siblingView;
+ (void) moveView: (VIEW_TYPE *) view bySnappingPoint: (CGPoint) point toOtherPoint: (CGPoint) otherPoint;
+ (void) moveView: (VIEW_TYPE *) view bySnappingPoint: (CGPoint) point toOtherPoint: (CGPoint) otherPoint withMargin: (CGPoint) margin;


#pragma mark - Point retrieval method

+ (CGPoint) pointForAnchorPoint: (JFAnchorPoint) anchorPoint ofView: (VIEW_TYPE *) view;


#pragma mark - Extra methods

+ (void) setHeightOfSuperview: (VIEW_TYPE *) superview toFitAllSubviewsWithMargin: (CGFloat) margin;
+ (void) snapViewToDiscreteCoordinates: (VIEW_TYPE *) view;

@end
