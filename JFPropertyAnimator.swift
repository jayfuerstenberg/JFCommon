//
// JFPropertyAnimator.swift
// JFCommon
//
// Created by Jason Fuerstenberg on 2014-06-04.
// Copyright (c) 2014 Jay Fuerstenberg Creative. All rights reserved.
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

import Foundation
import UIKit        // For getting CGPoint type.  TODO: find way to let this work on both iOS and OSX


// NOTE: Do not directly manipulate the below shared instance
var __JFPropertyAnimator_sharedInstance__ : AnyObject?


/*
 * A manager of animations which advances them once per run-loop.
 * Although not required for use with the JFPropertyAnimator class,
 * it abstracts away much of the boilerplate code for animating
 * objects and their properties.
 *
 * Usage Example:
 * JFPropertyAnimator.animateObject(animatableObject,
 *                                  propertyId: JFPropertyAnimator.PropertyAlpha,
 *                                  startValue: 0.0,
 *                                  endValue: 1.0,
 *                                  easeIn: true,
 *                                  easeOut: true,
 *                                  duration: 1.0,
 *                                  playCount: JFPropertyAnimator.PlayCountInfinite,
 *                                  completion: {(animatable: JFPropertyAnimatable, propertyId: UInt, playLoop: Int) in
 *                                      println("completed the animation loop #\(playLoop)")
 *                                  })
 */
class JFPropertyAnimator {
    
    // Some useful constants for use with the animator.
    class var PlayCountInfinite: Int { return 0 }
    class var ThirtyFps: Float { return 30.0 }
    class var OneSecondDuration: NSTimeInterval { return 1.0 }
    
    // Various helpful property types
    class var PropertyReserved: UInt { return 0 }
    class var PropertyXPosition: UInt { return 1 }
    class var PropertyYPosition: UInt { return 2 }
    class var PropertyZPosition: UInt { return 3 }
    class var PropertyRed: UInt { return 11 }
    class var PropertyGreen: UInt { return 12 }
    class var PropertyBlue: UInt { return 13 }
    class var PropertyAlpha: UInt { return 14 }
    class var PropertyScale: UInt { return 21 }
    class var PropertyXScale: UInt { return 22 }
    class var PropertyYScale: UInt { return 23 }
    class var PropertyZScale: UInt { return 24 }
    class var PropertyXAngle: UInt { return 31 }
    class var PropertyYAngle: UInt { return 32 }
    class var PropertyZAngle: UInt { return 33 }
    class var PropertySpeed: UInt { return 41 }
    class var PropertyAcceleration: UInt { return 42 }
    
    // NOTE: Custom animatable properties not covered by the above should begin from the below value
    class var PropertyUserDefined: UInt {return 10000 }
    
    // The array of managed animations which will be advanced in the run loop.
    var managedAnimations: NSMutableArray = NSMutableArray(capacity: 100)
    
    // The array of animations to remove from management (usually after finishing animation).
    @lazy var animationsToRemove: NSMutableArray = NSMutableArray(capacity: 10)
    
    /*
     * The FPS of the app.
     * This will help direct the animation speed.
     * It is assumed the app will maintain the same FPS throughout its lifecycle.
     */
    var fps: Float = JFPropertyAnimator.ThirtyFps
    
    /*
     * The flag to denote whether the animator is paused.
     *
     * NOTE: A paused animator will simply neglect to advance its managed animations.
     * It will not assign those animations to a paused state.
     */
    var paused: Bool = false
    
    
    /*
     * Returns the shared instance of the animator.
     */
    class func sharedAnimator() -> JFPropertyAnimator {
        
        if (__JFPropertyAnimator_sharedInstance__ == nil) {
            __JFPropertyAnimator_sharedInstance__ = JFPropertyAnimator()
        }
        
        return __JFPropertyAnimator_sharedInstance__ as JFPropertyAnimator
    }

    /*
     * Adds the provided animation to this animator.
     *
     * NOTE: It is more typical to call the animateObject... family of class methods
     * than it is to manually add an animation via this method.
     */
    func addManagedAnimation(animation: JFPropertyAnimation) {
        
        var target: JFPropertyAnimatable = animation.target
        var propertyId: UInt = animation.propertyId
        var existingAnimation: JFPropertyAnimation? = animationForAnimatable(target, propertyId: propertyId)
        if (existingAnimation != nil) {
            managedAnimations.removeObject(existingAnimation)
        }
        
        managedAnimations.addObject(animation)
    }
  
