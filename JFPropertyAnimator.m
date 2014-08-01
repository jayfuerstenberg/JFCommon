//
// JFPropertyAnimator.m
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

#import "JFPropertyAnimator.h"

// Pseudo-singleton shared instance.
JFPropertyAnimator *__JFPropertyAnimator__sharedSingletonInstance__ = nil;


@implementation JFPropertyAnimator


#pragma mark - Properties

@synthesize fps = _fps;
@synthesize paused = _paused;


#pragma mark - Object lifecycle methods

/*
 * Returns the shared animator instance.
 */
+ (id) sharedAnimator {
	
	if (__JFPropertyAnimator__sharedSingletonInstance__ == nil) {
		__JFPropertyAnimator__sharedSingletonInstance__ = [[JFPropertyAnimator alloc] init];
	}
	
	return __JFPropertyAnimator__sharedSingletonInstance__;
}

/*
 * Releases the shared animator instance.
 */
+ (void) releaseSharedAnimator {
	
    #if !__has_feature(objc_arc)
        [__JFPropertyAnimator__sharedSingletonInstance__ release];
    #endif
	__JFPropertyAnimator__sharedSingletonInstance__ = nil;
}

- (id) init {
	
	self = [super init];
	if (self != nil) {
		_fps = JFPropertyAnimator30Fps; // Assume 30fps unless told otherwise.
		[self lazyInitManagedAnimations];
		[self lazyInitAnimationsToRemove];
	}
	
	return self;
}

- (void) dealloc {
	
    #if !__has_feature(objc_arc)
        [_managedAnimations release];
        [_animationsToRemove release];
	
        [super dealloc];
    #else
        _managedAnimations = nil;
        _animationsToRemove = nil;
    #endif
}


#pragma mark - Lazy initialization methods

- (void) lazyInitManagedAnimations {
	
	if (_managedAnimations != nil) {
		return;
	}
	
	_managedAnimations = [[NSMutableArray alloc] initWithCapacity: 100];
}

- (void) lazyInitAnimationsToRemove {
	
	if (_animationsToRemove != nil) {
		return;
	}
	
	_animationsToRemove = [[NSMutableArray alloc] initWithCapacity: 10];
}


#pragma mark - Animation methods

+ (NSUInteger) managedAnimationCount {
    
    return [[JFPropertyAnimator sharedAnimator] innerManagedAnimationCount];
}

- (NSUInteger) innerManagedAnimationCount {
    
    return [_managedAnimations count];
}

/*
 * Adds the provided animation to this animator.
 *
 * NOTE: It is more typical to call the animateObject... family of class methods
 * than it is to manually add an animation via this method.
 */
- (void) addManagedAnimation: (JFPropertyAnimation *) animation {
	
	if (animation == nil) {
		return;
	}
	
	id <JFPropertyAnimatable> target = [animation target];
	NSUInteger propertyId = [animation propertyId];
	JFPropertyAnimation *existingAnimation = [self animationForAnimatable: target
																 property: propertyId];
	if (existingAnimation != nil) {
		// Need to remove the existing animation if adding a new one for the same object/property.
		@synchronized (_managedAnimations) {
			[_managedAnimations removeObject: existingAnimation];
		}
	}
	
	@synchronized (_managedAnimations) {
		[_managedAnimations addObject: animation];
	}
}

/*
 * Returns the animation for the animatable object plus its animated property pair.
 * If the object and property pair is not managed by this animator nil is returned.
 */
- (JFPropertyAnimation *) animationForAnimatable: (id <JFPropertyAnimatable>) animatable property: (NSUInteger) propertyId {
	
	if (animatable == nil) {
		return nil;
	}
	
	@synchronized (_managedAnimations) {
		for (JFPropertyAnimation *animation in _managedAnimations) {
			id <JFPropertyAnimatable> target = [animation target];
			if (target != animatable) {
				continue;
			}
			
			NSUInteger animationPropertyId = [animation propertyId];
			if (animationPropertyId != propertyId) {
				continue;
			}
			
			return animation;
		}
	}

	return nil;
}

/*
 * Iterates through the managed animations and advances them.
 */
+ (void) advanceManagedAnimations {
	
	JFPropertyAnimator *sharedAnimator = [JFPropertyAnimator sharedAnimator];
	[sharedAnimator innerAdvanceManagedAnimations];
}

/*
 * Performs the actual advancement.
 * Do not call this method outside of this class.
 */
