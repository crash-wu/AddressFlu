//
//  GPSspgModel.h
//  AddressFlu
//
//  Created by 吴小星 on 2017/6/3.
//  Copyright © 2017年 crash. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <YYModel/YYModel.h>
#import <SGSHTTPModule/SGSHTTPModule.h>


/**
 GPSspgAPI 坐标转换结果实体
 */
@interface GPSspgModel : NSObject<SGSResponseCollectionSerializable>


/**
 维度
 */
@property(nonnull,strong,nonatomic) NSString *lat ;


/**
 经度
 */
@property(nonnull,strong,nonatomic) NSString *lng;


/**
 匹配
 */
@property(nonatomic,strong,nonnull) NSString *match;

@end
