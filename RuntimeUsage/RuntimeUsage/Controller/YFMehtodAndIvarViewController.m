//
//  YFMehtodAndIvarViewController.m
//
//  Created by dyf on 2019/6/23.
//  Copyright © 2019 dyf. All rights reserved.
//

#import "YFMehtodAndIvarViewController.h"
#import "DYFRuntimeWrapper.h"

@interface YFMehtodAndIvarViewController ()

@property (weak, nonatomic) IBOutlet UITextField *classNameTF;
@property (weak, nonatomic) IBOutlet UITextView *displayView;

@end

@implementation YFMehtodAndIvarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = self.navItemTitle;
    self.displayView.text = (self.type == 1) ? @"方法名：\n" : @"属性名：\n";
}

- (IBAction)getAction:(id)sender {
    self.displayView.text = (self.type == 1) ? @"方法名：\n" : @"属性名：\n";
    
    NSArray *list = nil;
    
    if ([self.classNameTF.text isEqualToString:@""] || self.classNameTF.text.length == 0) {
        NSLog(@">>>> 输入不能为空");
        return;
    }
    
    if (self.type == 1) {
        list = [DYFRuntimeWrapper yf_getAllMethodsWithClass:NSClassFromString(self.classNameTF.text)];
    }else if (self.type == 2) {
        list = [DYFRuntimeWrapper yf_getAllIvarsWithClass:NSClassFromString(self.classNameTF.text)];
    }
    
    [self handleTask:list];
}

- (void)handleTask:(NSArray *)list {
    __block NSString *result = self.displayView.text;
    
    dispatch_queue_t queue = dispatch_queue_create("yf.cc.queue", DISPATCH_QUEUE_CONCURRENT);
    
    dispatch_async(queue, ^{
        for (NSString *name in list) {
            result = [result stringByAppendingString:[NSString stringWithFormat:@"%@\n", name]];
        }
    });
    
    dispatch_barrier_async(queue, ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            self.displayView.text = result;
        });
    });
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

@end
