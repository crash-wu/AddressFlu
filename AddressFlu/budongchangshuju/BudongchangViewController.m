//
//  BudongchangViewController.m
//  AddressFlu
//
//  Created by 吴小星 on 2017/8/18.
//  Copyright © 2017年 crash. All rights reserved.
//

#import "BudongchangViewController.h"

@interface BudongchangViewController ()

@property(nonnull,strong,nonatomic) UILabel *totalLb;


@property(nonnull,strong,nonatomic) UILabel *successLb;


@property(nonatomic,strong,nonnull) UILabel *failLb;


@property(nonnull,strong,nonatomic) UILabel *writeLb;

@property(nonatomic,assign) NSInteger total,success,fail,write;

@property(nonnull,strong,nonatomic)dispatch_semaphore_t semaphore;

@end

@implementation BudongchangViewController

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
    
    self.successLb = [[UILabel alloc]init];
    [self.view addSubview:self.successLb];
    [self.successLb mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.totalLb.mas_bottom).with.offset(20);
        make.left.equalTo(self.view.mas_left).with.offset(20);
        make.height.equalTo(@[@30]);
        make.right.equalTo(self.view.mas_right).with.offset(-20);
    }];
    
    self.successLb.textAlignment = NSTextAlignmentLeft;
    self.successLb.textColor = [UIColor blackColor];
    
    
    self.failLb = [[UILabel alloc]init];
    [self.view addSubview:self.failLb];
    [self.failLb mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.successLb.mas_bottom).with.offset(20);
        make.left.equalTo(self.view.mas_left).with.offset(20);
        make.height.equalTo(@[@30]);
        make.right.equalTo(self.view.mas_right).with.offset(-20);
    }];
    
    self.failLb.textAlignment = NSTextAlignmentLeft;
    self.failLb.textColor = [UIColor blackColor];
    
    self.writeLb = [[UILabel alloc]init];
    [self.view addSubview:self.writeLb];
    [self.writeLb mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.failLb.mas_bottom).with.offset(20);
        make.left.equalTo(self.view.mas_left).with.offset(20);
        make.height.equalTo(@[@30]);
        make.right.equalTo(self.view.mas_right).with.offset(-20);
    }];
    
    self.failLb.textAlignment = NSTextAlignmentLeft;
    self.failLb.textColor = [UIColor blackColor];
    
    
    self.totalLb.text = @"总条数:";
    self.successLb.text = @"处理成功数量:";
    self.failLb.text = @"处理失败数量:";
    self.writeLb.text = @"写入数量:";
    
    self.total = 1;
    self.success = 1;
    self.fail = 1;
    self.write = 1;
   
    
}



-(void)rightBtn:(UIButton *)button{
    
    //初始化线程锁信号量
    self.semaphore = dispatch_semaphore_create(1);
    
    //创建csv文件，接收处理后的csv数据流
    NSString *filePath = [self createFile];
    //写入csv数据表头
    [self exportCSVHeader:filePath];
    
    //读取本地csv 文件路径
    NSString *path = [[NSBundle mainBundle] pathForResource:@"幸福指数评价模型-表格 1" ofType:@"csv"];
    

    
    //读取csv文件数据流
    CSVParser *parser = [CSVParser new];
    [parser openFile: path];
    NSMutableArray *csvContent = [parser parseFile];
    
    //判断csv数据流数组长度，如果>0，则执行数据处理，否则结束
    if (csvContent.count > 0) {
        
        self.totalLb.text = [NSString stringWithFormat:@"数据总量:%ld",csvContent.count -1];
        
        for (int i = 2;  i < csvContent.count; i++) {
            
            //获取每一行csv数据流
            NSMutableArray *array = [csvContent objectAtIndex:i];
            
            if (array && array.count > 3) {
                NSString *keywork = array[0];

                
                [self bdPOISearch:keywork andCity:@"佛山" andCSVData:array andFile:filePath];
            }
            
        }
        
        [parser closeFile];
    }else{
        
        self.totalLb.text = @"数据总量:0";
        
    }
    
}


#pragma -POI


-(void)bdPOISearch:(NSString *_Nonnull) keywork andCity:(NSString *_Nonnull) city andCSVData:(NSMutableArray *_Nonnull) csvData andFile:(NSString *_Nonnull)filePath{
    
    //添加线程锁信号量

    __weak typeof( &*self) weak = self;
    [[BDBudongchangPOISearchHandler alloc] poiSearch:keywork andCity:city andCSV:csvData andSuccess:^(BDPOIReturnModel * _Nonnull codeModel) {
        
        __strong typeof(&*self) strong = weak;
        
        BDPOIModel *bdmodel = codeModel.poiModel;
        BDPOILocationModel *locationModle = bdmodel.location;
        NSString *location = [NSString stringWithFormat:@"%lf,%lf",locationModle.lat,locationModle.lng];
        csvData[1] = location;
        [strong bdRadiusForBusiness:location andCSVData:csvData andFile:filePath];
        

        
    } andFail:^(NSMutableArray * _Nullable csv) {
        __strong typeof( &*self) strong = weak;
        
        strong.fail ++;
        strong.failLb.text = [NSString stringWithFormat:@"数据处理失败:%ld",strong.fail];
        
        
    }];
}



