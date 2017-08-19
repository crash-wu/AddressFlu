//
//  GecodeViewController.m
//  AddressFlu
//
//  Created by 吴小星 on 2017/7/1.
//  Copyright © 2017年 crash. All rights reserved.
//

#import "GecodeViewController.h"

@interface GecodeViewController ()

@property(nonatomic,strong,nonnull) UILabel *totalLb;


/**
 高德坐标转换
 */
@property(nonnull,strong,nonatomic) UILabel *gdLocation;


/**
 高德坐标转换失败
 */
@property(nonnull,strong,nonatomic) UILabel *gdLtError;



/**
 高德逆地址编码
 */
@property(nonnull,strong,nonatomic) UILabel *gdAddress;


/**
 高德逆地址编码失败
 */
@property(nonnull,strong,nonatomic) UILabel *gdAddressErrorLb;


@property(nonatomic,assign) NSInteger gdcount;

@property(nonatomic,assign) NSInteger gdError;

@property(nonatomic,assign) NSInteger gdAddressCount;

@property(nonatomic,assign) NSInteger gdAddressError;

@end

@implementation GecodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.automaticallyAdjustsScrollViewInsets = true;
    
    self.view.backgroundColor = [UIColor whiteColor];
    
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
    
    self.gdLocation = [[UILabel alloc]init];
    [self.view addSubview:self.gdLocation];
    self.gdLocation.textAlignment = NSTextAlignmentLeft;
    self.gdLocation.textColor = [UIColor blackColor];
    [self.gdLocation mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.totalLb.mas_bottom).with.offset(20);
        make.left.equalTo(self.view.mas_left).with.offset(20);
        make.height.equalTo(@[@30]);
        make.right.equalTo(self.view.mas_right).with.offset(-20);
    }];
    self.gdLocation.textAlignment = NSTextAlignmentLeft;
    self.gdLocation.textColor = [UIColor blackColor];
    
    self.gdLtError = [[UILabel alloc]init];
    [self.view addSubview:self.gdLtError];
    [self.gdLtError mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.gdLocation.mas_bottom).with.offset(20);
        make.left.equalTo(self.view.mas_left).with.offset(20);
        make.height.equalTo(@[@30]);
        make.right.equalTo(self.view.mas_right).with.offset(-20);
    }];
    
    self.gdLtError.textAlignment = NSTextAlignmentLeft;
    self.gdLtError.textColor = [UIColor blackColor];
    
    self.gdAddress = [[UILabel alloc]init];
    [self.view addSubview:self.gdAddress];
    [self.gdAddress mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.gdLtError.mas_bottom).with.offset(20);
        make.left.equalTo(self.view.mas_left).with.offset(20);
        make.height.equalTo(@[@30]);
        make.right.equalTo(self.view.mas_right).with.offset(-20);
    }];
    
    self.gdAddress.textAlignment = NSTextAlignmentLeft;
    self.gdAddress.textColor = [UIColor blackColor];
    
    self.gdAddressErrorLb = [[UILabel alloc]init];
    [self.view addSubview:self.gdAddressErrorLb];
    self.gdAddressErrorLb.textAlignment = NSTextAlignmentLeft;
    self.gdAddressErrorLb.textColor = [UIColor blackColor];
    [self.gdAddressErrorLb mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.gdAddress.mas_bottom).with.offset(20);
        make.left.equalTo(self.view.mas_left).with.offset(20);
        make.height.equalTo(@[@30]);
        make.right.equalTo(self.view.mas_right).with.offset(-20);
    }];
    
    self.gdAddressErrorLb.textAlignment = NSTextAlignmentLeft;
    self.gdAddressErrorLb.textColor = [UIColor blackColor];
    
    
    UIBarButtonItem *rightBarBtn = [[UIBarButtonItem alloc]initWithTitle:@"开始读取" style:UIBarButtonItemStylePlain  target:self action:@selector(rightBtn:)];
    self.navigationItem.rightBarButtonItem = rightBarBtn;
    
    self.totalLb.text = @"数据总行数:0";
    
    self.gdLocation.text = @"转换高德坐标成功:0";
    self.gdLtError.text = @"转换高德坐标失败:0";
    
    self.gdAddress.text = @"逆地址编码:0";
    self.gdAddressErrorLb.text = @"逆地址查询失败：0";

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
    
    //读取本地csv 文件路径
    NSString *path = [[NSBundle mainBundle] pathForResource:@"230281" ofType:@"csv"];
    
    //初始化线程锁信号量
    
    //读取csv文件数据流
    CSVParser *parser = [CSVParser new];
    [parser openFile: path];
    NSMutableArray *csvContent = [parser parseFile];
    
    //判断csv数据流数组长度，如果>0，则执行数据处理，否则结束
    if (csvContent.count > 0) {
        
        self.totalLb.text = [NSString stringWithFormat:@"总行数:%ld",csvContent.count-1];
        
        for (int c = 1; c < [csvContent count]; c++) {
            //获取每一行csv数据流
            NSMutableArray *array = [csvContent objectAtIndex:c];
//_id,_class,terminalId,terminalCode,shopName,category,shopType,shopAddress,location,adminId,creater,confirmStatus,terminalStatus,cityCode,cityName,shopManagerName,managerCode,managerName,soleTraderCode,soleTraderName,salesmanCode,salesmanName,terminalClusterCode,contactPhone,createrTime,locatedType,locatedTime，pname,cname,vname,dname,address-gd            

            if (array.count > 8 && array[8]) {
                
                NSString *loncation = array[8];
                loncation = [loncation stringByReplacingOccurrencesOfString:@"[" withString:@""];
                loncation = [loncation stringByReplacingOccurrencesOfString:@"]" withString:@""];
                
                [self bdLocationToGd:loncation andCSVdata:array andFilePath:filePath];

            }

        }
        [parser closeFile];
    }else{

    }
}


