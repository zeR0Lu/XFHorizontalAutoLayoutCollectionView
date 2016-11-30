//
//  HeaderCollectionReusableView.m
//  testCollectionView
//
//  Created by zeroLu on 16/11/8.
//  Copyright © 2016年 zeroLu. All rights reserved.
//

#import "HeaderCollectionReusableView.h"

@interface HeaderCollectionReusableView ()
@property (nonatomic, strong) UILabel *label;
@end

@implementation HeaderCollectionReusableView
- (UILabel *)label {
    if ( !_label ) {
        _label = [[UILabel alloc] initWithFrame:CGRectMake(12.0, 0.0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame))];
        _label.text = @"header";
        _label.textColor = [UIColor blackColor];
    }
    return _label;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if ( self ) {
        self.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.label];
    }
    
    return self;
}

- (void)setText:(NSString *)text {
    self.label.text = text;
}

@end