#pragma mark - Radius 商圈

-(void)bdRadiusForBusiness:(NSString *_Nonnull)location andCSVData:(NSMutableArray *_Nonnull) csvData andFile:(NSString *_Nonnull)filePath {
    
    __weak typeof( &*self) weak = self;
    [[BDRadiusSearchHandler alloc] radiusSearch:location andKeywork:@"商圈" andRadius:3000 andCSV:csvData andSuccess:^(BDRadiuSearchReturnModel * _Nonnull codeModel) {
        
        __strong typeof( &*self) strong = weak;
        
        NSArray<BDPOIModel *> *array = codeModel.array;
        
        NSString *destion = @"";
        
        for (BDPOIModel *model in array) {
            
            BDPOILocationModel *locationModel = model.location;
            destion = [destion stringByAppendingFormat:@"|%f,%f",locationModel.lat,locationModel.lng];
        }
        
        destion = [destion substringFromIndex:1];
        NSMutableArray *csvDataRetrun = codeModel.csv;
        csvDataRetrun[2] =[NSNumber numberWithInteger:array.count];
        
        if (csvDataRetrun[1]) {
        [strong bdRoutematrix:csvDataRetrun[1] andDes:destion andCSVData:csvDataRetrun andFile:filePath andKey:@"商圈"];
        }
        

        
    } andFail:^(NSMutableArray * _Nullable csv) {
        
        __strong typeof( &*self) strong = weak;
        
        if (csv[1]) {
            
            [strong bdRadiusForBus:csv[1] andCSVData:csv andFile:filePath];
        }
        

    }];
    
}


#pragma mark - Radius 公交

-(void)bdRadiusForBus:(NSString *_Nonnull)location andCSVData:(NSMutableArray *_Nonnull) csvData andFile:(NSString *_Nonnull)filePath {
    
    __weak typeof( &*self) weak = self;
    [[BDRadiusSearchHandler alloc] radiusSearch:location andKeywork:@"公交" andRadius:1000 andCSV:csvData andSuccess:^(BDRadiuSearchReturnModel * _Nonnull codeModel) {
        
        __strong typeof( &*self) strong = weak;
        
        NSArray<BDPOIModel *> *array = codeModel.array;
        
        NSString *destion = @"";
        
        for (BDPOIModel *model in array) {
            
            BDPOILocationModel *locationModel = model.location;
            destion = [destion stringByAppendingFormat:@"|%f,%f",locationModel.lat,locationModel.lng];
        }
        
        destion = [destion substringFromIndex:1];
        NSMutableArray *csvDataRetrun = codeModel.csv;
        csvDataRetrun[7] =[NSNumber numberWithInteger:array.count];

        if (csvDataRetrun[1]) {
         [strong bdRoutematrixBus:csvDataRetrun[1] andDes:destion andCSVData:csvDataRetrun andFile:filePath andKey:@"公交"];
        }

        
    } andFail:^(NSMutableArray * _Nullable csv) {
        
        __strong typeof( &*self) strong = weak;

        if (csv[1]) {
        [strong bdRadiusForBank:csv[1] andCSVData:csv andFile:filePath];
        }

    }];
    
}


#pragma mark - Radius 银行

-(void)bdRadiusForBank:(NSString *_Nonnull)location andCSVData:(NSMutableArray *_Nonnull) csvData andFile:(NSString *_Nonnull)filePath {
    
    __weak typeof( &*self) weak = self;
    [[BDRadiusSearchHandler alloc] radiusSearch:location andKeywork:@"银行" andRadius:2000 andCSV:csvData andSuccess:^(BDRadiuSearchReturnModel * _Nonnull codeModel) {
        
        __strong typeof( &*self) strong = weak;
        
        NSArray<BDPOIModel *> *array = codeModel.array;
        
        NSString *destion = @"";
        
        for (BDPOIModel *model in array) {
            
            BDPOILocationModel *locationModel = model.location;
            destion = [destion stringByAppendingFormat:@"|%f,%f",locationModel.lat,locationModel.lng];
        }
        
        destion = [destion substringFromIndex:1];
        NSMutableArray *csvDataRetrun = codeModel.csv;
        csvDataRetrun[12] =[NSNumber numberWithInteger:array.count];
        
        if (csvDataRetrun[1]) {
        [strong bdRoutematrixBank:csvDataRetrun[1] andDes:destion andCSVData:csvDataRetrun andFile:filePath andKey:@"银行"];
        }

        
    } andFail:^(NSMutableArray * _Nullable csv) {
        
        __strong typeof( &*self) strong = weak;
        
        if (csv[1]) {
            [strong bdRadiusForSu:csv[1] andCSVData:csv andFile:filePath];
        }

    }];
    
}


