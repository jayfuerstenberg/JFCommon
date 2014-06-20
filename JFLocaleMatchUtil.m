//
// JFLocaleMatchUtil.m
// JFCommon
//
// Created by Jason Fuerstenberg on 2013/02/26.
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

#import "JFLocaleMatchUtil.h"

#define JFLocaleAmericanEnglish					@"en_US"
#define JFLocaleAmericanSamoanEnglish			@"en_AS"
#define JFLocaleAustralianEnglish				@"en_AU"
#define JFLocaleBritishEnglish					@"en_GB"
#define JFLocaleCanadianEnglish					@"en_CA"
#define JFLocaleFilipinoEnglish					@"en_PH"
#define JFLocaleIndianEnglish					@"en_IN"
#define JFLocaleMauritianEnglish				@"en_MU"
#define JFLocaleNewZealandishEnglish			@"en_NZ"
#define JFLocaleSouthAfricanEnglish				@"en_ZA"

#define JFLocaleBelgianFrench					@"fr_BE"
#define JFLocaleCanadianFrench					@"fr_CA"
#define JFLocaleFrenchFrench					@"fr_FR"
#define JFLocaleLuxembourgianFrench				@"fr_LU"
#define JFLocaleMauritianFrench					@"fr_MU"

#define JFLocaleJapanese						@"ja_JP"

#define JFLocaleAmericanSpanish					@"es_US"
#define JFLocaleArgentinianSpanish				@"es_AR"
#define JFLocaleChileanSpanish					@"es_CL"
#define JFLocaleColumbianSpanish				@"es_CO"
#define JFLocaleMexicanSpanish					@"es_MX"
#define JFLocaleSpanishSpanish					@"es_ES"
#define JFLocaleHonduranSpanish					@"es_HN"
#define JFLocalePeruvianSpanish					@"es_PE"
#define JFLocaleVenezuelanSpanish				@"es_VE"
// Puerto Rican Spanish?  Add later.

#define JFLocaleAngolanPortuguese				@"pt_AO"
#define JFLocaleBrazilianPortuguese				@"pt_BR"
#define JFLocalePortuguesePortuguese			@"pt_PT"


@implementation JFLocaleMatchUtil

/*
 * Returns the best locale from those an app supports (supportedLocales) given those available on the device (availableLocales), failing this falling back on the specified locale (fallbackLocale).
 * The returned locale, if not the fallback one will be in lowercase.
 */
+ (NSString *) optimalLocaleFromSupportedLocales: (NSArray *) supportedLocales forAvailableLocales: (NSArray *) availableLocales fallingBackOnLocale: (NSString *) fallbackLocale {
	
	NSUInteger supportedLocaleCount = [supportedLocales count];
	NSUInteger availableLocaleCount = [availableLocales count];
	
	if (supportedLocaleCount == 0) {
		return fallbackLocale;
	}
	
	if (availableLocaleCount == 0) {
		return fallbackLocale;
	}
	
	@synchronized (availableLocales) {
		@synchronized (supportedLocales) {
			for (NSString *availableLocale in availableLocales) {
				BOOL supported = [supportedLocales containsObject: availableLocale];
				if (supported) {
					// This available locale is perfectly supported as is.
					return availableLocale;
				}
				
				NSString *closeLocale = [self closeLocaleForLocale: availableLocale];
				supported = [supportedLocales containsObject: closeLocale];
				if (supported) {
					// This close locale is supported.
					return closeLocale;
				}
			}
		}
	}
	
	// There was no match so return the fallback locale.
	return fallbackLocale;
}

