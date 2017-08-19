//
//  BDRouteSearchHandler.m
//  AddressFlu
//
//  Created by 吴小星 on 2017/8/18.
//  Copyright © 2017年 crash. All rights reserved.
//

#import "BDRouteSearchHandler.h"

@interface BDRouteSearchHandler ()

@property(nonatomic,strong,nonnull) NSString *origins;


@property(nonnull,strong,nonatomic) NSString * destinations;

@end

@implementation BDRouteSearchHandler


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
//    
//http://api.map.baidu.com/routematrix/v2/driving?output=json&origins=40.45,116.34|40.54,116.35&destinations=40.34,116.45|40.35,116.46&ak=您的ak
    

    NSString *url =  [NSString stringWithFormat:@"http://api.map.baidu.com/routematrix/v2/walking?output=json&origins=%@&destinations=%@&ak=kGoAnw34FEtbZ4HkbM1EBCBSBCIih6xo",self.origins,self.destinations];

    
    url = [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet  URLQueryAllowedCharacterSet]];
    
    return url;
    
}



// 响应对象类型
- (nullable Class<SGSResponseCollectionSerializable>)responseObjectArrayClass{
    
    return [BDRoutematrixModel class];
}


/**
 百度路线搜索
 
 @param origins 经纬度
 @param dest  搜索半径
 @param csv     csv数组
 @param success POI搜索成功
 @param fail POI搜索失败
 */
-(void)routeSearch:(NSString *_Nonnull)origins  andDest:(NSString *_Nonnull)dest andCSV:(NSMutableArray *_Nonnull)csv andSuccess:(nonnull void (^)(BDRoutematrixReturnModel *_Nonnull codeModel))success andFail:(nonnull void (^)(NSMutableArray *_Nullable csv))fail{
    
    self.origins = origins;
    self.destinations = dest ;
    
    [self startWithCompletionSuccess:^(__kindof SGSBaseRequest * _Nonnull request) {
        
        
        NSArray<BDRoutematrixModel *> *array = ( NSArray<BDRoutematrixModel *>*) request.responseObjectArray;
        

        
        NSArray<BDRoutematrixModel *> *result = [array sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
            //3~4 2~1 3~1 3~2
            
            BDRoutematrixModel *obj1Model = (BDRoutematrixModel *)obj1;
            BDRoutematrixModel *obj2Model = (BDRoutematrixModel *) obj2;
            
            return [obj1Model.distance.value compare:obj2Model.distance.value]; //升序
            
        }];
        
        BDRoutematrixReturnModel * returnModel = [BDRoutematrixReturnModel new];
        returnModel.csv = csv;
        
        if (result.count > 0) {
            
            BDRoutematrixModel * max =result.firstObject;
            BDRoutematrixModel *min = result.lastObject;
            
            returnModel.maxDis = max.distance.value;
            returnModel.minDis = min.distance.value;
            
            double avDist = 0.0 ;
            int i = 0;
            for (BDRoutematrixModel *model in result ) {
                
                
                avDist = avDist + [model.distance.value doubleValue] ;

                i ++;
            }

            avDist = avDist / i;
            
            returnModel.avDis = [NSString stringWithFormat:@"%lf",avDist];
            returnModel.avTime = [NSString stringWithFormat:@"%lf",[max.duration.value doubleValue ]/60];
            
            success(returnModel);
            
        }else{
            
            fail(csv);
        }
        
    } failure:^(__kindof SGSBaseRequest * _Nonnull request) {
        
        fail(csv);
        
    }];
}


@end