    /*
     * Returns the animation for the animatable object plus its animated property pair.
     * If the object and property pair is not managed by this animator nil is returned.
     */
    func animationForAnimatable(animatable: JFPropertyAnimatable, propertyId: UInt) -> JFPropertyAnimation? {
        
        for animation : AnyObject in managedAnimations {
            var anim: JFPropertyAnimation = animation as JFPropertyAnimation
            var target: JFPropertyAnimatable = anim.target
            if (!target.isEqualTo(animatable)) {
                continue
            }
            
            var animationPropertyId: UInt = anim.propertyId
            if (animationPropertyId != propertyId) {
                continue
            }
            
            return anim
        }
    
        return nil
    }


    class func advanceManagedAnimations() {
    
        var sharedAnimator: JFPropertyAnimator = JFPropertyAnimator.sharedAnimator()
        sharedAnimator.innerAdvanceManagedAnimations()
    }
    
    func innerAdvanceManagedAnimations() {

        if (paused) {
            return
        }
        
        var copy: NSMutableArray = managedAnimations.mutableCopy() as NSMutableArray
        
        for anim : AnyObject in copy {
            var animation: JFPropertyAnimation = anim as JFPropertyAnimation
            animation.advance()
            
            var animationAdvancementIndex: Int
            var hasReachedEnd: Bool = animation.hasReachedEnd()
            if (!hasReachedEnd) {
                animationAdvancementIndex = animation.animationAdvancementIndex
                var currentValue: Float = animation.animationAdvancementArray[animationAdvancementIndex] as Float
                animation.changeHandler(currentValue: currentValue)
            } else {
                var target: JFPropertyAnimatable = animation.target
                var propertyId: UInt = animation.propertyId
                animation.completionHandler(object: target, propertyId: propertyId, playLoop: animation.playIndex)
                
                if (animation.playCount == 0 || animation.playIndex < animation.playCount) {
                    animation.repeat()
                    continue
                }
                
                animationsToRemove.addObject(animation)
            }
        }
        
        if (animationsToRemove.count > 0) {
            managedAnimations.removeObjectsInArray(animationsToRemove)
            animationsToRemove.removeAllObjects()
        }
    }
    
    class func animateObject(object: JFPropertyAnimatable, propertyId: UInt, startValue: Float, endValue: Float, easeIn: Bool, easeOut: Bool, duration: NSTimeInterval, playCount: Int) -> JFPropertyAnimation? {
        
        return JFPropertyAnimator.animateObject(object,
            propertyId: propertyId,
            startValue: startValue,
            endValue: endValue,
            easeIn: easeIn,
            easeOut: easeOut,
            duration: duration,
            playCount: playCount,
            change: {(currentValue: Float) in},
            completion: {(animatable: JFPropertyAnimatable, propertyId: UInt, playLoop: Int) in})
    }
    
    class func animateObject(object: JFPropertyAnimatable, propertyId: UInt, endValue: Float, easeIn: Bool, easeOut: Bool, duration: NSTimeInterval, playCount: Int) -> JFPropertyAnimation? {
        
        return JFPropertyAnimator.animateObject(object,
            propertyId: propertyId,
            startValue: Float.NaN,
            endValue: endValue,
            easeIn: easeIn,
            easeOut: easeOut,
            duration: duration,
            playCount: playCount,
            change: {(currentValue: Float) in},
            completion: {(animatable: JFPropertyAnimatable, propertyId: UInt, playLoop: Int) in})
    }
    
    class func animateObject(object: JFPropertyAnimatable, propertyId: UInt, startValue: Float, endValue: Float, easeIn: Bool, easeOut: Bool, duration: NSTimeInterval, playCount: Int, change: (Float) -> ()) -> JFPropertyAnimation? {
        
        return JFPropertyAnimator.animateObject(object,
            propertyId: propertyId,
            startValue: startValue,
            endValue: endValue,
            easeIn: easeIn,
            easeOut: easeOut,
            duration: duration,
            playCount: playCount,
            change: change,
            completion: {(animatable: JFPropertyAnimatable, propertyId: UInt, playLoop: Int) in})
    }
    
    class func animateObject(object: JFPropertyAnimatable, propertyId: UInt, endValue: Float, easeIn: Bool, easeOut: Bool, duration: NSTimeInterval, playCount: Int, change: (Float) -> (), completion: (JFPropertyAnimatable, UInt, Int) -> ()) -> JFPropertyAnimation? {
        
        return JFPropertyAnimator.animateObject(object,
            propertyId: propertyId,
            startValue: Float.NaN,
            endValue: endValue,
            easeIn: easeIn,
            easeOut: easeOut,
            duration: duration,
            playCount: playCount,
            change: change,
            completion: completion)
    }
    
