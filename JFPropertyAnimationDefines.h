//
// JFPropertyAnimationDefines.h
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


@protocol JFPropertyAnimatable;

/*
 * Implement this block handler to be notified of animation value changes.
 */
typedef void (^JFPropertyAnimatorAnimateChangeHandler) (CGFloat /* current property value */);

/*
 * Implement this block handler to be notified of animation completion.
 */
typedef void (^JFPropertyAnimatorAnimateCompletionHandler) (id <JFPropertyAnimatable> /* object */, NSUInteger /* propertyId */, NSUInteger /* animation loop # */);


#define JFPropertyAnimatorPlayCountInfinite			0

#define JFPropertyAnimator30Fps						30.0f
#define JFPropertyAnimator1SecondDuration			1.0


#define JFPropertyAnimatorPropertyReserved          0

#define JFPropertyAnimatorPropertyXPosition			1
#define JFPropertyAnimatorPropertyYPosition			2
#define JFPropertyAnimatorPropertyZPosition			3

#define JFPropertyAnimatorPropertyRed				11
#define JFPropertyAnimatorPropertyGreen             12
#define JFPropertyAnimatorPropertyBlue				13
#define JFPropertyAnimatorPropertyAlpha				14

#define JFPropertyAnimatorPropertyScale				21
#define JFPropertyAnimatorPropertyXScale			22
#define JFPropertyAnimatorPropertyYScale			23
#define JFPropertyAnimatorPropertyZScale			24

#define JFPropertyAnimatorPropertyXAngle			31
#define JFPropertyAnimatorPropertyYAngle			32
#define JFPropertyAnimatorPropertyZAngle			33

#define JFPropertyAnimatorPropertySpeed				41
#define JFPropertyAnimatorPropertyAcceleration		42


// NOTE: Custom animatable properties not covered by the above should begin from the below value
#define JFPropertyAnimatorPropertyUserDefined		10000

