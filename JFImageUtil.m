//
// JFImageUtil.m
// JFCommon
//
// Created by Jason Fuerstenberg on 2011/02/01.
// Copyright 2011 Jason Fuerstenberg. All rights reserved.
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

#import "JFImageUtil.h"


@implementation JFImageUtil

+ (UIImage *) scaleImage: (UIImage *) image ifDimensionsExceedSize: (CGSize) size {

	if (image == nil) {
		return nil;
	}
	
	CGFloat width = image.size.width;
	CGFloat height = image.size.height;
	
	if (width == 0.0f || height == 0.0f) {
		// The image has improper dimensions so return nil.
		return nil;
	}
	
	if (width <= size.width && height <= size.height) {
		// The image fits so just return it as is.
		return image;
	}
	
	CGFloat scale = [JFImageUtil imageScaleForSourceSize: image.size
											  targetSize: size];
	
	CGSize newSize = CGSizeMake(width * scale, height * scale);
		
	return [self imageWithImage: image
                   scaledToSize: newSize];
}
	 
+ (UIImage *) imageWithImage: (UIImage *) image scaledToSize: (CGSize) newSize {
	
	UIGraphicsBeginImageContext(newSize);
	[image drawInRect: CGRectMake(0.0f, 0.0f, newSize.width, newSize.height)];
	UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
    
	return newImage;
}

+ (CGFloat) imageScaleForSourceSize: (CGSize) sourceSize targetSize: (CGSize) targetSize {

	CGFloat scaleX = targetSize.width / sourceSize.width;
	CGFloat scaleY = targetSize.height / sourceSize.height;
	
	if (scaleX < scaleY) {
		return scaleX;
	}
	
	return scaleY;
}

@end
