//
//  LHTextCodeView.h
//  textFieldDemo
//
//  Created by rockfintech on 2021/4/15.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
/**
 * 完善版 - 加入动画 - 下划线
 */
@interface LHTextCodeView : UIView

/// 当前输入的内容
@property (nonatomic, copy, readonly) NSString *code;

- (instancetype)initWithCount:(NSInteger)count margin:(CGFloat)margin;

- (instancetype)init UNAVAILABLE_ATTRIBUTE;
+ (instancetype)new UNAVAILABLE_ATTRIBUTE;

@end



// ------------------------------------------------------------------------
// -----------------------------LHTC_lineView------------------------------
// ------------------------------------------------------------------------


@interface LHTC_lineView : UIView

@property (nonatomic, weak) UIView *colorView;

- (void)animation;

@end

NS_ASSUME_NONNULL_END