#pragma mark - Radius 学校

-(void)bdRadiusForSu:(NSString *_Nonnull)location andCSVData:(NSMutableArray *_Nonnull) csvData andFile:(NSString *_Nonnull)filePath {
    
    __weak typeof( &*self) weak = self;
    [[BDRadiusSearchHandler alloc] radiusSearch:location andKeywork:@"学校" andRadius:2000 andCSV:csvData andSuccess:^(BDRadiuSearchReturnModel * _Nonnull codeModel) {
        
        __strong typeof( &*self) strong = weak;
        
        NSArray<BDPOIModel *> *array = codeModel.array;
        
        NSString *destion = @"";
        
        for (BDPOIModel *model in array) {
            
            BDPOILocationModel *locationModel = model.location;
            destion = [destion stringByAppendingFormat:@"|%f,%f",locationModel.lat,locationModel.lng];
        }
        
        destion = [destion substringFromIndex:1];
        NSMutableArray *csvDataRetrun = codeModel.csv;
        csvDataRetrun[17] =[NSNumber numberWithInteger:array.count];
        
        if (csvDataRetrun[1]) {
            
            [strong bdRoutematrixSchool:location andDes:destion andCSVData:csvDataRetrun andFile:filePath andKey:@"学校"];
        }

        
    } andFail:^(NSMutableArray * _Nullable csv) {
        
        __strong typeof( &*self) strong = weak;
        if (csv[1]) {
            
            [strong bdRadiusForHost:csv[1] andCSVData:csv andFile:filePath];
        }

    }];
    
}

#pragma mark - Radius 医院
-(void)bdRadiusForHost:(NSString *_Nonnull)location andCSVData:(NSMutableArray *_Nonnull) csvData andFile:(NSString *_Nonnull)filePath {
    
    __weak typeof( &*self) weak = self;
    [[BDRadiusSearchHandler alloc] radiusSearch:location andKeywork:@"医院" andRadius:3000 andCSV:csvData andSuccess:^(BDRadiuSearchReturnModel * _Nonnull codeModel) {
        
        __strong typeof( &*self) strong = weak;
        
        NSArray<BDPOIModel *> *array = codeModel.array;
        
        NSString *destion = @"";
        
        for (BDPOIModel *model in array) {
            
            BDPOILocationModel *locationModel = model.location;
            destion = [destion stringByAppendingFormat:@"|%f,%f",locationModel.lat,locationModel.lng];
        }
        
        destion = [destion substringFromIndex:1];
        NSMutableArray *csvDataRetrun = codeModel.csv;
        csvDataRetrun[22] =[NSNumber numberWithInteger:array.count];
        if (csvDataRetrun[1]) {
            [strong bdRoutematrixHost:csvDataRetrun[1] andDes:destion andCSVData:csvDataRetrun andFile:filePath andKey:@"医院"];
        }
        

        
    } andFail:^(NSMutableArray * _Nullable csv) {
        
        __strong typeof( &*self) strong = weak;
        if (csv[1]) {
            [strong bdRadiusForRelax:csv[1] andCSVData:csv andFile:filePath];
        }


    }];
    
}


#pragma mark - Radius 休闲
-(void)bdRadiusForRelax:(NSString *_Nonnull)location andCSVData:(NSMutableArray *_Nonnull) csvData andFile:(NSString *_Nonnull)filePath {
    
    __weak typeof( &*self) weak = self;
    [[BDRadiusSearchHandler alloc] radiusSearch:location andKeywork:@"休闲" andRadius:3000 andCSV:csvData andSuccess:^(BDRadiuSearchReturnModel * _Nonnull codeModel) {
        
        __strong typeof( &*self) strong = weak;
        
        NSArray<BDPOIModel *> *array = codeModel.array;
        
        NSString *destion = @"";
        
        for (BDPOIModel *model in array) {
            
            BDPOILocationModel *locationModel = model.location;
            destion = [destion stringByAppendingFormat:@"|%f,%f",locationModel.lat,locationModel.lng];
        }
        
        destion = [destion substringFromIndex:1];
        NSMutableArray *csvDataRetrun = codeModel.csv;
        csvDataRetrun[27] =[NSNumber numberWithInteger:array.count];

        if (csvDataRetrun[1]) {
        [strong bdRoutematrixRelax:csvDataRetrun[1] andDes:destion andCSVData:csvDataRetrun andFile:filePath andKey:@"休闲"];
        }

        
    } andFail:^(NSMutableArray * _Nullable csv) {
        
        __strong typeof( &*self) strong = weak;
        if (csv[1]) {
        [strong bdRadiusForSuper:csv[1] andCSVData:csv andFile:filePath];
        }

    }];
    
}


