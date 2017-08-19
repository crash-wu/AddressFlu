//
//  AnalysisViewController.m
//  AddressFlu
//
//  Created by 吴小星 on 2017/6/7.
//  Copyright © 2017年 crash. All rights reserved.
//

#import "AnalysisHTMLViewController.h"
#import "TubarHTMLModel.h"
#import "GetTubarHTMLHandler.h"
#import <Masonry/Masonry.h>
#import "parseCSV.h"

@interface AnalysisHTMLViewController ()

@property(nonnull,strong,nonatomic) UILabel *totalLb;


/**
 写入数据
 */
@property(nonatomic,strong,nonnull) UILabel *writeLb;

@property(nonatomic,assign) __block NSInteger write;


/**
 POI 搜索
 */
@property(nonatomic,strong,nonnull) UILabel *poiSearchLb;


/**
 POI 搜索失败
 */
@property(nonatomic,strong,nonnull) UILabel *poiErrorLb;


/**
 POI搜索
 */
@property(nonatomic,assign) NSInteger poiSearchNum;

/**
 poi
 */
@property(nonatomic,assign) NSInteger poiError;


/**
 百度坐标转换
 */
@property(nonnull,strong,nonatomic) UILabel *bdLocationLb;


/**
 百度坐标转换失败
 */
@property(nonnull,strong,nonatomic) UILabel *bdLocation_errorlb;


/**
 百度坐标转换成功
 */
@property(nonatomic,assign) __block NSInteger bdcode;


/**
 百度坐标转换成功失败
 */
@property(nonatomic,assign) __block NSInteger bdErrorCode;



/**
 wgs84坐标转换
 */
@property(nonnull,strong,nonatomic) UILabel *wgs84Lb;


/**
 wgs84坐标转换失败
 */
@property(nonatomic,strong,nonnull) UILabel *wgs84_errorlb;

/**
 wgs84坐标转换成功
 */
@property(nonatomic,assign) __block NSInteger wgs84code;

/**
 wgs84坐标转换成功失败
 */
@property(nonatomic,assign) __block NSInteger wgs84code_error;



/**
 图吧坐标系转换高德
 */
@property(nonatomic,strong,nonnull) UILabel *mapbarToGDLb;

@property(nonatomic,strong,nonnull) UILabel *mapbarToGDErrorLb;

@property(nonatomic,assign) __block NSInteger mapbarToGD;

@property(nonatomic,assign) __block NSInteger mapBarToGDError;



/**
 逆地址编码
 */
@property(nonatomic,nonnull,strong) UILabel *decodeLb;

/**
 逆地址编码失败
 */
@property(nonnull,strong,nonatomic) UILabel *decodeErrroLb;

/**
 逆地址编码
 */
@property(nonatomic,assign)__block NSInteger decode;

/**
 逆地址编码失败
 */
@property(nonatomic,assign) __block NSInteger decodeError;


@property(nonatomic,strong,nonnull) UILabel *emptyLb;


@property(nonatomic,assign) __block NSInteger empty;



@property(nonatomic,strong,nonnull) UITextView *textView;


@end