- (void) innerAdvanceManagedAnimations {
	
	if (_paused) {
		return;
	}
    
    NSMutableArray *copy = nil;
    @synchronized (_managedAnimations) {
        copy = [_managedAnimations copy];
    }
    
	@synchronized (copy) {
		for (JFPropertyAnimation *animation in copy) {
			[animation advance];
            NSUInteger playCount = [animation playCount];
            NSUInteger playIndex = [animation playIndex];
            
            BOOL hasReachedEnd = [animation hasReachedEnd];
            if (!hasReachedEnd) {
                JFPropertyAnimatorAnimateChangeHandler changeHandler = [animation changeHandler];
                if (changeHandler != 0) {
                    NSUInteger index = [animation animationAdvancementIndex];
                    CGFloat currentValue = [[animation animationAdvancementArray] valueAtIndex: index];
                    changeHandler(currentValue);
                }
            } else {
				JFPropertyAnimatorAnimateCompletionHandler completionHandler = [animation completionHandler];
				if (completionHandler != 0) {
					id <JFPropertyAnimatable> target = [animation target];
					NSUInteger propertyId = [animation propertyId];
					completionHandler(target, propertyId, playIndex);
				}
					
				if (playCount == 0 || playIndex < playCount) {
					// This is a never-ending animation or a limited one with some plays left.
					[animation repeat];
					continue;
				}
				
				[_animationsToRemove addObject: animation];
			}
		}
	}
    
    [copy release];
    
    @synchronized (_managedAnimations) {
        if ([_animationsToRemove count] > 0) {
			[_managedAnimations removeObjectsInArray: _animationsToRemove];
			[_animationsToRemove removeAllObjects];
		}
    }
}

/*
 * Animates the provided object/property.
 */
+ (JFPropertyAnimation *) animateObject: (id <JFPropertyAnimatable>) object property: (NSUInteger) propertyId to: (CGFloat) endValue easeIn: (BOOL) easeIn easeOut: (BOOL) easeOut overDuration: (NSTimeInterval) duration playCount: (NSUInteger) playCount change: (JFPropertyAnimatorAnimateChangeHandler) changeHandler completion: (JFPropertyAnimatorAnimateCompletionHandler) completionHandler {
	
	return [JFPropertyAnimator animateObject: object
									property: propertyId
										from: NAN // Go with the object's current value.
										  to: endValue
									  easeIn: easeIn
									 easeOut: easeOut
								overDuration: duration
								   playCount: playCount
                                      change: changeHandler
								  completion: completionHandler];
}


/*
 * The very specific method to call for animating the provided object's property.
 */
