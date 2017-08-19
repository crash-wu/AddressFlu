//
//  BDRoutematrixModel.m
//  AddressFlu
//
//  Created by 吴小星 on 2017/8/18.
//  Copyright © 2017年 crash. All rights reserved.
//

#import "BDRoutematrixModel.h"

@implementation BDRoutematrixModel


+ (nullable NSArray<id<SGSResponseObjectSerializable>> *)colletionSerializeWithResponseObject:(id)object{
    
    
    return [NSArray yy_modelArrayWithClass:self json:object];
}


+ (NSDictionary *)modelContainerPropertyGenericClass {
    
    return @{@"distance" : [BDDistanceModel class],@"duration":[BDDurationModel class] };
}

@end
