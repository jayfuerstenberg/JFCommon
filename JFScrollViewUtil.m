//
// JFScrollViewUtil.m
// JFCommon
//
// Created by Jason Fuerstenberg on 2012/02/03.
// Copyright (c) 2012 Jason Fuerstenberg. All rights reserved.
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

#import "JFScrollViewUtil.h"


@implementation JFScrollViewUtil

#if TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR

/*
 * Scrolls the scroll view such that the view is not obscured by a keyboard of designated height.
 * Keyboard height is specifiable here to allow for custom input views injected in the view.
 * The scroll view is assumed to reach the bottom of the screen, therefore putting itself in the
 * way of the keyboard.
 *
 * The onus is on the caller to reverse the scroll and shrink the scroll view's content size by
 * the amount returned when the edit has ended.
 */
+ (CGFloat) scrollView: (UIScrollView *) scrollView byKeyboardHeight: (CGFloat) keyboardHeight ifNeededToUnobscureView: (UIView *) view  {
	
	if (view == nil) {
		return 0.0f;
	}
	
	CGSize contentSize = [scrollView contentSize];
	CGPoint contentOffset = [scrollView contentOffset];
	CGRect viewFrame = [view frame];
	CGRect viewFrameInScrollView = [scrollView convertRect: viewFrame
                                                  fromView: [view superview]];
	CGFloat lowestPoint = viewFrameInScrollView.origin.y + viewFrameInScrollView.size.height;
	CGFloat lowestPointConsideringOffset = lowestPoint - contentOffset.y;
	
	// This logic assumes the content length stretches for the entire length of the screen.
	CGFloat lowestVisibleScrollViewPoint = scrollView.frame.size.height - keyboardHeight;
	
	// NOTE: Add 30 points to provide a decent margin...
	CGFloat amountToScroll = lowestPointConsideringOffset - lowestVisibleScrollViewPoint + 30.0f;
	
	// Add to the content size to ensure the scroll will work.
	[scrollView setContentSize: CGSizeMake(contentSize.width, contentSize.height + keyboardHeight)];
	
	// Perform the scrolling now...
	if (amountToScroll > 0.0f) {
		[scrollView setContentOffset: CGPointMake(contentOffset.x, contentOffset.y + amountToScroll)
                            animated: YES];
	}
	
	return amountToScroll;
}

/*
 * Locates the first super view of the provided view which is a UIScrollView if any, or nil.
 */
+ (UIScrollView *) firstScrollViewInSuperViewHierarchyOfView: (UIView *) view {
	
	while (view != nil) {
		if ([view isKindOfClass: [UIScrollView class]]) {
			return (UIScrollView *) view;
		}
		
		view = [view superview];
	}
	
	return nil;
}

#endif

@end
