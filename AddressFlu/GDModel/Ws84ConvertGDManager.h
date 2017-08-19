//
//  Ws84ConvertGDManager.h
//  AddressFlu
//
//  Created by 吴小星 on 2017/5/21.
//  Copyright © 2017年 crash. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Ws84ConvertGDManager : NSObject

/**
 WGS84转GCJ02(火星坐标系)
 
 @return 返回火星坐标系
 */
-(nullable NSString *)wgs84togcj02:(NSString *_Nonnull) lonLat;

@end