+ (NSArray *) topTenLocalesFromPreferredLanguages: (NSArray *) preferredLanguages andRegionOfCurrentLocale: (NSString *) currentLocale {
	
	NSUInteger preferredLanguageCount = [preferredLanguages count];
	if (preferredLanguageCount == 0) {
		return nil;
	}
	
	if ([currentLocale length] == 0) {
		return nil;
	}
	
	NSRange rangeOfUnderbar = [currentLocale rangeOfString: @"_"];
	NSString *region = [[currentLocale substringFromIndex: rangeOfUnderbar.location + 1] uppercaseString];
	
	NSMutableArray *topTenLocales = [NSMutableArray arrayWithCapacity: 10];
	NSUInteger count = 0;
	
	@synchronized (preferredLanguages) {
		for (NSString *preferredLanguage in preferredLanguages) {
			NSRange rangeOfHyphen = [preferredLanguage rangeOfString: @"-"];
			if (rangeOfHyphen.location != NSNotFound) {
				// Don't consider languages that already have regions attached.
				continue;
			}
			
			NSString *locale = [[preferredLanguage lowercaseString] stringByAppendingFormat: @"_%@", region];
			
			[topTenLocales addObject: locale];
			count++;
			
			if (count == 10) {
				return topTenLocales;
			}
		}
	}
	return topTenLocales;
}

/*
 * Returns a close locale for the one provided or nil if one wasn't found.
 */
+ (NSString *) closeLocaleForLocale: (NSString *) locale {
	
	NSString *closeLocale = nil;
	/*closeLocale = [self closeChineseLocaleForLocale: locale];
	if (closeLocale != nil) {
		return closeLocale;
	}*/
	
	closeLocale = [self closeEnglishLocaleForLocale: locale];
	if (closeLocale != nil) {
		return closeLocale;
	}
	
	closeLocale = [self closeFrenchLocaleForLocale: locale];
	if (closeLocale != nil) {
		return closeLocale;
	}
	
	closeLocale = [self closeJapaneseLocaleForLocale: locale];
	if (closeLocale != nil) {
		return closeLocale;
	}
	
	closeLocale = [self closePortugueseLocaleForLocale: locale];
	if (closeLocale != nil) {
		return closeLocale;
	}
	
	closeLocale = [self closeSpanishLocaleForLocale: locale];
	if (closeLocale != nil) {
		return closeLocale;
	}
	
	return nil;
}

// TODO: Add this later...
/*+ (NSString *) closeChineseLocaleForLocale: (NSString *) locale {
	
	// HK
	// Taiwanese
	
	return nil;
}*/

/*
 * Returns a close English locale for the one provided or nil if one wasn't found.
 */
+ (NSString *) closeEnglishLocaleForLocale: (NSString *) locale {
	
	// American English
	if ([locale compare: JFLocaleAmericanSamoanEnglish options: NSCaseInsensitiveSearch] == NSOrderedSame) { return JFLocaleAmericanEnglish; }
	if ([locale compare: JFLocaleFilipinoEnglish options: NSCaseInsensitiveSearch] == NSOrderedSame) { return JFLocaleAmericanEnglish; }
    // Guam?
	// Saipan?
	
	// British English
	if ([locale compare: JFLocaleAustralianEnglish options: NSCaseInsensitiveSearch] == NSOrderedSame) { return JFLocaleBritishEnglish; }
	if ([locale compare: JFLocaleCanadianEnglish options: NSCaseInsensitiveSearch] == NSOrderedSame) { return JFLocaleBritishEnglish; }
	if ([locale compare: JFLocaleIndianEnglish options: NSCaseInsensitiveSearch] == NSOrderedSame) { return JFLocaleBritishEnglish; }
	if ([locale compare: JFLocaleMauritianEnglish options: NSCaseInsensitiveSearch] == NSOrderedSame) { return JFLocaleBritishEnglish; }
	if ([locale compare: JFLocaleNewZealandishEnglish options: NSCaseInsensitiveSearch] == NSOrderedSame) { return JFLocaleBritishEnglish; }
	if ([locale compare: JFLocaleSouthAfricanEnglish options: NSCaseInsensitiveSearch] == NSOrderedSame) { return JFLocaleBritishEnglish; }
	
	if ([JFLocaleMatchUtil isLocale: locale usingLanguageCode: @"en"]) {
		// It's some sort of English so assume American as that is the biggest market of English speakers.
		return JFLocaleAmericanEnglish;
	}
	
	return nil;
}

