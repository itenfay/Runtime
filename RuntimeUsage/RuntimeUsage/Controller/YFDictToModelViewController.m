//
//  YFDictToModelViewController.m
//
//  Created by dyf on 2019/6/23.
//  Copyright © 2019 dyf. All rights reserved.
//

#import "YFDictToModelViewController.h"
#import "YFModel.h"
#import "DYFRuntimeWrapper.h"

@interface YFDictToModelViewController ()

@property (weak, nonatomic) IBOutlet UITextField *nameTF;
@property (weak, nonatomic) IBOutlet UITextField *genderTF;
@property (weak, nonatomic) IBOutlet UITextField *ageTF;
@property (weak, nonatomic) IBOutlet UITextView *displayView;

@end

@implementation YFDictToModelViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = self.navItemTitle;
}

- (IBAction)dictToModel:(id)sender {
    NSDictionary *dict = @{@"name": self.nameTF.text,
                           @"gender": self.genderTF.text,
                           @"age": self.ageTF.text};
    YFModel *model = [DYFRuntimeWrapper yf_modelWithDict:dict modelClass:[YFModel class]];
    self.displayView.text = [self.displayView.text stringByAppendingString:[NSString stringWithFormat:@"\nname: %@\ngender: %@\nage: %@", model.name, model.gender, model.age]];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

@end
