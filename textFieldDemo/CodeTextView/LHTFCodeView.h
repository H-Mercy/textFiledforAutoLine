//
//  LHTFCodeView.h
//  textFieldDemo
//
//  Created by rockfintech on 2021/4/15.
//

/**基础版-下划线
 
 */
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LHTFCodeView : UIView
/// 当前输入的内容
@property (nonatomic, copy, readonly) NSString *code;

- (instancetype)initWithCount:(NSInteger)count margin:(CGFloat)margin;

- (instancetype)init UNAVAILABLE_ATTRIBUTE;
+ (instancetype)new UNAVAILABLE_ATTRIBUTE;
@end

NS_ASSUME_NONNULL_END
