//
//  BDLocationTranModel.h
//  AddressFlu
//
//  Created by 吴小星 on 2017/5/31.
//  Copyright © 2017年 crash. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <YYModel/YYModel.h>
#import <SGSHTTPModule/SGSHTTPModule.h>

@interface BDLocationTranModel : NSObject<SGSResponseCollectionSerializable>

/**
 x轴
 */
@property(nonnull,strong,nonatomic) NSString *x;


/**
 Y轴
 */
@property(nonatomic,strong,nonnull) NSString *y;

@end
