//
//  GradientButton.m
//  TapMeIfYouCan
//
//  Created by Andrey on 25.12.17.
//  Copyright © 2017 deynega. All rights reserved.
//

#import "GradientButton.h"
#import "Colors.h"

@interface GradientButton ()
@property (nonatomic, strong) CAGradientLayer *gradientLayer;

@end

@implementation GradientButton

- (instancetype)init {
    self = [super init];
    if (self) {
        [self makeGradientView];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.frame = frame;
        [self makeGradientView];
    }
    return self;
}

- (nullable instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self makeGradientView];
    }
    return self;
}

- (void)makeGradientView {
    self.gradientLayer = [CAGradientLayer layer];
    self.gradientLayer.frame = self.layer.bounds;
    self.gradientLayer.colors = GRADIENT_BUTTON;
    self.gradientLayer.borderColor = [UIColor lightGrayColor].CGColor;
    self.gradientLayer.cornerRadius = 10.f;
    [self.layer addSublayer:self.gradientLayer];
    [self.layer addSublayer:self.titleLabel.layer];
    [self.superview addSubview:self];
}


@end
