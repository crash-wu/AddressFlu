//
//  CodeViewController.m
//  AddressFlu
//
//  Created by 吴小星 on 2017/5/27.
//  Copyright © 2017年 crash. All rights reserved.
//

#import "CodeViewController.h"

@interface CodeViewController ()


/**
 CVS数据总共有几条
 */
@property(nonatomic,strong,nonnull) UILabel *totalLb;


/**
 获取经纬度
 */
@property(nonnull,strong,nonatomic) UILabel *overLb;



/**
 获取经纬度失败
 */
@property(nonnull,strong,nonatomic) UILabel *over_errorlb;


/**
 逆地址编码
 */
@property(nonnull,strong,nonatomic) UILabel *conventerLb;



/**
 逆地址编码失败
 */
@property(nonatomic,strong,nonnull) UILabel *conventer_errorlb;


/**
 药店
 */
@property(nonnull,strong,nonatomic) UILabel *shopLb;



/**
 百度坐标转换
 */
@property(nonnull,strong,nonatomic) UILabel *bdLocationLb;



/**
 百度坐标转换失败
 */
@property(nonnull,strong,nonatomic) UILabel *bdLocation_errorlb;


/**
 wgs84坐标转换
 */
@property(nonnull,strong,nonatomic) UILabel *wgs84Lb;



/**
 wgs84坐标转换失败
 */
@property(nonatomic,strong,nonnull) UILabel *wgs84_errorlb;


@property(nonatomic,strong,nonnull) UITextView *textView;


@property(nonnull,strong,nonatomic)dispatch_semaphore_t semaphore;


/**
 获取经纬度成功
 */
@property(nonatomic,assign) __block NSInteger getLonlatNuber;


/**
 获取经纬度失败
 */
@property(nonatomic,assign) __block NSInteger getLonlaterr;


/**
 逆地址编码成功
 */
@property(nonatomic,assign) __block NSInteger code;


/**
 逆地址编码失败
 */
@property(nonatomic,assign) __block NSInteger code_error;


@property(nonatomic,assign) __block NSInteger shop;

/**
 百度坐标转换成功
 */
@property(nonatomic,assign) __block NSInteger bdcode;


/**
 百度坐标转换成功失败
 */
@property(nonatomic,assign) __block NSInteger bdErrorCode;


/**
 wgs84坐标转换成功
 */
@property(nonatomic,assign) __block NSInteger wgs84code;


/**
 wgs84坐标转换成功失败
 */
@property(nonatomic,assign) __block NSInteger wgs84code_error;


@end

