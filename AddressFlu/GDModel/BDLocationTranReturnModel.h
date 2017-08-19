//
//  BDLocationTranReturnModel.h
//  AddressFlu
//
//  Created by 吴小星 on 2017/5/31.
//  Copyright © 2017年 crash. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BDLocationTranModel.h"

@interface BDLocationTranReturnModel : NSObject


/**
 百度坐标系转换后的
 */
@property(nonnull,strong,nonatomic) BDLocationTranModel *locationMode;


/**
 表格数据
 */
@property(nonatomic,strong,nonnull) NSMutableArray *csvData;

@end
