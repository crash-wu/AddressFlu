//
//  FindCountyHandler.h
//  AddressFlu
//
//  Created by 吴小星 on 2017/7/6.
//  Copyright © 2017年 crash. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SGSHTTPModule/SGSHTTPModule.h>
#import "DistrictModel.h"
#import "FindCountyReturnModel.h"

@interface FindCountyHandler : SGSBaseRequest

/**
 单例
 */
+(nonnull instancetype )sharedManager;

/**
 获取县级别下面的行政区
 
 @param country 区县名称
 @param csvData csv
 @param success 搜索成功
 @param fail 搜索失败
 */
-(void)getCountyCenterLocation:(NSString *_Nonnull) country andCSV:(NSMutableArray *_Nonnull)csvData andSuccess:(nonnull void (^)(FindCountyReturnModel *_Nonnull codeModel))success andFail:(nonnull void (^)(NSError *_Nullable error))fail;

@end
