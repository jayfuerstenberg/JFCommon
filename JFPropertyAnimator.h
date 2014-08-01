//
// JFPropertyAnimator.h
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
#import "JFPropertyAnimatable.h"
#import "JFPropertyAnimation.h"


/*
 * A manager of animations which advances them once per run-loop.
 * Although not required for use with the JFPropertyAnimator class,
 * it abstracts away much of the boilerplate code for animating
 * objects and their properties.
 *
 * Usage Example:
 * [JFPropertyAnimator animateObject: animatableObject
 *                          property: JFPropertyAnimatorPropertyXPosition
 *                              from: 0.0f
 *                                to: 100.0f
 *                            easeIn: YES
 *                           easeOut: YES
 *                      overDuration: 1.0
 *                         playCount: 1
 *                            change: nil
 *                        completion: ^(id <JFPropertyAnimatable> animatable, NSUInteger propertyId, NSUInteger loop) {
 *                                    // Done!
 *                                    }];
 */
@interface JFPropertyAnimator : NSObject {
	
    // The array of managed animations which will be advanced in the run loop.
	NSMutableArray *_managedAnimations;
	
    // The array of animations to remove from management (usually after finishing animation).
	NSMutableArray *_animationsToRemove;
	
	/*
	 * The FPS of the app.
	 * This will help direct the animation speed.
	 * It is assumed the app will maintain the same FPS throughout its lifecycle.
	 */
	CGFloat _fps;
	
	/*
     * The flag to denote whether the animator is paused.
     *
	 * NOTE: A paused animator will simply neglect to advance its managed animations.
	 * It will not assign those animations to a paused state.
	 */
	BOOL _paused;
}


#pragma mark - Properties

@property (nonatomic, assign) CGFloat fps;
@property (nonatomic, assign) BOOL paused;


#pragma mark - Lifecycle methods

+ (id) sharedAnimator;
+ (void) releaseSharedAnimator;


#pragma mark - Animation methods

+ (NSUInteger) managedAnimationCount;
+ (void) advanceManagedAnimations;
+ (JFPropertyAnimation *) animateObject: (id <JFPropertyAnimatable>) object property: (NSUInteger) propertyId to: (CGFloat) endValue easeIn: (BOOL) easeIn easeOut: (BOOL) easeOut overDuration: (NSTimeInterval) duration playCount: (NSUInteger) playCount change: (JFPropertyAnimatorAnimateChangeHandler) change completion: (JFPropertyAnimatorAnimateCompletionHandler) completionHandler;
+ (JFPropertyAnimation *) animateObject: (id <JFPropertyAnimatable>) object property: (NSUInteger) propertyId from: (CGFloat) startValue to: (CGFloat) endValue easeIn: (BOOL) easeIn easeOut: (BOOL) easeOut overDuration: (NSTimeInterval) duration playCount: (NSUInteger) playCount change: (JFPropertyAnimatorAnimateChangeHandler) change completion: (JFPropertyAnimatorAnimateCompletionHandler) completionHandler;
+ (JFPropertyAnimation *) animateObject: (id <JFPropertyAnimatable>) object property: (NSUInteger) propertyId withAdvancementArray: (JFPropertyAnimationAdvancementArray *) advancementArray playCount: (NSUInteger) playCount change: (JFPropertyAnimatorAnimateChangeHandler) change completion: (JFPropertyAnimatorAnimateCompletionHandler) completionHandler;
+ (void) stopAnimatingObject: (id <JFPropertyAnimatable>) object property: (NSUInteger) propertyId;
+ (void) stopAnimatingObject: (id <JFPropertyAnimatable>) object property: (NSUInteger) propertyId setFinalValueTo: (CGFloat) value;
+ (void) pause;
+ (void) unpause;

@end
