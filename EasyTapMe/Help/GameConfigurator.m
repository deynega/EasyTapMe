//
//  GameConfigurator.m
//  TapMeIfYouCan
//
//  Created by Andrey on 21.12.17.
//  Copyright © 2017 deynega. All rights reserved.
//

#import "GameConfigurator.h"

@implementation GameConfigurator

+ (GameConfigurator *)configurator {
    
    static GameConfigurator *configurator = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        configurator = [GameConfigurator new];
    });
    return configurator;
}

- (CGFloat)animationDuration {
    return .5f;
}

- (NSArray *)randomizeTagsWithDifficult:(DifficultType)type {
    int boxesCountMax = [self boxesCountMaxFromDifficult:type];
    NSUInteger boxesFlashCountMax = [self boxesFlashCountMaxFromDifficult:type];
    NSMutableArray *array = [NSMutableArray array];
    for (NSUInteger i = 0; i < boxesFlashCountMax; i++) {
        NSUInteger random = (NSUInteger)arc4random_uniform(boxesCountMax);
        [array addObject:@(random)];
    }
    return array;
}

- (int)boxesCountMaxFromDifficult:(DifficultType)type {
    switch (type) {
        case DifficultTypeEasy:
            return 9;
            break;
        case DifficultTypeNormal:
            return 16;
            break;
        case DifficultTypeHard:
            return 25;
            break;
    }
}

- (NSUInteger)boxesFlashCountMaxFromDifficult:(DifficultType)type {
    switch (type) {
        case DifficultTypeEasy:
            return 4;
            break;
        case DifficultTypeNormal:
            return 5;
            break;
        case DifficultTypeHard:
            return 6;
            break;
    }
}

- (NSUInteger)rowCountFromDifficult:(DifficultType)type {
    switch (type) {
        case DifficultTypeEasy:
            return 3;
            break;
        case DifficultTypeNormal:
            return 4;
            break;
        case DifficultTypeHard:
            return 5;
            break;
    }
}

- (NSUInteger)increaseScoreCountFromDifficult:(DifficultType)type {
    switch (type) {
        case DifficultTypeEasy:
            return 10;
            break;
        case DifficultTypeNormal:
            return 25;
            break;
        case DifficultTypeHard:
            return 50;
            break;
    }
}


@end
