//
//  ViewController.m
//
//  Created by dyf on 2019/6/17.
//  Copyright © 2019 dyf. All rights reserved.
//

#import "ViewController.h"
#import "YFMehtodAndIvarViewController.h"
#import "YFExchangeViewController.h"
#import "YFDictToModelViewController.h"
#import "YFArchiveViewController.h"
#import "YFModel.h"
#import "YFModel+AddingAttr.h"

@interface ViewController () <UITableViewDelegate, UITableViewDataSource>

/**
 数据源
 */
@property (nonatomic , strong) NSArray *dataArray;

@end

@implementation ViewController

- (NSArray *)dataArray {
    if (!_dataArray) {
        _dataArray = @[@"获得所有方法名", @"获取所有属性名", @"交换两个方法", @"替换某个方法", @"字典转模型", @"归档解档"];
    }
    return _dataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"Runtime运用";
    
    [self lookupModel];
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
    tableView.delegate     = self;
    tableView.dataSource   = self;
    tableView.rowHeight    = 60.0f;
    [self.view addSubview:tableView];
}

- (void)lookupModel {
    YFModel *m = [[YFModel alloc] init];
    m.name = @"李芬";
    m.gender = @"女";
    m.age = @"28";
    // 利用Runtime在分类中添加属性
    m.address = @"北京市通州区龙旺庄小区";
    NSLog(@">>>> name: %@\ngender: %@\nage: %@\naddress: %@", m.name, m.gender, m.age, m.address);
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellID = @"root.cell.id";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    NSString *str = self.dataArray[indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"Runtime - %@", str];
    cell.textLabel.textColor = [UIColor colorWithRed:10/255.0 green:115/255.0 blue:255/255.0 alpha:1.0];

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.row) {
        case 0: case 1: {
            YFMehtodAndIvarViewController *vc = [YFMehtodAndIvarViewController new];
            vc.navItemTitle = self.dataArray[indexPath.row];
            vc.type = (int)indexPath.row + 1;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 2: case 3: {
            YFExchangeViewController *vc = [YFExchangeViewController new];
            vc.navItemTitle = self.dataArray[indexPath.row];
            vc.type = (int)indexPath.row - 1;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 4: {
            YFDictToModelViewController *vc = [YFDictToModelViewController new];
            vc.navItemTitle = self.dataArray[indexPath.row];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
            
        case 5: {
            YFArchiveViewController *vc = [[YFArchiveViewController alloc] init];
            vc.navItemTitle = self.dataArray[indexPath.row];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        default:
            break;
    }
}

@end
