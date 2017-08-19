//
//  GDPOIModel.m
//  AddressFlu
//
//  Created by 吴小星 on 2017/6/8.
//  Copyright © 2017年 crash. All rights reserved.
//

#import "GDPOIModel.h"

@implementation GDPOIModel

+ (nullable NSArray<id<SGSResponseObjectSerializable>> *)colletionSerializeWithResponseObject:(id)object{
    
    
    return [NSArray yy_modelArrayWithClass:self json:object];
}


@end
