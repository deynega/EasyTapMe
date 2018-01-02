//
//  RatingViewController.m
//  TapMeIfYouCan
//
//  Created by Andrey on 29.12.17.
//  Copyright © 2017 deynega. All rights reserved.
//

#import "RatingViewController.h"
#import "Rating.h"
#import "GradientView.h"
#import "Colors.h"

@interface RatingViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) Rating *rating;

@end


@implementation RatingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.rating = [[Rating alloc]init];
    
    GradientView *gradientViewBackground= [[GradientView alloc]initWithFrame:self.view.bounds];
    [self.view addSubview:gradientViewBackground];
    [self.view sendSubviewToBack:gradientViewBackground];
}

- (void)viewWillAppear:(BOOL)animated {
    [self.rating sortRecordsArray];
    
}

#pragma mark - UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    tableView.backgroundColor = [UIColor clearColor];
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.detailTextLabel.textColor = [UIColor whiteColor];
    if (self.rating.recordsArray.count > indexPath.row) {
        cell.textLabel.text = [NSString stringWithFormat:@"   %@", [self.rating.recordsArray objectAtIndex:indexPath.row]];
        cell.detailTextLabel.text = @"";
    }else {
        cell.textLabel.text = @"   --";
        cell.detailTextLabel.text = @"";
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return tableView.frame.size.height / 10;
}


@end
