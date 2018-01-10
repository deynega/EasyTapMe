//
//  GameViewController.m
//  TapMeIfYouCan
//
//  Created by Andrey on 21.12.17.
//  Copyright © 2017 deynega. All rights reserved.
//

#import <StoreKit/StoreKit.h>
#import "GameViewController.h"
#import "MainViewController.h"
#import "Colors.h"
#import "AFViewShaker.h"
#import "GradientView.h"
#import "Rating.h"


@interface GameViewController ()
@property (nonatomic, assign, readonly) DifficultType difficultType;
@property (nonatomic, strong) NSMutableArray <NSNumber *> *randomTagArray;
@property (nonatomic, strong) NSMutableArray *userTagArray;
@property (nonatomic) NSUInteger maxTouchCount;

@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *livesLabel;

@property (nonatomic, strong) Game *game;
@property (nonatomic, strong) Rating *rating;

@property (nonatomic, weak) IBOutlet UIView *gameBoardView;
@property (nonatomic, strong) AFViewShaker *shakerView;

@end

@implementation GameViewController

- (instancetype)initWithDifficultType:(DifficultType)type {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
    self = [storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([GameViewController class])];
    if (self) {
        _difficultType = type;
        _randomTagArray = [[[GameConfigurator configurator] randomizeTagsWithDifficult:_difficultType] mutableCopy];
        _userTagArray = [NSMutableArray array];
        _game = [self createNewGameWithDifficultType:_difficultType];
        _rating = [[Rating alloc] init];
    }
    [NSUserDefaults.standardUserDefaults removeObjectForKey:@"currentGame"];
    return self;
}

- (instancetype)initWithGame:(Game *)game {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
    self = [storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([GameViewController class])];
    if (self) {
        _game = game;
        _difficultType = game.difficultType;
        _randomTagArray = [[[GameConfigurator configurator] randomizeTagsWithDifficult:_difficultType] mutableCopy];
        _userTagArray = [NSMutableArray array];
        _rating = [[Rating alloc] init];
    }
    [NSUserDefaults.standardUserDefaults removeObjectForKey:@"currentGame"];
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self updateLabels];
    [self createGameBoard];
    [self setupShakerView];
    
    GradientView * gradientViewBackground = [[GradientView alloc]initWithFrame:self.view.bounds];
    [self.view addSubview:gradientViewBackground];
    [self.view sendSubviewToBack:gradientViewBackground];
    
    [self.gameBoardView setExclusiveTouch:YES];
    self.gameBoardView.userInteractionEnabled = NO;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self prepareAnimation];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if (self.game.lives.integerValue > 0) {
        [self.game saveGame];
    }
}

#pragma mark - Setup

- (Game *)createNewGameWithDifficultType:(DifficultType)type {
    switch (type) {
        case DifficultTypeEasy:
            return [[Game alloc] initEasyGame];
            break;
        case DifficultTypeNormal:
            return [[Game alloc] initNormalGame];
            break;
        case DifficultTypeHard:
            return [[Game alloc] initHardGame];
            break;
    }
}

- (void)createGameBoard {
    DifficultType type = self.difficultType;
    NSUInteger tag = 0;
    NSUInteger rowCount = [[GameConfigurator configurator] rowCountFromDifficult:type];
    CGFloat boxSide = self.view.frame.size.width / (rowCount + .5f);
    CGFloat space = boxSide / (rowCount * 2 + 2);
    
    for (NSUInteger row = 0; row < rowCount; row++) {
        for (NSUInteger column = 0; column < rowCount; column++) {
            UIView *view = [self createBoxWithSide:boxSide space:space tag:tag row:row column:column];
            [self.gameBoardView addSubview:view];
            tag++;
        }
    }
}

- (UIView *)createBoxWithSide:(CGFloat)side space:(CGFloat)space tag:(NSUInteger)tag row:(NSUInteger)row column:(NSUInteger)column {
    CGFloat x = (space * (column + 1)) + column * side;
    CGFloat y = (space * (row + 1)) + row * side;
    CGRect rect = CGRectMake(x, y, side, side);
    UIView *view = [[UIView alloc] initWithFrame:rect];
    view.backgroundColor = DEFAULT_COLOR_BOX;
    view.layer.cornerRadius = 10.f;
    [view setTag:tag];
    return view;
}

- (void)setupShakerView {
    self.shakerView = [[AFViewShaker alloc] initWithView:self.gameBoardView];
}

#pragma mark - Updates

- (void)updateLabels {
    self.scoreLabel.text = [NSString stringWithFormat:@"Score: %@", self.game.score.stringValue];
    self.livesLabel.text = [NSString stringWithFormat:@"Lives: %@", self.game.lives.stringValue];
}

- (void)newLevel {
    self.randomTagArray = [[[GameConfigurator configurator] randomizeTagsWithDifficult:self.difficultType] mutableCopy];
    [self performSelector:@selector(prepareAnimation) withObject:self afterDelay:.5f];
}

#pragma mark - Animation

- (void)prepareAnimation {
    [self.userTagArray removeAllObjects];

    GameConfigurator *configurator = [GameConfigurator configurator];
    self.maxTouchCount = [configurator boxesFlashCountMaxFromDifficult:self.difficultType];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.5f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.gameBoardView.userInteractionEnabled = NO;
        if (self.randomTagArray.count > 0) {
            NSUInteger i;
            for (i = 0; i < self.randomTagArray.count; i++) {
                NSUInteger tag = self.randomTagArray[i].unsignedIntegerValue;
                for (UIView *view in self.gameBoardView.subviews) {
                    if (view.tag == tag) {
                        [self animateView:view delay:i];
                    }
                }
            }
            [self performSelector:@selector(enableUserInteraction) withObject:self afterDelay:i];
        }
    });
}

