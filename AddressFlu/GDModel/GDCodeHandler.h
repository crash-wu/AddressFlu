//
//  GDCodeHandler.h
//  AddressFlu
//
//  Created by 吴小星 on 2017/5/27.
//  Copyright © 2017年 crash. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SGSHTTPModule/SGSHTTPModule.h>
#import "GeCodeModel.h"
#import "GeCodeListModel.h"



/**
 高德地址编码
 */
@interface GDCodeHandler : SGSBaseRequest

/**
 单例
 */
+(nonnull instancetype )sharedManager;

//-(void)gecodeAddress:(NSString *_Nonnull)lonLat andCSVData:(NSMutableArray *_Nonnull)csvData andSuccess:(nonnull void (^)(GeCodeListModel *_Nonnull codeModel))success andFail:(nonnull void (^)(NSMutableArray *_Nullable csvData))fail;

/**
 高德逆地址编码
 
 @param lonLat 经纬度
 @param csvData CSV每行数据
 @param success 逆地址编码成功
 @param fail 逆地址编码失败
 */
-(void)gecodeAddress:(NSString *_Nonnull)lonLat andCity:(NSString *_Nullable)city andCSVData:(NSMutableArray *_Nonnull)csvData andSuccess:(nonnull void (^)(GeCodeListModel *_Nonnull codeModel))success andFail:(nonnull void (^)(NSMutableArray *_Nullable csvData))fail;

@end
