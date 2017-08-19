//
//  BDRoutematrixModel.h
//  AddressFlu
//
//  Created by 吴小星 on 2017/8/18.
//  Copyright © 2017年 crash. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BDDistanceModel.h"
#import "BDDurationModel.h"
#import <SGSHTTPModule/SGSHTTPModule.h>
#import <YYModel/YYModel.h>

@interface BDRoutematrixModel : NSObject<SGSResponseCollectionSerializable>


@property(nonnull,strong,nonatomic) BDDistanceModel *distance;

@property(nonatomic,strong,nonnull) BDDurationModel *duration;

@end
