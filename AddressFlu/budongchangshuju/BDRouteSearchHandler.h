//
//  BDRouteSearchHandler.h
//  AddressFlu
//
//  Created by 吴小星 on 2017/8/18.
//  Copyright © 2017年 crash. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SGSHTTPModule/SGSHTTPModule.h>
#import "BDRoutematrixModel.h"
#import "BDRoutematrixReturnModel.h"

@interface BDRouteSearchHandler : SGSBaseRequest


/**
 百度路线搜索
 
 @param origins 经纬度
 @param dest  搜索半径
 @param csv     csv数组
 @param success POI搜索成功
 @param fail POI搜索失败
 */
-(void)routeSearch:(NSString *_Nonnull)origins  andDest:(NSString *_Nonnull)dest andCSV:(NSMutableArray *_Nonnull)csv andSuccess:(nonnull void (^)(BDRoutematrixReturnModel *_Nonnull codeModel))success andFail:(nonnull void (^)(NSMutableArray *_Nullable csv))fail;

@end
