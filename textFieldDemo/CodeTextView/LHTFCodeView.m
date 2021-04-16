//
//  LHTFCodeView.m
//  textFieldDemo
//
//  Created by rockfintech on 2021/4/15.
//

#import "LHTFCodeView.h"

@interface LHTFCodeView ()
@property (nonatomic, assign) NSInteger itemCount;

@property (nonatomic, assign) CGFloat itemMargin;

@property (nonatomic, weak) UITextField *textField;
//覆盖在textField上的view
@property (nonatomic, weak) UIControl *maskView;
//label数组
@property (nonatomic, strong) NSMutableArray<UILabel *> *labels;
//下划线
@property (nonatomic, strong) NSMutableArray<UIView *> *lines;

@end
@implementation LHTFCodeView
//view初始化，设置验证码长度和宽距
- (instancetype)initWithCount:(NSInteger)count margin:(CGFloat)margin{
    
    if (self = [super init]) {
        
        self.itemCount = count;
        self.itemMargin = margin;
        
        [self configTextField];
    }
    return self;
}

//设置textField
-(void)configTextField{
    
    self.backgroundColor = [UIColor whiteColor];
    
    self.labels = @[].mutableCopy;
    self.lines = @[].mutableCopy;
    
    //添加一个输入的textField，在页面
    UITextField *textField = [[UITextField alloc] init];
    textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    textField.keyboardType = UIKeyboardTypeNumberPad;
    [textField addTarget:self action:@selector(tfEditingChanged:) forControlEvents:(UIControlEventEditingChanged)];
    [self addSubview:textField];
    self.textField = textField;
    
    //在textField上覆盖一个view，可以防止出现textField的一些特性
    UIButton *maskView = [UIButton new];
    maskView.backgroundColor = [UIColor whiteColor];
    [maskView addTarget:self action:@selector(clickMaskView) forControlEvents:(UIControlEventTouchUpInside)];
    [self addSubview:maskView];
    self.maskView = maskView;
    
    //根据itemCount循环添加label数组里面。在textField输入时，取出。
    for (NSInteger i = 0; i < self.itemCount; i++)
    {
        UILabel *label = [UILabel new];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor darkTextColor];
        label.font = [UIFont fontWithName:@"PingFangSC-Regular" size:41.5];
        [self addSubview:label];
        [self.labels addObject:label];
    }
    
    for (NSInteger i = 0; i < self.itemCount; i++)
    {
        UIView *line = [UIView new];
        line.backgroundColor = [UIColor purpleColor];
        [self addSubview:line];
        [self.lines addObject:line];
    }
}

//label的位置布局
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    if (self.labels.count != self.itemCount) return;
    
    CGFloat temp = self.bounds.size.width - (self.itemMargin * (self.itemCount - 1));
    CGFloat w = temp / self.itemCount;
    CGFloat x = 0;
    
    for (NSInteger i = 0; i < self.labels.count; i++)
    {
        x = i * (w + self.itemMargin);
        
        UILabel *label = self.labels[i];
        label.frame = CGRectMake(x, 0, w, self.bounds.size.height);
        
        UIView *line = self.lines[i];
        line.frame = CGRectMake(x, self.bounds.size.height - 1, w, 1);
    }
    
    self.textField.frame = self.bounds;
    self.maskView.frame = self.bounds;
}

#pragma mark - 编辑改变，---将输入的文字赋值给label
- (void)tfEditingChanged:(UITextField *)textField
{
    if (textField.text.length > self.itemCount) {
        textField.text = [textField.text substringWithRange:NSMakeRange(0, self.itemCount)];
    }
    
    for (int i = 0; i < self.itemCount; i++)
    {
        UILabel *label = [self.labels objectAtIndex:i];
        
        if (i < textField.text.length) {
            label.text = [textField.text substringWithRange:NSMakeRange(i, 1)];
        } else {
            label.text = nil;
        }
    }
    
    // 输入完毕后，自动隐藏键盘
    if (textField.text.length >= self.itemCount) {
        [textField resignFirstResponder];
    }
}
- (void)clickMaskView
{
    [self.textField becomeFirstResponder];
}

- (BOOL)endEditing:(BOOL)force
{
    [self.textField endEditing:force];
    return [super endEditing:force];
}

- (NSString *)code
{
    return self.textField.text;
}






/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
