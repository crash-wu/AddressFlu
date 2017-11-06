//
//  GDPOISearchHandler.m
//  AddressFlu
//
//  Created by 吴小星 on 2017/6/8.
//  Copyright © 2017年 crash. All rights reserved.
//

#import "GDPOISearchHandler.h"

@interface GDPOISearchHandler ()


/**
 城市名
 */
@property(nonnull,strong,nonatomic) NSString *city;


/**
 POI搜索关键字
 */
@property(nonatomic,strong,nonnull) NSString *keywords;

@end

@implementation GDPOISearchHandler

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
    
    // 获取结果
    id result = [json objectForKey:@"pois"];
    
    if (result != nil) {
        // 重置结果
        self.responseData = [NSJSONSerialization dataWithJSONObject:result options:kNilOptions error:nil];
        
    } else {
        self.responseData = nil;
    }
}


-(NSString *)requestURL{
    
//    NSString *url =  [NSString stringWithFormat:@"http://restapi.amap.com/v3/place/text?s=rsv3&key=169d2dd7829fe45690fabec812d05bc3&offset=10&page=1&sdkversion=1.3&language=zh_cn&appname=http://www.gpsspg.com/iframe/maps/amap_161128.htm?mapi=3&csid=53C6DA57-1E2E-4879-9A84-BE4663182191&csid=AF2AEFC6-8838-4595-9CCA-8794BB6C4DB2&keywords=%@&city=%@&types=090000",self.keywords,self.city];


    
    NSString *url =  [NSString stringWithFormat:@"http://restapi.amap.com/v3/place/text?key=4545233705058d936b933642e6530f6f&offset=10&page=1&keywords=%@&city=%@&types=090000",self.keywords,self.city];
    
    url = [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet  URLQueryAllowedCharacterSet]];
    
    return url;
    
}



// 响应对象类型
- (nullable Class<SGSResponseCollectionSerializable>)responseObjectArrayClass{
    
    return [GDPOIModel class];
}


/**
 高德POI搜索
 
 @param keyworks 经纬度
 @param city    城市名称
 @param csv     csv数组
 @param success POI搜索成功
 @param fail POI搜索失败
 */
-(void)poiSearch:(NSString *_Nonnull)keyworks andCity:(NSString *_Nullable)city andCSV:(NSMutableArray *_Nonnull)csv andSuccess:(nonnull void (^)(GDPOIReturnModel *_Nonnull codeModel))success andFail:(nonnull void (^)(NSMutableArray *_Nullable csv))fail{
    
    self.keywords = keyworks;
    self.city = city ;
    
    [self startWithCompletionSuccess:^(__kindof SGSBaseRequest * _Nonnull request) {
        
        
        NSArray<GDPOIModel *> *array = ( NSArray<GDPOIModel *>*) request.responseObjectArray;
        
        GDPOIReturnModel *returnModel = [GDPOIReturnModel new];
        
        if (array.count > 0) {
            
             GDPOIModel *model = array[0];
            NSString *name = [model.name stringByReplacingOccurrencesOfString:@"(" withString:@""];
            name = [name stringByReplacingOccurrencesOfString:@")" withString:@""];
            
            NSString *key = keyworks;
            key = [key stringByReplacingOccurrencesOfString:@"(" withString:@""];
            key = [key stringByReplacingOccurrencesOfString:@")" withString:@""];
            
            
            if ( [key isEqualToString:name]) {
                returnModel.csv = csv;
                model.name = keyworks;
                returnModel.poiModel = model;
                success(returnModel);
            }else{
              //  fail(csv);
                returnModel.csv = csv;
                returnModel.poiModel = model;
                success(returnModel);
            }
        }else{
            
            fail(csv);
        }
        
    } failure:^(__kindof SGSBaseRequest * _Nonnull request) {
        
        fail(csv);
        
    }];
}



@end
