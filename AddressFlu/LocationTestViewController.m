//
//  LocationTestViewController.m
//  AddressFlu
//
//  Created by 吴小星 on 2017/6/5.
//  Copyright © 2017年 crash. All rights reserved.
//

#import "LocationTestViewController.h"

@interface LocationTestViewController ()

/**
 CVS数据总共有几条
 */
@property(nonatomic,strong,nonnull) UILabel *totalLb;

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

@implementation LocationTestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
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
    
    self.bdLocationLb = [[UILabel alloc]init];
    [self.view addSubview:self.bdLocationLb];
    
    [self.bdLocationLb mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.totalLb.mas_bottom).with.offset(20);
        make.left.equalTo(self.view.mas_left).with.offset(20);
        make.height.equalTo(@[@30]);
        make.right.equalTo(self.view.mas_right).with.offset(-20);
    }];
    
    self.bdLocationLb.textAlignment = NSTextAlignmentLeft;
    self.bdLocationLb.textColor = [UIColor blackColor];
    
    self.bdLocation_errorlb = [[UILabel alloc]init];
    [self.view addSubview:self.bdLocation_errorlb];
    
    [self.bdLocation_errorlb mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.bdLocationLb.mas_bottom).with.offset(20);
        make.left.equalTo(self.view.mas_left).with.offset(20);
        make.height.equalTo(@[@30]);
        make.right.equalTo(self.view.mas_right).with.offset(-20);
    }];
    
    self.bdLocation_errorlb.textAlignment = NSTextAlignmentLeft;
    self.bdLocation_errorlb.textColor = [UIColor redColor];
    
    
    
    self.wgs84Lb = [[UILabel alloc]initWithFrame:CGRectZero];
    [self.view addSubview:self.wgs84Lb];
    [self.wgs84Lb mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.bdLocation_errorlb.mas_bottom).with.offset(20);
        make.left.equalTo(self.view.mas_left).with.offset(20);
        make.height.equalTo(@[@30]);
        make.right.equalTo(self.view.mas_right).with.offset(-20);
    }];
    
    self.wgs84Lb.textAlignment = NSTextAlignmentLeft;
    self.wgs84Lb.textColor = [UIColor blackColor];
    
    self.wgs84_errorlb = [[UILabel alloc]initWithFrame:CGRectZero];
    [self.view addSubview:self.wgs84_errorlb];
    [self.wgs84_errorlb mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.wgs84Lb.mas_bottom).with.offset(20);
        make.left.equalTo(self.view.mas_left).with.offset(20);
        make.height.equalTo(@[@30]);
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


-(void)rightBtn:(UIButton *)button{
    
    
    //创建csv文件，接收处理后的csv数据流
    NSString *filePath = [self createFile];
    //写入csv数据表头
    [self exportCSVHeader:filePath];
    
    self.textView.text = filePath;
    
    //读取本地csv 文件路径
    NSString *path = [[NSBundle mainBundle] pathForResource:@"xzq12" ofType:@"csv"];
    
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
        self.bdLocationLb.text = @"百度坐标转换:0";
        self.bdLocation_errorlb.text = @"百度坐标转换失败:0";
        
        self.wgs84Lb.text = @"wgs84坐标转换:0";
        self.wgs84_errorlb.text = @"wgs84坐标转换失败:0";
        
        for (int c = 1; c < [csvContent count]; c++) {
            
            //获取每一行csv数据流
            NSMutableArray *array = [csvContent objectAtIndex:c];
            
            
            if (array && array.count > 2) {
                NSString *lonlat = array[2];
                
                [self tranfromBD:lonlat andCSV:array andFile:filePath];
                
            }
            [parser closeFile];
        }
    }else{
        
        self.totalLb.text = @"数据总量:0";
        self.bdLocationLb.text = @"百度坐标转换:0";
        self.bdLocation_errorlb.text = @"百度坐标转换失败:0";
        
        self.wgs84Lb.text = @"wgs84坐标转换:0";
        self.wgs84_errorlb.text = @"wgs84坐标转换失败:0";
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
    
    [[BDCodeTransHandler alloc] bdLocationTran:lonlat andFrom:3  andCSVData:csv andSuccess:^(BDLocationTranReturnModel * _Nonnull bdLocationModel) {
        
        __strong typeof(&*self) strong  = weak;
        
        self.bdLocationLb.text = [NSString stringWithFormat:@"百度坐标转换:%ld",strong.bdcode];
        
        strong.bdcode ++;
        
        BDLocationTranModel *tranBDModel = bdLocationModel.locationMode;
        
        NSString *lonlat = [NSString stringWithFormat:@"%@,%@",tranBDModel.x,tranBDModel.y];
        
        NSMutableArray *bdcsvData = bdLocationModel.csvData;
        bdcsvData[3] = lonlat;

        

        //写csv文件
        [strong exportCSV:bdcsvData andFilePath:filePath];
        
    } andFail:^(NSMutableArray * _Nonnull csvData) {
        
        
//        //转换wgs坐标系
//        [self tranformWGS84:csvData[3] andCSV:csvData andFile:filePath];
        
        csvData[3] = csvData[2];
        //写csv文件
        [self exportCSV:csvData andFilePath:filePath];
        
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
        
        csvWgs[13]= lonlat;
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
    NSString *header = @"AREAID,NAME,COORD,baidu\r\n";
    
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
