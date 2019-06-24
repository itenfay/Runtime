//
//  YFExchangeViewController.m
//
//  Created by dyf on 2019/6/23.
//  Copyright © 2019 dyf. All rights reserved.
//

#import "YFExchangeViewController.h"
#import "DYFRuntimeWrapper.h"

@interface YFExchangeViewController ()

@property (weak, nonatomic) IBOutlet UIButton *exchangeButton;
@property (weak, nonatomic) IBOutlet UIButton *replaceButton;
@property (weak, nonatomic) IBOutlet UIButton *testButton;
@property (weak, nonatomic) IBOutlet UITextView *displayView;

@end

@implementation YFExchangeViewController

+ (void)load {
    [DYFRuntimeWrapper yf_addMethodWithClass:[self class] methodName:@"hello" impClass:[self class] impName:@"sayHello"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = self.navItemTitle;
    
    if (self.type == 1) {
        self.exchangeButton.hidden = NO;
        self.replaceButton.hidden  = YES;
    } else {
        self.exchangeButton.hidden = YES;
        self.replaceButton.hidden  = NO;
    }
    
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    [self performSelector:NSSelectorFromString(@"hello")];
#pragma clang diagnostic pop
}

- (IBAction)exchangeMethod:(id)sender {
    NSLog(@">>>> %s, sender: %@", __FUNCTION__, sender);
    [DYFRuntimeWrapper yf_exchangeMethodWithSourceClass:[self class]
                                              sourceSel:@selector(preload)
                                            targetClass:[self class]
                                              targetSel:@selector(refreshUI)];
}

- (IBAction)replaceMethod:(id)sender {
    NSLog(@">>>> %s, sender: %@", __FUNCTION__, sender);
    [DYFRuntimeWrapper yf_replaceMethodWithSourceClass:[self class]
                                             sourceSel:@selector(preload)
                                           targetClass:[self class]
                                             targetSel:@selector(refreshUI)];
}

- (void)sayHello {
    NSLog(@">>>> %s", __FUNCTION__);
}

- (void)preload {
    NSString *str = [NSString stringWithFormat:@"%s\n", __FUNCTION__];
    NSLog(@">>>> str1: %@", str);
    self.displayView.text = [self.displayView.text stringByAppendingString:str];
    NSLog(@">>>> self.displayView.text: %@", self.displayView.text);
}

- (void)refreshUI {
    NSString *str = [NSString stringWithFormat:@"%s-%@\n", __FUNCTION__, self.randomString];
    NSLog(@">>>> str2: %@", str);
    self.displayView.text = [self.displayView.text stringByAppendingString:str];
    NSLog(@">>>> self.displayView.text: %@", self.displayView.text);
}

- (NSString *)randomString {
    uint32_t a = arc4random_uniform(2);
    unsigned int len = (a == 1) ? 40 : 32;
    char data[len];
    for (int x = 0; x < len; x++) {
        uint32_t ar = arc4random_uniform(2);
        char ch = (char)(((ar == 1) ? 'A' : 'a') + (arc4random_uniform(26)));
        data[x] = ch;
    }
    return [[NSString alloc] initWithBytes:data length:len encoding:NSUTF8StringEncoding];
}

- (IBAction)testAction:(id)sender {
    NSLog(@">>>> %s, sender: %@", __FUNCTION__, sender);
    
    NSString *s1 = [NSString stringWithFormat:@"-[%@ preload]", NSStringFromClass([self class])];
    NSString *s2 = [NSString stringWithFormat:@"-[%@ refreshUI]", NSStringFromClass([self class])];
    
    if (self.type == 1) {
        NSString *s3 = [NSString stringWithFormat:@"%@\n%@\n交换后：\n", s1, s2];
        self.displayView.text = [@"交换前：\n" stringByAppendingString:s3];
    } else {
        NSString *s3 = [NSString stringWithFormat:@"%@\n%@\n替换后：\n", s1, s2];
        self.displayView.text = [@"替换前：\n" stringByAppendingString:s3];
    }
    
    [self preload];
    [self refreshUI];
}

@end
