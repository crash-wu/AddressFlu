//
//  BudongchangxiangmuViewController.m
//  AddressFlu
//
//  Created by 吴小星 on 2017/9/2.
//  Copyright © 2017年 crash. All rights reserved.
//

#import "BudongchangxiangmuViewController.h"

@interface BudongchangxiangmuViewController ()

@property(nonnull,strong,nonatomic) UILabel *bdPOILb;
@property(nonatomic,strong,nonnull) UILabel *bdPOIErrorLb;

@property(nonatomic,strong,nonnull) UILabel *gecodeLb;
@property(nonnull,strong,nonatomic) UILabel *gecodeErrorlb;
@property(nonatomic,strong,nonnull) UILabel *totalLb;

@property(nonatomic,assign) NSInteger total;
@property(nonatomic,assign) NSInteger bd;
@property(nonatomic,assign) NSInteger bdError;
@property(nonatomic,assign) NSInteger code;
@property (nonatomic,assign) NSInteger codeError;
@end

@implementation BudongchangxiangmuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
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
    
    self.bdPOILb = [[UILabel alloc]init];
    [self.view addSubview:self.bdPOILb];
    
    [self.bdPOILb mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.totalLb.mas_bottom).with.offset(20);
        make.left.equalTo(self.view.mas_left).with.offset(20);
        make.height.equalTo(@[@30]);
        make.right.equalTo(self.view.mas_right).with.offset(-20);
    }];
    
    self.bdPOILb.textAlignment = NSTextAlignmentLeft;
    self.bdPOILb.textColor = [UIColor blackColor];
    
    self.bdPOIErrorLb = [[UILabel alloc]init];
    [self.view addSubview:self.bdPOIErrorLb];
    [self.bdPOIErrorLb mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.bdPOILb.mas_bottom).with.offset(20);
        make.left.equalTo(self.view.mas_left).with.offset(20);
        make.height.equalTo(@[@30]);
        make.right.equalTo(self.view.mas_right).with.offset(-20);
    }];
    
    self.bdPOIErrorLb.textAlignment = NSTextAlignmentLeft;
    self.bdPOIErrorLb.textColor = [UIColor redColor];
    
    self.gecodeLb = [[UILabel alloc]init];
    [self.view addSubview:self.gecodeLb];
    [self.gecodeLb mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.bdPOIErrorLb.mas_bottom).with.offset(20);
        make.left.equalTo(self.view.mas_left).with.offset(20);
        make.height.equalTo(@[@30]);
        make.right.equalTo(self.view.mas_right).with.offset(-20);
    }];
    
    self.gecodeLb.textAlignment = NSTextAlignmentLeft;
    self.gecodeLb.textColor = [UIColor redColor];
    
    self.gecodeErrorlb = [[UILabel alloc]init];
    [self.view addSubview:self.gecodeErrorlb];
    [self.gecodeErrorlb mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.gecodeLb.mas_bottom).with.offset(20);
        make.left.equalTo(self.view.mas_left).with.offset(20);
        make.height.equalTo(@[@30]);
        make.right.equalTo(self.view.mas_right).with.offset(-20);
    }];
    
    self.gecodeErrorlb.textAlignment = NSTextAlignmentLeft;
    self.gecodeErrorlb.textColor = [UIColor redColor];
    
    self.totalLb.text = @"总数量:";
    self.bdPOILb.text = @"POI搜索" ;
    self.bdPOIErrorLb.text = @"POI 搜索失败：";
    self.gecodeLb.text = @"逆地址";
    self.gecodeErrorlb.text = @"逆地址失败:";
    
    self.bd = 1;
    self.bdError = 1;
    self.code = 1;
    self.codeError = 1;
    
    
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
    NSString *path = [[NSBundle mainBundle] pathForResource:@"项目1" ofType:@"csv"];
    
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
            if (array.count > 2) {
                //[self gdPOISearch:array[1] andCity:@"佛山市" andCSVData:array andFile:filePath];
                [self gdcode:array[2] andCity:@"佛山市" andCSV:array andFile:filePath];
            }

        }
        [parser closeFile];
    }else{
        
    }
}


