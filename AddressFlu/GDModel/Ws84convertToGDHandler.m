//
//  Ws84convertToGDHandler.m
//  AddressFlu
//
//  Created by 吴小星 on 2017/5/21.
//  Copyright © 2017年 crash. All rights reserved.
//

#import "Ws84convertToGDHandler.h"

@interface Ws84convertToGDHandler ()

/**
 需要做坐标转换地址编码
 */
@property(nonnull,strong,nonatomic) NSString *lonLat;


/**
 坐标系
 */
@property(nonnull,strong,nonatomic) NSString *coordsys;


@end

@implementation Ws84convertToGDHandler


/**
 单例
 */
+(nonnull instancetype )sharedManager{
    
    static Ws84convertToGDHandler *shared = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        shared = [[self alloc]init];
    });
    
    return shared;
}

/**
 *  @author crash         crash_wu@163.com   , 16-09-09 09:09:57
 *
 *  @brief  重新请求方法
 *
 *  @return 返回指定的请求方法为POST
 */
-(SGSRequestMethod)requestMethod{
    return SGSRequestMethodGet;
}



-(SGSRequestSerializerType)requestSerializerType{
    return SGSRequestSerializerTypeJSON;
}


- (void)requestCompleteFilter {
    // 如果有错误直接返回
    if (self.error != nil) return ;
    
    id json = self.responseJSON;
    
    // 不是JSON数据
    if ((json == nil) || ![json isKindOfClass:[NSDictionary class]]) {
        self.error = [NSError errorWithDomain:@"com.southgis.error" code:-8000 userInfo:@{NSLocalizedDescriptionKey: @"非JSON数据"}];
        
        // 清空返回结果
        self.responseData = nil;
        return ;
    }
    
    // 返回的状态码不合法
    NSInteger status = [[json objectForKey:@"status"] integerValue];
    
    if (status != 1) {
        NSString *desc = [json objectForKey:@"description"];
        self.error = [NSError errorWithDomain:@"com.southgis.error" code:status userInfo:@{NSLocalizedDescriptionKey: desc ?: @""}];
        
        // 清空返回结果
        self.responseData = nil;
        
        return ;
    }
    
    self.responseData = [NSJSONSerialization dataWithJSONObject:json options:kNilOptions error:nil];
}


-(NSString *)requestURL{
    
    return [NSString stringWithFormat:@"http://restapi.amap.com/v3/assistant/coordinate/convert?locations=%@&coordsys=%@&output=JSON&key=4545233705058d936b933642e6530f6f",self.lonLat ,self.coordsys];
    
//    4545233705058d936b933642e6530f6f
//    d4539b4944305815a85de33753ce6c8a

}

// 响应对象类型
- (Class<SGSResponseObjectSerializable>)responseObjectClass {
    return [Ws84ConvertToGDModel class];
}



/**
 高德坐标系转换
 
 @param lonLat 经纬度
 @param coordsys 坐标系(gps,mapbar,baidu)
 @param csvData csv行数据
 @param success 逆地址编码成功
 @param fail 逆地址编码失败
 */
-(void)ws84Convert:(NSString *_Nonnull)lonLat andcoordsys:(NSString *_Nullable)coordsys andCSVData:(NSMutableArray *_Nonnull)csvData  andSuccess:(nonnull void (^)(Ws84ConvertReturnModel *_Nonnull convertModel))success andFail:(nonnull void (^)(NSError *_Nonnull error))fail{
    
    self.coordsys = coordsys;
    self.lonLat = lonLat;
    [self startWithCompletionSuccess:^(__kindof SGSBaseRequest * _Nonnull request) {

        Ws84ConvertReturnModel *returnModel = [Ws84ConvertReturnModel new];
        Ws84ConvertToGDModel *model = (Ws84ConvertToGDModel *)request.responseObject ;
        returnModel.convertModel = model;
        returnModel.csvData = csvData;
        
        success(returnModel);
        
    } failure:^(__kindof SGSBaseRequest * _Nonnull request) {
        
        fail(request.error);
        
    }];
}


@end