+ (NSString *) closeFrenchLocaleForLocale: (NSString *) locale {
	
	if ([locale compare: JFLocaleBelgianFrench options: NSCaseInsensitiveSearch] == NSOrderedSame) { return JFLocaleFrenchFrench; }
	if ([locale compare: JFLocaleCanadianFrench options: NSCaseInsensitiveSearch] == NSOrderedSame) { return JFLocaleFrenchFrench; }
	if ([locale compare: JFLocaleLuxembourgianFrench options: NSCaseInsensitiveSearch] == NSOrderedSame) { return JFLocaleFrenchFrench; }
	if ([locale compare: JFLocaleMauritianFrench options: NSCaseInsensitiveSearch] == NSOrderedSame) { return JFLocaleFrenchFrench; }
	
	// Tahiti
	
	if ([JFLocaleMatchUtil isLocale: locale usingLanguageCode: @"fr"]) {
		// It's some sort of French so assume French French.
		return JFLocaleFrenchFrench;
	}
	
	return nil;
}

/*
 * Returns a close English locale for the one provided or nil if one wasn't found.
 */
+ (NSString *) closeJapaneseLocaleForLocale: (NSString *) locale {
	
	if ([JFLocaleMatchUtil isLocale: locale usingLanguageCode: @"ja"]) {
		// It's some sort of Japanese locale so assume Japanese Japanese.
		return JFLocaleJapanese;
	}
	
	return nil;
}

+ (NSString *) closePortugueseLocaleForLocale: (NSString *) locale {
	
	if ([locale compare: JFLocaleAngolanPortuguese options: NSCaseInsensitiveSearch] == NSOrderedSame) { return JFLocalePortuguesePortuguese; }
	if ([locale compare: JFLocaleBrazilianPortuguese options: NSCaseInsensitiveSearch] == NSOrderedSame) { return JFLocalePortuguesePortuguese; }
	
	if ([JFLocaleMatchUtil isLocale: locale usingLanguageCode: @"pt"]) {
		// It's some sort of Portuguese so assume Portuguese Portuguese.
		return JFLocalePortuguesePortuguese;
	}
	
	return nil;
}

+ (NSString *) closeSpanishLocaleForLocale: (NSString *) locale {

	if ([locale compare: JFLocaleAmericanSpanish options: NSCaseInsensitiveSearch] == NSOrderedSame) { return JFLocaleSpanishSpanish; }
	if ([locale compare: JFLocaleArgentinianSpanish options: NSCaseInsensitiveSearch] == NSOrderedSame) { return JFLocaleSpanishSpanish; }
	if ([locale compare: JFLocaleChileanSpanish options: NSCaseInsensitiveSearch] == NSOrderedSame) { return JFLocaleSpanishSpanish; }
	if ([locale compare: JFLocaleColumbianSpanish options: NSCaseInsensitiveSearch] == NSOrderedSame) { return JFLocaleSpanishSpanish; }
	if ([locale compare: JFLocaleHonduranSpanish options: NSCaseInsensitiveSearch] == NSOrderedSame) { return JFLocaleSpanishSpanish; }
	if ([locale compare: JFLocaleMexicanSpanish options: NSCaseInsensitiveSearch] == NSOrderedSame) { return JFLocaleSpanishSpanish; }
	if ([locale compare: JFLocalePeruvianSpanish options: NSCaseInsensitiveSearch] == NSOrderedSame) { return JFLocaleSpanishSpanish; }
	if ([locale compare: JFLocaleVenezuelanSpanish options: NSCaseInsensitiveSearch] == NSOrderedSame) { return JFLocaleSpanishSpanish; }
	
	if ([JFLocaleMatchUtil isLocale: locale usingLanguageCode: @"es"]) {
		// It's some sort of Spanish so assume Spanish Spanish.
		return JFLocaleSpanishSpanish;
	}
	
	return nil;
}


+ (BOOL) isLocale: (NSString *) locale usingLanguageCode: (NSString *) languageCode {
	
	if ([locale length] == 0) {
		return NO;
	}
	
	if ([languageCode length] != 2) {
		return NO;
	}
	
	NSRange rangeOfLanguageCode = [locale rangeOfString: languageCode];
	return rangeOfLanguageCode.location == 0 && rangeOfLanguageCode.length == 2;
}

@end
