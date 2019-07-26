//
//  CYTabBarController.m
//  CYKit
//
//  Created by Cheney Mars on 2019/7/11.
//  Copyright © 2019 Cheney Mars. All rights reserved.
//

#import "CYTabBarController.h"

@interface CYTabBarController ()

@property (nonatomic, strong) QMUITabBarViewController * tabBarController;

@end

@implementation CYTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tabBarController = QMUITabBarViewController.new;
    [self.view addSubview:self.tabBarController.view];
    [self addChildViewController:self.tabBarController];
    [self.tabBarController didMoveToParentViewController:self];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
