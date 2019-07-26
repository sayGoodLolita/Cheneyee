//
//  CYTableViewCell.h
//  Cheneyee
//
//  Created by Cheney Mars on 2019/7/19.
//  Copyright © 2019 Cheney Mars. All rights reserved.
//

#import <QMUIKit/QMUIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CYTableViewCell : QMUITableViewCell


/// 绑定 cell 和 itemViewModel 的数据
- (void)bindViewModel:(id)viewModel;

@end

NS_ASSUME_NONNULL_END
