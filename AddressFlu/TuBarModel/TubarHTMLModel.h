//
//  TubarHTMLModel.h
//  AddressFlu
//
//  Created by 吴小星 on 2017/6/7.
//  Copyright © 2017年 crash. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Ono/Ono.h>


/**
 获取图吧数据
 */
@interface TubarHTMLModel : NSObject


@property(nonnull,strong,nonatomic) NSString *url;


/**
 药店名称
 */
@property(nonatomic,strong,nonnull) NSString *name;



@property(nonatomic,strong,nonnull) NSString *location;


@end