+ (JFPropertyAnimation *) animateObject: (id <JFPropertyAnimatable>) object property: (NSUInteger) propertyId from: (CGFloat) startValue to: (CGFloat) endValue easeIn: (BOOL) easeIn easeOut: (BOOL) easeOut overDuration: (NSTimeInterval) duration playCount: (NSUInteger) playCount change: (JFPropertyAnimatorAnimateChangeHandler) changeHandler completion: (JFPropertyAnimatorAnimateCompletionHandler) completionHandler {
	
	if (object == nil || ![object conformsToProtocol: @protocol(JFPropertyAnimatable)]) {
		// Not a valid object.
		return nil;
	}
	
	JFPropertyAnimator *sharedAnimator = [JFPropertyAnimator sharedAnimator];
	CGFloat fps = [sharedAnimator fps];
	if (fps == 0.0f) {
		// Invalid!  Reset to 30.
		fps = JFPropertyAnimator30Fps;
	}
	
	if (duration <= 0.0f) {
		// Reset to 1 second if 0 seconds or less.
		duration = JFPropertyAnimator1SecondDuration;
	}
	
	CGFloat animationStep = 0.0f;
	CGFloat startValueForCalculation;
	
	if (!isnan(startValue)) {
		// The start value is valid and should be assigned now...
		[object setAnimatableProperty: propertyId
						   toNewValue: startValue];
		startValueForCalculation = startValue;
	} else {
		// The caller wants to go with the object's current value as the start value so retrieve that now...
		startValueForCalculation = [object valueOfAnimatableProperty: propertyId];
	}
	
	if (startValueForCalculation == endValue) {
		// No animation needed as values are the same.
        if (completionHandler != 0) {
            completionHandler(object, propertyId, 0);
        }
        
		return nil;
	}
	
	NSUInteger count = (NSUInteger) (fps * duration) + 1;
	JFPropertyAnimationAdvancementArray *advancementArray = [JFPropertyAnimationAdvancementArray advancementArrayWithElementCount: count];
	
	BOOL isLinear = [JFPropertyAnimator isLinearWithEaseIn: easeIn
												   easeOut: easeOut];
	if (isLinear) {
		// Simple calculation...
		animationStep = (endValue - startValueForCalculation) / (fps * duration);
		
		CGFloat val = startValueForCalculation;
		BOOL isNegative = animationStep < 0.0f;
		for (NSUInteger index = 0; index < count; index++) {
			if (!isNegative) {
				if (val > endValue) {
					val = endValue;
				}
			} else {
				if (val < endValue) {
					val = endValue;
				}
			}
			
			[advancementArray setValue: val
							   atIndex: index];
			val += animationStep;
		}
	} else if (easeIn && easeOut) {
        
        [JFPropertyAnimator populateAdvancementArray: advancementArray
                                      withStartPoint: CGPointMake(startValueForCalculation, startValueForCalculation)
                                       controlPoint1: CGPointMake(startValueForCalculation, endValue)
                                       controlPoint2: CGPointMake(endValue, startValueForCalculation)
                                            endPoint: CGPointMake(endValue, endValue)
                                         granularity: count];
    } else if (easeIn) {
        
        [JFPropertyAnimator populateAdvancementArray: advancementArray
                                      withStartPoint: CGPointMake(startValueForCalculation, startValue)
                                       controlPoint1: CGPointMake(startValueForCalculation, endValue)
                                       controlPoint2: CGPointMake(startValueForCalculation, endValue)
                                            endPoint: CGPointMake(endValue, endValue)
                                         granularity: count];
    } else if (easeOut) {
        
        [JFPropertyAnimator populateAdvancementArray: advancementArray
                                      withStartPoint: CGPointMake(startValueForCalculation, startValueForCalculation)
                                       controlPoint1: CGPointMake(endValue, startValueForCalculation)
                                       controlPoint2: CGPointMake(endValue, startValueForCalculation)
                                            endPoint: CGPointMake(endValue, endValue)
                                         granularity: count];
    }
    
    JFPropertyAnimation *existingAnimation = [sharedAnimator animationForAnimatable: object
                                                                           property: propertyId];
	if (existingAnimation != nil) {
        // Stop the existing animation before adding it again...
        [self stopAnimatingObject: object
                         property: propertyId];
    }
	
	
	// Create the animation...
	JFPropertyAnimation *animation = [JFPropertyAnimation propertyAnimation];
	[animation setTarget: object];
	[animation setPropertyId: propertyId];
	[animation setPlayCount: playCount];
	[animation setAnimationAdvancementArray: advancementArray];
    [animation setChangeHandler: changeHandler];
	[animation setCompletionHandler: completionHandler];
	
	// Add the animation to the managed array...
	[sharedAnimator addManagedAnimation: animation];
	
	return animation;
}

/*
 * Animates the provided object using the custom advancement array.
 */
+ (JFPropertyAnimation *) animateObject: (id <JFPropertyAnimatable>) object property: (NSUInteger) propertyId withAdvancementArray: (JFPropertyAnimationAdvancementArray *) advancementArray playCount: (NSUInteger) playCount change: (JFPropertyAnimatorAnimateChangeHandler) changeHandler completion: (JFPropertyAnimatorAnimateCompletionHandler) completionHandler {
	
	if (object == nil || ![object conformsToProtocol: @protocol(JFPropertyAnimatable)]) {
		// Not a valid object.
		return nil;
	}
	
	if (advancementArray == nil) {
		// Not a valid array.
		return nil;
	}
    
    JFPropertyAnimator *sharedAnimator = [JFPropertyAnimator sharedAnimator];
	
	// Create the animation...
	JFPropertyAnimation *animation = [JFPropertyAnimation propertyAnimation];
	[animation setTarget: object];
	[animation setPropertyId: propertyId];
	[animation setPlayCount: playCount];
	[animation setAnimationAdvancementArray: advancementArray];
    [animation setChangeHandler: changeHandler];
	[animation setCompletionHandler: completionHandler];
	
	// Add the animation to the managed array...
	[sharedAnimator addManagedAnimation: animation];
	
	return animation;
}