    class func animateObject(object: JFPropertyAnimatable, propertyId: UInt, endValue: Float, easeIn: Bool, easeOut: Bool, duration: NSTimeInterval, playCount: Int, completion: (JFPropertyAnimatable, UInt, Int) -> ()) -> JFPropertyAnimation? {
        
        return JFPropertyAnimator.animateObject(object,
            propertyId: propertyId,
            startValue: Float.NaN,
            endValue: endValue,
            easeIn: easeIn,
            easeOut: easeOut,
            duration: duration,
            playCount: playCount,
            change: {(currentValue: Float) in},
            completion: completion)
    }
    
    class func animateObject(object: JFPropertyAnimatable, propertyId: UInt, startValue: Float, endValue: Float, easeIn: Bool, easeOut: Bool, duration: NSTimeInterval, playCount: Int, completion: (JFPropertyAnimatable, UInt, Int) -> ()) -> JFPropertyAnimation? {
        
        return JFPropertyAnimator.animateObject(object,
            propertyId: propertyId,
            startValue: startValue,
            endValue: endValue,
            easeIn: easeIn,
            easeOut: easeOut,
            duration: duration,
            playCount: playCount,
            change: {(currentValue: Float) in},
            completion: completion)
    }
    
    class func animateObject(object: JFPropertyAnimatable, propertyId: UInt, startValue: Float, endValue: Float, easeIn: Bool, easeOut: Bool, duration: NSTimeInterval, playCount: Int, change: (Float) -> (), completion: (JFPropertyAnimatable, UInt, Int) -> ()) -> JFPropertyAnimation? {
        
        var sharedAnimator: JFPropertyAnimator = JFPropertyAnimator.sharedAnimator()
        var fps: Float = sharedAnimator.fps
        var innerDuration: NSTimeInterval = duration
        
        if (innerDuration <= 0.0) {
            // Reset to 1 second if 0 seconds or less.
            innerDuration = 1.0
        }
        
        var animationStep: Float = 0.0
        var startValueForCalculation: Float

        if (!startValue.isNaN) {
            object.setAnimatablePropertyToNewValue(propertyId, newValue: startValue)
            startValueForCalculation = startValue
        } else {
            startValueForCalculation = object.valueOfAnimatableProperty(propertyId)
        }
        
        if (startValueForCalculation == endValue) {
            // No animation needed as values are the same.
            completion(object, propertyId, 0)
            return nil
        }
        
        var count: UInt = UInt((fps * Float(innerDuration)) + 1.0)
        var advancementArray: NSMutableArray = NSMutableArray()
        var isLinear: Bool = isLinearWithEaseIn(easeIn, easeOut: easeOut)
        
        if (isLinear) {
            // Simple calculation...
            animationStep = (endValue - startValueForCalculation) / (fps * Float(innerDuration))

            var val: Float = startValueForCalculation
            var isNegative: Bool = animationStep < 0.0
            
            for index in 0..count {
                if (!isNegative) {
                    if (val > endValue) {
                        val = endValue
                    }
                } else {
                    if (val < endValue) {
                        val = endValue
                    }
                }
                
                advancementArray.addObject(val)
                val += animationStep
            }
            
        } else if (easeIn && easeOut) {
            
            populateAdvancementArray(advancementArray,
                startPoint: CGPointMake(startValue, startValue),
                controlPoint1: CGPointMake(startValue, endValue),
                controlPoint2: CGPointMake(endValue, startValue),
                endPoint: CGPointMake(endValue, endValue),
                granularity: count)

        } else if (easeIn) {
            
            populateAdvancementArray(advancementArray,
                startPoint: CGPointMake(startValue, startValue),
                controlPoint1: CGPointMake(startValue, endValue),
                controlPoint2: CGPointMake(startValue, endValue),
                endPoint: CGPointMake(endValue, endValue),
                granularity: count)
            
        } else if (easeOut) {
            
            populateAdvancementArray(advancementArray,
                startPoint: CGPointMake(startValue, startValue),
                controlPoint1: CGPointMake(endValue, startValue),
                controlPoint2: CGPointMake(endValue, startValue),
                endPoint: CGPointMake(endValue, endValue),
                granularity: count)
        }
        
        var existingAnimation: JFPropertyAnimation? = sharedAnimator.animationForAnimatable(object, propertyId: propertyId)
        if (existingAnimation != nil) {
            // Stop the existing animation before adding it again...
            stopAnimatingObject(object, propertyId: propertyId)
        }
        
