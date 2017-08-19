//
//  BDRadiuSearchReturnModel.h
//  AddressFlu
//
//  Created by 吴小星 on 2017/8/18.
//  Copyright © 2017年 crash. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BDPOIModel.h"

@interface BDRadiuSearchReturnModel : NSObject

@property(nonatomic,strong,nonnull) NSMutableArray *csv;

@property(nonatomic,strong,nonnull) NSArray<BDPOIModel *> *array;

@property(nonatomic,strong,nonnull) NSNumber *maxDistance;


@property(nonatomic,strong,nonnull) NSNumber *minDistance;

@property(nonatomic,strong,nonnull) NSNumber *averDistance;
/**
 搜索类型
 */
@property(nonatomic,strong,nonnull) NSString *keywork;

@end
