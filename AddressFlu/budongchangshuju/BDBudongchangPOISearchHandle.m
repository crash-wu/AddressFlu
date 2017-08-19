//
//  BDPOISearchHandler.m
//  AddressFlu
//
//  Created by 吴小星 on 2017/7/12.
//  Copyright © 2017年 crash. All rights reserved.
//

#import "BDBudongchangPOISearchHandler.h"

@interface BDBudongchangPOISearchHandler ()



/**
 城市名称
 */
@property(nonatomic,strong,nonnull) NSString *city;


/**
 搜索关键字
 */
@property(nonatomic,strong,nonnull) NSString *keywork;

@end

@implementation BDBudongchangPOISearchHandler


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
    
    if (status != 0) {
        NSString *desc = [json objectForKey:@"description"];
        self.error = [NSError errorWithDomain:@"com.southgis.error" code:status userInfo:@{NSLocalizedDescriptionKey: desc ?: @""}];
        
        // 清空返回结果
        self.responseData = nil;
        
        return ;
    }
    
    // 获取结果
    id result = [json objectForKey:@"results"];
    
    if (result != nil) {
        // 重置结果
        self.responseData = [NSJSONSerialization dataWithJSONObject:result options:kNilOptions error:nil];
        
    } else {
        self.responseData = nil;
    }
}


-(NSString *)requestURL{
    
//    http://api.map.baidu.com/place/v2/search?query=百度大厦&region=深圳&city_limit=true&output=json&ak={您的密钥}
    
    NSString *url =  [NSString stringWithFormat:@"http://api.map.baidu.com/place/v2/search?query=%@&region=%@&city_limit=true&output=json&ak=kGoAnw34FEtbZ4HkbM1EBCBSBCIih6xo",self.keywork,self.city];
    //Gfj4AHsBqsBLk7lqZpNcH3zGcb8QKiWK
    
    url = [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet  URLQueryAllowedCharacterSet]];
    
    return url;
    
}



// 响应对象类型
- (nullable Class<SGSResponseCollectionSerializable>)responseObjectArrayClass{
    
    return [BDPOIModel class];
}


/**
 BDPOI搜索
 
 @param keyworks 经纬度
 @param city    城市名称
 @param csv     csv数组
 @param success POI搜索成功
 @param fail POI搜索失败
 */
-(void)poiSearch:(NSString *_Nonnull)keyworks andCity:(NSString *_Nullable)city andCSV:(NSMutableArray *_Nonnull)csv andSuccess:(nonnull void (^)(BDPOIReturnModel *_Nonnull codeModel))success andFail:(nonnull void (^)(NSMutableArray *_Nullable csv))fail{
    
    self.keywork = keyworks;
    self.city = city ;
    
    [self startWithCompletionSuccess:^(__kindof SGSBaseRequest * _Nonnull request) {
        
        
        NSArray<BDPOIModel *> *array = ( NSArray<BDPOIModel *>*) request.responseObjectArray;
        
        BDPOIReturnModel *returnModel = [BDPOIReturnModel new];
        
        if (array.count > 0) {
            
            BDPOIModel *model = array[0];
                            
                returnModel.csv = csv;
                returnModel.poiModel = array[0];
                success(returnModel);

        }else{
            
            fail(csv);
        }
        
    } failure:^(__kindof SGSBaseRequest * _Nonnull request) {
        
        fail(csv);
        
    }];
}



@end