+ (void) stopAnimatingObject: (id <JFPropertyAnimatable>) object property: (NSUInteger) propertyId {
    
    JFPropertyAnimator *sharedAnimator = [JFPropertyAnimator sharedAnimator];
    [sharedAnimator innerStopAnimatingObject: object
                                    property: propertyId
                             setFinalValueTo: NAN];
}


+ (void) stopAnimatingObject: (id <JFPropertyAnimatable>) object property: (NSUInteger) propertyId setFinalValueTo: (CGFloat) value {
	
	JFPropertyAnimator *sharedAnimator = [JFPropertyAnimator sharedAnimator];
	[sharedAnimator innerStopAnimatingObject: object
									property: propertyId
							 setFinalValueTo: value];
}

/*
 * NOTE: Do not call this method from outside this class.
 */
- (void) innerStopAnimatingObject: (id <JFPropertyAnimatable>) object property: (NSUInteger) propertyId setFinalValueTo: (CGFloat) value {
	
	@synchronized (_managedAnimations) {
		for (JFPropertyAnimation *animation in _managedAnimations) {
			
			id <JFPropertyAnimatable> target = [animation target];
			if (target != object) {
				continue;
			}
			
			NSUInteger animationPropertyId = [animation propertyId];
			if (animationPropertyId != propertyId) {
				continue;
			}
			
			// Matching animation found!
			[animation stop];
            
            
            if (!isnan(value)) {
                [object setAnimatableProperty: propertyId
                                   toNewValue: value];
            }
			
			[_animationsToRemove addObject: animation];
            
            // Notify the animation completion handler, if any, of the stop...
            JFPropertyAnimatorAnimateCompletionHandler completionHandler = [animation completionHandler];
            if (completionHandler != 0) {
                id <JFPropertyAnimatable> target = [animation target];
                NSUInteger propertyId = [animation propertyId];
                NSUInteger playIndex = [animation playIndex];
                completionHandler(target, propertyId, playIndex);
            }
		}
		
		if ([_animationsToRemove count] > 0) {
			[_managedAnimations removeObjectsInArray: _animationsToRemove];
			[_animationsToRemove removeAllObjects];
		}
	}
}

/*
 * Pauses the shared animator.
 */
+ (void) pause {
	
	[[JFPropertyAnimator sharedAnimator] setPaused: YES];
}

/*
 * Unpauses the shared animator.
 */
+ (void) unpause {
	
	[[JFPropertyAnimator sharedAnimator] setPaused: NO];
}

/*
 * Returns YES if the ease-in and ease-out flags denote that a given
 * animation is linear in its advancement.
 */
+ (BOOL) isLinearWithEaseIn: (BOOL) easeIn easeOut: (BOOL) easeOut {
	
	return !easeIn && !easeOut;
}

/*
 * Generates the ease-in, ease-out curve path given the start, control and end points assigned.
 * The granularity determines the number of elements that will be present in the resulting array.
 */
+ (void) populateAdvancementArray: (JFPropertyAnimationAdvancementArray *) advancementArray withStartPoint: (CGPoint) startPoint controlPoint1: (CGPoint) controlPoint1 controlPoint2: (CGPoint) controlPoint2 endPoint: (CGPoint) endPoint granularity: (NSUInteger) granularity {
	
	double step = 1.0 / ((double) granularity - 1.0);
	double t = 0.0;
	
	for (SInt32 loop = 0; loop < granularity - 1; loop++, t += step) {
        
        CGPoint a, b, c;
        CGPoint temp;
		
		c.x = 3.0f * (controlPoint1.x - startPoint.x);
		c.y = 3.0f * (controlPoint1.y - startPoint.y);
		
		b.x = 3.0f * (controlPoint2.x - controlPoint1.x) - c.x;
		b.y = 3.0f * (controlPoint2.y - controlPoint1.y) - c.y;
		
		a.x = endPoint.x - startPoint.x - c.x - b.x;
		a.y = endPoint.y - startPoint.y - c.y - b.y;
		
		double t2 = t * t;
		double t3 = t2 * t;
		
		temp.x = (a.x * t3) + (b.x * t2) + (c.x * t) + startPoint.x;
		temp.y = (a.y * t3) + (b.y * t2) + (c.y * t) + startPoint.y;
		
        [advancementArray setValue: temp.x
                           atIndex: loop];
	}
    
    [advancementArray setValue: endPoint.x
                       atIndex: granularity - 1];
}

@end
