//
//  JFCoordinateFormatter.m
//  JFCommon
//
//  Created by Jason Fuerstenberg on 2010/08/11.
//  Copyright 2010 Jason Fuerstenberg. All rights reserved.
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

#import "JFCoordinateFormatter.h"


@implementation JFCoordinateFormatter


#pragma mark - Properties

@synthesize northText = _northText;
@synthesize southText = _southText;
@synthesize westText = _westText;
@synthesize eastText = _eastText;


#pragma mark - Object lifecycle methods

- (void) dealloc {

	JFRelease(_northText);
	JFRelease(_southText);
	JFRelease(_westText);
	JFRelease(_eastText);
	
	[super dealloc];
}


#pragma mark - Methods

- (NSString *) formattedStringForLatitude: (double) latitude longitude: (double) longitude {

	NSString *verticalLabel = @"";
	NSString *horizontalLabel = @"";
	
	if (latitude > 0.0f) {
		verticalLabel = _northText;
	} else if (latitude < 0.0f) {
		verticalLabel = _southText;
	}
	
	if (longitude > 0.0f) {
		horizontalLabel = _eastText;
	} else if (longitude < 0.0f) {
		horizontalLabel = _westText;
	}
	
	return [NSString stringWithFormat: @"%f %@ : %f %@", fabs(latitude), verticalLabel, fabs(longitude), horizontalLabel];
}

@end
