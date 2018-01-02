//
//  Game.h
//  TapMeIfYouCan
//
//  Created by Andrey on 21.12.17.
//  Copyright © 2017 deynega. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GameConfigurator.h"

@interface Game : NSObject <NSCoding>

@property (nonatomic, strong) NSNumber *score;
@property (nonatomic, strong) NSNumber *lives;
@property (nonatomic, assign, readonly) DifficultType difficultType;

- (instancetype)initEasyGame;
- (instancetype)initNormalGame;
- (instancetype)initHardGame;

- (void)saveGame;
- (Game *)loadGame;
- (NSNumber *)increaseScore;


@end
