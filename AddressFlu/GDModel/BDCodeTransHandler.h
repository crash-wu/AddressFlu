//
//  BDCodeTransHandler.h
//  AddressFlu
//
//  Created by 吴小星 on 2017/5/31.
//  Copyright © 2017年 crash. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SGSHTTPModule/SGSHTTPModule.h>
#import "BDLocationTranModel.h"
#import "BDLocationTranReturnModel.h"


/**
 百度地图坐标转换
 */
@interface BDCodeTransHandler : SGSBaseRequest


/**
 高德坐标转换百度坐标
 
 @param lonLat 经纬度
 @param from 坐标来源
 @param csvData CSV每行数据
 @param success 坐标转换成功编码成功
 @param fail 坐标转换失败编码失败
 */
-(void)bdLocationTran:(NSString *_Nonnull)lonLat andFrom:(NSInteger)from andCSVData:(NSMutableArray *_Nonnull)csvData andSuccess:(nonnull void (^)(BDLocationTranReturnModel *_Nonnull bdLocationModel))success andFail:(nonnull void (^)(NSMutableArray *_Nonnull csvData))fail;

@end