-(void)gdPOISearch:(NSString *_Nonnull) keywork andCity:(NSString *_Nonnull) city andCSVData:(NSMutableArray *_Nonnull) csvData andFile:(NSString *_Nonnull)filePath{
    
    //CODE,XMMC,XMDZ,location,pname,city,vname
    
    __weak typeof( &*self) weak = self;
    
    [[GDPOISearchHandler1 alloc] poiSearch:keywork andCity:city andCSV:csvData andSuccess:^(GDPOIReturnModel * _Nonnull codeModel) {
        
        __strong typeof( &*self) strong = weak;
        GDPOIModel * poiModel = codeModel.poiModel;
        NSMutableArray *array = codeModel.csv;
        
        
        if (poiModel.location) {
            array[3] = poiModel.location;
        }
        
        if (poiModel.pname) {
            array[4] = poiModel.pname;
        }
        
        if (poiModel.cityname) {
            array[5] = poiModel.cityname;
        }
        
        if (poiModel.adname) {
            array[6] = poiModel.adname;
        }
        
//        [strong  gdDecode:array[3] andCSV:codeModel.csv andFile:filePath andStatus:2 isChangeBD:YES];
        [strong exportCSV:array andFilePath:filePath];
        
        strong.bdPOILb.text = [NSString stringWithFormat:@"poi搜索成功:%ld",self.bd];
        strong.bd ++;
        
        
    } andFail:^(NSMutableArray * _Nullable csv) {
        
        
        __strong typeof(&*self) strong = weak;
        
        strong.bdPOIErrorLb.text = [NSString stringWithFormat:@"poi搜索失败:%ld",self.bdError];
        strong.bdError ++;
        
    }];
    
}


-(void)gdcode:(NSString *_Nonnull) address andCity:(NSString*_Nonnull) city andCSV:(NSMutableArray *_Nonnull) csv andFile:(NSString *_Nonnull) file{
    
    
    __weak typeof(&*self) weak = self;
    [[GDCodeHandler alloc] gecodeAddress:address andCity:city andCSVData:csv andSuccess:^(GeCodeListModel * _Nonnull codeModel) {
        
        __strong typeof(&*self) strong = weak;

        GeCodeModel *model = codeModel.codeModel;
        
        if (model.location) {
            csv[3] = model.location;
        }
        
        if (model.province) {
            csv[4] = model.province;
        }
        
        if (model.city) {
            csv[5] = model.city;
        }
        
        if (model.district) {
            csv[6] = model.district;
        }
        
        //        [strong  gdDecode:array[3] andCSV:codeModel.csv andFile:filePath andStatus:2 isChangeBD:YES];
        [strong exportCSV:csv andFilePath:file];
        
        strong.bdPOILb.text = [NSString stringWithFormat:@"poi搜索成功:%ld",self.bd];
        strong.bd ++;
        

    } andFail:^(NSMutableArray *_Nullable csvData) {
        __strong typeof(&*self) strong = weak;
        
        strong.bdPOIErrorLb.text = [NSString stringWithFormat:@"poi搜索失败:%ld",self.bdError];
        strong.bdError ++;

    }];
}


/**
 高德逆地址编码
 
 @param location 坐标
 @param csv CSV 数组
 @param file 文件保存路径
 @param changeBD 是否转换BD
 */
-(void)gdDecode:(NSString *_Nonnull) location andCSV:(NSMutableArray *_Nonnull) csv andFile:(NSString *_Nonnull)file andStatus:(NSInteger) status isChangeBD:(BOOL) changeBD{
    
    __weak typeof(&*self) weak = self;
    
    //坐标转换线程与高德逆地址编码线程为两种类型的异步线程，执行的先后顺序不确定，因此必须确保数据传递过程的准确性
    [[GDGetCodeHandler alloc]getCode:location andCSVData:csv andSuccess:^(SaveCSVDataModel * _Nonnull saveCSVDataModel) {
        
        __strong typeof(&*self) strong  = weak;
        
        //改变已经过滤的数据条目提示文本信息
        strong.gecodeLb.text = [NSString stringWithFormat:@"逆地址编码:%ld",strong.code];
        strong.code ++;
        
        
        SaveCSVDataModel *csvDataModel = saveCSVDataModel;
        
        //csv行数据
        NSMutableArray *csv = csvDataModel.csvData;
        
        //逆地址编码数据实体
        GDGetCodeModel *codeModel = saveCSVDataModel.codeMoel;
        AddressComponentModel *model = codeModel.addressComponent;
        
        
        //        name,address,coor,coor-gd,pname,cname,dname,vname,adrress-gd,status,fitler,fitler-grade,location,location-tb,url
        if (codeModel.formatted_address) {
            
            csv[1] = codeModel.formatted_address;
        }
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
        
        csv[9] = [NSString stringWithFormat:@"%ld",status];
                    
        [self exportCSV:csv andFilePath:file];

        
    } andFail:^(NSError * _Nonnull error) {
        
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
    NSString *header = @"CODE,XMMC,XMDZ,location,pname,city,vname\r\n";
    
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
