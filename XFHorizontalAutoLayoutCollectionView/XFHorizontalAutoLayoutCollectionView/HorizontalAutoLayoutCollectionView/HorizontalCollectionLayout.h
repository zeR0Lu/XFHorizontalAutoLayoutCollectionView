//
//  HorizontalCollectionLayout.h
//  testCollectionView
//
//  Created by zeroLu on 16/11/10.
//  Copyright © 2016年 zeroLu. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HorizontalCollectionLayoutDelegate <NSObject>

@optional
// 用协议传回 item 的内容,用于计算 item 宽度
- (NSString *)collectionViewItemSizeWithIndexPath:(NSIndexPath *)indexPath;
// 用协议传回 headerSize 的 size
- (CGSize)collectionViewDynamicHeaderSizeWithIndexPath:(NSIndexPath *)indexPath;
// 用协议传回 footerSize 的 size
- (CGSize)collectionViewDynamicFooterSizeWithIndexPath:(NSIndexPath *)indexPath;
@end

@interface HorizontalCollectionLayout : UICollectionViewLayout
// item 的行距
@property (nonatomic, assign) CGFloat lineSpacing;
// item 的间距 
@property (nonatomic, assign) CGFloat interitemSpacing;
// collectionView 边距缩进
@property (nonatomic, assign) UIEdgeInsets insetForSection;
// header 高度
@property (nonatomic, assign) CGFloat headerViewHeight;
// footer 高度
@property (nonatomic, assign) CGFloat footerViewHeight;
// item 高度
@property (nonatomic, assign) CGFloat itemHeight;

@property (nonatomic, weak) id<HorizontalCollectionLayoutDelegate> delegate;

@end
