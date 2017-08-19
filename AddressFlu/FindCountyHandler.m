//
//  FindCountyHandler.m
//  AddressFlu
//
//  Created by 吴小星 on 2017/7/6.
//  Copyright © 2017年 crash. All rights reserved.
//

#import "FindCountyHandler.h"

@interface FindCountyHandler ()

@property(nonatomic,nonnull,strong) NSString * countyName;

@end

@implementation FindCountyHandler

/**
 单例
 */
+(nonnull instancetype )sharedManager{
    
    static FindCountyHandler *shared = nil;
    
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
    id result = [json objectForKey:@"districts"];
    
    if (result != nil) {
        // 重置结果
        self.responseData = [NSJSONSerialization dataWithJSONObject:result options:kNilOptions error:nil];
        
    } else {
        self.responseData = nil;
    }
}


-(NSString *)requestURL{
    
    NSString *url = [NSString stringWithFormat:@"http://restapi.amap.com/v3/config/district?key=4545233705058d936b933642e6530f6f&keywords=%@&subdistrict=1&showbiz=false&extensions=base",self.countyName];
    
//    NSString *url = [NSString stringWithFormat:@"http://lbs.amap.com/dev/api?keywords=%@&subdistrict=3&showbiz=false&extensions=base",self.countyName];
    
    url = [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet  URLQueryAllowedCharacterSet]];
    
    return url;
    
}

// 响应对象类型
// 响应对象类型
- (nullable Class<SGSResponseCollectionSerializable>)responseObjectArrayClass{
    
    return [DistrictModel class];
}


/**
 获取县级别下面的行政区

 @param country 区县名称
 @param csvData csv
 @param success 搜索成功
 @param fail 搜索失败
 */
-(void)getCountyCenterLocation:(NSString *_Nonnull) country andCSV:(NSMutableArray *_Nonnull)csvData andSuccess:(nonnull void (^)(FindCountyReturnModel *_Nonnull codeModel))success andFail:(nonnull void (^)(NSError *_Nullable error))fail{
    
    self.countyName = country;
    
    [self startWithCompletionSuccess:^(__kindof SGSBaseRequest * _Nonnull request) {
        

        NSArray<DistrictModel *> *array = ( NSArray<DistrictModel *>*) request.responseObjectArray;
        if (array && array.count >0) {
            
            DistrictModel *model = array[0];
            
            FindCountyReturnModel *returnModel = [FindCountyReturnModel new];
            
            NSMutableArray<DistrictModel *> * distModels = [NSMutableArray array];
            distModels[0] = array[0];
            for (DistrictModel *mode in model.districts) {
                
                [distModels addObject:mode];
            }
            
            returnModel.district =  [distModels copy];
            returnModel.csvData = csvData;
            
            success(returnModel);
                        
        }else{
            fail(nil);
        }
        
        NSLog(@"");
        
    } failure:^(__kindof SGSBaseRequest * _Nonnull request) {
        
        fail(request.error);
        
    }];
    
}

@end
