//
//  BDPOIModel.h
//  AddressFlu
//
//  Created by 吴小星 on 2017/7/12.
//  Copyright © 2017年 crash. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BDPOILocationModel.h"
#import <YYModel/YYModel.h>
#import <SGSHTTPModule/SGSHTTPModule.h>
#import "BDDetailInfoModel.h"

@interface BDPOIModel : NSObject<SGSResponseCollectionSerializable>


@property(nonatomic,strong,nonnull) NSString *name;

@property(nonatomic,strong,nonnull) BDPOILocationModel *location;

@property(nonatomic,strong,nonnull) BDDetailInfoModel *detail_info;

@end
