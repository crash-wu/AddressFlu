//
//  DistrictModel.m
//  AddressFlu
//
//  Created by 吴小星 on 2017/7/6.
//  Copyright © 2017年 crash. All rights reserved.
//

#import "DistrictModel.h"

@implementation DistrictModel

+ (nullable NSArray<id<SGSResponseObjectSerializable>> *)colletionSerializeWithResponseObject:(id)object{
    
    
    return [NSArray yy_modelArrayWithClass:self json:object];
}

+ (NSDictionary *)modelContainerPropertyGenericClass {
    
    return @{@"districts" : [DistrictModel class] };
}

@end