@implementation CodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.getLonlatNuber = 0;
    self.shop = 1;
    self.getLonlaterr = 1;
    self.code_error = 1;
    
    
    self.bdcode = 1;
    
    self.bdErrorCode = 1;
    
    self.wgs84code = 1;
    self.wgs84code_error = 1;
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.automaticallyAdjustsScrollViewInsets = true;
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    UIBarButtonItem *rightBarBtn = [[UIBarButtonItem alloc]initWithTitle:@"开始读取" style:UIBarButtonItemStylePlain  target:self action:@selector(rightBtn:)];
    
    
    self.navigationItem.rightBarButtonItem = rightBarBtn;
    
    self.totalLb = [[UILabel alloc]init];
    [self.view addSubview:self.totalLb];
    
    [self.totalLb mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.view.mas_top).with.offset(20);
        make.left.equalTo(self.view.mas_left).with.offset(20);
        make.height.equalTo(@[@30]);
        make.right.equalTo(self.view.mas_right).with.offset(-20);
    }];
    
    self.totalLb.textAlignment = NSTextAlignmentLeft;
    
    self.totalLb.textColor = [UIColor blackColor];
    
    self.overLb = [[UILabel alloc]init];
    [self.view addSubview:self.overLb];
    
    [self.overLb mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.totalLb.mas_bottom).with.offset(20);
        make.left.equalTo(self.view.mas_left).with.offset(20);
        make.height.equalTo(@[@20]);
        make.right.equalTo(self.view.mas_right).with.offset(-20);
    }];
    
    self.overLb.textAlignment = NSTextAlignmentLeft;
    self.overLb.textColor = [UIColor blackColor];
    
    self.over_errorlb = [[UILabel alloc]init];
    [self.view addSubview:self.over_errorlb];
    
    [self.over_errorlb mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.overLb.mas_bottom).with.offset(10);
        make.left.equalTo(self.view.mas_left).with.offset(20);
        make.height.equalTo(@[@20]);
        make.right.equalTo(self.view.mas_right).with.offset(-20);
    }];
    
    self.over_errorlb.textAlignment = NSTextAlignmentLeft;
    self.over_errorlb.textColor = [UIColor redColor];
    
    self.shopLb = [[UILabel alloc]init];
    [self.view addSubview:self.shopLb];
    
    [self.shopLb mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.over_errorlb.mas_bottom).with.offset(10);
        make.left.equalTo(self.view.mas_left).with.offset(20);
        make.height.equalTo(@[@20]);
        make.right.equalTo(self.view.mas_right).with.offset(-20);
    }];
    
    self.shopLb.textAlignment = NSTextAlignmentLeft;
    self.shopLb.textColor = [UIColor blackColor];
    
    self.conventerLb = [[UILabel alloc]initWithFrame:CGRectZero];
    [self.view addSubview:self.conventerLb];
    [self.conventerLb mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.shopLb.mas_bottom).with.offset(20);
        make.left.equalTo(self.view.mas_left).with.offset(20);
        make.height.equalTo(@[@30]);
        make.right.equalTo(self.view.mas_right).with.offset(-20);
    }];
    
    self.conventerLb.textAlignment = NSTextAlignmentLeft;
    self.conventerLb.textColor = [UIColor blackColor];
    
    self.conventer_errorlb = [[UILabel alloc]initWithFrame:CGRectZero];
    [self.view addSubview:self.conventer_errorlb];
    [self.conventer_errorlb mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.conventerLb.mas_bottom).with.offset(20);
        make.left.equalTo(self.view.mas_left).with.offset(20);
        make.height.equalTo(@[@30]);
        make.right.equalTo(self.view.mas_right).with.offset(-20);
    }];
    
    self.conventer_errorlb.textAlignment = NSTextAlignmentLeft;
    self.conventer_errorlb.textColor = [UIColor redColor];
    
    self.bdLocationLb = [[UILabel alloc]init];
    [self.view addSubview:self.bdLocationLb];
    
    [self.bdLocationLb mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.conventer_errorlb.mas_bottom).with.offset(10);
        make.left.equalTo(self.view.mas_left).with.offset(20);
        make.height.equalTo(@[@20]);
        make.right.equalTo(self.view.mas_right).with.offset(-20);
    }];
    
    self.bdLocationLb.textAlignment = NSTextAlignmentLeft;
    self.bdLocationLb.textColor = [UIColor blackColor];
    
    self.bdLocation_errorlb = [[UILabel alloc]init];
    [self.view addSubview:self.bdLocation_errorlb];
    
    [self.bdLocation_errorlb mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.bdLocationLb.mas_bottom).with.offset(10);
        make.left.equalTo(self.view.mas_left).with.offset(20);
        make.height.equalTo(@[@20]);
        make.right.equalTo(self.view.mas_right).with.offset(-20);
    }];
    
    self.bdLocation_errorlb.textAlignment = NSTextAlignmentLeft;
    self.bdLocation_errorlb.textColor = [UIColor redColor];
    
    self.wgs84Lb = [[UILabel alloc]initWithFrame:CGRectZero];
    [self.view addSubview:self.wgs84Lb];
    [self.wgs84Lb mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.bdLocation_errorlb.mas_bottom).with.offset(10);
        make.left.equalTo(self.view.mas_left).with.offset(20);
        make.height.equalTo(@[@20]);
        make.right.equalTo(self.view.mas_right).with.offset(-20);
    }];
    
    self.wgs84Lb.textAlignment = NSTextAlignmentLeft;
    self.wgs84Lb.textColor = [UIColor blackColor];
    
    self.wgs84_errorlb = [[UILabel alloc]initWithFrame:CGRectZero];
    [self.view addSubview:self.wgs84_errorlb];
    [self.wgs84_errorlb mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.wgs84Lb.mas_bottom).with.offset(10);
        make.left.equalTo(self.view.mas_left).with.offset(20);
        make.height.equalTo(@[@20]);
        make.right.equalTo(self.view.mas_right).with.offset(-20);
    }];
    
    self.wgs84_errorlb.textAlignment = NSTextAlignmentLeft;
    self.wgs84_errorlb.textColor = [UIColor redColor];
    
    
    self.textView = [[UITextView alloc]initWithFrame:CGRectZero];
    [self.view addSubview:self.textView];
    
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.wgs84_errorlb.mas_bottom).with.offset(20);
        make.left.equalTo(self.view.mas_left).with.offset(20);
        make.height.equalTo(@[@70]);
        make.right.equalTo(self.view.mas_right).with.offset(-20);
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


