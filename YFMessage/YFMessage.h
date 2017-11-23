//
//  YFMessage.h
//
//  Created by Dandre on 16/3/22.
//  Copyright © 2016年 Dandre. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MBProgressHUD.h"

//typedef void(^AlertButtonClickedBlock)(NSInteger buttonIndex);

/**< 消息提示 */
@interface YFMessage : NSObject <UIAlertViewDelegate>

@property (nonatomic, strong) MBProgressHUD * _Nullable hudView;
@property (nonatomic, strong) UIView * _Nullable noContentTipView;
//@property (nonatomic, copy) AlertButtonClickedBlock block;

+ (YFMessage *_Nonnull)shareMessage;

/**
 *  显示无内容提示
 *
 *  @param message 提示的文字
 *  @param image   显示的图片
 *  @param view    显示所在的视图
 */
+ (UIView *_Nonnull)showNoContentTip:(NSString *_Nullable)message
                               image:(NSString *_Nullable)image
                              onView:(UIView *_Nonnull)view;
/**
 *  隐藏无内容提示视图
 */
+ (void)hideNoContentTipView;

@end

@interface YFMessage (AlertView)

/**
 alert提示框待UIAlertController返回值

 @param message 提示内容
 @param title 提示标题
 @param style alert类型
 @param actions UIAlertAction对象的集合
 @return 返回UIAlertController对象
 */
+ (UIAlertController *_Nonnull)alert:(NSString *_Nullable)message
                               title:(NSString *_Nullable)title
                               style:(UIAlertControllerStyle)style
                             actions:(NSArray <UIAlertAction *> *_Nullable)actions;

/**
 alert提示框待UIAlertController返回值
 
 @param message 提示内容
 @param title 提示标题
 @param style alert类型
 @param cancelActionTitle 取消按钮标题
 @param actionTitles 其他按钮标题的集合
 @param callback 点击按钮时的回调
 @return 返回UIAlertController对象
 */
+ (UIAlertController *_Nonnull)alert:(NSString *_Nullable)message
                               title:(NSString *_Nullable)title
                               style:(UIAlertControllerStyle)style
                   cancelActionTitle:(NSString *_Nullable)cancelActionTitle
                   otherActionTitles:(NSArray<NSString *> *_Nullable)actionTitles
                         clickedBack:(void(^_Nullable)(NSString *_Nonnull actionTitle, NSInteger actionIndex))callback;

/**
 alert提示框
 
 @param message 提示的内容，可以是对象，如数组
 */
+ (void)alert:(id _Nullable)message;

/**
 alert提示框
 
 @param message 提示的内容，可以是对象，如数组
 @param title 提示的标题
 */
+ (void)alert:(NSString * _Nullable)message title:(NSString *_Nullable)title;

/**
 alert提示框
 
 @param message 提示的内容
 @param cancelTitle 取消按钮标题
 @param conformTitle 确认按钮标题
 @param callback 点击按钮后的回调
 */
+ (void)alert:(NSString *_Nullable)message
  cancelTitle:(NSString *_Nullable)cancelTitle
 conformTitle:(NSString *_Nullable)conformTitle
  clickedBack:(void(^_Nullable)(NSString *_Nonnull actionTitle, NSInteger actionIndex))callback;

/**
 alert提示框
 
 @param message 提示的内容
 @param title 提示的标题
 @param cancelTitle 取消按钮标题
 @param conformTitle 确认按钮标题
 @param callback 点击按钮后的回调
 */
+ (void)alert:(NSString *_Nullable)message
        title:(NSString *_Nullable)title
  cancelTitle:(NSString *_Nullable)cancelTitle
 conformTitle:(NSString *_Nullable)conformTitle
  clickedBack:(void(^_Nullable)(NSString *_Nonnull actionTitle, NSInteger actionIndex))callback;

/**
 带一个输入框的alert提示框
 
 @param title 提示标题
 @param message 提示内容
 @param cancelTitle 取消按钮标题
 @param conformTitle 确认按钮文本
 @param textFieldConfigHandler 输入框的配置闭包
 @param callback 点击按钮时的回调
 */
+ (void)alertEditViewWithTitle:(NSString *_Nullable)title
                       message:(NSString *_Nullable)message
                   cancelTitle:(NSString *_Nullable)cancelTitle
                  conformTitle:(NSString *_Nullable)conformTitle
        textFieldConfigHandler:(void(^_Nullable)(UITextField * _Nonnull textField))textFieldConfigHandler
                   clickedBack:(void(^_Nullable)(NSString * _Nonnull actionTitle, NSInteger actionIndex))callback;

/**
 支持自定义内容对齐方式的alert提示框
 
 @param message 提示内容
 @param title 提示标题
 @param cancelTitle 取消按钮标题
 @param conformTitle 确认按钮标题
 @param textAlign 内容对齐方式
 @param callback 点击按钮时的回调
 */
+ (void)alert:(id _Nullable)message
        title:(NSString *_Nullable)title
  cancelTitle:(NSString *_Nullable)cancelTitle
 conformTitle:(NSString *_Nullable)conformTitle
    textAlign:(NSTextAlignment)textAlign
  clickedBack:(void(^_Nullable)(NSString * _Nonnull actionTitle, NSInteger actionIndex))callback;

@end

@interface YFMessage (MBProgressHUD)

/**
 *  可以自动隐藏的提示
 *
 *  @param message 提示的内容
 *  @param view    提示视图要显示在的视图
 *  @param flag    是否自动隐藏
 */
+ (void)show:(id _Nullable )message onView:(UIView *_Nonnull)view autoHidden:(BOOL)flag;

/**
 *  显示HUD提示
 *
 *  @param message        提示的文字
 *  @param image          提示的image
 *  @param viewController delegate
 *  @param autoHidden     是否自动隐藏
 */
+ (void)show:(id _Nullable )message
       image:(UIImage *_Nullable)image
    delegate:(__kindof UIViewController *_Nonnull)viewController
  autoHidden:(BOOL)autoHidden;

/**
 *  创建并显示小菊花
 */
+ (void)showActiveViewOnView:(UIView *_Nonnull)view;
+ (void)showActiveViewWithTipString:(NSString *_Nullable)tipString
                             onView:(UIView *_Nonnull)view;
/**
 *  小菊花-无超时限制
 */
+ (void)showActiveViewMessage:(NSString *_Nonnull)tipString
                       onView:(UIView *_Nonnull)view;
/**
 *  隐藏小菊花
 */
+ (void)hideActiveView;

@end