#pragma mark - Radius 超市
-(void)bdRadiusForSuper:(NSString *_Nonnull)location andCSVData:(NSMutableArray *_Nonnull) csvData andFile:(NSString *_Nonnull)filePath {
    
    __weak typeof( &*self) weak = self;
    [[BDRadiusSearchHandler alloc] radiusSearch:location andKeywork:@"超市" andRadius:3000 andCSV:csvData andSuccess:^(BDRadiuSearchReturnModel * _Nonnull codeModel) {
        
        __strong typeof( &*self) strong = weak;
        
        NSArray<BDPOIModel *> *array = codeModel.array;
        
        NSString *destion = @"";
        
        for (BDPOIModel *model in array) {
            
            BDPOILocationModel *locationModel = model.location;
            destion = [destion stringByAppendingFormat:@"|%f,%f",locationModel.lat,locationModel.lng];
        }
        
        destion = [destion substringFromIndex:1];
        NSMutableArray *csvDataRetrun = codeModel.csv;
        csvDataRetrun[32] =[NSNumber numberWithInteger:array.count];
        if (csvDataRetrun[1]) {
            [strong bdRoutematrixSuper:csvDataRetrun[1] andDes:destion andCSVData:csvDataRetrun andFile:filePath andKey:@"超市"];
        }

        
    } andFail:^(NSMutableArray * _Nullable csv) {
        
        __strong typeof( &*self) strong = weak;
        if (csv[1]) {
        [strong bdRadiusForPublic:csv[1] andCSVData:csv andFile:filePath];
        }

    }];
    
}


#pragma mark - Radius 治安
-(void)bdRadiusForPublic:(NSString *_Nonnull)location andCSVData:(NSMutableArray *_Nonnull) csvData andFile:(NSString *_Nonnull)filePath {
    
    __weak typeof( &*self) weak = self;
    [[BDRadiusSearchHandler alloc] radiusSearch:location andKeywork:@"治安" andRadius:3000 andCSV:csvData andSuccess:^(BDRadiuSearchReturnModel * _Nonnull codeModel) {
        
        __strong typeof( &*self) strong = weak;
        
        NSArray<BDPOIModel *> *array = codeModel.array;
        
        NSString *destion = @"";
        
        for (BDPOIModel *model in array) {
            
            BDPOILocationModel *locationModel = model.location;
            destion = [destion stringByAppendingFormat:@"|%f,%f",locationModel.lat,locationModel.lng];
        }
        
        destion = [destion substringFromIndex:1];
        NSMutableArray *csvDataRetrun = codeModel.csv;
        csvDataRetrun[37] =[NSNumber numberWithInteger:array.count];
        if (csvDataRetrun[1]) {
        [strong bdRoutematrixPubilc:csvDataRetrun[1] andDes:destion andCSVData:csvDataRetrun andFile:filePath andKey:@"治安"];
        }

        
    } andFail:^(NSMutableArray * _Nullable csv) {
        
        __strong typeof( &*self) strong = weak;
        if (csv[1]) {
        [strong bdRadiusForHouse:csv[1] andCSVData:csv andFile:filePath];
        }

    }];
    
}

#pragma mark - Radius 家政
-(void)bdRadiusForHouse:(NSString *_Nonnull)location andCSVData:(NSMutableArray *_Nonnull) csvData andFile:(NSString *_Nonnull)filePath {
    
    __weak typeof( &*self) weak = self;
    [[BDRadiusSearchHandler alloc] radiusSearch:location andKeywork:@"家政" andRadius:2000 andCSV:csvData andSuccess:^(BDRadiuSearchReturnModel * _Nonnull codeModel) {
        
        __strong typeof( &*self) strong = weak;
        
        NSArray<BDPOIModel *> *array = codeModel.array;
        
        NSString *destion = @"";
        
        for (BDPOIModel *model in array) {
            
            BDPOILocationModel *locationModel = model.location;
            destion = [destion stringByAppendingFormat:@"|%f,%f",locationModel.lat,locationModel.lng];
        }
        
        destion = [destion substringFromIndex:1];
        NSMutableArray *csvDataRetrun = codeModel.csv;
        csvDataRetrun[42] =[NSNumber numberWithInteger:array.count];
        if (csvDataRetrun[1]) {
            [strong bdRoutematrixHouse:csvDataRetrun[1] andDes:destion andCSVData:csvDataRetrun andFile:filePath andKey:@"家政"];
        }

        
    } andFail:^(NSMutableArray * _Nullable csv) {
        
        __strong typeof( &*self) strong = weak;
        if (csv[1]) {
        [strong bdRadiusForDiet:csv[1] andCSVData:csv andFile:filePath];
        }

    }];
    
}


