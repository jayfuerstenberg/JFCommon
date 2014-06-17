//
// JFPropertyAnimation.m
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

#import "JFPropertyAnimation.h"

@implementation JFPropertyAnimation


#pragma mark - Properties

@synthesize target = _target;
@synthesize propertyId = _propertyId;
@synthesize changeHandler = _changeHandler;
@synthesize completionHandler = _completionHandler;
@synthesize animationAdvancementArray = _animationAdvancementArray;
@synthesize animationAdvancementIndex = _animationAdvancementIndex;
@synthesize playCount = _playCount;
@synthesize playIndex = _playIndex;
@synthesize paused = _paused;
@synthesize tag = _tag;


#pragma mark - Object lifecycle methods

+ (id) propertyAnimation {
	
	id propertyAnimation = [[JFPropertyAnimation alloc] init];
    #if !__has_feature(objc_arc)
        // Autorelease the instance
        [propertyAnimation autorelease];
    #endif

	return propertyAnimation;
}

- (id) init {
	
	self = [super init];
	if (self != nil) {
		_playIndex = 1;
	}
	
	return self;
}

- (void) dealloc {
	
    #if !__has_feature(objc_arc)
        [_target release];
        [_animationAdvancementArray release];
    
        [super dealloc];
    #else
        _target = nil;
        _animationAdvancementArray = nil;
    #endif
}


#pragma mark - Animation methods

/*
 * Advances the animation one step.
 *
 * NOTE: This method is intended to be called by the JFPropertyAnimator class but applications
 * driving their own animations may call it directly.
 */
- (void) advance {
	
	if (_paused || _stopped) {
		return;
	}
	
	if ([self hasReachedEnd]) {
		return;
	}

	CGFloat newValue = [_animationAdvancementArray valueAtIndex: _animationAdvancementIndex];
	[_target setAnimatableProperty: _propertyId
						toNewValue: newValue];
	
	_animationAdvancementIndex++;
}

- (void) pause {
	
	_paused = YES;
}

- (void) unpause {
	
	_paused = NO;
}

/*
 * Repeats the animation.
 *
 * NOTE: This method is intended to be called by the JFPropertyAnimator class but applications
 * driving their own animations may call it directly.
 */
- (void) repeat {
	
	if (_paused || _stopped) {
		return;
	}
	
	_animationAdvancementIndex = 0;
	_playIndex++;
}

- (void) stop {
	
	_stopped = YES;
}

- (BOOL) hasReachedEnd {
	
	NSUInteger count = [_animationAdvancementArray count];
	return _animationAdvancementIndex == count;
}

@end
