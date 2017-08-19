//
//  GDGetCodeHandler.m
//  IndoorLocationDemo
//
//  Created by 吴小星 on 2017/5/17.
//  Copyright © 2017年 crash. All rights reserved.
//

#import "GDGetCodeHandler.h"

@interface GDGetCodeHandler ()


/**
 需要做逆地址编码的坐标
 */
@property(nonnull,strong,nonatomic) NSString *lonLat;


@end

@implementation GDGetCodeHandler


/**
 单例
 */
+(nonnull instancetype )sharedManager{
    
    static GDGetCodeHandler *shared = nil;
    
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
    return SGSRequestMethodPost;
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
    id result = [json objectForKey:@"regeocode"];
    
    if (result != nil) {
        // 重置结果
        self.responseData = [NSJSONSerialization dataWithJSONObject:result options:kNilOptions error:nil];
        
    } else {
        self.responseData = nil;
    }
}


-(NSString *)requestURL{
    
//    return [NSString stringWithFormat:@"http://restapi.amap.com/v3/geocode/regeo?output=JSON&location=%@&key=9a6085ae15410730b75b7eeb57dc71ec&radius=1000&extensions=all",self.lonLat];
    
//    return [NSString stringWithFormat:@"http://restapi.amap.com/v3/geocode/regeo?key=169d2dd7829fe45690fabec812d05bc3&s=rsv3&location=%@&poitype=药店,医疗机构,医院&callback=jsonp_967581_&platform=JS&logversion=2.0&sdkversion=1.3&appname=http://www.gpsspg.com/iframe/maps/amap_161128.htm?mapi=3&csid=E8EE511A-42EF-4BFE-92AD-C54913CB7739",self.lonLat];
    
//    NSString *url = [NSString stringWithFormat:@"http://restapi.amap.com/v3/geocode/regeo?key=169d2dd7829fe45690fabec812d05bc3&s=rsv3&location=%@&poitype=药店,医疗机构,医院,诊所,卫生院,门诊,药房,卫生服务站&radius=100&callback=jsonp_967581_&platform=JS&logversion=2.0&sdkversion=1.3&appname=http://www.gpsspg.com/iframe/maps/amap_161128.htm?mapi=3&csid=E8EE511A-42EF-4BFE-92AD-C54913CB7739",self.lonLat];
    
//        NSString *url = [NSString stringWithFormat:@"http://restapi.amap.com/v3/geocode/regeo?key=169d2dd7829fe45690fabec812d05bc3&s=rsv3&location=%@&radius=100&callback=jsonp_967581_&platform=JS&logversion=2.0&sdkversion=1.3&appname=http://www.gpsspg.com/iframe/maps/amap_161128.htm?mapi=3&csid=E8EE511A-42EF-4BFE-92AD-C54913CB7739",self.lonLat];
    
    NSString *url = [NSString stringWithFormat:@"http://restapi.amap.com/v3/geocode/regeo?output=JSON&location=%@&key=4545233705058d936b933642e6530f6f&radius=1000&extensions=all",self.lonLat];
    
//    4545233705058d936b933642e6530f6f
    
    
    url = [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet  URLQueryAllowedCharacterSet]];

    return url;
    
}

// 响应对象类型
- (Class<SGSResponseObjectSerializable>)responseObjectClass {
    return [GDGetCodeModel class];
}



/**
 高德逆地址编码
 
 @param lonLat 经纬度
 @param csvData CSV每行数据
 @param success 逆地址编码成功
 @param fail 逆地址编码失败
 */
-(void)getCode:(NSString *_Nonnull)lonLat andCSVData:(NSMutableArray *_Nonnull)csvData  andSuccess:(nonnull void (^)(SaveCSVDataModel *_Nonnull saveCSVDataModel))success andFail:(nonnull void (^)(NSError *_Nonnull error))fail{

    self.lonLat = lonLat;
    
    [self startWithCompletionSuccess:^(__kindof SGSBaseRequest * _Nonnull request) {
                
        SaveCSVDataModel *saveModel = [SaveCSVDataModel new];
        saveModel.csvData = csvData;
        GDGetCodeModel *model = (GDGetCodeModel *)request.responseObject ;
        saveModel.codeMoel = model;
        success(saveModel);
        
    } failure:^(__kindof SGSBaseRequest * _Nonnull request) {
        
        fail(request.error);
        
    }];
}


@end
