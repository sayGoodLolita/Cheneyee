//
//  CYTableViewCell.m
//  Cheneyee
//
//  Created by Cheney Mars on 2019/7/19.
//  Copyright © 2019 Cheney Mars. All rights reserved.
//

#import "CYTableViewCell.h"

@implementation CYTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

/// 绑定 cell 和 itemViewModel 的数据
- (void)bindViewModel:(id)viewModel {

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
