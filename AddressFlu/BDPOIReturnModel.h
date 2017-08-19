//
//  BDPOIReturnModel.h
//  AddressFlu
//
//  Created by 吴小星 on 2017/7/12.
//  Copyright © 2017年 crash. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BDPOIModel.h"

@interface BDPOIReturnModel : NSObject

@property(nonatomic,strong,nonnull) NSMutableArray *csv;

@property(nonatomic,strong,nonnull) BDPOIModel *poiModel;

@end
