//
//  Rating.h
//  TapMeIfYouCan
//
//  Created by Andrey on 28.12.17.
//  Copyright © 2017 deynega. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Rating : NSObject

@property (nonatomic, strong) NSMutableArray *recordsArray;
@property (nonatomic, strong) NSMutableDictionary *recordsDict;

- (instancetype)init;

- (int)checkCurrentResult:(NSNumber *)result;
- (void)sortRecordsArray;


@end
