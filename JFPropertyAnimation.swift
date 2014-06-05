//
// JFPropertyAnimation.swift
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


/*
 * An animation which is applied against a target
 * (implementing the JFPropertyAnimatable protocol)
 * and its property.
*/
class JFPropertyAnimation {
    
    // The animatable target.
    var target: JFPropertyAnimatable
    
    // The property being animated.
    var propertyId: UInt = 0
    
    // The func/closure to be notified upon each change in value.
    var changeHandler: (currentValue: Float) -> Void
    
    // The func/closure to be notified upon completion of the animation.
    var completionHandler: (object: JFPropertyAnimatable, propertyId: UInt, playLoop: Int) -> Void
    
    // The array of values to iterate over.
    var animationAdvancementArray: NSMutableArray = NSMutableArray()
    
    // The index into the above array.
    var animationAdvancementIndex: Int = 0
    
    // The number of times this animation plays/repeats.
    var playCount: Int = 0
    
    // The current play index.
    var playIndex: Int = 1
    
    // The flag denoting whether the animation is paused or not.
    var paused: Bool = false
    
    // The flag denoting whether the animation is stopped or not.
    var stopped: Bool = false
    
    // Genral purpose tag.
    var tag: UInt = 0
    
    
    init(target: JFPropertyAnimatable) {
        
        self.target = target
        
        func doNothingChangeHandler(currentValue: Float) -> Void { /* do nothing */ }
        changeHandler = doNothingChangeHandler
        
        func doNothingCompletionHandler(object: JFPropertyAnimatable, propertyId: UInt, playLoop: Int) -> Void { /* do nothing */ }
        completionHandler = doNothingCompletionHandler
    }
    
    
    func advance() {
        
        if (paused || stopped || hasReachedEnd()) {
            return
        }
        
        var newValue = animationAdvancementArray[animationAdvancementIndex] as Float
        target.setAnimatablePropertyToNewValue(propertyId, newValue: newValue)
        animationAdvancementIndex++
    }
    
    func hasReachedEnd() -> Bool {
        
        var count: Int = animationAdvancementArray.count
        return animationAdvancementIndex >= count
    }
    
    func repeat() {
        
        if (paused || stopped) {
            return
        }
        
        animationAdvancementIndex = 0
        playIndex++
    }
    
    func pause() {
        
        paused = true
    }
    
    func unpause() {
        
        paused = false
    }
    
    func stop() {
        
        stopped = true
    }
}
