//
//  BudongchangHandler.m
//  AddressFlu
//
//  Created by 吴小星 on 2017/8/19.
//  Copyright © 2017年 crash. All rights reserved.
//

#import "BudongchangHandler.h"

@interface BudongchangHandler ()

@property(nonatomic,strong,nullable) Success success;

@property(nonatomic,strong,nullable) Fail fail;

@end

@implementation BudongchangHandler





#pragma -POI

-(void)bdPOISearch:(NSString *_Nonnull) keywork andCity:(NSString *_Nonnull) city andCSVData:(NSMutableArray *_Nonnull) csvData andFile:(NSString *_Nonnull)filePath success:(nullable void(^)(NSMutableArray *_Nullable csv))success fail:(nullable void(^) (NSMutableArray *_Nullable csv) )fail{
    
    self.success = success;
    self.fail = fail;

    __weak typeof( &*self) weak = self;
    [[BDPOISearchHandler alloc] poiSearch:keywork andCity:city andCSV:csvData andSuccess:^(BDPOIReturnModel * _Nonnull codeModel) {
        
        __strong typeof(&*self) strong = weak;
        
        BDPOIModel *bdmodel = codeModel.poiModel;
        BDPOILocationModel *locationModle = bdmodel.location;
        NSString *location = [NSString stringWithFormat:@"%lf,%lf",locationModle.lat,locationModle.lng];
        [strong  bdRadiusForBusiness:location andCSVData:csvData andFile:filePath];
        
        
        
    } andFail:^(NSMutableArray * _Nullable csv) {

                
        fail(nil);
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
        csvDataRetrun[1] =[NSNumber numberWithInteger:array.count];
        
        [strong bdRoutematrix:location andDes:destion andCSVData:csvDataRetrun andFile:filePath andKey:@"商圈"];
        
    } andFail:^(NSMutableArray * _Nullable csv) {
        
        __strong typeof( &*self) strong = weak;
        
        [strong bdRadiusForBus:location andCSVData:csv andFile:filePath];
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
        csvDataRetrun[6] =[NSNumber numberWithInteger:array.count];
        
        [strong bdRoutematrixBus:location andDes:destion andCSVData:csvDataRetrun andFile:filePath andKey:@"公交"];
        
    } andFail:^(NSMutableArray * _Nullable csv) {
        
        __strong typeof( &*self) strong = weak;
        
        [strong bdRadiusForBank:location andCSVData:csv andFile:filePath];
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
        csvDataRetrun[11] =[NSNumber numberWithInteger:array.count];
        
        [strong bdRoutematrixBank :location andDes:destion andCSVData:csvDataRetrun andFile:filePath andKey:@"银行"];
        
    } andFail:^(NSMutableArray * _Nullable csv) {
        
        __strong typeof( &*self) strong = weak;
        [strong bdRadiusForSu:location andCSVData:csv andFile:filePath];
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
        csvDataRetrun[16] =[NSNumber numberWithInteger:array.count];
        
        [strong bdRoutematrixSchool:location andDes:destion andCSVData:csvDataRetrun andFile:filePath andKey:@"学校"];
        
    } andFail:^(NSMutableArray * _Nullable csv) {
        
        __strong typeof( &*self) strong = weak;
        
        [strong bdRadiusForHost:location andCSVData:csv andFile:filePath];
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
        csvDataRetrun[21] =[NSNumber numberWithInteger:array.count];
        
        [strong bdRoutematrixHost:location andDes:destion andCSVData:csvDataRetrun andFile:filePath andKey:@"医院"];
        
    } andFail:^(NSMutableArray * _Nullable csv) {
        
        __strong typeof( &*self) strong = weak;
        
        [strong bdRadiusForRelax:location andCSVData:csv andFile:filePath];
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
        csvDataRetrun[26] =[NSNumber numberWithInteger:array.count];
        
        [strong bdRoutematrixRelax:location andDes:destion andCSVData:csvDataRetrun andFile:filePath andKey:@"休闲"];
        
    } andFail:^(NSMutableArray * _Nullable csv) {
        
        __strong typeof( &*self) strong = weak;
        
        [strong bdRadiusForSuper:location andCSVData:csv andFile:filePath];
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
        csvDataRetrun[31] =[NSNumber numberWithInteger:array.count];
        
        [strong bdRoutematrixSuper:location andDes:destion andCSVData:csvDataRetrun andFile:filePath andKey:@"超市"];
        
    } andFail:^(NSMutableArray * _Nullable csv) {
        
        __strong typeof( &*self) strong = weak;
        
        [strong bdRadiusForPublic:location andCSVData:csv andFile:filePath];
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
        csvDataRetrun[36] =[NSNumber numberWithInteger:array.count];
        
        [strong bdRoutematrixPubilc:location andDes:destion andCSVData:csvDataRetrun andFile:filePath andKey:@"治安"];
        
    } andFail:^(NSMutableArray * _Nullable csv) {
        
        __strong typeof( &*self) strong = weak;
        
        [strong bdRadiusForHouse:location andCSVData:csv andFile:filePath];
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
        csvDataRetrun[41] =[NSNumber numberWithInteger:array.count];
        
        [strong bdRoutematrixHouse:location andDes:destion andCSVData:csvDataRetrun andFile:filePath andKey:@"家政"];
        
    } andFail:^(NSMutableArray * _Nullable csv) {
        
        __strong typeof( &*self) strong = weak;
        
        [strong bdRadiusForDiet:location andCSVData:csv andFile:filePath];
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
        csvDataRetrun[46] =[NSNumber numberWithInteger:array.count];
        
        [strong bdRoutematrixDiet:location andDes:destion andCSVData:csvDataRetrun andFile:filePath andKey:@"饮食"];
        
    } andFail:^(NSMutableArray * _Nullable csv) {
        
        __strong typeof( &*self) strong = weak;
        
        [strong bdRadiusForMetro:location andCSVData:csv andFile:filePath];
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
        csvDataRetrun[51] =[NSNumber numberWithInteger:array.count];
        
        [strong bdRoutematrixMetro:location andDes:destion andCSVData:csvDataRetrun andFile:filePath andKey:@"地铁"];
        
    } andFail:^(NSMutableArray * _Nullable csv) {
        
        __strong typeof( &*self) strong = weak;
//        
//        [strong exportCSV:csv andFilePath:filePath];
        self.fail(csv);
    }];
    
}

