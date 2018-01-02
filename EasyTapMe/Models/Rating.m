//
//  Rating.m
//  TapMeIfYouCan
//
//  Created by Andrey on 28.12.17.
//  Copyright © 2017 deynega. All rights reserved.
//

#import "Rating.h"
#import "GameViewController.h"


@interface Rating ()
@property (nonatomic, strong) GameViewController *gameVC;

@end

@implementation Rating

- (instancetype)init {
    self = [super init];
    if (self) {
        [self makeNewArray];
        _gameVC = [[GameViewController alloc] init];
    }
    return self;
}

-(void)makeNewArray {
    self.recordsArray = [NSMutableArray array];
    if (![NSUserDefaults.standardUserDefaults objectForKey:@"records"]) {
        [NSUserDefaults.standardUserDefaults setObject:self.recordsArray forKey:@"records"];
    }else {
        self.recordsArray = [NSMutableArray arrayWithArray:[NSUserDefaults.standardUserDefaults objectForKey:@"records"]];
    }
}

- (int)checkCurrentResult:(NSNumber *)result {
    if (result.unsignedIntegerValue == 0) {
        NSLog(@"Looser!");
        return 0;
    } else if ([self checkForBestResult:result] == YES) {
        [self addResult:result];
        NSLog(@"Best result!");
        return 3;
    } else if ([self checkForTableCurrentResult:result] == YES) {
        [self addResult:result];
        NSLog(@"Hit the table!!");
        return 2;
    } else {
        NSLog(@"Game Over!");
        return 1;
    }
}

- (BOOL)checkForTableCurrentResult:(NSNumber *)result {
    NSUInteger res = result.unsignedIntegerValue;
    if (res == 0) {
        return NO;
    } else {
        if ((self.recordsArray.count < 10) || (result > self.recordsArray.lastObject)) {
            return YES;
        } else
            return  NO;
    }
}

- (BOOL)checkForBestResult:(NSNumber *)result {
    if (result > self.recordsArray.firstObject) {
        return YES;
    } else {
        return NO;
    }
}

-(void)addResult:(NSNumber *)result {
    [self.recordsArray addObject:result];
    [self sortRecordsArray];
    [NSUserDefaults.standardUserDefaults setObject:self.recordsArray forKey:@"records"];
}

-(void)sortRecordsArray {
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"self" ascending:NO];
    [self.recordsArray sortUsingDescriptors:[NSArray arrayWithObject:sort]];
    while (self.recordsArray.count > 10) {
        [self.recordsArray removeLastObject];
    }
}


@end