/**
 执行csv文件数据处理按键（导航栏右边按键）
 */
-(void)rightBtn:(UIButton *)button{
    
    //创建csv文件，接收处理后的csv数据流
    NSString *filePath = [self createFile];
    //写入csv数据表头
    [self exportCSVHeader:filePath];
    
    self.textView.text = filePath;
    
    //读取本地csv 文件路径
    NSString *path = [[NSBundle mainBundle] pathForResource:@"黑龙江省药店-补充" ofType:@"csv"];
    
    //初始化线程锁信号量
    self.semaphore = dispatch_semaphore_create(1);
    __weak typeof(&*self) weak = self;
    
    //读取csv文件数据流
    CSVParser *parser = [CSVParser new];
    [parser openFile: path];
    NSMutableArray *csvContent = [parser parseFile];
    
    //判断csv数据流数组长度，如果>0，则执行数据处理，否则结束
    if (csvContent.count > 0) {
        
        self.totalLb.text = [NSString stringWithFormat:@"数据总行:%ld",csvContent.count-1];
        self.overLb.text = @"已经获取经纬度:0";
        self.conventerLb.text = @"逆地址编码:0";
        self.shopLb.text = @"药店名查询:0";
        self.conventer_errorlb.text = @"逆地址查询失败：0";
        self.over_errorlb.text = @"获取经纬度失败:0";
        
        self.bdLocationLb.text = @"百度坐标转换:0";
        self.bdLocation_errorlb.text = @"百度坐标转换失败:0";
        
        self.wgs84Lb.text = @"wgs84坐标转换:0";
        self.wgs84_errorlb.text = @"wgs84坐标转换失败:0";
        
        self.code = 1;
        
        for (int c = 1; c < [csvContent count]; c++) {
            
            //获取每一行csv数据流
            NSMutableArray *array = [csvContent objectAtIndex:c];
            
            if (array.count > 2 && ![array[0] isEqualToString:@""]) {
                
                //添加线程锁信号量
              //  dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
                
                //查询地址名称
                //先查询医药名称，医药名称查询不到，再查询医药地址，因为医药名称查询的精度级别比较高
                [[GDCodeHandler alloc] gecodeAddress:array[1] andCity:nil andCSVData:array andSuccess:^(GeCodeListModel * _Nonnull codeModel) {
                    
                    __strong typeof(&*self) strong = weak;
                    //改变已经过滤的数据条目提示文本信息
                    strong.overLb.text = [NSString stringWithFormat:@"已经获取经纬度:%ld",strong.getLonlatNuber+1];
                    strong.getLonlatNuber ++;
                    GeCodeModel *model = codeModel.codeModel;
                    
                    if (model.location) {
                        //开始执行高德逆地址编码(异步线程)
                        //坐标转换线程与高德逆地址编码线程为两种类型的异步线程，执行的先后顺序不确定，因此必须确保数据传递过程的准确性
                        NSMutableArray *arrayTemp = codeModel.csvData;
                        arrayTemp[3] = model.location;
                        
                        [weak opposite:model.location andCSVdata:arrayTemp andFilePath:filePath];
                        
                    }
                } andFail:^(NSMutableArray *_Nullable csvData) {
                    
                    [[GDCodeHandler alloc] gecodeAddress:array[0] andCity:nil andCSVData:csvData andSuccess:^(GeCodeListModel * _Nonnull codeModel) {
                        
                        __strong typeof(&*self) strong = weak;
                        //改变已经过滤的数据条目提示文本信息
                        strong.overLb.text = [NSString stringWithFormat:@"已经获取经纬度:%ld",strong.getLonlatNuber+1];
                        strong.getLonlatNuber ++;
                        GeCodeModel *model = codeModel.codeModel;
                        
                        if (model.location) {
                            //坐标转换线程与高德逆地址编码线程为两种类型的异步线程，执行的先后顺序不确定，因此必须确保数据传递过程的准确性
                            NSMutableArray *arrayTemp = codeModel.csvData;
                            arrayTemp[3] = model.location;
                            
                            [weak opposite:model.location andCSVdata:arrayTemp andFilePath:filePath];
                            
                        }
                        
                    } andFail:^(NSMutableArray * _Nullable csvData) {
                        
                        //写csv文件
                        [self exportCSV:csvData andFilePath:filePath];
                        self.over_errorlb.text = [NSString stringWithFormat:@"已经获取经纬度失败:%ld",self.getLonlaterr];
                        self.getLonlaterr ++;
                        
                    }];
                    
                }];
                
                //解除线程锁信号量
               // dispatch_semaphore_signal(self.semaphore);
            }
        }
        [parser closeFile];
    }else{
        
        self.totalLb.text = @"数据总量:0";
        self.overLb.text = @"已经过滤:0";
        self.conventerLb.text = @"坐标转换:0";
    }
}

