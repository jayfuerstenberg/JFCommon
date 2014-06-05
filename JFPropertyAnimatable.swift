//
// JFPropertyAnimatable.swift
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
 * The protocol to which objects whose properties are animatable must adhere.
 * A property can be anything and common examples include color, position and opacity.
 * The property value is assumed to be a floating point number but can be rounded
 * to an integer type if needed.
 *
 * Objects intending to be animated are typically added to the PropertyAnimator
 * class via one of the animateObject... class methods.
 */
protocol JFPropertyAnimatable {
    
    /*
    * Assigns the new value of the provided property.
    * The property ID is arbitrary and application specific.
    */
    func setAnimatablePropertyToNewValue(propertyId: UInt, newValue: Float) -> Void
    
    /*
    * Returns the current value of the provided property ID.
    */
    func valueOfAnimatableProperty(propertyId: UInt) -> Float
    
    /*
     * Return true if the other object is equal to the receiver.
     */
    func isEqualTo(other: JFPropertyAnimatable?) -> Bool
}