#pragma mark -路线规划 -商圈
-(void)bdRoutematrix:(NSString *_Nonnull)ori andDes:(NSString *_Nonnull) destion andCSVData:(NSMutableArray *_Nonnull) csvData andFile:(NSString *_Nonnull)filePath andKey:(NSString *_Nonnull) keywork{
    
    __weak typeof( &*self) weak = self;
    [[BDRouteSearchHandler alloc] routeSearch:ori andDest:destion andCSV:csvData andSuccess:^(BDRoutematrixReturnModel * _Nonnull codeModel) {
        __strong typeof( &*self) strong = weak;
        NSMutableArray *csvDataReturn = codeModel.csv;
        csvDataReturn[2] = codeModel.maxDis;
        csvDataReturn[3] = codeModel.minDis;
        csvDataReturn[4] = codeModel.avDis;
        csvDataReturn[5] = codeModel.avTime;
        
        [strong bdRadiusForBus:ori andCSVData:csvDataReturn andFile:filePath];
        
    } andFail:^(NSMutableArray * _Nullable csv) {
        __strong typeof( &*self) strong = weak;
        
        csv[2] = [NSNumber numberWithInt:0];
        csv[3] = [NSNumber numberWithInt:0];
        csv[4] = [NSNumber numberWithInt:0];
        csv[5] = [NSNumber numberWithInt:0];
        [strong bdRadiusForBus:ori andCSVData:csv andFile:filePath];
    }];
}

