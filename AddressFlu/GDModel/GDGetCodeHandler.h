//
//  GDGetCodeHandler.h
//  IndoorLocationDemo
//
//  Created by 吴小星 on 2017/5/17.
//  Copyright © 2017年 crash. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SGSHTTPModule/SGSHTTPModule.h>
#import "GDGetCodeModel.h"
#import "SaveCSVDataModel.h"
#import "Ws84ConvertGDManager.h"
/**
 高德逆地址编码
 */
@interface GDGetCodeHandler : SGSBaseRequest


/**
 单例
 */
+(nonnull instancetype )sharedManager;



/**
 高德逆地址编码
 
 @param lonLat 经纬度
 @param csvData CSV每行数据
 @param success 逆地址编码成功
 @param fail 逆地址编码失败
 */
-(void)getCode:(NSString *_Nonnull)lonLat andCSVData:(NSMutableArray *_Nonnull)csvData  andSuccess:(nonnull void (^)(SaveCSVDataModel *_Nonnull saveCSVDataModel))success andFail:(nonnull void (^)(NSError *_Nonnull error))fail;

@end
