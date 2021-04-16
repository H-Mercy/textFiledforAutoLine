//
//  LHTFCursorView.h
//  textFieldDemo
//
//  Created by rockfintech on 2021/4/15.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/**基础版-下划线-有光标
 
 */
@interface LHTFCursorView : UIView
//-----------------------------------Data-------------------

//当前输入的内容
@property(nonatomic,copy,readonly)NSString * code;

// ----------------------------Method----------------------------
//设置验证码的位数,间距
- (instancetype)initWithCount:(NSInteger)count margin:(CGFloat)margin;
//attribute,设置函数属性，变量属性，类型属性等
/*书写格式
 attribute后面会紧跟括号，括号内是相应的参数
 */
- (instancetype)init UNAVAILABLE_ATTRIBUTE;
+ (instancetype)new UNAVAILABLE_ATTRIBUTE;
@end

// ------------------------------------------------------------------------
// -----------------------------LHCorsolLabel------------------------------
// ------------------------------------------------------------------------

@interface LHCorsolLabel : UILabel

@property (nonatomic, weak, readonly) UIView *cursorView;

- (void)startAnimating;
- (void)stopAnimating;

@end
NS_ASSUME_NONNULL_END
