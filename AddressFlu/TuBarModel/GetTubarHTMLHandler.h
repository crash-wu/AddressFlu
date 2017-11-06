//
//  GetTubarHTMLHandler.h
//  AddressFlu
//
//  Created by 吴小星 on 2017/6/7.
//  Copyright © 2017年 crash. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Ono/Ono.h>
#import "TubarHTMLModel.h"
#import <SVProgressHUD/SVProgressHUD.h>


/**
 解析图吧HTML数据(http://poi.mapbar.com/haerbin/D30/)
 */
@interface GetTubarHTMLHandler : NSObject



/**
 解析HTML数据
 
 @param url HTML网址
 */
-(void)analysisHTMLData:(NSString *_Nonnull) url success:(nonnull void (^)(NSMutableArray<TubarHTMLModel *> * _Nullable htmlModes)) success andFail:(nonnull void (^)(NSError *_Nullable error))fail;

@end
