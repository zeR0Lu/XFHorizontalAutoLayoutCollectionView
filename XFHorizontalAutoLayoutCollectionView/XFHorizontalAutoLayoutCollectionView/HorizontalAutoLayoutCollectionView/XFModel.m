//
//  XFModel.m
//  testCollectionView
//
//  Created by zeroLu on 16/10/28.
//  Copyright © 2016年 cydl. All rights reserved.
//

#import "XFModel.h"

@implementation SubModel
+ (NSArray *)getSubModelWithData:(NSArray *)data {
    
    NSMutableArray *result = [NSMutableArray array];
    for (NSDictionary *dict in data) {
        SubModel *model = [[SubModel alloc] init];
        model.subName = dict[@"subName"];
        model.isSelected = false;
        [result addObject:model];
    }
    return result.copy;
}
@end

@implementation XFModel
+ (NSArray *)getModel {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"Contents.json" ofType:nil];
    
    NSData *data = [NSData dataWithContentsOfFile:path];
    
    NSJSONSerialization *object = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    
    NSArray *array = (NSArray *)object;
    
    NSMutableArray *result = [NSMutableArray array];
    for (NSDictionary *dict in array) {
        XFModel *model = [[XFModel alloc] init];
        model.subAttr = [SubModel getSubModelWithData:dict[@"subAttr"]];
        model.mainName = dict[@"mainName"];
        [result addObject:model];
    }
    return result;
}
@end
