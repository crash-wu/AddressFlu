//
//  Ws84ConvertToGDModel.h
//  AddressFlu
//
//  Created by 吴小星 on 2017/5/21.
//  Copyright © 2017年 crash. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <YYModel/YYModel.h>
#import <SGSHTTPModule/SGSHTTPModule.h>



/**
 高德WS84经纬度转换成高德坐标实体
 */
@interface Ws84ConvertToGDModel : NSObject<SGSResponseObjectSerializable>


/**
 经纬度坐标
 */
@property(nonatomic,strong,nonnull) NSString *locations;

@end
