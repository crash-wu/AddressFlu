//
//  GDPOIReturnModel.h
//  AddressFlu
//
//  Created by 吴小星 on 2017/6/12.
//  Copyright © 2017年 crash. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GDPOIModel.h"

@interface GDPOIReturnModel : NSObject

@property(nonatomic,strong,nonnull) NSMutableArray *csv;

@property(nonatomic,strong,nonnull) GDPOIModel *poiModel;

@end
