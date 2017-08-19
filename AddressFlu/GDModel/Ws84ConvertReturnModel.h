//
//  Ws84ConvertReturnModel.h
//  AddressFlu
//
//  Created by 吴小星 on 2017/5/21.
//  Copyright © 2017年 crash. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Ws84ConvertToGDModel.h"

@interface Ws84ConvertReturnModel : NSObject

@property(nonatomic,strong,nonnull) Ws84ConvertToGDModel *convertModel;

@property(nonnull,strong,nonatomic) NSMutableArray *csvData;

@end
