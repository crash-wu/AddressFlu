//
//  Ws84ConvertToGDModel.m
//  AddressFlu
//
//  Created by 吴小星 on 2017/5/21.
//  Copyright © 2017年 crash. All rights reserved.
//

#import "Ws84ConvertToGDModel.h"

@implementation Ws84ConvertToGDModel

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
