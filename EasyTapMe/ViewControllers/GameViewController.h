//
//  GameViewController.h
//  TapMeIfYouCan
//
//  Created by Andrey on 21.12.17.
//  Copyright © 2017 deynega. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GameConfigurator.h"
#import "Game.h"

@interface GameViewController : UIViewController

- (instancetype)initWithDifficultType:(DifficultType)type;
- (instancetype)initWithGame:(Game *)game;


@end