- (void)animateView:(UIView *)view delay:(NSUInteger)delay {
    CGFloat duration = [[GameConfigurator configurator] animationDuration];
    NSUInteger dispatchDelay = delay * duration * 2;

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(dispatchDelay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:duration animations:^{
            view.backgroundColor = ANIMATE_COLOR_BOX;
            view.transform = CGAffineTransformMakeScale(1.1f, 1.1f);
            
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:duration animations:^{
                view.backgroundColor = DEFAULT_COLOR_BOX;
                view.transform = CGAffineTransformMakeScale(1.0f, 1.0f);
            }];
        }];
    });
}

#pragma mark - Touches

- (void)enableUserInteraction {
    self.gameBoardView.userInteractionEnabled = YES;
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    
    if (self.userTagArray.count >= self.maxTouchCount) {
        self.gameBoardView.userInteractionEnabled = NO;
        [self checkArrays];
    }
    if ([self.gameBoardView.subviews containsObject:touch.view]) {
        [UIView animateWithDuration:.4f animations:^{
            touch.view.backgroundColor = TOUCH_COLOR;
            touch.view.backgroundColor = DEFAULT_COLOR_BOX;
            [self.userTagArray addObject:@(touch.view.tag)];
        } completion:^(BOOL finished) {
            if (self.userTagArray.count == self.randomTagArray.count) {
                [self checkArrays];
            }
        }];
    } else {
        [self.shakerView shake];
    }
}

#pragma mark - Check Result

- (void)checkArrays {
    self.gameBoardView.userInteractionEnabled = NO;
    NSArray *checkingArray = [NSArray arrayWithArray:self.userTagArray];
    [self.userTagArray removeAllObjects];
    if ([checkingArray isEqual:self.randomTagArray]) {
        [self flashBoxesWithColor:SUCCESS_COLOR];
        self.game.score = [self.game increaseScore];
        [self newLevel];

    } else {
        [self flashBoxesWithColor:ERROR_COLOR];
        self.game.lives = @(self.game.lives.unsignedIntegerValue - 1);
        if (self.game.lives.unsignedIntegerValue > 0) {
            [self newLevel];
        } else {
            [NSUserDefaults.standardUserDefaults removeObjectForKey:@"currentGame"];
            [self checkResult];
        }
    }
    [self updateLabels];
}

- (void)flashBoxesWithColor:(UIColor *)color {
    for (UIView *view in self.gameBoardView.subviews) {
        [UIView animateWithDuration:.4f animations:^{
            view.backgroundColor = color;
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:.4f animations:^{
                view.backgroundColor = DEFAULT_COLOR_BOX;
            }];
        }];
    }
}

- (void)checkResult {
    int checkResult = [self.rating checkCurrentResult:self.game.score];
    switch (checkResult) {
        case 0:
            [self alertTryAgain];
            break;
        case 1:
            [self alertGameOver];
            break;
        case 2:
            [self alertNotBestResult];
            break;
        case 3:
            [self alertBestResult];
            break;
        default:
            break;
    }
}

#pragma mark - Alerts

- (void)alertTryAgain {
    NSString *titleString = @"You are a complete loser!";
    NSString *messageString = @"You didn't get any score";
    [self makeAlertWithTitle:titleString andMessage:messageString];
}

- (void)alertNotBestResult {
    NSString *titleString = @"Congratulations!";
    NSString *messageString = [NSString stringWithFormat:@"You got %@ scores, check the highscore table now!", self.game.score];
    [self makeAlertWithTitle:titleString andMessage:messageString];
}

- (void)alertBestResult {
    NSString *titleString = @"Congratulations!";
    NSString *messageString = [NSString stringWithFormat:@"You are the best with %@ scores", self.game.score];
    [self makeAlertWithTitle:titleString andMessage:messageString];
}

- (void)alertGameOver {
    NSString *titleString = @"Game over!";
    NSString *messageString = [NSString stringWithFormat:@"You got %@ scores", self.game.score];
    [self makeAlertWithTitle:titleString andMessage:messageString];
}

- (void)makeAlertWithTitle:(NSString *)title andMessage:(NSString *)message {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title
                                                                   message:message
                                                            preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction * action) {
                                                         [self callMainViewController];
                                                     }];
    [alert addAction:okAction];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)callMainViewController {
    [self displayReviewController];
    //оставлять эту анимацию, или сделать всплываение снизу?
    ////////
    CATransition *transition = [[CATransition alloc] init];
    transition.duration = 0.5;
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromRight;
    [transition setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    [self.view.window.layer addAnimation:transition forKey:kCATransition];
    ////////
    NSString *storyboardName = @"Main";
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:storyboardName bundle: nil];
    UIViewController *mainVC = [storyboard instantiateViewControllerWithIdentifier:@"NavigationController"];
    [self presentViewController:mainVC animated:NO completion:nil];
//    [self presentViewController:mainVC animated:YES completion:nil];
    
}

#pragma mark - Rate App

-(void)displayReviewController {
    [NSUserDefaults.standardUserDefaults registerDefaults:[NSDictionary dictionaryWithObjectsAndKeys:@(0), @"displayReviewController", nil]];
    NSInteger integer = [[NSUserDefaults.standardUserDefaults objectForKey:@"displayReviewController"] integerValue];
    NSNumber *number = [NSNumber numberWithInteger:integer + 1];
    if ([number integerValue] % 5 == 0){
        if (@available(iOS 10.3, *)) {
            [SKStoreReviewController requestReview];
        }
    }
    [NSUserDefaults.standardUserDefaults setObject:number forKey:@"displayReviewController"];
}


@end
