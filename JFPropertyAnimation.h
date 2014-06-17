//
// JFPropertyAnimation.h
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
#import "JFPropertyAnimationAdvancementArray.h"


/*
 * An animation which is applied against a target
 * (implementing the JFPropertyAnimatable protocol)
 * and its property.
 */
@interface JFPropertyAnimation : NSObject {
	
    // The animatable target.
	id <JFPropertyAnimatable> _target;
	
    // The property being animated.
	NSUInteger _propertyId;
    
    // The block to be notified upon each change in value.
    JFPropertyAnimatorAnimateChangeHandler _changeHandler;
	
    // The block to be notified upon completion of the animation.
	JFPropertyAnimatorAnimateCompletionHandler _completionHandler;
	
    // The array of values to iterate over.
	JFPropertyAnimationAdvancementArray *_animationAdvancementArray;
	
    // The index into the above array.
	NSUInteger _animationAdvancementIndex;
	
    // The number of times this animation plays/repeats.
	NSUInteger _playCount;
	
    // The current play index.
	NSUInteger _playIndex;
	
    // The flag denoting whether the animation is paused or not.
	BOOL _paused;
	
    // The flag denoting whether the animation is stopped or not.
	BOOL _stopped;
	
	// Genral purpose tag.
	NSInteger _tag;
}


#pragma mark - Properties

@property (nonatomic, retain) id <JFPropertyAnimatable> target;
@property (nonatomic, assign) NSUInteger propertyId;
@property (nonatomic, copy) JFPropertyAnimatorAnimateChangeHandler changeHandler;
@property (nonatomic, copy) JFPropertyAnimatorAnimateCompletionHandler completionHandler;
@property (nonatomic, retain) JFPropertyAnimationAdvancementArray *animationAdvancementArray;
@property (nonatomic, assign) NSUInteger animationAdvancementIndex;
@property (nonatomic, assign) NSUInteger playCount;
@property (nonatomic, assign) NSUInteger playIndex;
@property (nonatomic, readonly, getter=isPaused) BOOL paused;
@property (nonatomic, assign) NSInteger tag;


#pragma mark - Object lifecycle methods

+ (id) propertyAnimation;


#pragma mark - Animation methods

- (void) advance;
- (BOOL) hasReachedEnd;
- (void) repeat;
- (void) pause;
- (void) unpause;
- (void) stop;

@end
