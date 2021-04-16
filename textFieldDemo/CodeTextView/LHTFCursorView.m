//
//  LHTFCursorView.m
//  textFieldDemo
//
//  Created by rockfintech on 2021/4/15.
//

#import "LHTFCursorView.h"
@interface LHTFCursorView ()

@property (nonatomic, assign) NSInteger itemCount;

@property (nonatomic, assign) CGFloat itemMargin;

@property (nonatomic, weak) UITextField *textField;

@property (nonatomic, weak) UIControl *maskView;
//labels数组
@property (nonatomic, strong) NSMutableArray<LHCorsolLabel *> *labels;

@property (nonatomic, strong) NSMutableArray<UIView *> *lines;

@property (nonatomic, weak) LHCorsolLabel *currentLabel;

@end

@implementation LHTFCursorView

//初始化
- (instancetype)initWithCount:(NSInteger)count margin:(CGFloat)margin{
    
    if (self = [super init]) {
        self.itemCount = count;
        self.itemMargin = margin;
        
        //textfield的设置
        [self configTextField];
    }
    
    return  self;
}


-(void)configTextField{
    
    self.backgroundColor = [UIColor whiteColor];
    //深拷贝
    self.labels = @[].mutableCopy;
    self.lines = @[].mutableCopy;
    
    //创建UI，textField,maskView,label,下划线
    UITextField *textField = [[UITextField alloc] init];
    textField.backgroundColor = [UIColor orangeColor];
    textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    textField.keyboardType = UIKeyboardTypeNumberPad;
    [textField addTarget:self action:@selector(tfEditingChanged:) forControlEvents:(UIControlEventEditingChanged)];
    
    // 小技巧：这个属性为YES，可以强制使用系统的数字键盘，缺点是重新输入时，会清空之前的内容
    // clearsOnBeginEditing 属性并不适用于 secureTextEntry = YES 时
    // textField.secureTextEntry = YES;
    [self addSubview:textField];
    self.textField = textField;
    
    // 小技巧：通过textField上层覆盖一个maskView，可以去掉textField的长按事件,点击开始编辑
    UIButton * maskView = [UIButton new];
    maskView.backgroundColor = [UIColor whiteColor];
    [maskView addTarget:self action:@selector(clickMaskView) forControlEvents:(UIControlEventTouchUpInside)];
    [self addSubview:maskView];
    self.maskView = maskView;
    
    for (NSInteger i = 0; i < self.itemCount; i++)
    {
        LHCorsolLabel *label = [LHCorsolLabel new];
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

- (void)layoutSubviews{
    
    [super layoutSubviews];
    
    if (self.labels.count != self.itemCount) return;
    //每一个item的宽度
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

#pragma mark - 编辑改变
- (void)tfEditingChanged:(UITextField *)textField
{
    if (textField.text.length > self.itemCount) {
        textField.text = [textField.text substringWithRange:NSMakeRange(0, self.itemCount)];
    }
    //将输入的文本在label上展示
    for (int i = 0; i < self.itemCount; i++)
    {
        UILabel *label = [self.labels objectAtIndex:i];
        
        if (i < textField.text.length) {
            label.text = [textField.text substringWithRange:NSMakeRange(i, 1)];
        } else {
            label.text = nil;
        }
    }
    [self cursor];
    // 输入完毕后，自动隐藏键盘
    if (textField.text.length >= self.itemCount) {
        [self.currentLabel stopAnimating];
        [textField resignFirstResponder];
    }
}
- (void)clickMaskView
{
    [self.textField becomeFirstResponder];
    //处理光标
    [self cursor];
}

- (BOOL)endEditing:(BOOL)force
{
    [self.textField endEditing:force];
    [self.currentLabel stopAnimating];
    return [super endEditing:force];
}



#pragma mark - 处理光标
- (void)cursor
{
    [self.currentLabel stopAnimating];
    NSInteger index = self.code.length;
    if (index < 0) index = 0;
    if (index >= self.labels.count) index = self.labels.count - 1;
    //判断是哪一个光标，然后开始动画
    LHCorsolLabel *label = [self.labels objectAtIndex:index];
    [label startAnimating];
    self.currentLabel = label;
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

//设置label样式
// ------------------------------------------------------------------------
// -----------------------------LHCursorLabel------------------------------
// ------------------------------------------------------------------------
@implementation LHCorsolLabel

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupView];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self setupView];
    }
    return self;
}

#pragma mark - 初始化View
- (void)setupView
{
    //模拟光标
    UIView *cursorView = [[UIView alloc] init];
    cursorView.backgroundColor = [UIColor blueColor];
    cursorView.alpha = 0;
    [self addSubview:cursorView];
    _cursorView = cursorView;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat h = 30;
    CGFloat w = 2;
    CGFloat x = self.bounds.size.width * 0.5;
    CGFloat y = self.bounds.size.height * 0.5;
    self.cursorView.frame = CGRectMake(0, 0, w, h);
    self.cursorView.center = CGPointMake(x, y);
}

- (void)startAnimating
{
    if (self.text.length > 0) return;
    //支持 移动·旋转·放大·缩小 的动画库
    CABasicAnimation *oa = [CABasicAnimation animationWithKeyPath:@"opacity"];
    oa.fromValue = [NSNumber numberWithFloat:0];
    oa.toValue = [NSNumber numberWithFloat:1];
    oa.duration = 1;
    oa.repeatCount = MAXFLOAT;
    oa.removedOnCompletion = NO;
    oa.fillMode = kCAFillModeForwards;
    oa.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    [self.cursorView.layer addAnimation:oa forKey:@"opacity"];
}

- (void)stopAnimating
{
    [self.cursorView.layer removeAnimationForKey:@"opacity"];
}

@end