        // Create the animation...
        var animation: JFPropertyAnimation = JFPropertyAnimation(target: object)
        animation.propertyId = propertyId
        animation.playCount = playCount
        animation.animationAdvancementArray = advancementArray
        animation.changeHandler = change
        animation.completionHandler = completion
        
        // Add the animation to the managed array...
        sharedAnimator.addManagedAnimation(animation)
        
        return animation
    }
    
    class func animateObject(object: JFPropertyAnimatable, propertyId: UInt, advancementArray: NSMutableArray, playCount: Int, change: (Float) -> (), completion: (JFPropertyAnimatable, UInt, Int) -> ()) -> JFPropertyAnimation? {
        
        var animation: JFPropertyAnimation = JFPropertyAnimation(target: object)
        animation.propertyId = propertyId
        animation.playCount = playCount
        animation.animationAdvancementArray = advancementArray
        animation.changeHandler = change
        animation.completionHandler = completion
        
        var sharedAnimator: JFPropertyAnimator = JFPropertyAnimator.sharedAnimator()
        sharedAnimator.addManagedAnimation(animation)
        
        return animation
    }
    
    class func stopAnimatingObject(object: JFPropertyAnimatable, propertyId: UInt) {
        
        var sharedAnimator: JFPropertyAnimator = JFPropertyAnimator.sharedAnimator()
        sharedAnimator.innerStopAnimatingObject(object, propertyId: propertyId, value: Float.NaN)
    }
    
    class func stopAnimatingObject(object: JFPropertyAnimatable, propertyId: UInt, finalValue: Float) {
        
        var sharedAnimator: JFPropertyAnimator = JFPropertyAnimator.sharedAnimator()
        sharedAnimator.innerStopAnimatingObject(object, propertyId: propertyId, value: finalValue)
    }
    
    func innerStopAnimatingObject(object: JFPropertyAnimatable, propertyId: UInt, value: Float) {
        
        for anim: AnyObject in managedAnimations {
            var animation: JFPropertyAnimation = anim as JFPropertyAnimation
            var target: JFPropertyAnimatable = animation.target
            if (!object.isEqualTo(target)) {
                continue
            }
            
            var animationPropertyId: UInt = animation.propertyId
            if (animationPropertyId != propertyId) {
                continue
            }
            
            animation.stop()
            if (!value.isNaN) {
                object.setAnimatablePropertyToNewValue(propertyId, newValue: value)
            }
            
            animationsToRemove.addObject(animation)
        }
        
        if (animationsToRemove.count > 0) {
            managedAnimations.removeObjectsInArray(animationsToRemove)
            animationsToRemove.removeAllObjects()
        }
    }
    
    class func pause() {
        
        JFPropertyAnimator.sharedAnimator().paused = true
    }
    
    class func unpause() {
        
        JFPropertyAnimator.sharedAnimator().paused = false
    }
    
    /*
     * Returns true if the ease-in and ease-out flags denote that a given
     * animation is linear in its advancement.
     */
    class func isLinearWithEaseIn(easeIn: Bool, easeOut: Bool) -> Bool {
        
        return !easeIn && !easeOut
    }
    
    /*
     * Generates the ease-in, ease-out curve path given the start, control and end points assigned.
     * The granularity determines the number of elements that will be present in the resulting array.
     */
    class func populateAdvancementArray(advancementArray: NSMutableArray, startPoint: CGPoint, controlPoint1: CGPoint, controlPoint2: CGPoint, endPoint: CGPoint, granularity: UInt) {
        
        var step: Float = (1.0 / (Float(granularity) - 1.0))
        var t: Float = 0.0
        
        for (var loop: UInt = 0; loop < granularity - UInt(1); loop++, t += step) {
            var c: CGPoint = CGPointMake(3.0 * (controlPoint1.x - startPoint.x), (controlPoint1.y - startPoint.y))
            var b: CGPoint = CGPointMake(3.0 * (controlPoint2.x - controlPoint1.x) - c.x, 3.0 * (controlPoint2.y - controlPoint1.y) - c.y)
            var a: CGPoint = CGPointMake(endPoint.x - startPoint.x - c.x - b.x, endPoint.y - startPoint.y - c.y - b.y)
            
            var t2: Float = t * t
            var t3: Float = t2 * t
            
            var temp: CGPoint = CGPointMake((a.x * t3) + (b.x * t2) + (c.x * t) + startPoint.x, (a.y * t3) + (b.y * t2) + (c.y * t) + startPoint.y)
            
            advancementArray[Int(loop)] = temp.x
        }
        
        advancementArray[Int(granularity - 1)] = endPoint.x
    }
}
