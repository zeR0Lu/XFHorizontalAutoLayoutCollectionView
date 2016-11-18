//
//  XFContentCell.m
//  testCollectionView
//
//  Created by zeroLu on 16/11/18.
//  Copyright © 2016年 zeroLu. All rights reserved.
//

#import "XFContentCell.h"
#import "XFModel.h"

@interface XFContentCell ()
@property (weak, nonatomic) IBOutlet UILabel *label;
@property (weak, nonatomic) IBOutlet UIImageView *bgImageView;
@end

@implementation XFContentCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setModel:(SubModel *)model {
    _model = model;
    
    self.label.text = model.subName;
    
    self.label.textColor = (model.isSelected)?[UIColor whiteColor]:[UIColor blackColor];
    self.bgImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"options_button_bg_%d",model.isSelected]];
}

@end
