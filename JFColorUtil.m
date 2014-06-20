//
// JFColorUtil.m
// JFCommon
//
// Created by Jason Fuerstenberg on 2013/02/13.
// Copyright (c) 2013 Jason Fuerstenberg. All rights reserved.
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


#import "JFColorUtil.h"


@implementation JFColorUtil

+ (UIColor *) colorByDarkeningColor: (UIColor *) color {
    
    if (color == nil) {
        return nil;
    }
    
	// oldComponents is the array INSIDE the original color
	// changing these changes the original, so we copy it
	CGFloat *oldComponents = (CGFloat *) CGColorGetComponents([color CGColor]);
	CGFloat newComponents[4];
	
	int numComponents = CGColorGetNumberOfComponents([color CGColor]);
	
	switch (numComponents) {
		case 2:
			//grayscale
			newComponents[0] = oldComponents[0] * 0.7;
			newComponents[1] = oldComponents[0] * 0.7;
			newComponents[2] = oldComponents[0] * 0.7;
			newComponents[3] = oldComponents[1];
			break;
            
		case 4:
			//RGBA
			newComponents[0] = oldComponents[0] * 0.7;
			newComponents[1] = oldComponents[1] * 0.7;
			newComponents[2] = oldComponents[2] * 0.7;
			newComponents[3] = oldComponents[3];
			break;
	}
	
	CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
	CGColorRef newColor = CGColorCreate(colorSpace, newComponents);
	CGColorSpaceRelease(colorSpace);
	
	UIColor *retColor = [UIColor colorWithCGColor: newColor];
	CGColorRelease(newColor);
	
	return retColor;
}

+ (UIColor *) colorByLighteningColor: (UIColor *) color {
    
    if (color == nil) {
        return nil;
    }
    
	// oldComponents is the array INSIDE the original color
	// changing these changes the original, so we copy it
	CGFloat *oldComponents = (CGFloat *) CGColorGetComponents([color CGColor]);
	CGFloat newComponents[4];
	
	int numComponents = CGColorGetNumberOfComponents([color CGColor]);
	
	switch (numComponents) {
		case 2:
            //grayscale
			newComponents[0] = MIN(1.0f, oldComponents[0] + 0.3);
			newComponents[1] = MIN(1.0f, oldComponents[0] + 0.3);
			newComponents[2] = MIN(1.0f, oldComponents[0] + 0.3);
			newComponents[3] = oldComponents[1];
			break;
		case 4:
			//RGBA
			newComponents[0] = MIN(1.0f, oldComponents[0] + 0.3);
			newComponents[1] = MIN(1.0f, oldComponents[1] + 0.3);
			newComponents[2] = MIN(1.0f, oldComponents[2] + 0.3);
			newComponents[3] = oldComponents[3];
			break;
	}
	
	CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
	CGColorRef newColor = CGColorCreate(colorSpace, newComponents);
	CGColorSpaceRelease(colorSpace);
	
	UIColor *retColor = [UIColor colorWithCGColor: newColor];
	CGColorRelease(newColor);
	
	return retColor;
}

@end
