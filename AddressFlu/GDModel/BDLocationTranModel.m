//
//  BDLocationTranModel.m
//  AddressFlu
//
//  Created by 吴小星 on 2017/5/31.
//  Copyright © 2017年 crash. All rights reserved.
//

#import "BDLocationTranModel.h"

@implementation BDLocationTranModel

/*!
 *  @abstract 将响应结果转换为模型对象
 *
 *  @param object 响应结果
 *
 *  @return 转换成功返回模型对象，否则返回 `nil`
 */
+ (nullable NSArray<id<SGSResponseObjectSerializable>> *)colletionSerializeWithResponseObject:(id)object{
    
    
    return [NSArray yy_modelArrayWithClass:self json:object];
}


@end
