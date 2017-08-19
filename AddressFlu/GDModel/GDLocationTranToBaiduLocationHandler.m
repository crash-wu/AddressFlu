//
//  GDLocationTranToBaiduLocationHandler.m
//  AddressFlu
//
//  Created by 吴小星 on 2017/6/3.
//  Copyright © 2017年 crash. All rights reserved.
//

#import "GDLocationTranToBaiduLocationHandler.h"

@interface GDLocationTranToBaiduLocationHandler ()


@property(nonatomic,nonnull,strong) NSString * latlng;

@end


/**
 高德坐标转换成百度坐标
 */
@implementation GDLocationTranToBaiduLocationHandler

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
    
    if (status != 200) {
        NSString *desc = [json objectForKey:@"description"];
        self.error = [NSError errorWithDomain:@"com.southgis.error" code:status userInfo:@{NSLocalizedDescriptionKey: desc ?: @""}];
        
        // 清空返回结果
        self.responseData = nil;
        
        return ;
    }
    
    // 获取结果
    id result = [json objectForKey:@"result"];
    
    if (result != nil) {
        // 重置结果
        self.responseData = [NSJSONSerialization dataWithJSONObject:result options:kNilOptions error:nil];
        
    } else {
        self.responseData = nil;
    }
}


-(NSString *)requestURL{
    
    
    NSString *url = [NSString stringWithFormat:@"http://api.gpsspg.com/convert/coord/?oid=5144&key=7E5D7BFC116684AE7C3ADCF57601E9CA&output=json&from=3&to=0&latlng=%@",self.latlng];
    
//    oid=5144
//    key=7E5D7BFC116684AE7C3ADCF57601E9CA
    
//    oid=5043
//    &key=3FCC4542E380C3411637B68C61C32423
    
    url = [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet  URLQueryAllowedCharacterSet]];
    
    return url;
    
}



// 响应对象类型
- (nullable Class<SGSResponseCollectionSerializable>)responseObjectArrayClass{
    
    return [GPSspgModel class];
}


/**
 GPSspg高德坐标转换wgs84坐标
 
 @param lonlat 经纬度
 @param csvData CSV每行数据
 @param success 逆地址编码成功
 @param fail 逆地址编码失败
 */
-(void)spgtranlocation:(NSString *_Nonnull)lonlat andCSVData:(NSMutableArray *_Nonnull)csvData andSuccess:(nonnull void (^)(GPSspgTranforReturnModel *_Nonnull codeModel))success andFail:(nonnull void (^)(NSMutableArray *_Nullable csvData))fail{
    
    NSArray *array = [lonlat componentsSeparatedByString:@","];
    
    if (array && array.count == 2) {
        self.latlng = [NSString stringWithFormat:@"%@,%@",array[1],array[0]];
        
    }else{
        self.latlng = @"";
    }
    

    [self startWithCompletionSuccess:^(__kindof SGSBaseRequest * _Nonnull request) {
        
        NSArray<GPSspgModel *> *array = ( NSArray<GPSspgModel *>*) request.responseObjectArray;
        
        if (array.count > 0) {
            
            GPSspgTranforReturnModel *model = [GPSspgTranforReturnModel new];
            model.csvData = csvData;
            model.spgModel = array[0];
            success(model);
            
        }else{
            fail(csvData);
        }
    } failure:^(__kindof SGSBaseRequest * _Nonnull request) {
        
        fail(csvData);
        
    }];
}

@end
