//
//  BDPOIModel.m
//  AddressFlu
//
//  Created by 吴小星 on 2017/7/12.
//  Copyright © 2017年 crash. All rights reserved.
//

#import "BDPOIModel.h"

@implementation BDPOIModel

+ (nullable NSArray<id<SGSResponseObjectSerializable>> *)colletionSerializeWithResponseObject:(id)object{
    
    
    return [NSArray yy_modelArrayWithClass:self json:object];
}


+ (NSDictionary *)modelContainerPropertyGenericClass {
    
    return @{@"location" : [BDPOILocationModel class] ,@"detail_info":[BDDetailInfoModel class]};
}
@end
