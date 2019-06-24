//
//  YFArchiveViewController.m
//
//  Created by dyf on 2019/6/23.
//  Copyright © 2019 dyf. All rights reserved.
//

#import "YFArchiveViewController.h"
#import "YFModel.h"
#import "DYFRuntimeWrapper.h"

@interface YFArchiveViewController ()

@property (weak, nonatomic) IBOutlet UITextField *nameTF;
@property (weak, nonatomic) IBOutlet UITextField *genderTF;
@property (weak, nonatomic) IBOutlet UITextView *displayView;
@property (weak, nonatomic) IBOutlet UITextField *ageTF;

@property (nonatomic, copy) NSString *filePath;

@end

@implementation YFArchiveViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = self.navItemTitle;
    // 创建路径
    NSString *documentPath      = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES) lastObject];
    NSString *filePath          = [documentPath stringByAppendingPathComponent:@"YFModel.plist"];
    self.filePath               = filePath;
}

- (IBAction)archive:(id)sender {
    YFModel *model = [YFModel new];
    model.name     = self.nameTF.text;
    model.gender   = self.genderTF.text;
    model.age      = self.ageTF.text;
    
    BOOL ret = [DYFRuntimeWrapper yf_archive:[model class] model:model filePath:self.filePath];
    if (ret) {
        NSLog(@">>>> 归档成功：%@", self.filePath);
    } else {
        NSLog(@">>>> 归档失败！！！");
    }
}

- (IBAction)unarchive:(id)sender {
    self.displayView.text = @"解档后的数据：";
    
    YFModel *m = [DYFRuntimeWrapper yf_unarchive:[YFModel class] filePath:self.filePath];
    
    self.displayView.text = [self.displayView.text stringByAppendingString:[NSString stringWithFormat:@"\nname: %@\ngender: %@\nage: %@", m.name, m.gender, m.age]];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

@end