@implementation AnalysisHTMLViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.automaticallyAdjustsScrollViewInsets = true;
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.totalLb = [[UILabel alloc]initWithFrame:CGRectZero];
    [self.view addSubview:self.totalLb];
    
    self.totalLb.textColor = [UIColor blackColor];
    self.totalLb.font  = [UIFont systemFontOfSize:14.f];
    
    [self.totalLb mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.equalTo(self.view.mas_top).with.offset(20);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.height.equalTo(@[@20]);
    }];
    
    
    self.writeLb = [[UILabel alloc]initWithFrame:CGRectZero];
    [self.view addSubview:self.writeLb];
    
    [self.writeLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.totalLb.mas_bottom).with.offset(10);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.height.equalTo(@[@20]);
        
    }];
    
    self.writeLb.textColor = [UIColor blackColor];
    self.writeLb.font  = [UIFont systemFontOfSize:14.f];
    
    self.poiSearchLb = [[UILabel alloc]initWithFrame:CGRectZero];
    [self.view addSubview:self.poiSearchLb];
    [self.poiSearchLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.writeLb.mas_bottom).with.offset(10);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.height.equalTo(@[@20]);
        
    }];
    
    self.poiSearchLb.textColor = [UIColor blackColor];
    self.poiSearchLb.font  = [UIFont systemFontOfSize:14.f];
    
    
    self.poiErrorLb = [[UILabel alloc]initWithFrame:CGRectZero];
    [self.view addSubview:self.poiErrorLb];
    
    [self.poiErrorLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.poiSearchLb.mas_bottom).with.offset(10);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.height.equalTo(@[@20]);
        
    }];
    
    self.poiErrorLb.textColor = [UIColor redColor];
    self.poiErrorLb.font  = [UIFont systemFontOfSize:14.f];

    
    self.mapbarToGDLb = [[UILabel alloc]initWithFrame:CGRectZero];
    [self.view addSubview:self.mapbarToGDLb];
    
    [self.mapbarToGDLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.poiErrorLb.mas_bottom).with.offset(10);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.height.equalTo(@[@20]);
        
    }];
    self.mapbarToGDLb.textColor = [UIColor blackColor];
    self.mapbarToGDLb.font  = [UIFont systemFontOfSize:14.f];
    
    

    self.mapbarToGDErrorLb = [[UILabel alloc]initWithFrame:CGRectZero];
    [self.view addSubview:self.mapbarToGDErrorLb];
    [self.mapbarToGDErrorLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mapbarToGDLb.mas_bottom).with.offset(10);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.height.equalTo(@[@20]);
        
    }];
    self.mapbarToGDErrorLb.textColor = [UIColor redColor];
    self.mapbarToGDErrorLb.font  = [UIFont systemFontOfSize:14.f];
    

    
    self.bdLocationLb = [[UILabel alloc]initWithFrame:CGRectZero];
    [self.view addSubview:self.bdLocationLb];
    [self.bdLocationLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mapbarToGDErrorLb.mas_bottom).with.offset(10);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.height.equalTo(@[@20]);
        
    }];
    self.bdLocationLb.textColor = [UIColor blackColor];
    self.bdLocationLb.font  = [UIFont systemFontOfSize:14.f];
    
    
    self.bdLocation_errorlb = [[UILabel alloc]initWithFrame:CGRectZero];
    [self.view addSubview:self.bdLocation_errorlb];
    [self.bdLocation_errorlb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bdLocationLb.mas_bottom).with.offset(10);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.height.equalTo(@[@20]);
        
    }];
    self.bdLocation_errorlb.textColor = [UIColor redColor];
    self.bdLocation_errorlb.font  = [UIFont systemFontOfSize:14.f];
    
    
    
    
    self.wgs84Lb = [[UILabel alloc]initWithFrame:CGRectZero];
    [self.view addSubview:self.wgs84Lb];
    [self.wgs84Lb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bdLocation_errorlb.mas_bottom).with.offset(10);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.height.equalTo(@[@20]);
        
    }];
    self.wgs84Lb.textColor = [UIColor blackColor];
    self.wgs84Lb.font  = [UIFont systemFontOfSize:14.f];
    
    
    
    self.wgs84_errorlb = [[UILabel alloc]initWithFrame:CGRectZero];
    [self.view addSubview:self.wgs84_errorlb];
    [self.wgs84_errorlb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.wgs84Lb.mas_bottom).with.offset(10);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.height.equalTo(@[@20]);
        
    }];
    self.wgs84_errorlb.textColor = [UIColor redColor];
    self.wgs84_errorlb.font  = [UIFont systemFontOfSize:14.f];
    
    
    
    self.decodeLb = [[UILabel alloc]initWithFrame:CGRectZero];
    [self.view addSubview:self.decodeLb];
    [self.decodeLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.wgs84_errorlb.mas_bottom).with.offset(10);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.height.equalTo(@[@20]);
        
    }];
    self.decodeLb.textColor = [UIColor blackColor];
    self.decodeLb.font  = [UIFont systemFontOfSize:14.f];
    
    
    
    self.decodeErrroLb = [[UILabel alloc]initWithFrame:CGRectZero];
    [self.view addSubview:self.decodeErrroLb];
    [self.decodeErrroLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.decodeLb.mas_bottom).with.offset(10);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.height.equalTo(@[@20]);
        
    }];
    
    self.decodeErrroLb.textColor = [UIColor redColor];
    self.decodeErrroLb.font  = [UIFont systemFontOfSize:14.f];
    
    
    self.emptyLb = [[UILabel alloc]initWithFrame:CGRectZero];
    [self.view addSubview:self.emptyLb];
    [self.emptyLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.decodeErrroLb.mas_bottom).with.offset(10);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.height.equalTo(@[@20]);
        
    }];
    
    self.emptyLb.textColor = [UIColor redColor];
    self.emptyLb.font  = [UIFont systemFontOfSize:14.f];
    
    
    self.textView=[ [UITextView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:self.textView];
    
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.equalTo(self.emptyLb.mas_bottom).with.offset(20);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.height.equalTo(@[@100]);
    }];
    self.textView.textColor = [UIColor blackColor];
    self.textView.font = [UIFont systemFontOfSize:13.f];
    
    UIBarButtonItem *rightBarBtn = [[UIBarButtonItem alloc]initWithTitle:@"开始读取" style:UIBarButtonItemStylePlain  target:self action:@selector(rightBtn:)];
    self.navigationItem.rightBarButtonItem = rightBarBtn;
    self.navigationController.title = self.cityName;
    [self setlable];
}


