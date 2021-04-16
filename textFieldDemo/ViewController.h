//
//  ViewController.h
//  textFieldDemo
//
//  Created by rockfintech on 2021/4/15.
//
// 屏幕宽度高度
#define SW ([UIScreen mainScreen].bounds.size.width)
#define SH ([UIScreen mainScreen].bounds.size.height)

// 随机色
#define HWRandomColor [UIColor colorWithRed:arc4random_uniform(256)/255.0 green:arc4random_uniform(256)/255.0 blue:arc4random_uniform(256)/255.0 alpha:1.0]
#import <UIKit/UIKit.h>

@interface ViewController : UIViewController


@end

