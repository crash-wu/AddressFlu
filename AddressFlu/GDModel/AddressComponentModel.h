//
//  AddressComponentModel.h
//  AddressFluserder
//
//  Created by 吴小星 on 2017/5/20.
//  Copyright © 2017年 crash. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <YYModel/YYModel.h>
#import <SGSHTTPModule/SGSHTTPModule.h>

@interface AddressComponentModel : NSObject<SGSResponseObjectSerializable>


/**
 省份
 */
@property(nonatomic,strong,nonnull) NSString *province;



/**
 城市
 */
@property(nonatomic,strong,nonnull) NSString *city;


/**
 坐标点所在区
 */
@property(nonatomic,strong,nonnull) NSString *district;


/**
 坐标点所在乡镇/街道（此街道为社区街道，不是道路信息）
 */
@property(nonatomic,strong,nonnull) NSString *township;

@end
