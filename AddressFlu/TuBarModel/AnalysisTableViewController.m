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
    
    self.titleArray = [[NSArray alloc] initWithObjects:@"广州市",@"深圳市",@"珠海市",@"汕头市",@"佛山市",@"韶关市",@"湛江市",@"肇庆市",@"江门市",@"茂名市",@"惠州市",@"梅州市",@"汕尾市",@"河源市",@"阳江市",@"清远市",@"东莞市",@"中山",@"潮州",@"揭阳",@"云浮", nil];
    
    self.chinasArray = [[NSArray alloc] initWithObjects:@"guangzhou",@"shenzhen",@"zhuhai",@"shantou",@"foshan",@"shaoguan",@"zhanjiang",@"zhaoqing",@"jiangmen",@"maoming",@"huizhou",@"meizhou",@"shanwei",@"heyuan",@"yangjiang",@"qingyuan",@"dongguan",@"zhongshan",@"chaozhou",@"jieyang",@"yunfu", nil];
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
