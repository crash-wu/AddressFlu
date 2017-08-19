//
//  BDCitySearchHandler.m
//  AddressFlu
//
//  Created by 吴小星 on 2017/8/18.
//  Copyright © 2017年 crash. All rights reserved.
//

#import "BDRadiusSearchHandler.h"

@interface BDRadiusSearchHandler ()




/**
 搜索半径
 */
@property(nonatomic,assign) float radius;


/**
 搜索坐标点
 */
@property(nonatomic,strong,nonnull) NSString *location;


/**
 搜索关键字
 */
@property(nonatomic,strong,nonnull) NSString *keywork;




@end

@implementation BDRadiusSearchHandler


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

//    
//    NSString *url =  [NSString stringWithFormat:@"http://api.map.baidu.com/place/v2/search?query=%@&region=%@&city_limit=true&output=json&ak=kGoAnw34FEtbZ4HkbM1EBCBSBCIih6xo",self.keywork,self.city];
    
    NSString *url =  [NSString stringWithFormat:@"http://api.map.baidu.com/place/v2/search?query=%@&page_size=30&page_num=0&scope=1&location=%@&radius=%f&output=json&ak=kGoAnw34FEtbZ4HkbM1EBCBSBCIih6xo",self.keywork,self.location,self.radius];
    
//    http://api.map.baidu.com/place/v2/search?query=酒店&page_size=10&page_num=0&scope=1&location=39.915,116.404&radius=2000&output=json&ak={您的密钥}
    //Gfj4AHsBqsBLk7lqZpNcH3zGcb8QKiWK
    
    url = [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet  URLQueryAllowedCharacterSet]];
    
    return url;
    
}



// 响应对象类型
- (nullable Class<SGSResponseCollectionSerializable>)responseObjectArrayClass{
    
    return [BDPOIModel class];
}


/**
 百度POI圆形搜索
 
 @param location 经纬度
 @param radius  搜索半径
 @param keywork 搜索关键字
 @param csv     csv数组
 @param success POI搜索成功
 @param fail POI搜索失败
 */
-(void)radiusSearch:(NSString *_Nonnull)location andKeywork:(NSString *_Nonnull) keywork andRadius:(float)radius andCSV:(NSMutableArray *_Nonnull)csv andSuccess:(nonnull void (^)(BDRadiuSearchReturnModel *_Nonnull codeModel))success andFail:(nonnull void (^)(NSMutableArray *_Nullable csv))fail{
    
    self.location = location;
    self.radius = radius ;
    self.keywork = keywork;
    
    [self startWithCompletionSuccess:^(__kindof SGSBaseRequest * _Nonnull request) {
        
        
        NSArray<BDPOIModel *> *array = ( NSArray<BDPOIModel *>*) request.responseObjectArray;
        
        
//        NSArray<BDPOIModel *> *result = [array sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
//            //3~4 2~1 3~1 3~2
//            
//            BDPOIModel *obj1Model = (BDPOIModel *)obj1;
//            BDPOIModel *obj2Model = (BDPOIModel *) obj2;
//            
//            return [obj1Model.detail_info.distance compare:obj2Model.detail_info.distance]; //升序
//            
//        }];
        
        if (array.count > 0) {
            BDRadiuSearchReturnModel *returnModel = [BDRadiuSearchReturnModel new];
            returnModel.csv = csv;
            returnModel.array = array;
            returnModel.keywork = keywork;
            
//            BDPOIModel * max =result.firstObject;
//            BDPOIModel *min = result.lastObject;
//            
//            returnModel.maxDistance = max.detail_info.distance;
//            returnModel.minDistance = min.detail_info.distance;
//            
//            double avDist = 0.0 ;
//            for (BDPOIModel *model in result ) {
//                
//                
//                avDist = avDist + [model.detail_info.distance doubleValue] ;
//            }
//            
//            returnModel.averDistance = [ NSNumber numberWithDouble:avDist /result.count];
            
            success(returnModel);
            
        }else{
            fail(csv);
        }

        
    } failure:^(__kindof SGSBaseRequest * _Nonnull request) {
        
        fail(csv);
        
    }];
}


@end
