//
//  XFModel.h
//  testCollectionView
//
//  Created by zeroLu on 16/10/28.
//  Copyright © 2016年 cydl. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SubModel : NSObject

@property (nonatomic, copy) NSString *subName;

@property (nonatomic, assign) BOOL isSelected;

+ (NSArray *)getSubModelWithData:(NSArray *)data;

@end

@interface XFModel : NSObject
/**
 子分类
 */
@property (nonatomic, copy) NSArray *subAttr;
/**
 属性名称
 */
@property (nonatomic, copy) NSString *mainName;

+ (NSArray *)getModel;
@end
