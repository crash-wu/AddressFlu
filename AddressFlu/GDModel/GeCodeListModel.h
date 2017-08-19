//
//  GeCodeListModel.h
//  AddressFlu
//
//  Created by 吴小星 on 2017/5/27.
//  Copyright © 2017年 crash. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GeCodeModel.h"
#import <YYModel/YYModel.h>

@interface GeCodeListModel : NSObject


@property(nonnull,strong,nonatomic) GeCodeModel *codeModel;

@property(nonnull,strong,nonatomic) NSMutableArray<NSString *> *csvData;

@end