/**
 逆地址编码处理

 @param location 坐标
 @param csvData CSV数据
 */
-(void)opposite:(NSString *_Nonnull) location andCSVdata:(NSMutableArray *_Nonnull)csvData andFilePath:(NSString *_Nonnull) filePath{

        //开始执行高德逆地址编码(异步线程)
        //坐标转换线程与高德逆地址编码线程为两种类型的异步线程，执行的先后顺序不确定，因此必须确保数据传递过程的准确性
        __weak typeof(&*self) weak = self;
    
        [[GDGetCodeHandler alloc]getCode:location andCSVData:csvData andSuccess:^(SaveCSVDataModel * _Nonnull saveCSVDataModel) {
            
            __strong typeof(&*self) strong  = weak;
            
            //改变已经过滤的数据条目提示文本信息
            strong.conventerLb.text = [NSString stringWithFormat:@"逆地址编码:%ld",strong.code];
            strong.code ++;
            
            //逆地址编码数据实体
            GDGetCodeModel *codeModel = saveCSVDataModel.codeMoel;
            AddressComponentModel *addressModel = codeModel.addressComponent;
            
            if (addressModel.province) {
                saveCSVDataModel.csvData[4] = addressModel.province;
            }else{
                saveCSVDataModel.csvData[4] = @"";
            }
            
            if (addressModel.city) {
                saveCSVDataModel.csvData[5] = addressModel.city;
            }else{
                
                saveCSVDataModel.csvData[5] = @"";
            }
            
            if (addressModel.district) {
                saveCSVDataModel.csvData[6] = addressModel.district;
            }else{
                saveCSVDataModel.csvData[6] = @"";
            }
            
            if (addressModel.township) {
                saveCSVDataModel.csvData[7] = addressModel.township;
            }else{
                saveCSVDataModel.csvData[7] = @"";
            }
            
            if (codeModel.formatted_address) {
                saveCSVDataModel.csvData[8] = codeModel.formatted_address;
            }else{
                saveCSVDataModel.csvData[8] = @"";
            }
            
            
            NSString *city = nil;
            
            //判断乡镇名称是否存在
            if (saveCSVDataModel.csvData[7] ) {
                
                //获取乡镇
                NSString *town = saveCSVDataModel.csvData[7];
                
                if (![town isEqualToString:@""]) {
                    
                    city = city;
                }
            }else{
                //不存在，则获取区/县
                city = saveCSVDataModel.csvData[6];
            }
            
            //查询药店名称存在不
            [[GDCodeHandler alloc] gecodeAddress:saveCSVDataModel.csvData[0] andCity:city andCSVData:saveCSVDataModel.csvData andSuccess:^(GeCodeListModel * _Nonnull codeModel) {
                
                NSMutableArray *temp = codeModel.csvData;
                
                GeCodeModel *model = codeModel.codeModel;
                if ([model.level isEqualToString:@"兴趣点"]) {
                    temp[9] = @"1";
                    temp[3] = model.location;
                    
                }else{
                    temp[9] = @"0";
                }

                //写csv文件
               // [strong exportCSV:temp andFilePath:filePath];
                
                strong.shopLb.text = [NSString stringWithFormat:@"药店名查询:%ld",strong.shop];
                strong.shop ++;
                
                if (temp && temp.count > 3){
                    
                    [strong tranfromBD:temp[3] andCSV:temp andFile:filePath];
                }
                
                
            } andFail:^(NSMutableArray *_Nullable csvData) {
                
                csvData[9] = @"0";
                //写csv文件
               // [strong exportCSV:csvData andFilePath:filePath];
                strong.shopLb.text = [NSString stringWithFormat:@"药店名查询:%ld",strong.shop];
                strong.shop ++;
                
                if (csvData && csvData.count > 3){
                    
                    [strong tranfromBD:csvData[3] andCSV:csvData andFile:filePath];
                }
                
            }];
            
        } andFail:^(NSError * _Nonnull error) {
            
            self.conventer_errorlb.text = [NSString stringWithFormat:@"逆地址编码失败:%ld",self.code_error];
            self.code_error ++;
            
        }];
}


