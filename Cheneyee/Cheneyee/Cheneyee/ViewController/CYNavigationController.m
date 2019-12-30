//
//  CYNavigationController.m
//  CYKit
//
//  Created by Cheney Mars on 2019/7/10.
//  Copyright © 2019 Cheney Mars. All rights reserved.
//

#import "CYNavigationController.h"
#import "UIBarButtonItem+CYEx.h"
#import "CYViewController.h"

@interface CYNavigationController ()


@end

@implementation CYNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

/// 显示导航栏的细线
- (void)showNavigationBottomLine {
     self.navigationBar.shadowImage = UINavigationBar.appearance.shadowImage;
}

/// 隐藏导航栏的细线
- (void)hideNavigationBottomLine {
    self.navigationBar.shadowImage = UIImage.new;
}

- (void)pushViewController:(CYViewController *)viewController animated:(BOOL)animated {
    if (self.viewControllers.count) viewController.hidesBottomBarWhenPushed = YES;
    [super pushViewController:viewController animated:animated];
}

/*
#pragma mark - Navigation
`
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
