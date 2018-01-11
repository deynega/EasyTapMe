//
//  MainViewController.m
//  TapMeIfYouCan
//
//  Created by Andrey on 21.12.17.
//  Copyright © 2017 deynega. All rights reserved.
//

#import "MainViewController.h"
#import "GameViewController.h"
#import "GradientView.h"
#import "Colors.h"
#import "Game.h"

@interface MainViewController ()

- (IBAction)buttonContinue:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *buttonContinue;
@property (nonatomic, strong) NSUserDefaults* userDefaults;

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.userDefaults = NSUserDefaults.standardUserDefaults;

    self.navigationController.navigationBar.barTintColor = NAVIGATION_BAR_TINT_COLOR;
    self.navigationController.navigationBar.translucent = NO;
    
    GradientView * gradientViewBackground = [[GradientView alloc]initWithFrame:self.view.bounds];
    [self.view addSubview:gradientViewBackground];
    [self.view sendSubviewToBack:gradientViewBackground];
    
    [self.navigationController.navigationBar setValue:@(YES) forKeyPath:@"hidesShadow"];  // --- this code remove liner between nav bar and view
}

- (void)viewWillAppear:(BOOL)animated {
    if ([self.userDefaults objectForKey:@"currentGame"]) {
        self.buttonContinue.alpha = 1;
        self.buttonContinue.enabled = YES;
        
    } else {
        self.buttonContinue.alpha = 0.5f;
        self.buttonContinue.enabled = NO;
    }
}

#pragma mark - ButtonsAction

- (IBAction)buttonContinue:(id)sender {
    
    Game *currentGame = [[Game alloc] loadGame];
    GameViewController *gameVC = [[GameViewController alloc] initWithGame:currentGame];
    [self.navigationController pushViewController:gameVC animated:YES];
    
}

- (IBAction)buttonEasy:(id)sender {
     if ([self.userDefaults objectForKey:@"currentGame"]) {
         [self showAlertWithDifficultType:DifficultTypeEasy];
     } else {
         [self callGameViewControllerWithDifficultType:DifficultTypeEasy];
     }
}

- (IBAction)buttonNormal:(id)sender {
    if ([self.userDefaults objectForKey:@"currentGame"]) {
        [self showAlertWithDifficultType:DifficultTypeNormal];
    } else {
        [self callGameViewControllerWithDifficultType:DifficultTypeNormal];
    }
}

- (IBAction)buttonHard:(id)sender {
    if ([self.userDefaults objectForKey:@"currentGame"]) {
        [self showAlertWithDifficultType:DifficultTypeHard];
    } else {
        [self callGameViewControllerWithDifficultType:DifficultTypeHard];
    }
}

#pragma mark - Alerts

- (void)showAlertWithDifficultType:(DifficultType)type {
    NSString *alertMessage =[NSString stringWithFormat:@"Are you sure you want to abort the current game?"];
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil
                                                                   message:alertMessage
                                                            preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel
                                                         handler:^(UIAlertAction * _Nonnull action) {}];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction * action) {
                                                         [self callGameViewControllerWithDifficultType:type];
                                                     }];
    [alert addAction:cancelAction];
    [alert addAction:okAction];
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - call GameViewController With Difficult Type

- (void)callGameViewControllerWithDifficultType:(DifficultType)type {
    GameViewController *gameVC = [[GameViewController alloc] initWithDifficultType:type];
    [self.navigationController pushViewController:gameVC animated:YES];
}


@end
