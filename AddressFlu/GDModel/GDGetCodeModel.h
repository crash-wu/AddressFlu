//
//  GDGetCodeModel.h
//  AddressFluserder
//
//  Created by 吴小星 on 2017/5/20.
//  Copyright © 2017年 crash. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AddressComponentModel.h"
#import <YYModel/YYModel.h>
#import <SGSHTTPModule/SGSHTTPModule.h>


/**
 高德逆地址编码数据实体
 */
@interface GDGetCodeModel : NSObject<SGSResponseObjectSerializable>


/**
 逆地址编码节点数据(省份，市，区／县，乡/镇,街道)
 */
@property(nonnull,strong,nonatomic) AddressComponentModel *addressComponent;

/**
 格式化后的地址详情
 */
@property(nonatomic,strong,nonnull) NSString *formatted_address;

@end