#pragma mark - Radius 饮食
-(void)bdRadiusForDiet:(NSString *_Nonnull)location andCSVData:(NSMutableArray *_Nonnull) csvData andFile:(NSString *_Nonnull)filePath {
    
    __weak typeof( &*self) weak = self;
    [[BDRadiusSearchHandler alloc] radiusSearch:location andKeywork:@"饮食" andRadius:1000 andCSV:csvData andSuccess:^(BDRadiuSearchReturnModel * _Nonnull codeModel) {
        
        __strong typeof( &*self) strong = weak;
        
        NSArray<BDPOIModel *> *array = codeModel.array;
        
        NSString *destion = @"";
        
        for (BDPOIModel *model in array) {
            
            BDPOILocationModel *locationModel = model.location;
            destion = [destion stringByAppendingFormat:@"|%f,%f",locationModel.lat,locationModel.lng];
        }
        
        destion = [destion substringFromIndex:1];
        NSMutableArray *csvDataRetrun = codeModel.csv;
        csvDataRetrun[47] =[NSNumber numberWithInteger:array.count];
        if (csvDataRetrun[1]) {
        [strong bdRoutematrixDiet:csvDataRetrun[1] andDes:destion andCSVData:csvDataRetrun andFile:filePath andKey:@"饮食"];
        }

        
    } andFail:^(NSMutableArray * _Nullable csv) {
        
        __strong typeof( &*self) strong = weak;
        if (csv[1]) {
        [strong bdRadiusForMetro:csv[1] andCSVData:csv andFile:filePath];
        }

    }];
    
}


#pragma mark - Radius 地铁
-(void)bdRadiusForMetro:(NSString *_Nonnull)location andCSVData:(NSMutableArray *_Nonnull) csvData andFile:(NSString *_Nonnull)filePath {
    
    __weak typeof( &*self) weak = self;
    [[BDRadiusSearchHandler alloc] radiusSearch:location andKeywork:@"地铁" andRadius:2000 andCSV:csvData andSuccess:^(BDRadiuSearchReturnModel * _Nonnull codeModel) {
        
        __strong typeof( &*self) strong = weak;
        
        NSArray<BDPOIModel *> *array = codeModel.array;
        
        NSString *destion = @"";
        
        for (BDPOIModel *model in array) {
            
            BDPOILocationModel *locationModel = model.location;
            destion = [destion stringByAppendingFormat:@"|%f,%f",locationModel.lat,locationModel.lng];
        }
        
        destion = [destion substringFromIndex:1];
        NSMutableArray *csvDataRetrun = codeModel.csv;
        csvDataRetrun[52] =[NSNumber numberWithInteger:array.count];
        
        if (csvDataRetrun[1]) {
        [strong bdRoutematrixMetro:csvDataRetrun[1] andDes:destion andCSVData:csvDataRetrun andFile:filePath andKey:@"地铁"];
        }


        
    } andFail:^(NSMutableArray * _Nullable csv) {
        
        __strong typeof( &*self) strong = weak;
        
//        strong.fail ++;
//        strong.failLb.text = [NSString stringWithFormat:@"数据处理失败:%ld",strong.fail];
        [strong exportCSV:csv andFilePath:filePath];
    }];
    
}

#pragma mark -路线规划 -商圈
-(void)bdRoutematrix:(NSString *_Nonnull)ori andDes:(NSString *_Nonnull) destion andCSVData:(NSMutableArray *_Nonnull) csvData andFile:(NSString *_Nonnull)filePath andKey:(NSString *_Nonnull) keywork{
    
    __weak typeof( &*self) weak = self;
    [[BDRouteSearchHandler alloc] routeSearch:ori andDest:destion andCSV:csvData andSuccess:^(BDRoutematrixReturnModel * _Nonnull codeModel) {
        __strong typeof( &*self) strong = weak;
        NSMutableArray *csvDataReturn = codeModel.csv;
        csvDataReturn[3] = codeModel.maxDis;
        csvDataReturn[4] = codeModel.minDis;
        csvDataReturn[5] = codeModel.avDis;
        csvDataReturn[6] = codeModel.avTime;
        
        [strong bdRadiusForBus:ori andCSVData:csvDataReturn andFile:filePath];
        
    } andFail:^(NSMutableArray * _Nullable csv) {
        __strong typeof( &*self) strong = weak;
        
        csv[3] = [NSNumber numberWithInt:0];
        csv[4] = [NSNumber numberWithInt:0];
        csv[5] = [NSNumber numberWithInt:0];
        csv[6] = [NSNumber numberWithInt:0];
        [strong bdRadiusForBus:ori andCSVData:csv andFile:filePath];
        
//        [strong exportCSV:csv andFilePath:filePath];
    }];
}

#pragma mark -路线规划 -公交
-(void)bdRoutematrixBus:(NSString *_Nonnull)ori andDes:(NSString *_Nonnull) destion andCSVData:(NSMutableArray *_Nonnull) csvData andFile:(NSString *_Nonnull)filePath andKey:(NSString *_Nonnull) keywork{
    
    __weak typeof( &*self) weak = self;
    [[BDRouteSearchHandler alloc] routeSearch:ori andDest:destion andCSV:csvData andSuccess:^(BDRoutematrixReturnModel * _Nonnull codeModel) {
        __strong typeof( &*self) strong = weak;
        NSMutableArray *csvDataReturn = codeModel.csv;
        csvDataReturn[8] = codeModel.maxDis;
        csvDataReturn[9] = codeModel.minDis;
        csvDataReturn[10] = codeModel.avDis;
        csvDataReturn[11] = codeModel.avTime;
        
        [strong bdRadiusForBank:ori andCSVData:csvDataReturn andFile:filePath];
        
    } andFail:^(NSMutableArray * _Nullable csv) {
        __strong typeof( &*self) strong = weak;
        
        csv[8] = [NSNumber numberWithInt:0];
        csv[9] = [NSNumber numberWithInt:0];
        csv[10] = [NSNumber numberWithInt:0];
        csv[11] = [NSNumber numberWithInt:0];
        
        [strong bdRadiusForBank:ori andCSVData:csv andFile:filePath];
        
    }];
}


