//
//  AnalysisTableViewController.h
//  AddressFlu
//
//  Created by 吴小星 on 2017/6/8.
//  Copyright © 2017年 crash. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Masonry/Masonry.h>
#import "AnalysisHTMLViewController.h"

@interface AnalysisTableViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>


@property(nonatomic,strong,nonnull) UITableView *tableView;


@end
