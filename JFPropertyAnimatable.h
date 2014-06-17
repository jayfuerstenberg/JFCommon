//
// JFPropertyAnimatable.h
// JFCommon
//
// Created by Jason Fuerstenberg on 2013/09/17.
// Copyright (c) 2013 Jason Fuerstenberg. All rights reserved.
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

#import "JFPropertyAnimationDefines.h"


/*
 * The protocol to which objects whose properties are animatable adhere.
 * A property can be anything and common examples include color, position, opacity.
 * The property value is assumed to be a floating point number but can be rounded
 * to an integer type if needed.
 *
 * Objects intending to be animated are typically added to the JFPropertyAnimator
 * class via one of the animateObject... class methods.
 */
@protocol JFPropertyAnimatable <NSObject>

/*
 * Assigns the new value of the provided property.
 * The property ID is arbitrary and application specific.
 */
- (void) setAnimatableProperty: (NSUInteger) propertyId toNewValue: (CGFloat) newValue;

/*
 * Returns the current value of the provided property.
 */
- (CGFloat) valueOfAnimatableProperty: (NSUInteger) propertyId;

@end
