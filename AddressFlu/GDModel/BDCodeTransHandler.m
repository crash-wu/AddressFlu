//
//  BDCodeTransHandler.m
//  AddressFlu
//
//  Created by 吴小星 on 2017/5/31.
//  Copyright © 2017年 crash. All rights reserved.
//

#import "BDCodeTransHandler.h"

@interface BDCodeTransHandler ()


/**
 转换的坐标
 */
@property(nonatomic,strong,nonnull) NSString *lonlat;


/**
 坐标来源
 */
@property(nonatomic,assign) NSInteger from;

@end

@implementation BDCodeTransHandler
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
    id result = [json objectForKey:@"result"];
    
    if (result != nil) {
        // 重置结果
        self.responseData = [NSJSONSerialization dataWithJSONObject:result options:kNilOptions error:nil];
        
    } else {
        self.responseData = nil;
    }
}


-(NSString *)requestURL{
    
    
    //sGSOaO07WkRHHiCRxxbSQVBn
    NSString *url = [NSString stringWithFormat:@"http://api.map.baidu.com/geoconv/v1/?coords=%@&from=%ld&to=5&ak=kGoAnw34FEtbZ4HkbM1EBCBSBCIih6xo",self.lonlat,self.from];
    
    
    url = [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet  URLFragmentAllowedCharacterSet]];
    
    return url;
    
}



// 响应对象类型
- (nullable Class<SGSResponseCollectionSerializable>)responseObjectArrayClass{
    
    return [BDLocationTranModel class];
}


/**
 高德坐标转换百度坐标
 
 @param lonLat 经纬度
 @param from 坐标来源
 @param csvData CSV每行数据
 @param success 坐标转换成功编码成功
 @param fail 坐标转换失败编码失败
 */
-(void)bdLocationTran:(NSString *_Nonnull)lonLat andFrom:(NSInteger)from andCSVData:(NSMutableArray *_Nonnull)csvData andSuccess:(nonnull void (^)(BDLocationTranReturnModel *_Nonnull bdLocationModel))success andFail:(nonnull void (^)(NSMutableArray *_Nonnull csvData))fail{
    
    self.lonlat = lonLat;
    self.from = from;
    
    [self startWithCompletionSuccess:^(__kindof SGSBaseRequest * _Nonnull request) {
        
        NSArray<BDLocationTranModel *> *array = ( NSArray<BDLocationTranModel *>*) request.responseObjectArray;
        
        if (array.count > 0) {

            
            BDLocationTranReturnModel *returnModel = [BDLocationTranReturnModel new];
            
            returnModel.csvData = csvData;
            returnModel.locationMode = array[0];
            
            success(returnModel);
            
        }else{
            fail(csvData);
        }
        

    } failure:^(__kindof SGSBaseRequest * _Nonnull request) {
        
        NSLog(@"fail");
        fail(csvData);
        
    }];
}





@end
