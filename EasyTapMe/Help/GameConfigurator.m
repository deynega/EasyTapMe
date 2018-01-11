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

#pragma mark - Random

- (NSArray *)randomizeTagsWithDifficult:(DifficultType)type {
    int boxesCountMax = [self boxesCountMaxFromDifficult:type];
    NSUInteger previousNumber = 100;
    NSUInteger boxesFlashCountMax = [self boxesFlashCountMaxFromDifficult:type];
    NSMutableArray *array = [NSMutableArray array];
    for (NSUInteger i = 0; i < boxesFlashCountMax; i++) {
        NSUInteger random;
        do {
            random = (NSUInteger)arc4random_uniform(boxesCountMax);
        } while (random == previousNumber);
        previousNumber = random;
        
        [array addObject:@(random)];
    }
    return array;
}

#pragma mark - Box/Flash Count

- (int)boxesCountMaxFromDifficult:(DifficultType)type {
    return (int)pow([self rowCountFromDifficult:type], 2);
}

- (NSUInteger)boxesFlashCountMaxFromDifficult:(DifficultType)type {
    return [self rowCountFromDifficult:type] +1;
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
