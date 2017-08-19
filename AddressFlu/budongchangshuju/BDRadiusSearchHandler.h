//
//  BDCitySearchHandler.h
//  AddressFlu
//
//  Created by 吴小星 on 2017/8/18.
//  Copyright © 2017年 crash. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SGSHTTPModule/SGSHTTPModule.h>
#import "BDPOIModel.h"
#import "BDRadiuSearchReturnModel.h"


//百度圆形区域检索
@interface BDRadiusSearchHandler : SGSBaseRequest


/**
 百度POI圆形搜索
 
 @param location 经纬度
 @param radius  搜索半径
 @param keywork 搜索关键字
 @param csv     csv数组
 @param success POI搜索成功
 @param fail POI搜索失败
 */
-(void)radiusSearch:(NSString *_Nonnull)location andKeywork:(NSString *_Nonnull) keywork andRadius:(float)radius andCSV:(NSMutableArray *_Nonnull)csv andSuccess:(nonnull void (^)(BDRadiuSearchReturnModel *_Nonnull codeModel))success andFail:(nonnull void (^)(NSMutableArray *_Nullable csv))fail;

@end