/**
 转换百度坐标
 
 @param lonlat 坐标转换
 @param csv csv数据
 @param filePath 保存路径
 */
-(void)tranfromBD:(NSString *_Nonnull) lonlat andCSV:(NSMutableArray *_Nonnull)csv andFile:(NSString *_Nonnull)filePath{
    
    __weak typeof(&*self) weak = self;
    
    [[BDCodeTransHandler alloc] bdLocationTran:lonlat andFrom:3 andCSVData:csv andSuccess:^(BDLocationTranReturnModel * _Nonnull bdLocationModel) {
        
        __strong typeof(&*self) strong  = weak;
        
        self.bdLocationLb.text = [NSString stringWithFormat:@"百度坐标转换:%ld",strong.bdcode];
        
        strong.bdcode ++;
        
        BDLocationTranModel *tranBDModel = bdLocationModel.locationMode;
        
        NSString *lonlat = [NSString stringWithFormat:@"%@,%@",tranBDModel.x,tranBDModel.y];
        
        NSMutableArray *bdcsvData = bdLocationModel.csvData;
        bdcsvData[2] = lonlat;
        
        NSString *lonlatd = bdcsvData[3];
        
        [strong tranformWGS84:bdcsvData[3] andCSV:bdcsvData andFile:filePath];
        
        
    } andFail:^(NSMutableArray * _Nonnull csvData) {
        
        
        //转换wgs坐标系
        [self tranformWGS84:csvData[3] andCSV:csvData andFile:filePath];
        
        self.bdLocation_errorlb.text = [NSString stringWithFormat:@"wgs84坐标转换失败:%ld",self.bdErrorCode];
        self.bdErrorCode ++;
    }];
    
}

/**
 高德坐标转换wgs84
 
 @param lonlat 经纬度
 @param csv csv数据
 @param filePath 保存路径
 */
