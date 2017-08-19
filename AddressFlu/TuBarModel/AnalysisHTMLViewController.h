//
//  AnalysisViewController.h
//  AddressFlu
//
//  Created by 吴小星 on 2017/6/7.
//  Copyright © 2017年 crash. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GDPOISearchHandler.h"
#import "GDLocationTranToBaiduLocationHandler.h"
#import "BDCodeTransHandler.h"
#import "Ws84convertToGDHandler.h"
#import "GDGetCodeHandler.h"
#import "GDPOIReturnModel.h"
#import "BDPOISearchHandler.h"


/**
 获取HTML数据
 */
@interface AnalysisHTMLViewController : UIViewController

/**
 城市名
 */
@property(nonatomic,nonnull,strong) NSString *city;


@property(nonnull,nonatomic,strong) NSString *cityName;




@end
