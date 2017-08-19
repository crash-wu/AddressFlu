//
//  FindCentLocationViewController.m
//  AddressFlu
//
//  Created by 吴小星 on 2017/7/6.
//  Copyright © 2017年 crash. All rights reserved.
//

#import "FindCentLocationViewController.h"

@interface FindCentLocationViewController ()


/**
 区县总数
 */
@property(nonnull,strong,nonatomic) UILabel *totalLb;


/**
 以及完成读写的区县
 */
@property(nonnull,strong,nonatomic) UILabel *writeLb;


/**
 区县总数
 */
@property(nonatomic,assign) NSInteger total;


/**
 完成读写的区县数量
 */
@property(nonatomic,assign) NSInteger write;



@end

@implementation FindCentLocationViewController

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
    
    
    self.writeLb = [[UILabel alloc]initWithFrame:CGRectZero];
    [self.view addSubview:self.writeLb];
    [self.writeLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.totalLb.mas_bottom).with.offset(20);
        make.left.equalTo(self.view.mas_left).with.offset(20);
        make.height.equalTo(@[@30]);
        make.right.equalTo(self.view.mas_right).with.offset(-20);
        
    }];
    
    self.writeLb.textAlignment = NSTextAlignmentLeft;
    self.writeLb.textColor = [UIColor blackColor];
    self.write = 1;
}


/**
 执行csv文件数据处理按键（导航栏右边按键）
 */
-(void)rightBtn:(UIButton *)button{
    
    //创建csv文件，接收处理后的csv数据流
    NSString *filePath = [self createFile];
    //写入csv数据表头
    [self exportCSVHeader:filePath];
    
    
    
    //读取本地csv 文件路径
    NSString *path = [[NSBundle mainBundle] pathForResource:@"高德地图API 城市编码对照表" ofType:@"csv"];
    
    //读取csv文件数据流
    CSVParser *parser = [CSVParser new];
    [parser openFile: path];
    NSMutableArray *csvContent = [parser parseFile];
    

    
    //判断csv数据流数组长度，如果>0，则执行数据处理，否则结束
    if (csvContent.count > 0) {
        self.totalLb.text = [NSString stringWithFormat:@"区／县数量总数:%ld",csvContent.count -1];
        
        for (int i = 1;  i < csvContent.count; i++) {
            
            NSMutableArray *csv = csvContent[i];
            
            __weak typeof(&*self) weak = self;
            
            if (  csv.count > 5 && csv[5]) {

                [[FindCountyHandler alloc] getCountyCenterLocation:csv[5] andCSV:csv andSuccess:^(FindCountyReturnModel * _Nonnull codeModel) {
                    
                    __strong typeof(&*self) strong = weak;
                    
                    NSArray<DistrictModel *> *dis = codeModel.district;
                    
                    for (DistrictModel *model in dis ) {
                        
                        NSMutableArray *csVBDData = [NSMutableArray array];
                        
                        if (codeModel.csvData[0]) {
                            csVBDData[0] = codeModel.csvData[0];
                        }else{
                            csVBDData[0] = @"";
                            
                        }
                        
                        if (codeModel.csvData[1]) {
                            csVBDData[1] = codeModel.csvData[1];
                        }else{
                            csVBDData[1] = @"";
                            
                        }
                        
//                        csVBDData[0] = codeModel.csvData[0];
//                        csVBDData[1] = codeModel.csvData[1];
                        
                        if (model.name) {
                            csVBDData[2] = model.name;
                        }else{
                            csVBDData[2] = @"";
                            
                        }
                        
                        if (model.center) {
                            csVBDData[3] = model.center;
                        }else{
                            csVBDData[3] = @"";
                            
                        }
                        
                        if (model.adcode) {
                            csVBDData[4] = model.adcode;
                        }else{
                            csVBDData[4] = @"";
                            
                        }
                        
//                        csVBDData[2] = model.name;
//                        csVBDData[3] = model.center;
//                        csVBDData[4] = model.adcode;
                        
                        if (codeModel.csvData[5]) {
                        csVBDData[5] = codeModel.csvData[5];
                        }else{
                            csVBDData[5] = @"";

                        }
                        
                        if (codeModel.csvData[6]) {
                            csVBDData[6] = codeModel.csvData[6];
                        }else{
                            csVBDData[6] = @"";
                            
                        }

                        
                        [strong tranfromBD:model.center andCSV:csVBDData andFile:filePath ];
                    }
                    
                    strong.writeLb.text = [NSString stringWithFormat:@"已经写入:%ld",strong.write];
                    strong.write ++;
                } andFail:^(NSError * _Nullable error) {
                    
                }];
                
            }
            
        }
        
        [parser closeFile];
    }else{
        
        self.totalLb.text = @"数据总量:0";
        
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
        

        
        BDLocationTranModel *tranBDModel = bdLocationModel.locationMode;
        
        NSString *lonlat = [NSString stringWithFormat:@"%@,%@",tranBDModel.x,tranBDModel.y];
        
        NSMutableArray *bdcsvData = bdLocationModel.csvData;
        bdcsvData[3] = lonlat;
        
        [strong exportCSV:bdcsvData andFilePath:filePath];
        
        
    } andFail:^(NSMutableArray * _Nonnull csvData) {
        

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
    NSString *header = @"city,county,town,centerLocation,adcode\r\n";
    
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
