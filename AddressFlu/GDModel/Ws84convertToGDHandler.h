//
//  Ws84convertToGDHandler.h
//  AddressFlu
//
//  Created by 吴小星 on 2017/5/21.
//  Copyright © 2017年 crash. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SGSHTTPModule/SGSHTTPModule.h>
#import "Ws84ConvertToGDModel.h"
#import "SaveCSVDataModel.h"
#import "Ws84ConvertReturnModel.h"


/**
 Ws84坐标系转换高德坐标
 */
@interface Ws84convertToGDHandler : SGSBaseRequest


/**
 高德坐标系转换
 
 @param lonLat 经纬度
 @param coordsys 坐标系(gps,mapbar,baidu)
 @param csvData csv行数据
 @param success 逆地址编码成功
 @param fail 逆地址编码失败
 */
-(void)ws84Convert:(NSString *_Nonnull)lonLat andcoordsys:(NSString *_Nullable)coordsys andCSVData:(NSMutableArray *_Nonnull)csvData  andSuccess:(nonnull void (^)(Ws84ConvertReturnModel *_Nonnull convertModel))success andFail:(nonnull void (^)(NSError *_Nonnull error))fail;

@end
