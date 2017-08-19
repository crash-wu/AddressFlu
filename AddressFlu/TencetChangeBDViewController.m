//
//  TencetChangeBDViewController.m
//  AddressFlu
//
//  Created by 吴小星 on 2017/7/17.
//  Copyright © 2017年 crash. All rights reserved.
//

#import "TencetChangeBDViewController.h"

@interface TencetChangeBDViewController ()

@property(nonatomic,strong,nonnull) UITextField *lon;

@property(nonatomic,strong,nonnull) UITextField *lat;


@property(nonatomic,strong,nonnull) UIButton *btn;

@end

@implementation TencetChangeBDViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.automaticallyAdjustsScrollViewInsets = true;
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.lon = [[UITextField alloc]initWithFrame:CGRectZero];
    [self.view addSubview:self.lon];
    
    [self.lon mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.view.mas_top).with.offset(20);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.height.equalTo(@[@20]);
    }];
    
    self.lon.placeholder = @"lon";
    
    self.lat = [[UITextField alloc]initWithFrame:CGRectZero];
    [self.view addSubview:self.lat];
    [self.lat mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.lon.mas_bottom).with.offset(20);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.height.equalTo(@[@20]);
    }];
    
    self.lat.placeholder = @"lat";
    
    
    self.btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:self.btn];
    [self.btn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.lat.mas_bottom).with.offset(20);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.height.equalTo(@[@20]);
    }];
    [self.btn setTitle:@"确定" forState:UIControlStateNormal];
    
    [self.btn addTarget:self action:@selector(touch :) forControlEvents:UIControlEventTouchUpInside];
    [self.btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    
}


-(void)touch:(UIButton*)button{
    
    //[self bd_encrypt:[self.lat.text  floatValue] andLon:[self.lon.text floatValue]];
    [self ten_bd:[self.lat.text floatValue] andLon:[self.lon.text floatValue]];
}


/**
 腾讯地图坐标转换百度地图坐标

 @param lat <#lat description#>
 @param lon <#lon description#>
 */
-(void) bd_encrypt:(float)lat andLon:(float) lon{
    
    float x_pi = 3.14159265358979324 * 3000.0 / 180.0;
    float x = lon;
    float y = lat;
    
    float z = sqrtf(x *x +y *y) + 0.00002 *sinf(y *x_pi);
    float theta = atan2f(y, x) + 0.000003 * cosf(x * x_pi);
    
    float longitude = z *cosf(theta) + 0.0065;
    float latitude = z * sinf(theta) + 0.006;
    
    NSLog(@"longitude:%lf",longitude);
    NSLog(@"lat:%lf",latitude);
}



/**
 百度转腾讯

 @param lat <#lat description#>
 @param lon <#lon description#>
 */
-(void)ten_bd:(float) lat andLon:(float) lon{

        double tx_lat;
        double tx_lon;
        double x_pi=3.14159265358979324 * 3000.0 /180.0;
        double x = lon - 0.0065, y = lat - 0.006;
        double z = sqrtf(x * x + y * y) - 0.00002 * sinf(y * x_pi);
        double theta = atan2(y, x) - 0.000003 * cosf(x * x_pi);
        tx_lon = z * cosf(theta);
        tx_lat = z * sinf(theta);
    
    NSLog(@"lon:%ld,lat:%ld",tx_lon,tx_lat);
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