#pragma mark -路线规划 -银行
-(void)bdRoutematrixBank:(NSString *_Nonnull)ori andDes:(NSString *_Nonnull) destion andCSVData:(NSMutableArray *_Nonnull) csvData andFile:(NSString *_Nonnull)filePath andKey:(NSString *_Nonnull) keywork{
    
    __weak typeof( &*self) weak = self;
    [[BDRouteSearchHandler alloc] routeSearch:ori andDest:destion andCSV:csvData andSuccess:^(BDRoutematrixReturnModel * _Nonnull codeModel) {
        __strong typeof( &*self) strong = weak;
        NSMutableArray *csvDataReturn = codeModel.csv;
        csvDataReturn[13] = codeModel.maxDis;
        csvDataReturn[14] = codeModel.minDis;
        csvDataReturn[15] = codeModel.avDis;
        csvDataReturn[16] = codeModel.avTime;
        
        [strong bdRadiusForSu:ori andCSVData:csvDataReturn andFile:filePath];
        
    } andFail:^(NSMutableArray * _Nullable csv) {
        __strong typeof( &*self) strong = weak;
        csv[13] = [NSNumber numberWithInt:0];
        csv[14] = [NSNumber numberWithInt:0];
        csv[15] = [NSNumber numberWithInt:0];
        csv[16] = [NSNumber numberWithInt:0];

        [strong bdRadiusForSu:ori andCSVData:csv andFile:filePath];
    }];
}


#pragma mark -路线规划 -学校
-(void)bdRoutematrixSchool:(NSString *_Nonnull)ori andDes:(NSString *_Nonnull) destion andCSVData:(NSMutableArray *_Nonnull) csvData andFile:(NSString *_Nonnull)filePath andKey:(NSString *_Nonnull) keywork{
    
    __weak typeof( &*self) weak = self;
    [[BDRouteSearchHandler alloc] routeSearch:ori andDest:destion andCSV:csvData andSuccess:^(BDRoutematrixReturnModel * _Nonnull codeModel) {
        __strong typeof( &*self) strong = weak;
        NSMutableArray *csvDataReturn = codeModel.csv;
        csvDataReturn[18] = codeModel.maxDis;
        csvDataReturn[19] = codeModel.minDis;
        csvDataReturn[20] = codeModel.avDis;
        csvDataReturn[21] = codeModel.avTime;
        
        [strong bdRadiusForHost:ori andCSVData:csvDataReturn andFile:filePath];
        
    } andFail:^(NSMutableArray * _Nullable csv) {
        __strong typeof( &*self) strong = weak;
        
        csv[18] = [NSNumber numberWithInt:0];
        csv[19] = [NSNumber numberWithInt:0];
        csv[20] = [NSNumber numberWithInt:0];
        csv[21] = [NSNumber numberWithInt:0];
        
        [strong bdRadiusForHost:ori andCSVData:csv andFile:filePath];
        
    }];
}


#pragma mark -路线规划 -医院
-(void)bdRoutematrixHost:(NSString *_Nonnull)ori andDes:(NSString *_Nonnull) destion andCSVData:(NSMutableArray *_Nonnull) csvData andFile:(NSString *_Nonnull)filePath andKey:(NSString *_Nonnull) keywork{
    
    __weak typeof( &*self) weak = self;
    [[BDRouteSearchHandler alloc] routeSearch:ori andDest:destion andCSV:csvData andSuccess:^(BDRoutematrixReturnModel * _Nonnull codeModel) {
        __strong typeof( &*self) strong = weak;
        NSMutableArray *csvDataReturn = codeModel.csv;
        csvDataReturn[23] = codeModel.maxDis;
        csvDataReturn[24] = codeModel.minDis;
        csvDataReturn[25] = codeModel.avDis;
        csvDataReturn[26] = codeModel.avTime;
        

        [strong bdRadiusForRelax:ori andCSVData:csvDataReturn andFile:filePath];
        
    } andFail:^(NSMutableArray * _Nullable csv) {
        __strong typeof( &*self) strong = weak;
        
        csv[23] = [NSNumber numberWithInt:0];
        csv[24] = [NSNumber numberWithInt:0];
        csv[25] = [NSNumber numberWithInt:0];
        csv[26] = [NSNumber numberWithInt:0];
        [strong bdRadiusForRelax:ori andCSVData:csv andFile:filePath];
    }];
}