-(void)bdLocationToGd:(NSString *) location andCSVdata:(NSMutableArray *_Nonnull) csvData andFilePath:(NSString *_Nonnull) filePath{
    
    
    __weak typeof(&*self) weak = self;
    [[Ws84convertToGDHandler alloc]ws84Convert:location andcoordsys:@"baidu" andCSVData:csvData andSuccess:^(Ws84ConvertReturnModel * _Nonnull convertModel) {
        
        __strong typeof(&*self) strong = weak;
        
        //改变已经执行坐标转换的数据条目提示文本信息
        strong.gdLocation.text = [NSString stringWithFormat:@"高德坐标转换成功:%ld",strong.gdcount];
        
        strong.gdcount ++;
        Ws84ConvertToGDModel *ws84Model = convertModel.convertModel;
        
        //坐标转换线程与高德逆地址编码线程为两种类型的异步线程，执行的先后顺序不确定，因此必须确保数据传递过程的准确性
        
        [strong opposite:ws84Model.locations andCSVdata:convertModel.csvData andFilePath:filePath];
        
    } andFail:^(NSError * _Nonnull error) {
        weak.gdLtError.text = [NSString stringWithFormat:@"高德坐标转换失败:%ld",weak.gdError];
        
        weak.gdError ++;
        
    }];
    
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
        
        strong.gdAddress.text = [NSString stringWithFormat:@"逆地址编码成功:%ld",strong.gdAddressCount];
        strong.gdAddressCount ++;

        
        //逆地址编码数据实体
        GDGetCodeModel *codeModel = saveCSVDataModel.codeMoel;
        AddressComponentModel *addressModel = codeModel.addressComponent;
//_id,_class,terminalId,terminalCode,shopName,category,shopType,shopAddress,location,adminId,creater,confirmStatus,terminalStatus,cityCode,cityName,shopManagerName,managerCode,managerName,soleTraderCode,soleTraderName,salesmanCode,salesmanName,terminalClusterCode,contactPhone,createrTime,locatedType,locatedTime，pname,cname,vname,dname,address-gd        
        
        if (addressModel.province) {
            saveCSVDataModel.csvData[27] = addressModel.province;
            
        }else{
            saveCSVDataModel.csvData[27] = @"";
        }
        
        if (addressModel.city) {
            saveCSVDataModel.csvData[28] = addressModel.city;
        }else{
            
            saveCSVDataModel.csvData[28] = @"";
        }
        
        if (addressModel.district) {
            saveCSVDataModel.csvData[29] = addressModel.district;
        }else{
            saveCSVDataModel.csvData[29] = @"";
        }
        
        if (addressModel.township) {
            saveCSVDataModel.csvData[30] = addressModel.township;
        }else{
            saveCSVDataModel.csvData[30] = @"";
        }
        
        if (codeModel.formatted_address) {
            saveCSVDataModel.csvData[31] = codeModel.formatted_address;
        }else{
            saveCSVDataModel.csvData[31] = @"";
        }
        
        [self exportCSV:saveCSVDataModel.csvData andFilePath:filePath];
    
        
    } andFail:^(NSError * _Nonnull error) {
        
        weak.gdAddressErrorLb.text = [NSString stringWithFormat:@"逆地址编码失败:%ld",weak.gdAddressError];
        weak.gdAddressError ++;
        
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
    NSString *header = @"_id,_class,terminalId,terminalCode,shopName,category,shopType,shopAddress,location,adminId,creater,confirmStatus,terminalStatus,cityCode,cityName,shopManagerName,managerCode,managerName,soleTraderCode,soleTraderName,salesmanCode,salesmanName,terminalClusterCode,contactPhone,createrTime,locatedType,locatedTime，pname,cname,vname,dname,address-gd\r\n";
    
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
            
            
            if (i==10) {
                
                NSString *csvTemp = csv;
                
                csvTemp = [csv stringByReplacingOccurrencesOfString:@"\"" withString:@"'"];

                
                csvString = [NSString stringWithFormat:@"%@,\"%@\"", csvString,csvTemp];
            }else{
                
                csvString = [NSString stringWithFormat:@"%@,\"%@\"", csvString,csv];
            }

            
//"{""loginName"":""admin"",""userGuid"":""54a0be656eb4ecb727cb0d10""}"
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
