//
//  SaveCSVDataModel.h
//  AddressFlu
//
//  Created by 吴小星 on 2017/5/21.
//  Copyright © 2017年 crash. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GDGetCodeModel.h"

@interface SaveCSVDataModel : NSObject

@property(nonatomic,strong,nonnull) GDGetCodeModel *codeMoel;

@property(nonnull,strong,nonatomic) NSMutableArray *csvData;

@end