#pragma mark -路线规划 -公交
-(void)bdRoutematrixBus:(NSString *_Nonnull)ori andDes:(NSString *_Nonnull) destion andCSVData:(NSMutableArray *_Nonnull) csvData andFile:(NSString *_Nonnull)filePath andKey:(NSString *_Nonnull) keywork{
    
    __weak typeof( &*self) weak = self;
    [[BDRouteSearchHandler alloc] routeSearch:ori andDest:destion andCSV:csvData andSuccess:^(BDRoutematrixReturnModel * _Nonnull codeModel) {
        __strong typeof( &*self) strong = weak;
        NSMutableArray *csvDataReturn = codeModel.csv;
        csvDataReturn[6] = codeModel.maxDis;
        csvDataReturn[7] = codeModel.minDis;
        csvDataReturn[8] = codeModel.avDis;
        csvDataReturn[9] = codeModel.avTime;
        
        [strong bdRadiusForBank:ori andCSVData:csvDataReturn andFile:filePath];
        
    } andFail:^(NSMutableArray * _Nullable csv) {
        __strong typeof( &*self) strong = weak;
        
        csv[6] = [NSNumber numberWithInt:0];
        csv[7] = [NSNumber numberWithInt:0];
        csv[8] = [NSNumber numberWithInt:0];
        csv[9] = [NSNumber numberWithInt:0];
        
        [strong bdRadiusForBank:ori andCSVData:csv andFile:filePath];
        
    }];
}


#pragma mark -路线规划 -银行
-(void)bdRoutematrixBank:(NSString *_Nonnull)ori andDes:(NSString *_Nonnull) destion andCSVData:(NSMutableArray *_Nonnull) csvData andFile:(NSString *_Nonnull)filePath andKey:(NSString *_Nonnull) keywork{
    
    __weak typeof( &*self) weak = self;
    [[BDRouteSearchHandler alloc] routeSearch:ori andDest:destion andCSV:csvData andSuccess:^(BDRoutematrixReturnModel * _Nonnull codeModel) {
        __strong typeof( &*self) strong = weak;
        NSMutableArray *csvDataReturn = codeModel.csv;
        csvDataReturn[10] = codeModel.maxDis;
        csvDataReturn[11] = codeModel.minDis;
        csvDataReturn[12] = codeModel.avDis;
        csvDataReturn[13] = codeModel.avTime;
        
        [strong bdRadiusForSu:ori andCSVData:csvDataReturn andFile:filePath];
        
    } andFail:^(NSMutableArray * _Nullable csv) {
        __strong typeof( &*self) strong = weak;
        csv[10] = [NSNumber numberWithInt:0];
        csv[11] = [NSNumber numberWithInt:0];;
        csv[12] = [NSNumber numberWithInt:0];;
        csv[13] = [NSNumber numberWithInt:0];;
        
        [strong bdRadiusForSu:ori andCSVData:csv andFile:filePath];
    }];
}


#pragma mark -路线规划 -学校
-(void)bdRoutematrixSchool:(NSString *_Nonnull)ori andDes:(NSString *_Nonnull) destion andCSVData:(NSMutableArray *_Nonnull) csvData andFile:(NSString *_Nonnull)filePath andKey:(NSString *_Nonnull) keywork{
    
    __weak typeof( &*self) weak = self;
    [[BDRouteSearchHandler alloc] routeSearch:ori andDest:destion andCSV:csvData andSuccess:^(BDRoutematrixReturnModel * _Nonnull codeModel) {
        __strong typeof( &*self) strong = weak;
        NSMutableArray *csvDataReturn = codeModel.csv;
        csvDataReturn[14] = codeModel.maxDis;
        csvDataReturn[15] = codeModel.minDis;
        csvDataReturn[16] = codeModel.avDis;
        csvDataReturn[17] = codeModel.avTime;
        
        [strong bdRadiusForHost:ori andCSVData:csvDataReturn andFile:filePath];
        
    } andFail:^(NSMutableArray * _Nullable csv) {
        __strong typeof( &*self) strong = weak;
        
        csv[14] = [NSNumber numberWithInt:0];
        csv[15] = [NSNumber numberWithInt:0];
        csv[16] = [NSNumber numberWithInt:0];
        csv[17] = [NSNumber numberWithInt:0];
        
        [strong bdRadiusForHost:ori andCSVData:csv andFile:filePath];
        
    }];
}