-(void)setlable{
    self.totalLb.text = @"获取数据个数:0";
    self.writeLb.text = @"写入数据:0";
    self.poiSearchLb.text = @"POI搜索成功:0";
    self.poiErrorLb.text = @"POI搜索失败成功:0";
    self.bdLocationLb.text = @"百度坐标转换:0";
    self.bdLocation_errorlb.text = @"百度坐标转换失败:0";
    self.wgs84Lb.text = @"百度poi:0";
    self.wgs84_errorlb.text = @"百度POI换失败:0";
    self.mapbarToGDLb.text = @"map转换gd成功:0";
    self.mapbarToGDErrorLb.text = @"map转换gd失败:0";
    self.decodeLb.text = @"高德逆地址成功:0";
    self.decodeErrroLb.text = @"高德逆地址失败:0";
    self.emptyLb.text = @"图吧坐标为空:0";
    

    self.write = 1;
    self.poiSearchNum = 1;
    self.poiError = 1;
    self.bdcode = 1;
    self.bdErrorCode = 1;
    self.wgs84code = 1;
    self.wgs84code_error = 1;
    self.mapbarToGD = 1;
    self.mapBarToGDError = 1;
    self.decode = 1;
    self.decodeError = 1;
    self.empty = 1;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
   // [self setTilte:self.cityName];
}

-(void)rightBtn:(UIButton *)button{
    
    //创建csv文件，接收处理后的csv数据流
    NSString *filePath = [self createFile:[NSString stringWithFormat:@"%@-急诊部",self.cityName]];
    
    
    self.textView.text = filePath;
    
    //写入csv数据表头
    [self exportCSVHeader:filePath];
    
    NSString *url = [NSString stringWithFormat:@"http://poi.mapbar.com/%@/DD0",self.city];
    
    //  D20 社区医疗 -
    //  D30 药店
    //  D50 综合医院 -
    //  D60 专科医院 -
    //  D70 急救中心 -
    //  D80 康复中心 -
    //  DA0 诊所 -
    //  DB1 疾病预防中心 -
    //  DD0 急诊部 -
    
    __weak typeof(&*self) weak = self;
    
    [[GetTubarHTMLHandler alloc] analysisHTMLData:url success:^(NSMutableArray<TubarHTMLModel *> *htmlModes) {
        

        __strong typeof(&*self) strong = weak;
        strong.totalLb.text = [NSString stringWithFormat:@"获取数据个数:%ld",htmlModes.count];
        
        for (TubarHTMLModel *model  in   htmlModes) {
            NSMutableArray *array = [self getMutableArray];
            if (model.name) {
                array[0] = model.name;
            }
            
            if (model.location) {
                array[12] = model.location;
            }

//            name,address,coor,coor-gd,pname,cname,dname,vname,adrress-gd,status,fitler,fitler-grade,location,location-tb,url
            //延时30毫秒执行，避免出现账号被锁
            [NSThread sleepForTimeInterval:0.03];
            
            [strong gdPOISearch:model.name andCity:self.cityName andCSVData:array andFile:filePath];
        }
        
    } andFail:^(NSError * _Nullable error) {
        self.totalLb.text = @"获取失败!";
        
    }];
    
}

