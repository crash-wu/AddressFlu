//
//  GeCodeModel.h
//  AddressFlu
//
//  Created by 吴小星 on 2017/5/27.
//  Copyright © 2017年 crash. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <YYModel/YYModel.h>
#import <SGSHTTPModule/SGSHTTPModule.h>

@interface GeCodeModel : NSObject<SGSResponseCollectionSerializable>


/**
 详细地址
 */
@property(nonatomic,strong,nonnull) NSString * formatted_address;



/**
 省份
 */
@property(nonatomic,strong,nonnull) NSString *province;


/**
 城市
 */
@property(nonatomic,strong,nonnull) NSString *city;


/**
 所在的区
 */
@property(nonatomic,strong,nonnull) NSString *district;


@property(nonatomic,strong,nonnull) NSString *township;

@property(nonatomic,strong,nonnull) NSString *street;


@property(nonatomic,strong,nonnull) NSString *location;


/**
 查询级别
 */
@property(nonatomic,strong,nonnull) NSString *level;

@end
