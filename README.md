## Runtime
 Runtime的封装，一行代码就实现获取所有方法名，获取所有属性名，添加一个方法，交换两个方法，字典转模型和归档解档。另外，在示例中也介绍了为[分类添加属性](https://github.com/dgynfi/Runtime/blob/master/RuntimeUsage/RuntimeUsage/Model/YFModel%2BAddingAttr.m)。

---

### Preview
<div text-align="center"><img src="https://github.com/dgynfi/Runtime/raw/master/images/runtime-usage.gif" width="414" height="736" /></div>

---

### 技术交流群(群号:155353383) 

欢迎加入技术交流群，一起探讨技术问题。<br />
![](https://github.com/dgynfi/Runtime/raw/master/images/qq155353383.jpg)

### 使用说明

- 导入头文件 
```
#import "DYFRuntimeWrapper.h"
```

#### Runtime应用介绍

- 获取所有方法名，例如获取UITableView的方法名
```
NSArray *list = [DYFRuntimeWrapper yf_getAllMethodsWithClass:[UITableView class]];

for (NSString *name in list) {
    NSLog(@">>>> %@", name);
}
```

- 获取所有属性名，例如获取UILabel的属性变量
```
NSArray *list = [DYFRuntimeWrapper yf_getAllIvarsWithClass:[UILabel class]];

for (NSString *name in list) {
    NSLog(@">>>> %@", name);
}
```

- 添加一个方法
```
+ (void)load {
    [DYFRuntimeWrapper yf_addMethodWithClass:[self class] methodName:@"hello" impClass:[self class] impName:@"sayHello"];
}

- (void)viewDidLoad {
    [super viewDidLoad];

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    [self performSelector:NSSelectorFromString(@"hello")];
#pragma clang diagnostic pop
}

- (void)sayHello {
    NSLog(@">>>> %s", __FUNCTION__);
}
```

- 交换两个方法
```
- (IBAction)exchangeMethod:(id)sender {
    [DYFRuntimeWrapper yf_exchangeMethodWithSourceClass:[self class] sourceSel:@selector(preload) targetClass:[self class] targetSel:@selector(refreshUI)];
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
```

- 替换某个方法
```
- (IBAction)replaceMethod:(id)sender {
    [DYFRuntimeWrapper yf_replaceMethodWithSourceClass:[self class] sourceSel:@selector(preload) targetClass:[self class] targetSel:@selector(refreshUI)];
}
// 同上
```

- 字典转模型
```
- (IBAction)dictToModel:(id)sender {
    NSDictionary *dict = @{@"name": self.nameTF.text,
                           @"gender": self.genderTF.text,
                           @"age": self.ageTF.text};
    YFModel *model = [DYFRuntimeWrapper yf_modelWithDict:dict modelClass:[YFModel class]];
    self.displayView.text = [self.displayView.text stringByAppendingString:[NSString stringWithFormat:@"\nname: %@\ngender: %@\nage: %@", model.name, model.gender, model.age]];
}
```

- 归档解档
```
- (void)viewDidLoad {
    [super viewDidLoad];
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
```

- 使用Runtime为分类添加属性
1. 导入头文件`#import <objc/message.h>`
2. 声明属性
```
/** 居住地址 */
@property (nonatomic, copy) NSString *address;
```

3. 申明一个key值
```
static NSString *kHomeAddress = @"kHomeAddress";
```

4. 重写setter、getter方法
```
// get方法
- (NSString *)address {
    return objc_getAssociatedObject(self, &kHomeAddress);
}

// set方法
- (void)setAddress:(NSString *)address {
    objc_setAssociatedObject(self, &kHomeAddress, address, OBJC_ASSOCIATION_COPY_NONATOMIC);
}
```

这样就成功添加了一个属性。

Runtime的封装主要实现都在`DYFRuntimeWrapper `类中，可以快速使用Runtime，具体的实现大家可以查看或下载Demo：[传送门](https://github.com/dgynfi/Runtime/tree/master/RuntimeUsage)。
