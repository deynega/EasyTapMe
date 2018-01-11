//
//  Game.m
//  TapMeIfYouCan
//
//  Created by Andrey on 21.12.17.
//  Copyright © 2017 deynega. All rights reserved.
//

#import "Game.h"

@implementation Game

- (instancetype)init {
    self = [super init];
    if (self) {
        _score = @(0);
        _lives = @(3);
    }
    return self;
}

- (instancetype)initEasyGame {
    self = [self init];
    if (self) {
        _difficultType = DifficultTypeEasy;
    }
    return self;
}

- (instancetype)initNormalGame {
    self = [self init];
    if (self) {
        _difficultType = DifficultTypeNormal;
    }
    return self;
}

- (instancetype)initHardGame {
    self = [self init];
    if (self) {
        _difficultType = DifficultTypeHard;
    }
    return self;
}

#pragma mark - NSCoding

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if (self) {
        _score = [aDecoder decodeObjectForKey:@"score"];
        _lives = [aDecoder decodeObjectForKey:@"lives"];
        _difficultType = [aDecoder decodeIntegerForKey: @"difficulType"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:_score forKey:@"score"];
    [aCoder encodeObject:_lives forKey:@"lives"];
    [aCoder encodeInteger:_difficultType forKey:@"difficulType"];
}

- (void)saveGame {
    NSData *encodedObject = [NSKeyedArchiver archivedDataWithRootObject:self];
    [NSUserDefaults.standardUserDefaults setObject:encodedObject forKey:@"currentGame"];
    [NSUserDefaults.standardUserDefaults synchronize];
}

- (Game *)loadGame {
    NSData *encodedObject = [NSUserDefaults.standardUserDefaults objectForKey:@"currentGame"];
    Game *savedGame = [NSKeyedUnarchiver unarchiveObjectWithData:encodedObject];
    return savedGame;
}

- (NSNumber *)increaseScore {
    NSUInteger raise = [[GameConfigurator configurator] increaseScoreCountFromDifficult:self.difficultType];
    self.score = @(self.score.unsignedIntegerValue + raise);
    return self.score;
}


@end
