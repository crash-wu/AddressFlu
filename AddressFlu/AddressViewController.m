//
//  AddressViewController.m
//  AddressFlu
//
//  Created by 吴小星 on 2017/5/20.
//  Copyright © 2017年 crash. All rights reserved.
//

#import "AddressViewController.h"

@interface AddressViewController ()

/**
 CVS数据总共有几条
 */
@property(nonatomic,strong,nonnull) UILabel *totalLb;



/**
 逆地址编码
 */
@property(nonnull,strong,nonatomic) UILabel *conventerLb;



/**
 逆地址编码失败
 */
@property(nonatomic,strong,nonnull) UILabel *conventer_errorlb;


/**
 转换高德坐标
 */
@property(nonnull,strong,nonatomic) UILabel *wgsToGDLb;


/**
 wgs转换高德失败
 */
@property(nonnull,strong,nonatomic) UILabel *wgsToGD_errorlb;


/**
 百度坐标转换
 */
@property(nonnull,strong,nonatomic) UILabel *bdLocationLb;



/**
 百度坐标转换失败
 */
@property(nonnull,strong,nonatomic) UILabel *bdLocation_errorlb;



@property(nonatomic,strong,nonnull) UITextView *textView;


@property(nonnull,strong,nonatomic)dispatch_semaphore_t semaphore;




/**
 逆地址编码成功
 */
@property(nonatomic,assign) __block NSInteger code;


/**
 逆地址编码失败
 */
@property(nonatomic,assign) __block NSInteger code_error;


/**
 百度坐标转换成功
 */
@property(nonatomic,assign) __block NSInteger bdcode;


/**
 百度坐标转换成功失败
 */
@property(nonatomic,assign) __block NSInteger bdErrorCode;


/**
 wgs84坐标转换高德坐标成功
 */
@property(nonatomic,assign) __block NSInteger wgstoGDcode;


/**
 wgs84坐标转换高德坐标成功失败
 */
@property(nonatomic,assign) __block NSInteger wgstoGDcode_error;


@end