#pragma mark -路线规划 -医院
-(void)bdRoutematrixHost:(NSString *_Nonnull)ori andDes:(NSString *_Nonnull) destion andCSVData:(NSMutableArray *_Nonnull) csvData andFile:(NSString *_Nonnull)filePath andKey:(NSString *_Nonnull) keywork{
    
    __weak typeof( &*self) weak = self;
    [[BDRouteSearchHandler alloc] routeSearch:ori andDest:destion andCSV:csvData andSuccess:^(BDRoutematrixReturnModel * _Nonnull codeModel) {
        __strong typeof( &*self) strong = weak;
        NSMutableArray *csvDataReturn = codeModel.csv;
        csvDataReturn[18] = codeModel.maxDis;
        csvDataReturn[19] = codeModel.minDis;
        csvDataReturn[20] = codeModel.avDis;
        csvDataReturn[21] = codeModel.avTime;
        
        
        [strong bdRadiusForRelax:ori andCSVData:csvDataReturn andFile:filePath];
        
    } andFail:^(NSMutableArray * _Nullable csv) {
        __strong typeof( &*self) strong = weak;
        
        csv[18] = [NSNumber numberWithInt:0];
        csv[19] = [NSNumber numberWithInt:0];
        csv[20] = [NSNumber numberWithInt:0];
        csv[21] = [NSNumber numberWithInt:0];
        [strong bdRadiusForRelax:ori andCSVData:csv andFile:filePath];
    }];
}

#pragma mark -路线规划 -悠闲
-(void)bdRoutematrixRelax:(NSString *_Nonnull)ori andDes:(NSString *_Nonnull) destion andCSVData:(NSMutableArray *_Nonnull) csvData andFile:(NSString *_Nonnull)filePath andKey:(NSString *_Nonnull) keywork{
    
    __weak typeof( &*self) weak = self;
    [[BDRouteSearchHandler alloc] routeSearch:ori andDest:destion andCSV:csvData andSuccess:^(BDRoutematrixReturnModel * _Nonnull codeModel) {
        __strong typeof( &*self) strong = weak;
        NSMutableArray *csvDataReturn = codeModel.csv;
        csvDataReturn[22] = codeModel.maxDis;
        csvDataReturn[23] = codeModel.minDis;
        csvDataReturn[24] = codeModel.avDis;
        csvDataReturn[25] = codeModel.avTime;
        
        [strong bdRadiusForSuper:ori andCSVData:csvDataReturn andFile:filePath];
        
    } andFail:^(NSMutableArray * _Nullable csv) {
        __strong typeof( &*self) strong = weak;
        
        csv[22] = [NSNumber numberWithInt:0];
        csv[23] = [NSNumber numberWithInt:0];
        csv[24] = [NSNumber numberWithInt:0];
        csv[25] = [NSNumber numberWithInt:0];
        
        [strong bdRadiusForSuper:ori andCSVData:csv andFile:filePath];
    }];
}


