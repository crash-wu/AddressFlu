//
//  GDPOIModel.h
//  AddressFlu
//
//  Created by 吴小星 on 2017/6/8.
//  Copyright © 2017年 crash. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <YYModel/YYModel.h>
#import <SGSHTTPModule/SGSHTTPModule.h>


/**
 高德POI实体
 */
@interface GDPOIModel : NSObject<SGSResponseCollectionSerializable>


@property(nonatomic,strong,nonnull) NSString *name;

/**
 省份
 */
@property(nonatomic,nonnull,strong) NSString *pname;


/**
 城市名称
 */
@property(nonatomic,strong,nonnull) NSString *cityname;


/**
 区／县
 */
@property(nonatomic,nonnull,strong) NSString * adname;


/**
 地名地址查询
 */
@property(nonatomic,nonnull,strong) NSString *location;



/**
 地名地址
 */
@property(nonatomic,strong,nonnull) NSString *address;

@end
