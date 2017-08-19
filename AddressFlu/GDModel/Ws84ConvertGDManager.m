//
//  Ws84ConvertGDManager.m
//  AddressFlu
//
//  Created by 吴小星 on 2017/5/21.
//  Copyright © 2017年 crash. All rights reserved.
//

#import "Ws84ConvertGDManager.h"

@implementation Ws84ConvertGDManager


/**
 WGS84转GCJ02(火星坐标系)
 
 @return 返回火星坐标系
 */
-(nullable NSString *)wgs84togcj02:(NSString *_Nonnull) lonLat{
    
    NSArray *array = [lonLat componentsSeparatedByString:@","];
    
    double lng = [array[0] floatValue] ;
    double lat = [array[1] floatValue] ;
    
    // 长半轴
    static double a = 6378245.0;
    // 扁率
    static double ee = 0.00669342162296594323;
    
    double dlat = [self transformlat:lonLat];
    double dlng = [self transformlng:lonLat];
    double radlat = lng / 180.0 * M_PI;
    double magic = sin(radlat);
    magic = 1 - ee * magic * magic;
    double sqrtmagic = sqrt(magic);
    
    dlat = (dlat * 180.0) / ((a * (1 - ee)) / (magic * sqrtmagic) * M_PI);
    
    dlng = (dlng * 180.0) / (a / sqrtmagic * cos(radlat) * M_PI);
    
    double mglat = lat + dlat;
    double mglng = lng + dlng;
    
    
    return [NSString stringWithFormat:@"%lf,%lf",mglng,mglat];
    
    
}



/**
 维度转换
 
 @param lonLat 需要转换的坐标
 @return 转换后的纬度
 */
-(float)transformlat:(NSString *_Nonnull) lonLat{
    
    
    NSArray *array = [lonLat componentsSeparatedByString:@","];
    
    double lng = [array[0] floatValue] - 105.0;
    double lat = [array[1] floatValue] - 35.0;
    
    float ret = -100.0 +2.0*lng + 3.0*lat +0.2*lat*lat + 0.1*lng*lat +0.2*sqrtf(fabs(lng));
    
    ret += (20.0 * sin(6.0 * lng * M_PI) + 20.0 * sin(2.0 * lat * M_PI)) * 2.0 / 3.0;
    ret += (20.0 * sin(lat * M_PI) + 40.0 * sin(lat / 3.0 * M_PI)) * 2.0 / 3.0;
    ret += (160.0 * sin(lat / 12.0 * M_PI) + 320 * sin(lat * M_PI / 30.0)) * 2.0 / 3.0;
    return ret;
}


/**
 经度度转换
 
 @param lonLat 需要转换的坐标
 @return 转换后的经度
 */
-(float)transformlng:(NSString *_Nonnull)lonLat{
    
    NSArray *array = [lonLat componentsSeparatedByString:@","];
    
    double lng = [array[0] floatValue] - 105.0;
    double lat = [array[1]  floatValue]- 35.0;
    
    double ret = 300.0 + lng + 2.0 * lat + 0.1 * lng * lat + 0.1 * lng * lat + 0.1 * sqrt(fabs(lng));
    ret += (20.0 * sin(6.0 * lng * M_PI) + 20.0 * sin(2.0 * lng * M_PI)) * 2.0 / 3.0;
    ret += (20.0 * sin(lat * M_PI) + 40.0 * sin(lng / 3.0 * M_PI)) * 2.0 / 3.0;
    ret += (150.0 * sin(lng / 12.0 * M_PI) + 300.0 * sin(lng / 30.0 * M_PI)) * 2.0 / 3.0;
    return ret;
}


@end
