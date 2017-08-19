//
//  FindCountyReturnModel.h
//  AddressFlu
//
//  Created by 吴小星 on 2017/7/6.
//  Copyright © 2017年 crash. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DistrictModel.h"

@interface FindCountyReturnModel : NSObject

@property(nonnull,strong,nonatomic) NSMutableArray *csvData;

@property(nonnull,strong,nonatomic) NSArray<DistrictModel *> *district;

@end
