//
//  GDLocationTranToBaiduLocationHandler.h
//  AddressFlu
//
//  Created by 吴小星 on 2017/6/3.
//  Copyright © 2017年 crash. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SGSHTTPModule/SGSHTTPModule.h>
#import "GPSspgModel.h"
#import "GPSspgTranforReturnModel.h"


/**
 高德坐标转换GPS坐标
 */
@interface GDLocationTranToBaiduLocationHandler : SGSBaseRequest

/**
 GPSspg高德坐标转换wgs84坐标
 
 @param lonlat 经纬度
 @param csvData CSV每行数据
 @param success 逆地址编码成功
 @param fail 逆地址编码失败
 */
-(void)spgtranlocation:(NSString *_Nonnull)lonlat andCSVData:(NSMutableArray *_Nonnull)csvData andSuccess:(nonnull void (^)(GPSspgTranforReturnModel *_Nonnull codeModel))success andFail:(nonnull void (^)(NSMutableArray *_Nullable csvData))fail;

@end
