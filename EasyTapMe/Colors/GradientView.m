//
//  GradientView.m
//  TapMeIfYouCan
//
//  Created by Andrey on 21.12.17.
//  Copyright © 2017 deynega. All rights reserved.
//

#import "GradientView.h"
#import "Colors.h"

@implementation GradientView

- (instancetype)initWithFrame:(CGRect)rect
{
    self = [super initWithFrame:rect];
    if (self) {
        CAGradientLayer *gradient = [CAGradientLayer layer];
        gradient.frame = self.bounds;
        gradient.colors = APP_BACKGROUND;
        [self.layer addSublayer:gradient];
    }
    return self;
}

@end


