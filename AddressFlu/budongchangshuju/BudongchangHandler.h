//
//  BudongchangHandler.h
//  AddressFlu
//
//  Created by 吴小星 on 2017/8/19.
//  Copyright © 2017年 crash. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "parseCSV.h"
#import <Masonry/Masonry.h>
#import "BDPOISearchHandler.h"
#import "BDRouteSearchHandler.h"
#import "BDRadiusSearchHandler.h"


typedef void(^Success)( NSMutableArray *_Nullable csv);

typedef void(^Fail)(NSMutableArray *_Nullable csv);

@interface BudongchangHandler : NSObject

-(void)bdPOISearch:(NSString *_Nonnull) keywork andCity:(NSString *_Nonnull) city andCSVData:(NSMutableArray *_Nonnull) csvData andFile:(NSString *_Nonnull)filePath success:(nullable void(^)(NSMutableArray *_Nullable csv))success fail:(nullable void(^) (NSMutableArray *_Nullable csv) )fail;

@end
