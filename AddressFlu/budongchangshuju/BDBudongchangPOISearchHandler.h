//
//  BDPOISearchHandler.h
//  AddressFlu
//
//  Created by 吴小星 on 2017/7/12.
//  Copyright © 2017年 crash. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SGSHTTPModule/SGSHTTPModule.h>
#import "BDPOIModel.h"
#import "BDPOIReturnModel.h"

@interface BDBudongchangPOISearchHandler : SGSBaseRequest

/**
 BDPOI搜索
 
 @param keyworks 经纬度
 @param city    城市名称
 @param csv     csv数组
 @param success POI搜索成功
 @param fail POI搜索失败
 */
-(void)poiSearch:(NSString *_Nonnull)keyworks andCity:(NSString *_Nullable)city andCSV:(NSMutableArray *_Nonnull)csv andSuccess:(nonnull void (^)(BDPOIReturnModel *_Nonnull codeModel))success andFail:(nonnull void (^)(NSMutableArray *_Nullable csv))fail;

@end