#pragma mark -路线规划 -悠闲
-(void)bdRoutematrixRelax:(NSString *_Nonnull)ori andDes:(NSString *_Nonnull) destion andCSVData:(NSMutableArray *_Nonnull) csvData andFile:(NSString *_Nonnull)filePath andKey:(NSString *_Nonnull) keywork{
    
    __weak typeof( &*self) weak = self;
    [[BDRouteSearchHandler alloc] routeSearch:ori andDest:destion andCSV:csvData andSuccess:^(BDRoutematrixReturnModel * _Nonnull codeModel) {
        __strong typeof( &*self) strong = weak;
        NSMutableArray *csvDataReturn = codeModel.csv;
        csvDataReturn[28] = codeModel.maxDis;
        csvDataReturn[29] = codeModel.minDis;
        csvDataReturn[30] = codeModel.avDis;
        csvDataReturn[31] = codeModel.avTime;

        [strong bdRadiusForSuper:ori andCSVData:csvDataReturn andFile:filePath];
        
    } andFail:^(NSMutableArray * _Nullable csv) {
        __strong typeof( &*self) strong = weak;
        

        csv[28] = [NSNumber numberWithInt:0];
        csv[29] = [NSNumber numberWithInt:0];
        csv[30] = [NSNumber numberWithInt:0];
        csv[31] = [NSNumber numberWithInt:0];
        
        [strong bdRadiusForSuper:ori andCSVData:csv andFile:filePath];
    }];
}


#pragma mark -路线规划 -超市
-(void)bdRoutematrixSuper:(NSString *_Nonnull)ori andDes:(NSString *_Nonnull) destion andCSVData:(NSMutableArray *_Nonnull) csvData andFile:(NSString *_Nonnull)filePath andKey:(NSString *_Nonnull) keywork{
    
    __weak typeof( &*self) weak = self;
    [[BDRouteSearchHandler alloc] routeSearch:ori andDest:destion andCSV:csvData andSuccess:^(BDRoutematrixReturnModel * _Nonnull codeModel) {
        __strong typeof( &*self) strong = weak;
        NSMutableArray *csvDataReturn = codeModel.csv;
        csvDataReturn[33] = codeModel.maxDis;
        csvDataReturn[34] = codeModel.minDis;
        csvDataReturn[35] = codeModel.avDis;
        csvDataReturn[36] = codeModel.avTime;
        
        [strong bdRadiusForPublic:ori andCSVData:csvDataReturn andFile:filePath];
        
    } andFail:^(NSMutableArray * _Nullable csv) {
        __strong typeof( &*self) strong = weak;
        
        strong.fail ++;
        strong.failLb.text = [NSString stringWithFormat:@"数据处理失败:%ld",strong.fail];
        csv[33] = [NSNumber numberWithInt:0];
        csv[34] = [NSNumber numberWithInt:0];
        csv[35] = [NSNumber numberWithInt:0];
        csv[36] = [NSNumber numberWithInt:0];
        [strong bdRadiusForPublic:ori andCSVData:csv andFile:filePath];
        
    }];
}


#pragma mark -路线规划 -治安
-(void)bdRoutematrixPubilc:(NSString *_Nonnull)ori andDes:(NSString *_Nonnull) destion andCSVData:(NSMutableArray *_Nonnull) csvData andFile:(NSString *_Nonnull)filePath andKey:(NSString *_Nonnull) keywork{
    
    __weak typeof( &*self) weak = self;
    [[BDRouteSearchHandler alloc] routeSearch:ori andDest:destion andCSV:csvData andSuccess:^(BDRoutematrixReturnModel * _Nonnull codeModel) {
        __strong typeof( &*self) strong = weak;
        NSMutableArray *csvDataReturn = codeModel.csv;
        csvDataReturn[38] = codeModel.maxDis;
        csvDataReturn[39] = codeModel.minDis;
        csvDataReturn[40] = codeModel.avDis;
        csvDataReturn[41] = codeModel.avTime;
        

        [strong bdRadiusForHouse:ori andCSVData:csvDataReturn andFile:filePath];
        
    } andFail:^(NSMutableArray * _Nullable csv) {
        __strong typeof( &*self) strong = weak;
        
        csv[38] = [NSNumber numberWithInt:0];
        csv[39] = [NSNumber numberWithInt:0];
        csv[40] = [NSNumber numberWithInt:0];
        csv[41] = [NSNumber numberWithInt:0];
        
        
        [strong bdRadiusForHouse:ori andCSVData:csv andFile:filePath];
        
    }];
}