#pragma mark -路线规划 -超市
-(void)bdRoutematrixSuper:(NSString *_Nonnull)ori andDes:(NSString *_Nonnull) destion andCSVData:(NSMutableArray *_Nonnull) csvData andFile:(NSString *_Nonnull)filePath andKey:(NSString *_Nonnull) keywork{
    
    __weak typeof( &*self) weak = self;
    [[BDRouteSearchHandler alloc] routeSearch:ori andDest:destion andCSV:csvData andSuccess:^(BDRoutematrixReturnModel * _Nonnull codeModel) {
        __strong typeof( &*self) strong = weak;
        NSMutableArray *csvDataReturn = codeModel.csv;
        csvDataReturn[26] = codeModel.maxDis;
        csvDataReturn[27] = codeModel.minDis;
        csvDataReturn[28] = codeModel.avDis;
        csvDataReturn[29] = codeModel.avTime;
        
        [strong bdRadiusForPublic:ori andCSVData:csvDataReturn andFile:filePath];
        
    } andFail:^(NSMutableArray * _Nullable csv) {
        __strong typeof( &*self) strong = weak;
        
        csv[26] = [NSNumber numberWithInt:0];
        csv[27] = [NSNumber numberWithInt:0];
        csv[28] = [NSNumber numberWithInt:0];
        csv[29] = [NSNumber numberWithInt:0];
        [strong bdRadiusForPublic:ori andCSVData:csv andFile:filePath];
        
    }];
}


#pragma mark -路线规划 -治安
-(void)bdRoutematrixPubilc:(NSString *_Nonnull)ori andDes:(NSString *_Nonnull) destion andCSVData:(NSMutableArray *_Nonnull) csvData andFile:(NSString *_Nonnull)filePath andKey:(NSString *_Nonnull) keywork{
    
    __weak typeof( &*self) weak = self;
    [[BDRouteSearchHandler alloc] routeSearch:ori andDest:destion andCSV:csvData andSuccess:^(BDRoutematrixReturnModel * _Nonnull codeModel) {
        __strong typeof( &*self) strong = weak;
        NSMutableArray *csvDataReturn = codeModel.csv;
        csvDataReturn[30] = codeModel.maxDis;
        csvDataReturn[31] = codeModel.minDis;
        csvDataReturn[32] = codeModel.avDis;
        csvDataReturn[33] = codeModel.avTime;
        
        
        [strong bdRadiusForHouse:ori andCSVData:csvDataReturn andFile:filePath];
        
    } andFail:^(NSMutableArray * _Nullable csv) {
        __strong typeof( &*self) strong = weak;
        
        csv[30] = [NSNumber numberWithInt:0];
        csv[31] = [NSNumber numberWithInt:0];
        csv[32] = [NSNumber numberWithInt:0];
        csv[33] = [NSNumber numberWithInt:0];
        
        
        [strong bdRadiusForHouse:ori andCSVData:csv andFile:filePath];
        
    }];
}


#pragma mark -路线规划 -家政
-(void)bdRoutematrixHouse:(NSString *_Nonnull)ori andDes:(NSString *_Nonnull) destion andCSVData:(NSMutableArray *_Nonnull) csvData andFile:(NSString *_Nonnull)filePath andKey:(NSString *_Nonnull) keywork{
    
    __weak typeof( &*self) weak = self;
    [[BDRouteSearchHandler alloc] routeSearch:ori andDest:destion andCSV:csvData andSuccess:^(BDRoutematrixReturnModel * _Nonnull codeModel) {
        __strong typeof( &*self) strong = weak;
        NSMutableArray *csvDataReturn = codeModel.csv;
        csvDataReturn[34] = codeModel.maxDis;
        csvDataReturn[35] = codeModel.minDis;
        csvDataReturn[36] = codeModel.avDis;
        csvDataReturn[37] = codeModel.avTime;
        
        [strong bdRadiusForDiet:ori andCSVData:csvDataReturn andFile:filePath];
        
    } andFail:^(NSMutableArray * _Nullable csv) {
        __strong typeof( &*self) strong = weak;
        
        csv[34] = [NSNumber numberWithInt:0];
        csv[35] = [NSNumber numberWithInt:0];
        csv[36] = [NSNumber numberWithInt:0];
        csv[37] = [NSNumber numberWithInt:0];
        [strong bdRadiusForDiet:ori andCSVData:csv andFile:filePath];
    }];
}


