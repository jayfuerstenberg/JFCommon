//
// JFInterruptableActionPerformer.m
// JFCommon
//
// Created by Jason Fuerstenberg on 2012/05/03.
// Copyright (c) 2012 Jason Fuerstenberg. All rights reserved.
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
//

#import "JFInterruptableActionPerformer.h"


@implementation JFInterruptableActionPerformer


#pragma mark - Object lifecycle methods

/*
 * Releases any allocated members.
 */
- (void) dealloc {
	
	[self cleanUp];
	
#if !__has_feature(objc_arc) // NON ARC
	[super dealloc];
#endif
}

- (void) cleanUp {
    
    [_timer invalidate];
	
#if !__has_feature(objc_arc) // NON ARC
	[_timer release];
	[_target release];
	[_object release];
#endif
	_timer = nil;
	_target = nil;
	_object = nil;
}


#pragma mark - Action methods

/*
 * Forces the perform even if the time has not transpired.
 */
- (void) performPendingActionIfAny {
    
	if (!_cancelled) {
		if (_expectsObject) {
			[_target performSelector: _action withObject: _object];
		} else {
			[_target performSelector: _action];
		}
	}
    
    [self cleanUp];
}

/*
 * Performs the provided action upon the target after the specified delay.
 * If another call to this method is made prior to the delay the previous call is invalidated/interrupted.
 */
- (void) performInterruptableAction: (SEL) action uponTarget: (id <NSObject>) target afterDelay: (NSTimeInterval) delay {
    
#if !__has_feature(objc_arc) // NON ARC
    [_target release];
	[_object release];
#endif

    _previousInvocation = [[NSDate date] timeIntervalSince1970];
    _delay = delay;
    _target = target;
    _action = action;
    _object = nil;
    _expectsObject = NO;
	_cancelled = NO;
	
#if !__has_feature(objc_arc) // NON ARC
	[_target retain];
#endif
    
    [self lazyInitTimer];
}


/*
 * Performs the provided action upon the target after the specified delay, passing the supplied object to it.
 * If another call to this method is made prior to the delay the previous call is invalidated/interrupted.
 */
- (void) performInterruptableAction: (SEL) action uponTarget: (id <NSObject>) target afterDelay: (NSTimeInterval) delay withObject: (id <NSObject>) object {
    
    _previousInvocation = [[NSDate date] timeIntervalSince1970];
    _delay = delay;
    _target = target;
    _action = action;
    _object = object;
    _expectsObject = YES;
	_cancelled = NO;
	
#if !__has_feature(objc_arc) // NON ARC
	[_object retain];
	[_target retain];
#endif
    
    [self lazyInitTimer];
}


/*
 * Cancels any yet-to-occur action.
 */
- (void) cancel {
	
	_cancelled = YES;
}


#pragma mark - Timer methods

/*
 * Lazy initializes the timer which will actually perform the action.
 */
- (void) lazyInitTimer {
    
    if (_timer != nil) {
        return;
    }

    _timer = [NSTimer scheduledTimerWithTimeInterval: _delay
                                              target: self
                                            selector: @selector(timerFired)
                                            userInfo: nil
                                             repeats: YES];
#if !__has_feature(objc_arc) // NON ARC
	[_timer retain];
#endif
    
    [_timer fire];
}

/*
 * The method called when the timer fired.
 * This triggers the action.
 */
- (void) timerFired {
    
    NSTimeInterval now = [[NSDate date] timeIntervalSince1970];
    if (now - _previousInvocation < _delay) {
        return;
    }
    
    [self performPendingActionIfAny];
}

@end
