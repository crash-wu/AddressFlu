//
//  GPSspgModel.m
//  AddressFlu
//
//  Created by 吴小星 on 2017/6/3.
//  Copyright © 2017年 crash. All rights reserved.
//

#import "GPSspgModel.h"

@implementation GPSspgModel

+ (nullable NSArray<id<SGSResponseObjectSerializable>> *)colletionSerializeWithResponseObject:(id)object{
    
    
    return [NSArray yy_modelArrayWithClass:self json:object];
}


@end