#pragma mark -路线规划 -饮食
-(void)bdRoutematrixDiet:(NSString *_Nonnull)ori andDes:(NSString *_Nonnull) destion andCSVData:(NSMutableArray *_Nonnull) csvData andFile:(NSString *_Nonnull)filePath andKey:(NSString *_Nonnull) keywork{
    
    __weak typeof( &*self) weak = self;
    [[BDRouteSearchHandler alloc] routeSearch:ori andDest:destion andCSV:csvData andSuccess:^(BDRoutematrixReturnModel * _Nonnull codeModel) {
        __strong typeof( &*self) strong = weak;
        NSMutableArray *csvDataReturn = codeModel.csv;
        csvDataReturn[38] = codeModel.maxDis;
        csvDataReturn[39] = codeModel.minDis;
        csvDataReturn[40] = codeModel.avDis;
        csvDataReturn[41] = codeModel.avTime;
        
        [strong bdRadiusForMetro:ori andCSVData:csvDataReturn andFile:filePath];
        
    } andFail:^(NSMutableArray * _Nullable csv) {
        __strong typeof( &*self) strong = weak;
        
        csv[38] = [NSNumber numberWithInt:0];
        csv[39] = [NSNumber numberWithInt:0];
        csv[40] = [NSNumber numberWithInt:0];
        csv[41] = [NSNumber numberWithInt:0];
        [strong bdRadiusForMetro:ori andCSVData:csv andFile:filePath];
        
    }];
}


#pragma mark -路线规划 -地铁
-(void)bdRoutematrixMetro:(NSString *_Nonnull)ori andDes:(NSString *_Nonnull) destion andCSVData:(NSMutableArray *_Nonnull) csvData andFile:(NSString *_Nonnull)filePath andKey:(NSString *_Nonnull) keywork{
    
    __weak typeof( &*self) weak = self;
    [[BDRouteSearchHandler alloc] routeSearch:ori andDest:destion andCSV:csvData andSuccess:^(BDRoutematrixReturnModel * _Nonnull codeModel) {
        __strong typeof( &*self) strong = weak;
        NSMutableArray *csvDataReturn = codeModel.csv;
        csvDataReturn[42] = codeModel.maxDis;
        csvDataReturn[43] = codeModel.minDis;
        csvDataReturn[44] = codeModel.avDis;
        csvDataReturn[45] = codeModel.avTime;
        
//        [strong exportCSV:csvDataReturn andFilePath:filePath ];
        strong.success(csvDataReturn);
        
    } andFail:^(NSMutableArray * _Nullable csv) {
        __strong typeof( &*self) strong = weak;
        

        csv[42] = [NSNumber numberWithInt:0];
        csv[43] = [NSNumber numberWithInt:0];
        csv[44] = [NSNumber numberWithInt:0];
        csv[45] = [NSNumber numberWithInt:0];
        
//        [strong exportCSV:csv andFilePath:filePath ];
        strong.fail(csv);
        
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
    NSString *header = @",商圈,,,,,公交,,,,,银行,,,,,学校,,,,,医院,,,,,休闲,,,,,商超,,,,,治安,,,,,家政,,,,,餐饮,,,,,地铁,,,,,,,\r\n楼盘名称,数量,最远距离,最近距离,平均距离,通勤时间,数量,最远距离,最近距离,平均距离,通勤时间,数量,最远距离,最近距离,平均距离,通勤时间,数量,最远距离,最近距离,平均距离,通勤时间,数量,最远距离,最近距离,平均距离,通勤时间,数量,最远距离,最近距离,平均距离,通勤时间,数量,最远距离,最近距离,平均距离,通勤时间,数量,最远距离,最近距离,平均距离,通勤时间,数量,最远距离,最近距离,平均距离,通勤时间,数量,最远距离,最近距离,平均距离,通勤时间,数量,最远距离,最近距离,平均距离,通勤时间,经度,纬度,地址\r\n";
    
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
