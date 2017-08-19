//
//  DistrictModel.h
//  AddressFlu
//
//  Created by 吴小星 on 2017/7/6.
//  Copyright © 2017年 crash. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <YYModel/YYModel.h>
#import <SGSHTTPModule/SGSHTTPModule.h>

@interface DistrictModel : NSObject<SGSResponseCollectionSerializable>

/**
 街道名称
 */
@property(nonatomic,strong,nonnull) NSString *name;


/**
 街道中心点坐标
 */
@property(nonatomic,strong,nonnull) NSString *center;


/**
 城市编码
 */
@property(nonatomic,nonnull,strong) NSString *adcode;


@property(nonatomic,nonnull,strong) NSArray<DistrictModel *> *districts;

@end