-(void)gdPOISearch:(NSString *_Nonnull) keywork andCity:(NSString *_Nonnull) city andCSVData:(NSMutableArray *_Nonnull) csvData andFile:(NSString *_Nonnull)filePath{
    
    
    __weak typeof( &*self) weak = self;
    
    [[GDPOISearchHandler alloc] poiSearch:keywork andCity:city andCSV:csvData andSuccess:^(GDPOIReturnModel * _Nonnull codeModel) {
        
        __strong typeof( &*self) strong = weak;
        GDPOIModel * poiModel = codeModel.poiModel;
        NSMutableArray *array = codeModel.csv;
        
//name,address,coor,coor-gd,pname,cname,dname,vname,adrress-gd,status,fitler,fitler-grade,location,location-tb,url
        
        if (poiModel.address) {
            array[1] = poiModel.address;
        }
        
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
        
        array[9] = @"2";
        [strong  gdDecode:array[3] andCSV:codeModel.csv andFile:filePath andStatus:2 isChangeBD:YES];

        strong.poiSearchLb.text = [NSString stringWithFormat:@"poi搜索成功:%ld",self.poiSearchNum];
        strong.poiSearchNum ++;

        
    } andFail:^(NSMutableArray * _Nullable csv) {

            
        __strong typeof(&*self) strong = weak;
        
        strong.poiErrorLb.text = [NSString stringWithFormat:@"poi搜索失败:%ld",self.poiError];
        strong.poiError ++;

        //百度坐标POI搜索
        
        [strong bdPOISearch:keywork andCity:city andCSVData:csv andFile:filePath];
    }];
    
}


-(void)bdPOISearch:(NSString *_Nonnull) keywork andCity:(NSString *_Nonnull) city andCSVData:(NSMutableArray *_Nonnull) csvData andFile:(NSString *_Nonnull)filePath{
    
    
    __weak typeof( &*self) weak = self;
    [[BDPOISearchHandler alloc] poiSearch:keywork andCity:city andCSV:csvData andSuccess:^(BDPOIReturnModel * _Nonnull codeModel) {
        
        __strong typeof(&*self) strong = weak;
        
        BDPOIModel *bdmodel = codeModel.poiModel;
        BDPOILocationModel *locationModle = bdmodel.location;
        NSString *location = [NSString stringWithFormat:@"%lf,%lf",locationModle.lng,locationModle.lat];
        
//name,address,coor,coor-gd,pname,cname,dname,vname,adrress-gd,status,fitler,fitler-grade,location,location-tb,url
        
        NSMutableArray *array = codeModel.csv;
        array[2] = location;
        strong.wgs84Lb.text = [NSString stringWithFormat:@"百度POI搜索成功:%ld",strong.wgs84code];
        strong.wgs84code ++;
        
        [strong mapbarToGD:array andFile:filePath andLocationType:@"baidu" isChangeBD:NO isStatus:2];
        
    } andFail:^(NSMutableArray * _Nullable csv) {
        __strong typeof( &*self) strong = weak;
        strong.wgs84_errorlb.text = [NSString stringWithFormat:@"百度POI搜索失败:%ld",strong.wgs84code_error];
        strong.wgs84code_error ++;
        
        NSString *location = csv[12];
        
        if (location.length > 0 ) {
            [weak mapbarToGD:csv andFile:filePath andLocationType:@"mapbar" isChangeBD:YES isStatus:1];
        }else{
            weak.emptyLb.text = [NSString stringWithFormat:@"图吧坐标为空:%ld",self.empty];
            weak.empty ++;
            
        }

    }];
}


-(NSMutableArray *_Nonnull)getMutableArray{
//    gd,status,fitler,fitler-grade,location
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:14];
    for (int i = 0; i< 14; i++) {
        array[i] = @"";
    }
    return array;
}

/**
 通过图吧坐标处理

 @param csvData CSV数组
 @param filePath 保存文件路径
 */
