//
//  HorizontalCollectionLayout.m
//  testCollectionView
//
//  Created by zeroLu on 16/11/10.
//  Copyright © 2016年 zeroLu. All rights reserved.
//

#import "HorizontalCollectionLayout.h"

#define SCREENWIDTH [[UIScreen mainScreen] bounds].size.width

@interface HorizontalCollectionLayout ()

@property (nonatomic, strong) NSMutableArray *attributesArray;

@property (nonatomic, strong) NSMutableArray *itemsattributes;

@property (nonatomic, strong) NSMutableArray *headerAttributes;

@property (nonatomic, strong) NSMutableArray *footerAttributes;

@property (nonatomic, assign) CGFloat contentHeight;

@property (nonatomic, assign) CGFloat viewWidth;

@end

@implementation HorizontalCollectionLayout

- (instancetype)init {
    if (self = [super init]) {
        
        //设置间距的默认值
        self.headerViewHeight = 0.0;
        self.footerViewHeight = 0.0;
        self.interitemSpacing = 4.0;
        self.lineSpacing = 4.0;
        self.itemHeight = 30.0;
        self.insetForSection = UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0);
    }
    return self;
}

/** 1、当collectionView布局item时 第一个执行的方法 */
//这里有个要注意的地方,在执行这个方法的时候, 已经完成了对象的赋值
- (void)prepareLayout {
    /** 重写layout中的方法 首先必须调用父类 */
    [super prepareLayout];
    
    self.viewWidth = SCREENWIDTH - self.insetForSection.left - self.insetForSection.right;
    //所有内容的布局属性数组
    self.attributesArray = [NSMutableArray array];
    
    //item的数据模型是2原数组,就是第一层数组包含的是section,第二层是每个section包含的item
    self.itemsattributes = [NSMutableArray array];
    //记录 collectionview 的内容高度
    self.contentHeight = 0.0;
    
    /** 获取collectionView 中的item的个数 */
    NSInteger sectionCount = [self.collectionView numberOfSections];
    /** 遍历得到每个item 设置位置信息 */
    for (NSInteger i = 0; i < sectionCount; i++) {
        
        NSInteger itemCount = [self.collectionView numberOfItemsInSection:i];
        for (NSInteger j = 0; j < itemCount; j++) {
            [self setItemFrameWithIndexPath:[NSIndexPath indexPathForItem:j inSection:i]];
            
            if ( (i == sectionCount - 1) && ( j == itemCount - 1) ) {
                //这里是当最后一个 item 的布局设置完成后如果有设置 footer 就要把 footer 添加到所有布局数组
                if ( [self.delegate respondsToSelector:@selector(collectionViewDynamicFooterSizeWithIndexPath:)] ) {
                    
                    UICollectionViewLayoutAttributes *lastAttributes = self.attributesArray.lastObject;
                    
                    [self makeFooterAttributesWithLastItemAttributes:lastAttributes];
                    
                    UICollectionViewLayoutAttributes *footerAttributes = self.footerAttributes.lastObject;
                    
                    self.contentHeight = CGRectGetMaxY(footerAttributes.frame) + self.insetForSection.bottom;
                }
            }
        }
    }
}

- (void)setItemFrameWithIndexPath:(NSIndexPath *)indexPath {
    
    //这里主要是设置一下 item 的初始 frame
    CGFloat x = 0.0;
    CGFloat y = 0.0;
    CGFloat width = [self countItemSizeWithIndexPath:indexPath];
    CGFloat height = 30.0;
    
    // 获取数组最后一个 layoutAttributes, 这样方便计算 frame 和 判断是否需要计算新的 section
    UICollectionViewLayoutAttributes *lastAttributes = self.attributesArray.lastObject;
    
    if ( lastAttributes ) {
        //如果数组有值代表不是设置第一个item
        if ( lastAttributes.indexPath.section == indexPath.section ) {
            //同一组
            if ( CGRectGetMaxX(lastAttributes.frame) + self.interitemSpacing + width > self.viewWidth ) {
                //需要换行
                x = self.insetForSection.left;
                y = CGRectGetMaxY(lastAttributes.frame) + self.lineSpacing;
            }else {
                //不需要换行
                x = CGRectGetMaxX(lastAttributes.frame) + self.interitemSpacing;
                y = CGRectGetMinY(lastAttributes.frame);
            }
        }else {
            //不同一组
            //添加 footer 的布局,内部会判断是否需要添加
            [self makeFooterAttributesWithLastItemAttributes:lastAttributes];
            
            //添加一个新的 section 数组
            [self.itemsattributes addObject:[NSMutableArray array]];
            
            //这里重新获取最后一个 layoutAttributes 是因为如果加入了 footer 总的 layoutAttributes就会改变
            lastAttributes = self.attributesArray.lastObject;
            
            //添加 header 的布局,内部会判断是否需要添加
            [self makeHeaderAttributesWithIndexPath:indexPath lastItemAttributes:lastAttributes];
            
            //设置新的 section 的第一个 item 的 frame
            x = self.insetForSection.left;
            y = CGRectGetMaxY(lastAttributes.frame) + self.lineSpacing * 2 + self.headerViewHeight;
        }
    }else {
        //这里是设置第一个section的item
        [self.itemsattributes addObject:[NSMutableArray array]];
        
        //添加 header 的布局,内部会判断是否需要添加
        [self makeHeaderAttributesWithIndexPath:indexPath lastItemAttributes:lastAttributes];
        
        //这里判断是否有 header, 如果有就获取最后一个 layoutAttributes
        if ( self.headerAttributes.count ) {
            lastAttributes = self.attributesArray.lastObject;
        }
        
        //设置新的 section 的第一个 item 的 frame
        x = self.insetForSection.left;
        y = self.lineSpacing + lastAttributes.frame.size.height;
    }
    
    //设置每一个 item 的 frame
    UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    /** 添加frame */
    attributes.frame = CGRectMake(x, y, width, height);
    self.contentHeight = CGRectGetMaxY(attributes.frame) + self.lineSpacing;
    /** 保存在数组中 */
    [self.itemsattributes[indexPath.section] addObject:attributes];
    
    [self.attributesArray addObject:attributes];
}

