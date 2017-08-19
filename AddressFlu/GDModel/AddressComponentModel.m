//
//  AddressComponentModel.m
//  AddressFluserder
//
//  Created by 吴小星 on 2017/5/20.
//  Copyright © 2017年 crash. All rights reserved.
//

#import "AddressComponentModel.h"

@implementation AddressComponentModel

/*!
 *  @abstract 将响应结果转换为模型对象
 *
 *  @param object 响应结果
 *
 *  @return 转换成功返回模型对象，否则返回 `nil`
 */
+ (nullable id<SGSResponseObjectSerializable>)objectSerializeWithResponseObject:(id)object{
    
    return [self yy_modelWithJSON:object];
}

@end
