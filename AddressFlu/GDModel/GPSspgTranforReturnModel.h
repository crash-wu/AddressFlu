//
//  GPSspgTranforReturnModel.h
//  AddressFlu
//
//  Created by 吴小星 on 2017/6/3.
//  Copyright © 2017年 crash. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GPSspgModel.h"

@interface GPSspgTranforReturnModel : NSObject


@property(nonatomic,strong,nonnull) GPSspgModel *spgModel;


@property(nonnull,strong,nonatomic) NSMutableArray *csvData;

@end