#pragma mark -路线规划 -家政
-(void)bdRoutematrixHouse:(NSString *_Nonnull)ori andDes:(NSString *_Nonnull) destion andCSVData:(NSMutableArray *_Nonnull) csvData andFile:(NSString *_Nonnull)filePath andKey:(NSString *_Nonnull) keywork{
    
    __weak typeof( &*self) weak = self;
    [[BDRouteSearchHandler alloc] routeSearch:ori andDest:destion andCSV:csvData andSuccess:^(BDRoutematrixReturnModel * _Nonnull codeModel) {
        __strong typeof( &*self) strong = weak;
        NSMutableArray *csvDataReturn = codeModel.csv;
        csvDataReturn[43] = codeModel.maxDis;
        csvDataReturn[44] = codeModel.minDis;
        csvDataReturn[45] = codeModel.avDis;
        csvDataReturn[46] = codeModel.avTime;
        
        [strong bdRadiusForDiet:ori andCSVData:csvDataReturn andFile:filePath];
        
    } andFail:^(NSMutableArray * _Nullable csv) {
        __strong typeof( &*self) strong = weak;
        
        csv[43] = [NSNumber numberWithInt:0];
        csv[44] = [NSNumber numberWithInt:0];
        csv[45] = [NSNumber numberWithInt:0];
        csv[46] = [NSNumber numberWithInt:0];
        [strong bdRadiusForDiet:ori andCSVData:csv andFile:filePath];
    }];
}


#pragma mark -路线规划 -饮食
-(void)bdRoutematrixDiet:(NSString *_Nonnull)ori andDes:(NSString *_Nonnull) destion andCSVData:(NSMutableArray *_Nonnull) csvData andFile:(NSString *_Nonnull)filePath andKey:(NSString *_Nonnull) keywork{
    
    __weak typeof( &*self) weak = self;
    [[BDRouteSearchHandler alloc] routeSearch:ori andDest:destion andCSV:csvData andSuccess:^(BDRoutematrixReturnModel * _Nonnull codeModel) {
        __strong typeof( &*self) strong = weak;
        NSMutableArray *csvDataReturn = codeModel.csv;
        csvDataReturn[48] = codeModel.maxDis;
        csvDataReturn[49] = codeModel.minDis;
        csvDataReturn[50] = codeModel.avDis;
        csvDataReturn[51] = codeModel.avTime;
        
        [strong bdRadiusForMetro:ori andCSVData:csvDataReturn andFile:filePath];
        
    } andFail:^(NSMutableArray * _Nullable csv) {
        __strong typeof( &*self) strong = weak;

        csv[48] = [NSNumber numberWithInt:0];
        csv[49] = [NSNumber numberWithInt:0];
        csv[50] = [NSNumber numberWithInt:0];
        csv[51] = [NSNumber numberWithInt:0];
        [strong bdRadiusForMetro:ori andCSVData:csv andFile:filePath];
        
    }];
}


#pragma mark -路线规划 -地铁
-(void)bdRoutematrixMetro:(NSString *_Nonnull)ori andDes:(NSString *_Nonnull) destion andCSVData:(NSMutableArray *_Nonnull) csvData andFile:(NSString *_Nonnull)filePath andKey:(NSString *_Nonnull) keywork{
    
    __weak typeof( &*self) weak = self;
    [[BDRouteSearchHandler alloc] routeSearch:ori andDest:destion andCSV:csvData andSuccess:^(BDRoutematrixReturnModel * _Nonnull codeModel) {
        __strong typeof( &*self) strong = weak;
        NSMutableArray *csvDataReturn = codeModel.csv;
        csvDataReturn[53] = codeModel.maxDis;
        csvDataReturn[54] = codeModel.minDis;
        csvDataReturn[55] = codeModel.avDis;
        csvDataReturn[56] = codeModel.avTime;
        
        [strong exportCSV:csvDataReturn andFilePath:filePath ];
        
    } andFail:^(NSMutableArray * _Nullable csv) {
        __strong typeof( &*self) strong = weak;
        
        csv[53] = [NSNumber numberWithInt:0];
        csv[54] = [NSNumber numberWithInt:0];
        csv[55] = [NSNumber numberWithInt:0];
        csv[56] = [NSNumber numberWithInt:0];
        
        [strong exportCSV:csv andFilePath:filePath ];
        
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    NSString *header = @",,商圈,,,,,公交,,,,,银行,,,,,学校,,,,,医院,,,,,休闲,,,,,商超,,,,,治安,,,,,家政,,,,,餐饮,,,,,地铁,,,,,,,\r\n楼盘名称,,数量,最远距离,最近距离,平均距离,通勤时间,数量,最远距离,最近距离,平均距离,通勤时间,数量,最远距离,最近距离,平均距离,通勤时间,数量,最远距离,最近距离,平均距离,通勤时间,数量,最远距离,最近距离,平均距离,通勤时间,数量,最远距离,最近距离,平均距离,通勤时间,数量,最远距离,最近距离,平均距离,通勤时间,数量,最远距离,最近距离,平均距离,通勤时间,数量,最远距离,最近距离,平均距离,通勤时间,数量,最远距离,最近距离,平均距离,通勤时间,数量,最远距离,最近距离,平均距离,通勤时间,经度,纬度,地址\r\n";
    
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
        self.writeLb.text = [NSString stringWithFormat:@"写入数量:%ld",self.write];
        self.write ++;
        

        
    }
}

@end
