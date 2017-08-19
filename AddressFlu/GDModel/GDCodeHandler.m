//
//  GDCodeHandler.m
//  AddressFlu
//
//  Created by 吴小星 on 2017/5/27.
//  Copyright © 2017年 crash. All rights reserved.
//

#import "GDCodeHandler.h"


@interface GDCodeHandler ()


/**
 地址
 */
@property(nonatomic,strong,nonnull) NSString *address;


@property(nonatomic,strong,nonnull) NSString *city;

@end

@implementation GDCodeHandler


/**
 单例
 */
+(nonnull instancetype )sharedManager{
    
    static GDCodeHandler *shared = nil;
    
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
    
    // 获取结果
    id result = [json objectForKey:@"geocodes"];
    
    if (result != nil) {
        // 重置结果
        self.responseData = [NSJSONSerialization dataWithJSONObject:result options:kNilOptions error:nil];
        
    } else {
        self.responseData = nil;
    }
}


-(NSString *)requestURL{
    

//    NSString *url = [NSString stringWithFormat:@"http://restapi.amap.com/v3/geocode/geo?key=9282c787da7191a247fe34a8e0b497e3&address=%@&city=哈尔滨",self.address];
    
    NSString *url = @"";
    if (self.city) {
        url = [NSString stringWithFormat:@"http://restapi.amap.com/v3/geocode/geo?key=169d2dd7829fe45690fabec812d05bc3&s=rsv3&logversion=2.0&sdkversion=1.3&appname=http://www.gpsspg.com/iframe/maps/amap_161128.htm?mapi=3&csid=53C6DA57-1E2E-4879-9A84-BE4663182191&address=%@&city=%@",self.address,self.city];
        
    }else{
        url = [NSString stringWithFormat:@"http://restapi.amap.com/v3/geocode/geo?key=169d2dd7829fe45690fabec812d05bc3&s=rsv3&logversion=2.0&sdkversion=1.3&appname=http://www.gpsspg.com/iframe/maps/amap_161128.htm?mapi=3&csid=53C6DA57-1E2E-4879-9A84-BE4663182191&address=%@",self.address];
        
    }
    

    
    
    url = [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet  URLQueryAllowedCharacterSet]];
    
    return url;
    
}



// 响应对象类型
- (nullable Class<SGSResponseCollectionSerializable>)responseObjectArrayClass{
    
    return [GeCodeModel class];
}


/**
 高德逆地址编码
 
 @param lonLat 经纬度
 @param csvData CSV每行数据
 @param success 逆地址编码成功
 @param fail 逆地址编码失败
 */
-(void)gecodeAddress:(NSString *_Nonnull)lonLat andCity:(NSString *_Nullable)city andCSVData:(NSMutableArray *_Nonnull)csvData andSuccess:(nonnull void (^)(GeCodeListModel *_Nonnull codeModel))success andFail:(nonnull void (^)(NSMutableArray *_Nullable csvData))fail{
    
    self.address = lonLat;
    self.city = city ;
    
    [self startWithCompletionSuccess:^(__kindof SGSBaseRequest * _Nonnull request) {
        
        
        NSArray<GeCodeModel *> *array = ( NSArray<GeCodeModel *>*) request.responseObjectArray;
        
        if (array.count > 0) {
            
            GeCodeListModel *model = [GeCodeListModel new];
            model.csvData = csvData;
            model.codeModel = array[0];
            success(model);
            
        }else{
            fail(csvData);
        }
    } failure:^(__kindof SGSBaseRequest * _Nonnull request) {
        
        fail(csvData);
        
    }];
}


@end