#pragma mark - 
- (void)makeHeaderAttributesWithIndexPath:(NSIndexPath *)indexPath lastItemAttributes:(UICollectionViewLayoutAttributes *)attributes {
    //设置第一个section的header
    UICollectionViewLayoutAttributes *headerAttributes = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader withIndexPath:indexPath];
    
    CGFloat y = (attributes)?CGRectGetMaxY(attributes.frame) + self.lineSpacing:self.insetForSection.top;
    CGFloat headerWidth =  0.0;
    CGFloat headerHeight =  0.0;
    
    if ( [self.delegate respondsToSelector:@selector(collectionViewDynamicHeaderSizeWithIndexPath:)] ) {
        CGSize size = [self.delegate collectionViewDynamicHeaderSizeWithIndexPath:indexPath];
        
        headerWidth = size.width;
        headerHeight = size.height;
    }else {
        headerWidth = self.viewWidth;
        headerHeight = self.headerViewHeight;
    }
    
    if ( headerHeight > 0.0 ) {
        headerAttributes.frame = CGRectMake(self.insetForSection.left, y, headerWidth, headerHeight);
        
        [self.headerAttributes addObject:headerAttributes];
        [self.attributesArray addObject:headerAttributes];
    }
}

- (void)makeFooterAttributesWithLastItemAttributes:(UICollectionViewLayoutAttributes *)attributes {
    
    UICollectionViewLayoutAttributes *footerAttributes = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionFooter withIndexPath:attributes.indexPath];
    
    CGFloat footerWidth =  0.0;
    CGFloat footerHeight =  0.0;
    if ( [self.delegate respondsToSelector:@selector(collectionViewDynamicFooterSizeWithIndexPath:)] ) {
        
        CGSize size = [self.delegate collectionViewDynamicFooterSizeWithIndexPath:attributes.indexPath];
        footerWidth = size.width;
        footerWidth = size.height;
    } else {
        footerWidth = self.viewWidth;
        footerHeight = self.footerViewHeight;
    }
    
    if ( footerHeight > 0 ) {
        footerAttributes.frame = CGRectMake(self.insetForSection.left, CGRectGetMaxY(attributes.frame) + self.lineSpacing, footerWidth - self.insetForSection.right, footerHeight);
        [self.footerAttributes addObject:footerAttributes];
        [self.attributesArray addObject:footerAttributes];
    }
    
}

#pragma mark -
//这个是返回所有 header, footer, item 属性的回调方法, 一定要实现
- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    return self.attributesArray;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    return self.itemsattributes[indexPath.section][indexPath.item];
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForSupplementaryViewOfKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath {
    if ( [elementKind isEqual: UICollectionElementKindSectionHeader] ) {
        return self.headerAttributes[indexPath.section];
    }else {
        return self.footerAttributes[indexPath.section];
    }
}

/** 4、设置滚动范围 */
// 这里可以处理 uicollectionview 内容不够屏幕高度不能滑动的问题,只要把 contentsize.height 设置成比屏幕高度大就可以了
- (CGSize)collectionViewContentSize {
    
    return CGSizeMake(0.0, self.contentHeight + self.insetForSection.bottom);
}

- (CGFloat)countItemSizeWithIndexPath:(NSIndexPath *)indexPath {
    NSString *content = [self.delegate collectionViewItemSizeWithIndexPath:indexPath];
    
    CGSize size = [content sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15.0]}];
    
    return MAX(size.width + 16.0, 40.0);
}


#pragma mark - lazy
// header 的布局属性数组
- (NSMutableArray *)headerAttributes {
    if ( !_headerAttributes ) {
        _headerAttributes = [NSMutableArray array];
    }
    return _headerAttributes;
}

// footer 的布局属性数组
- (NSMutableArray *)footerAttributes {
    if ( !_footerAttributes ) {
        _footerAttributes = [NSMutableArray array];
    }
    return _footerAttributes;
}
@end