-(void)mapbarToGD:(NSMutableArray *)csvData andFile:(NSString *_Nonnull) filePath andLocationType:(NSString *_Nonnull) locationType isChangeBD:(BOOL) chageBD isStatus:(NSInteger) status{
    
    __weak typeof(&*self) weak = self;
    
    NSString *location = @"";
    
    if (chageBD) {
        location = csvData[12];
    }else{
        location = csvData[2];
    }
    
//    name,address,coor,coor-gd,pname,cname,dname,vname,adrress-gd,status,fitler,fitler-grade,location,location-tb,url
    
    [[Ws84convertToGDHandler alloc]ws84Convert:location andcoordsys:locationType andCSVData:csvData andSuccess:^(Ws84ConvertReturnModel * _Nonnull convertModel) {

            
            //改变已经执行坐标转换的数据条目提示文本信息
            self.mapbarToGDLb.text = [NSString stringWithFormat:@"转高德坐标转换成功:%ld",weak.mapbarToGD];
            
            weak.mapbarToGD ++;

        Ws84ConvertToGDModel *ws84Model = convertModel.convertModel;
        convertModel.csvData[3] = ws84Model.locations;
        

            //高德逆地址编码
        [self gdDecode:ws84Model.locations andCSV:convertModel.csvData andFile:filePath andStatus:status isChangeBD:chageBD];


        
    } andFail:^(NSError * _Nonnull error) {

            
            //改变已经执行坐标转换的数据条目提示文本信息
            self.mapbarToGDErrorLb.text = [NSString stringWithFormat:@"mapbar转高德坐标转换失败:%ld",weak.mapBarToGDError];
            
            weak.mapBarToGDError ++;

        
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
        strong.decodeLb.text = [NSString stringWithFormat:@"逆地址编码:%ld",strong.decode];
        strong.decode ++;

        
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
        
        if (changeBD) {
            //百度 = @坐标转换
            [self tranfromBD:csv[3] andCSV:csv andFile:file];
        }else{

            [self exportCSV:csv andFilePath:file];
        }
        
    } andFail:^(NSError * _Nonnull error) {
        
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
        [strong exportCSV:bdcsvData andFilePath:filePath];
        
        
    } andFail:^(NSMutableArray * _Nonnull csvData) {
        
        //转换wgs坐标系
        weak.bdLocation_errorlb.text = [NSString stringWithFormat:@"百度坐标转换失败:%ld",self.bdErrorCode];
        weak.bdErrorCode ++;

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
        NSString *location = csvData[2];
        if (location) {
            csvData[12] = location;
        }
        [self exportCSV:csvData andFilePath:filePath];
        dispatch_async(dispatch_get_main_queue(), ^{
            strong.wgs84_errorlb.text = [NSString stringWithFormat:@"wgs84坐标转换失败:%ld",strong.wgs84code_error];
            strong.wgs84code_error ++;
        });
        
    }];
}




/**
 创建文件
 @param path 保存文件名称
 
 @return 所创建的文件在沙盒中的路径
 */
- (NSString *_Nonnull)createFile:(NSString *_Nonnull)path{
    
    //将处理好的csv数据流写入到沙盒中的Documents目录
    // 获取Documents目录路径
    NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    
    
    NSString *fileName = [NSString stringWithFormat:@"%@.csv",path];
    //获取完整的写入文件路径
    NSString *filePath = [docDir stringByAppendingPathComponent:fileName];
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
//    NSString *header = @"name,address,coor,coor-gd,pname,cname,dname,vname,adrress-gd,status,fitler,fitler-grade,location,location-tb,url\r\n";
    NSString *header = @"name,address,coor,coor-tentect,pname,cname,dname,vname,adrress-gd,status,shopBindType,fitler,fitler-grade,location_type,filter-grade,name-source\r\n";

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
    
//    NSString *header = @"name,address,coor,coor-gd,pname,cname,dname,vname,adrress-gd,status,fitler,fitler-grade,location,location-tb,url\r\n";

    
//    NSString *header = @"name,address,coor,coor-tentect,pname,cname,dname,vname,adrress-gd,status,shopBindType,fitler,fitler-grade,location_type,filter-grade,name-source\r\n";
    
    
    NSMutableArray *array = [NSMutableArray array];
    
    array[0] = csvData[0];
    array[1] = csvData[1];
    array[2] = csvData[2];
    array[3] = csvData[3];
    array[4] = csvData[4];
    array[5] = csvData[5];
    array[6] = csvData[6];
    array[7] = csvData[7];
    array[8] = csvData[8];
    array[9] = csvData[9];
    array[10] = @"0";

    
    if (![output hasSpaceAvailable]) {
        NSLog(@"没有足够可用空间");
    } else {
        
        NSString *csvString = @"";
        
        int i = 0;
        for (NSString *csv in array) {

            
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
        
        self.writeLb.text = [NSString stringWithFormat:@"写入成功:%ld",self.write];
        self.write ++;
        
    }
}



@end
