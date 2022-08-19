//
//  YZAnimationListViewController.m
//  YZAnimation
//
//  Created by hyz on 2022/8/15.
//  Copyright © 2022 zone1026. All rights reserved.
//

#import "YZAnimationListViewController.h"

#import "YZShineAnimationViewController.h"
#import "YZLoadingAnimationViewController.h"

@interface YZAnimationListViewController ()

@property (nonatomic, strong) NSArray <NSString *> *listArr;

@end

@implementation YZAnimationListViewController

#pragma mark - Init

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

#pragma mark - Configure

#pragma mark - Network

#pragma mark - Event Response

#pragma mark - Public Methods

#pragma mark - Private Methods

#pragma mark - TableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.listArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    if (self.listArr.count > indexPath.row) {
        cell.textLabel.text = [self.listArr objectAtIndex:indexPath.row];
    }
    
    return cell;
}

#pragma mark - TableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    UIViewController *targetVc = nil;
    switch (indexPath.row) {
        case 0:
            targetVc = [[YZShineAnimationViewController alloc] init];
            break;
        case 1:
            targetVc = [[YZLoadingAnimationViewController alloc] init];
            break;
        default:
            break;
    }
    
    if (targetVc == nil) targetVc = [[UIViewController alloc] init];
    
    [self.navigationController pushViewController:targetVc animated:YES];
}

#pragma mark - Notification

#pragma mark - Setter & Getter

- (NSArray <NSString *> *)listArr {
    if (_listArr == nil) {
        _listArr = @[@"Shine Animation", @"Loading Animation"];
    }
    
    return _listArr;
}

#pragma mark - Lazy Loading

@end
