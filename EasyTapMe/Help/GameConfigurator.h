//
//  GameConfigurator.h
//  TapMeIfYouCan
//
//  Created by Andrey on 21.12.17.
//  Copyright © 2017 deynega. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>

typedef NS_ENUM(NSUInteger, DifficultType) {
    DifficultTypeEasy,
    DifficultTypeNormal,
    DifficultTypeHard
};

@interface GameConfigurator : NSObject

+ (GameConfigurator *)configurator;
- (CGFloat)animationDuration;
- (NSArray *)randomizeTagsWithDifficult:(DifficultType)type;
- (NSUInteger)rowCountFromDifficult:(DifficultType)type;
- (NSUInteger)boxesFlashCountMaxFromDifficult:(DifficultType)type;
- (NSUInteger)increaseScoreCountFromDifficult:(DifficultType)type;


@end

