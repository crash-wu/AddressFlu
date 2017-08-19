//
//  BDRoutematrixReturnModel.h
//  AddressFlu
//
//  Created by 吴小星 on 2017/8/18.
//  Copyright © 2017年 crash. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BDRoutematrixReturnModel : NSObject

@property(nonatomic,strong,nonnull) NSMutableArray *csv;


/**
 最远距离
 */
@property(nonnull,strong,nonatomic)  NSString * maxDis;


/**
 最近距离
 */
@property(nonnull,strong,nonatomic) NSString * minDis;


/**
 平均距离
 */
@property(nonnull,strong,nonatomic) NSString * avDis;


@property(nonnull,strong,nonatomic) NSString * avTime;


@end
