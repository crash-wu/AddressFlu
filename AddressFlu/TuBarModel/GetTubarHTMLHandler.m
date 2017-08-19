//
//  GetTubarHTMLHandler.m
//  AddressFlu
//
//  Created by 吴小星 on 2017/6/7.
//  Copyright © 2017年 crash. All rights reserved.
//

#import "GetTubarHTMLHandler.h"

@implementation GetTubarHTMLHandler



/**
 解析HTML数据

 @param url HTML网址
 */
-(void)analysisHTMLData:(NSString *_Nonnull) url success:(nonnull void (^)(NSMutableArray<TubarHTMLModel *> *htmlModes)) success andFail:(nonnull void (^)(NSError *_Nullable error))fail{
    
    NSMutableArray<TubarHTMLModel *> *array=[NSMutableArray array];
    NSData *data= [NSData dataWithContentsOfURL:[NSURL URLWithString:url]]; //下载网页数据
    
    NSError *error;
    ONOXMLDocument *doc=[ONOXMLDocument HTMLDocumentWithData:data error:&error];
//    /html/body/div[3]/div[2]
    ONOXMLElement *postsParentElement= [doc firstChildWithXPath:@"/html/body/div[2]/div[2]"]; //寻找该 XPath 代表的 HTML 节点,
    
    if (!postsParentElement) {
        fail(nil);
    }

    //遍历其子节点,
    [postsParentElement.children enumerateObjectsUsingBlock:^(ONOXMLElement *element, NSUInteger idx, BOOL * _Nonnull stop) {
        
            
            [self postElements:element success:^(NSMutableArray<TubarHTMLModel *> *htmlModes) {
                
                for (TubarHTMLModel *model in htmlModes ) {
                    
                    [array addObject:model];
                }
                
            } andFail:^(NSError * _Nullable error) {
                
                fail(error);
            }];
        
        if (postsParentElement.children.count -1 == idx) {
            
            
            success(array);
        }

    }];

}


-(void)postElements:(ONOXMLElement*)elements success:(void (^)(NSMutableArray<TubarHTMLModel *> *htmlModes)) success andFail:(void (^)(NSError *_Nullable error))fail{
    
    NSMutableArray<TubarHTMLModel *> *array = [NSMutableArray array];
    
    ONOXMLElement *titleElement= [elements firstChildWithXPath:[NSString stringWithFormat:@"dd"]];
    
    if (!titleElement) {
        fail(nil);
    }

    //遍历其子节点,
    [titleElement.children enumerateObjectsUsingBlock:^(ONOXMLElement *element, NSUInteger idx, BOOL * _Nonnull stop) {
        
        TubarHTMLModel *model = [self postWithHtmlStr:element];
        if (model && ![model.name isEqualToString:@""] && model.name.length < 100) {
            
            [array addObject:model];
        }
        
        
        if (titleElement.children.count -1 == idx) {
            
            
            success(array);
        }
    }];

}

-(TubarHTMLModel*)postWithHtmlStr:(ONOXMLElement*)element{
    
    TubarHTMLModel *p=[TubarHTMLModel new];

    NSString *url = [element valueForAttribute:@"href"];
    
//    if (url == nil) {
//        NSLog(@"url is nill");
//    }
//    

   // http://poi.mapbar.net/qiqihaer/MAPITPJIQPQPTWTWCRTPC
    url = [ url stringByReplacingOccurrencesOfString:@"http://poi.mapbar.com" withString:@"http://poi.mapbar.net"];
//    url = [ url stringByReplacingOccurrencesOfString:@".com" withString:@".net"];
    
    p.url = url;
    
    p.name= [element stringValue];

    //*[@id="dnode"]
    //*[@id="dnode"]
    //通过解密加密后的经纬度字符串串，得出经纬度坐标

    p.location = [self analysisPwdData:url];
    return p;
}


/**
 获取经纬度加密字符串

 @param url     获取经纬度加密字符串
 @return 返回经纬度坐标

 */
-(NSString *_Nullable)analysisPwdData:(NSString *_Nonnull) url {
    
    NSData *data= [NSData dataWithContentsOfURL:[NSURL URLWithString:url]]; //下载网页数据
    
    NSError *error;
    ONOXMLDocument *doc=[ONOXMLDocument HTMLDocumentWithData:data error:&error];

    ONOXMLElement *postsParentElement= [doc firstChildWithXPath:@"//*[@id=\"dnode\"]"]; //寻找该 XPath 代表的 HTML 节点,
    
    //获取加密字符串
    NSString *pwd = [postsParentElement valueForAttribute:@"value"];
    
    NSString *lonlat = [self decipher:pwd  ];
    
    return lonlat;
}



/**
 通过图吧经纬度加密字符串解密经纬度实际值

 @param key 经纬度加密字符串
 @return 解密后的经纬度坐标
 */
-(NSString *_Nullable)decipher:(NSString *_Nonnull) key{
    
    
    NSString *location = nil;
    NSInteger W7pj = -1;
    NSInteger I524S = 0;
    NSString * qk_X = @"";
    
    if (key.length > 0) {
        
        for (int i = 0; i < key.length ; i++) {
            
           // int j86T = [self parseIntFor36:[key substringWithRange:NSMakeRange(i, 1)]] -10;
            NSInteger j86T = strtoul([[key substringWithRange:NSMakeRange(i, 1)] UTF8String],0,36) - 10;
            
            if (j86T >= 17) {
                j86T = j86T - 7;
            }
        
            qk_X = [qk_X stringByAppendingString:[self parseIntTo36:j86T]];
            if (j86T >= I524S) {
                W7pj = i;
                I524S = j86T;
            }
        }
        
        NSInteger U8T = strtoul([[qk_X substringWithRange:NSMakeRange(0, W7pj)] UTF8String],0,16);
        
        NSInteger f9v8D = strtoul([[qk_X substringWithRange:NSMakeRange(W7pj+1,qk_X.length - W7pj -1  )] UTF8String],0,16);
        
        float lon = (U8T + f9v8D - 3409)/2;
        float lat = (f9v8D - lon) /100000.000;
        
        lon /= 100000.000;
        
        location = [NSString stringWithFormat:@"%f,%f",lon,lat];
    }
    
//    if (location == nil) {
//        
//        NSLog(@"location is nill");
//    }
//    
    return location;
    
}



/**
 36进制转化10进制

 @param key 36进制字符
 @return 返回10进制字符
 */
-(int)parseIntFor36:(NSString *_Nonnull)key{
    
    NSString *X36 = @"0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ";
    key = key.uppercaseString;
    
    int result = 0;
    NSInteger lenght = X36.length;

    for (int i = 0;  i < lenght; i++) {
        
        if ([key isEqualToString:[X36 substringWithRange:NSMakeRange(i, 1)]]) {
            
            result = i;
        }
    }
    
    return result;
    
}


/**
 10进制转换成36进制

 @param key 10进制数字
 @return 10进制字符串
 */
-(NSString *_Nonnull)parseIntTo36:(NSInteger) key{
    
    NSString *X36 = @"0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ";
    NSString *  result = [X36 substringWithRange:NSMakeRange(key % 36, 1)];
    
    return result;
}

@end
