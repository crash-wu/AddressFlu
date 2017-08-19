//
//  AnalysisTableViewController.m
//  AddressFlu
//
//  Created by 吴小星 on 2017/6/8.
//  Copyright © 2017年 crash. All rights reserved.
//

#import "AnalysisTableViewController.h"

@interface AnalysisTableViewController ()


@property(nonatomic,strong,nonnull) NSArray *titleArray;


@property(nonatomic,strong,nonnull) NSArray *chinasArray;

@end

@implementation AnalysisTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.automaticallyAdjustsScrollViewInsets = true;
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
    
    [self.view addSubview:self.tableView];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.equalTo(self.view);
    }];
    
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    self.titleArray = [[NSArray alloc] initWithObjects:@"鸡西市",@"鹤岗市",@"牡丹江市",@"大兴安岭地区",@"哈尔滨市",@"大庆市",@"齐齐哈尔市",@"佳木斯市",@"七台河市",@"黑河市",@"绥化市",@"双鸭山市",@"伊春市", nil];
    
    self.chinasArray = [[NSArray alloc] initWithObjects:@"jixi",@"hegang",@"mudanjiang",@"daxinganling",@"haerbin",@"daqing",@"qiqihaer",@"jiamusi",@"qitaihe",@"heihe",@"suihua",@"shuangyashan",@"yichun1", nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - UITableViewDateSource ,UITableViewDelegate

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.titleArray.count;
}

-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}


-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cellID"];
    
    if (!cell) {
        
         cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cellID"];
    }

    cell.textLabel.text = self.titleArray[indexPath.row];
    
    return cell;
}


-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    AnalysisHTMLViewController *vc = [[AnalysisHTMLViewController alloc]init];
    
    vc.cityName = self.titleArray[indexPath.row];
    vc.city = self.chinasArray[indexPath.row];
    
    [self.navigationController pushViewController:vc animated:YES];
    
}
@end