@implementation AddressViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    
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
    

    
    self.wgsToGDLb = [[UILabel alloc]init];
    [self.view addSubview:self.wgsToGDLb];
    
    [self.wgsToGDLb mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.totalLb.mas_bottom).with.offset(10);
        make.left.equalTo(self.view.mas_left).with.offset(20);
        make.height.equalTo(@[@20]);
        make.right.equalTo(self.view.mas_right).with.offset(-20);
    }];
    
    self.wgsToGDLb.textAlignment = NSTextAlignmentLeft;
    self.wgsToGDLb.textColor = [UIColor blackColor];
    
    self.wgsToGD_errorlb = [[UILabel alloc]init];
    [self.view addSubview:self.wgsToGD_errorlb];
    
    [self.wgsToGD_errorlb mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.wgsToGDLb.mas_bottom).with.offset(10);
        make.left.equalTo(self.view.mas_left).with.offset(20);
        make.height.equalTo(@[@20]);
        make.right.equalTo(self.view.mas_right).with.offset(-20);
    }];
    
    self.wgsToGDLb.textAlignment = NSTextAlignmentLeft;
    self.wgsToGDLb.textColor = [UIColor redColor];
    
    
    self.conventerLb = [[UILabel alloc]initWithFrame:CGRectZero];
    [self.view addSubview:self.conventerLb];
    [self.conventerLb mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.wgsToGD_errorlb.mas_bottom).with.offset(20);
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
    

    self.textView = [[UITextView alloc]initWithFrame:CGRectZero];
    [self.view addSubview:self.textView];
    
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.bdLocation_errorlb.mas_bottom).with.offset(20);
        make.left.equalTo(self.view.mas_left).with.offset(20);
        make.height.equalTo(@[@70]);
        make.right.equalTo(self.view.mas_right).with.offset(-20);
    }];
    
    
    self.totalLb.text = @"数据总行数:0";
    
    self.wgsToGDLb.text = @"转换高德坐标成功:0";
    self.wgsToGD_errorlb.text = @"转换高德坐标失败:0";
    
    self.conventerLb.text = @"逆地址编码:0";
    self.conventer_errorlb.text = @"逆地址查询失败：0";
    
    self.bdLocationLb.text = @"百度坐标转换:0";
    self.bdLocation_errorlb.text = @"百度坐标转换失败:0";
    
    
    
    self.code = 1;
    self.code_error = 1;
    
    self.bdcode = 1;
    self.bdErrorCode = 1;
    
    self.wgstoGDcode = 1;
    self.wgstoGDcode_error = 1;
    

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
    NSString *path = [[NSBundle mainBundle] pathForResource:@"工作表 1-表格 1" ofType:@"csv"];
    
    __weak typeof(&*self) weak = self;
    
    //读取csv文件数据流
    CSVParser *parser = [CSVParser new];
    [parser openFile: path];
    NSMutableArray *csvContent = [parser parseFile];
    
    //判断csv数据流数组长度，如果>0，则执行数据处理，否则结束
    if (csvContent.count > 0) {
        
        self.totalLb.text = [NSString stringWithFormat:@"数据总行:%ld",csvContent.count-1];

        for (int c = 1; c < [csvContent count]; c++) {
            
            //获取每一行csv数据流
            NSMutableArray *array = [csvContent objectAtIndex:c];
            
            if (array.count > 12) {
                
                
                //将ws84坐标转换成高德坐标(异步线程)
                [[Ws84convertToGDHandler alloc]ws84Convert:array[12] andcoordsys:@"gps" andCSVData:array andSuccess:^(Ws84ConvertReturnModel * _Nonnull convertModel) {
                    
                    //改变已经执行坐标转换的数据条目提示文本信息
                    self.wgsToGDLb.text = [NSString stringWithFormat:@"高德坐标转换成功:%ld",weak.wgstoGDcode];
                    
                    weak.wgstoGDcode ++;
                    Ws84ConvertToGDModel *ws84Model = convertModel.convertModel;
                    
                    convertModel.csvData[3] = ws84Model.locations;

                    //坐标转换线程与高德逆地址编码线程为两种类型的异步线程，执行的先后顺序不确定，因此必须确保数据传递过程的准确性
                    [[GDGetCodeHandler alloc]getCode:ws84Model.locations andCSVData:convertModel.csvData andSuccess:^(SaveCSVDataModel * _Nonnull saveCSVDataModel) {
                    
                        __strong typeof(&*self) strong  = weak;
                        
                        //改变已经过滤的数据条目提示文本信息
                        strong.conventerLb.text = [NSString stringWithFormat:@"逆地址编码:%ld",strong.code];
                        strong.code ++;
                        
                        SaveCSVDataModel *csvDataModel = saveCSVDataModel;
                        
                        //csv行数据
                        NSMutableArray *csv = csvDataModel.csvData;
                        
                        //逆地址编码数据实体
                        GDGetCodeModel *codeModel = saveCSVDataModel.codeMoel;
                        AddressComponentModel *model = codeModel.addressComponent;

                        //处理省份数据
                        if (model.province) {
                            csv[4] = model.province;
                        }else{
                            csv[4] = @"";
                        }
                        
                        //处理市数据
                        if (model.city) {
                            csv[5] = model.city;
                        }else{
                            csv[5] = @"";
                        }
                        
                        //区/县数据
                        if (model.district) {
                            csv[6] = model.district;
                        }else{
                            csv[6] = @"";;
                        }
                        
                        
                        //乡/镇数据
                        if (model.township) {
                            csv[7] = model.township;
                        }else{
                            csv[7] = @"";
                        }
                        
                        
                        //详细的地址数据
                        if (codeModel.formatted_address) {
                            csv[8] = codeModel.formatted_address;
                        }else{
                            csv[8] = @"";
                        }
                        //百度坐标转换
                        [self tranfromBD:csv[12] andCSV:csv andFile:filePath];
                        
                    } andFail:^(NSError * _Nonnull error) {
                        
                    }];
                    
                } andFail:^(NSError * _Nonnull error) {
                    
                }];
            }
        }
        [parser closeFile];
    }else{
        
    }
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
                
        [self exportCSV:bdcsvData andFilePath:filePath];
        
        
    } andFail:^(NSMutableArray * _Nonnull csvData) {
        

        [self exportCSV:csvData andFilePath:filePath];
        self.bdLocation_errorlb.text = [NSString stringWithFormat:@"百度坐标转换失败:%ld",self.bdErrorCode];
        self.bdErrorCode ++;
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
    NSString *header = @"name,address,location-bd,location-gd,pname-gd,cname-gd,dname-gd,vname-gd,adrress-gd,status,fitler,fitler-grade,location\r\n";
    
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

            //处理经纬度字符串
            csvString = [NSString stringWithFormat:@"%@,\"%@\"", csvString,csv];
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