-(void)tranformWGS84:(NSString *_Nonnull) lonlat andCSV:(NSMutableArray *_Nonnull)csv andFile:(NSString *_Nonnull)filePath{
    
    
    __weak typeof(&*self) weak = self;
    [[GDLocationTranToBaiduLocationHandler alloc] spgtranlocation:lonlat andCSVData:csv andSuccess:^(GPSspgTranforReturnModel * _Nonnull codeModel) {
        
        __strong typeof(&*self) strong = weak;
        
        strong.wgs84Lb.text = [NSString stringWithFormat:@"wgs84坐标转换:%ld",strong.wgs84code];
        strong.wgs84code ++;
        
        NSMutableArray *csvWgs = codeModel.csvData;
        
        GPSspgModel *spgModel = codeModel.spgModel;
        
        NSString *lonlat = [NSString stringWithFormat:@"%@,%@",spgModel.lng,spgModel.lat];
        
        csvWgs[12]= lonlat;
        //写csv文件
        [strong exportCSV:csvWgs andFilePath:filePath];
        
    } andFail:^(NSMutableArray * _Nullable csvData) {
        
        __strong typeof(&*self) strong = weak;
        
        //写csv文件
        [self exportCSV:csvData andFilePath:filePath];
        
        strong.wgs84_errorlb.text = [NSString stringWithFormat:@"wgs84坐标转换:%ld",strong.wgs84code_error];
        strong.wgs84code_error ++;
        
    }];
}




/**
 创建文件
 
 @return 所创建的文件在沙盒中的路径
 */
- (NSString *_Nonnull)createFile{
    
    //将处理好的csv数据流写入到沙盒中的Documents目录
    // 获取Documents目录路径
    NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    
    
    //获取完整的写入文件路径
    NSString *filePath = [docDir stringByAppendingPathComponent:@"address.csv"];
    NSLog(@"filePath = %@", filePath);
    
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    //创建文件
    if (![fileManager createFileAtPath:filePath contents:nil attributes:nil]) {
        NSLog(@"不能创建文件");
    }
    return  filePath;
}



/**
 写入表头
 
 @param filePath 写入文件的路径
 */
-(void)exportCSVHeader:(NSString *)filePath{
    
    //创建文件流写入对象
    NSOutputStream *output = [[NSOutputStream alloc] initToFileAtPath:filePath append:YES];
    
    //开启文件流写入
    [output open];
    
    //表头数据
    NSString *header = @"name,address,location-bd,location-gd,pname,cname,dname,vname,adrress-gd,status,fitler,fitler-grade,location\r\n";
    
    //流编码处理
    const uint8_t *headerString = (const uint8_t *)[header cStringUsingEncoding:NSUTF8StringEncoding];
    
    NSInteger headerLength = [header lengthOfBytesUsingEncoding:NSUTF8StringEncoding];
    
    //写入数据
    NSInteger result = [output write:headerString maxLength:headerLength];
    if (result <= 0) {
        NSLog(@"写入错误");
    }
    
    //关闭文件流
    [output close];
}



/**
 写入CVS 数据
 
 @param csvData csv数据数据(列数据)
 @param filePath 写入文件路径
 */
- (void)exportCSV:(NSArray<NSString *> *)csvData andFilePath:(NSString *_Nonnull)filePath{
    
    
    NSOutputStream *output = [[NSOutputStream alloc] initToFileAtPath:filePath append:YES];
    [output open];
    
    
    if (![output hasSpaceAvailable]) {
        NSLog(@"没有足够可用空间");
    } else {
        
        NSString *csvString = @"";
        
        int i = 0;
        for (NSString *csv in csvData) {
            
            if (i == 3 || i == 2 || i== 12 || i == 1) {
                //处理经纬度字符串
                csvString = [NSString stringWithFormat:@"%@,\"%@\"", csvString,csv];
                
            }else{
                csvString = [NSString stringWithFormat:@"%@,%@", csvString,csv];
            }
            i ++;
            
        }
        
        csvString =   [csvString substringWithRange:NSMakeRange(1,csvString.length -1)];
        csvString = [NSString stringWithFormat:@"%@\r\n",csvString];
        
        const uint8_t *rowString = (const uint8_t *)[csvString cStringUsingEncoding:NSUTF8StringEncoding];
        NSInteger rowLength = [csvString lengthOfBytesUsingEncoding:NSUTF8StringEncoding];
        NSInteger result = [output write:rowString maxLength:rowLength];
        if (result <= 0) {
            NSLog(@"无法写入内容");
        }
        
        [output close];
        
    }
}




@end
