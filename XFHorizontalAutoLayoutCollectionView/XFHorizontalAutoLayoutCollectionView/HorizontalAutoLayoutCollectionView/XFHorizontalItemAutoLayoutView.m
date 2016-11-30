//
//  XFHorizontalItemAutoLayoutView.m
//  testCollectionView
//
//  Created by zeroLu on 16/11/17.
//  Copyright © 2016年 zeroLu. All rights reserved.
//

#import "XFHorizontalItemAutoLayoutView.h"
#import "HorizontalCollectionLayout.h"
#import "FooterCollectionReusableView.h"
#import "HeaderCollectionReusableView.h"
#import "XFContentCell.h"
#import "XFModel.h"

@interface XFHorizontalItemAutoLayoutView () <HorizontalCollectionLayoutDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, copy) NSArray *dataArray;

@end

@implementation XFHorizontalItemAutoLayoutView

- (instancetype)init {
    self = [super init];
    
    if ( self ) {
        
        self.dataArray = [XFModel getModel];
        
        [self.collectionView reloadData];
    }
    
    return self;
}

#pragma mark - UICollectionView
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return self.dataArray.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    XFModel *model = self.dataArray[section];
    return model.subAttr.count;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
    if ( kind == UICollectionElementKindSectionHeader ) {
        HeaderCollectionReusableView *view = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderCollectionReusableView" forIndexPath:indexPath];
        XFModel *model = self.dataArray[indexPath.section];
        view.text = model.mainName;
        return view;
    }else {
        FooterCollectionReusableView *view = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"FooterCollectionReusableView" forIndexPath:indexPath];
        return view;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    XFContentCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"XFContentCell" forIndexPath:indexPath];
    XFModel *model = self.dataArray[indexPath.section];
    SubModel *smodel = model.subAttr[indexPath.item];
    
    cell.model = smodel;
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    XFModel *model = self.dataArray[indexPath.section];
    SubModel *smodel = model.subAttr[indexPath.item];
    smodel.isSelected = !smodel.isSelected;
    
    [collectionView reloadData];
}

#pragma mark - lazy

- (UICollectionView *)collectionView {
    if ( !_collectionView ) {
        
        HorizontalCollectionLayout *layout = [[HorizontalCollectionLayout alloc] init];
        layout.lineSpacing = 8.0;
        layout.interitemSpacing = 12.0;
        layout.headerViewHeight = 40.0;
        layout.footerViewHeight = 40.0;
//        layout.itemInset = UIEdgeInsetsMake(0.0, 12.0, 16.0, 12.0);
        layout.delegate = self;
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.frame = CGRectMake(0.0, 0.0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 64.0);
        _collectionView.backgroundColor = [UIColor whiteColor];
        [self addSubview:_collectionView];
        
        [_collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([XFContentCell class]) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([XFContentCell class])];
        
        [_collectionView registerClass:[HeaderCollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderCollectionReusableView"];
        [_collectionView registerNib:[UINib nibWithNibName:@"FooterCollectionReusableView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"FooterCollectionReusableView"];
    }
    
    return _collectionView;
}

// HorizontalCollectionLayoutDelegate
- (NSString *)collectionViewItemSizeWithIndexPath:(NSIndexPath *)indexPath {
    XFModel *model = self.dataArray[indexPath.section];
    SubModel *smodel = model.subAttr[indexPath.item];
    return smodel.subName;
}

@end
