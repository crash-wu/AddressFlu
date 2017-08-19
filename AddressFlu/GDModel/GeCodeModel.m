//
//  GeCodeModel.m
//  AddressFlu
//
//  Created by 吴小星 on 2017/5/27.
//  Copyright © 2017年 crash. All rights reserved.
//

#import "GeCodeModel.h"

@implementation GeCodeModel

+ (nullable NSArray<id<SGSResponseObjectSerializable>> *)colletionSerializeWithResponseObject:(id)object{
    
    
    return [NSArray yy_modelArrayWithClass:self json:object];
}


@end
