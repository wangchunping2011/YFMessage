//
//  YFMessage.m
//
//  Created by Dandre on 16/3/22.
//  Copyright © 2016年 Dandre. All rights reserved.
//

#import "YFMessage.h"

@implementation YFMessage

static YFMessage *yfMsg = nil;
+ (YFMessage *_Nonnull)shareMessage
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        yfMsg = [[YFMessage alloc] init];
        yfMsg.hudView = [[MBProgressHUD alloc] init];
        
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
        imageView.userInteractionEnabled = NO;
        imageView.tag = 0x10000;
        UILabel *tipLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
        tipLabel.font = [UIFont systemFontOfSize:16];
        tipLabel.lineBreakMode = NSLineBreakByCharWrapping;
        tipLabel.numberOfLines = 0;
        tipLabel.textAlignment = NSTextAlignmentCenter;
        tipLabel.tag = 0x10001;
        tipLabel.textColor = [UIColor colorWithWhite:200/255.0 alpha:1];
        tipLabel.numberOfLines = 0;
       
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
        view.backgroundColor = [UIColor clearColor];
        yfMsg.noContentTipView = view;
        yfMsg.noContentTipView.userInteractionEnabled = NO;
        [yfMsg.noContentTipView addSubview:imageView];
        [yfMsg.noContentTipView addSubview:tipLabel];
    });
    
    return yfMsg;
}

/**
 *  显示无内容提示
 *
 *  @param message 提示的文字
 *  @param image   显示的图片
 *  @param view    显示所在的视图
 */
+ (UIView *_Nonnull)showNoContentTip:(NSString *_Nullable)message
                               image:(NSString *_Nullable)image
                              onView:(UIView *_Nonnull)view
{
    
    if ([YFMessage shareMessage].noContentTipView == nil) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        imageView.userInteractionEnabled = NO;
        imageView.tag = 0x10000;
        
        UILabel *tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        tipLabel.font = [UIFont systemFontOfSize:16];
        tipLabel.lineBreakMode = NSLineBreakByCharWrapping;
        tipLabel.numberOfLines = 0;
        tipLabel.textAlignment = NSTextAlignmentCenter;
        tipLabel.tag = 0x10001;
        tipLabel.textColor = [UIColor colorWithWhite:200/255.0 alpha:1];
        tipLabel.numberOfLines = 0;
       
        UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        view.backgroundColor = [UIColor clearColor];
        [YFMessage shareMessage].noContentTipView = view;
        [YFMessage shareMessage].noContentTipView.userInteractionEnabled = NO;
        [[YFMessage shareMessage].noContentTipView addSubview:imageView];
        [[YFMessage shareMessage].noContentTipView addSubview:tipLabel];
    }
    [YFMessage shareMessage].noContentTipView.frame = CGRectMake(0, view.frame.size.height/2-130, view.frame.size.width, 210);
    UIImageView *imageView = [[YFMessage shareMessage].noContentTipView viewWithTag:0x10000];
    imageView.frame = CGRectMake(view.frame.size.width/2-50, 20, 100, 100);
    imageView.image = [UIImage imageNamed:image];
    imageView.contentMode = UIViewContentModeCenter;
    
    UILabel *label = [[YFMessage shareMessage].noContentTipView viewWithTag:0x10001];
    label.frame = CGRectMake(0, 140, view.frame.size.width, 50);
    label.text = message;
    
    [view addSubview:[YFMessage shareMessage].noContentTipView];
    
    [YFMessage shareMessage].noContentTipView.hidden = NO;
    
    return [YFMessage shareMessage].noContentTipView;
}

/**
 *  隐藏无内容提示视图
 */
+ (void)hideNoContentTipView
{
    [YFMessage shareMessage].noContentTipView.hidden = YES;
}

@end


@implementation YFMessage (AlertView)

#pragma mark - 创建alert带回调-基础方法
+ (UIAlertController *_Nonnull)alert:(NSString *_Nullable)message
                               title:(NSString *_Nullable)title
                               style:(UIAlertControllerStyle)style
                   cancelActionTitle:(NSString *_Nullable)cancelActionTitle
                   otherActionTitles:(NSArray<NSString *> *_Nullable)actionTitles
                         clickedBack:(void(^_Nullable)(NSString *_Nonnull actionTitle, NSInteger actionIndex))callback

{
    NSMutableArray *actions = @[].mutableCopy;
    if (cancelActionTitle) {
        [actions addObject:[UIAlertAction actionWithTitle:cancelActionTitle
                                                    style:UIAlertActionStyleCancel
                                                  handler:^(UIAlertAction * _Nonnull action) {
                                                      if (callback) {
                                                          callback(action.title, [actionTitles indexOfObject:action.title]);
                                                      }
                                                  }]];
    }
    for (NSString *actionTitle in actionTitles) {
        [actions addObject:[UIAlertAction actionWithTitle:actionTitle
                                                    style:UIAlertActionStyleDefault
                                                  handler:^(UIAlertAction * _Nonnull action) {
                                                      if (callback) {
                                                          callback(action.title, [actionTitles indexOfObject:action.title]);
                                                      }
                                                  }]];
    }
    
    return [YFMessage alert:message
                      title:title
                      style:style
                    actions:actions];
}
#pragma mark - 创建alert基础方法
+ (UIAlertController *_Nonnull)alert:(NSString *_Nullable)message
                               title:(NSString *_Nullable)title
                               style:(UIAlertControllerStyle)style
                             actions:(NSArray <UIAlertAction *> *_Nullable)actions
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title
                                                                   message:message
                                                            preferredStyle:style];
    for (UIAlertAction *action in actions) {
        [alert addAction:action];
    }
    [[self getCurrentVC] presentViewController:alert animated:YES completion:nil];
    return alert;
}


/**
 alert提示框
 
 @param message 提示的内容，可以是对象，如数组
 */
+ (void)alert:(id _Nullable)message
{
    NSString *msg = message;
    if (![message isKindOfClass:[NSString class]]) {
        msg = [NSString stringWithFormat:@"%@",message];
    }
    [YFMessage alert:msg title:@"温馨提示"];
}

/**
 alert提示框
 
 @param message 提示的内容，可以是对象，如数组
 @param title 提示的标题
 */
+ (void)alert:(NSString * _Nullable)message title:(NSString *_Nullable)title
{
    [YFMessage alert:message
               title:title
               style:UIAlertControllerStyleAlert
   cancelActionTitle:@"确定"
   otherActionTitles:nil
         clickedBack:nil];
}

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
  clickedBack:(void(^_Nullable)(NSString *_Nonnull actionTitle, NSInteger actionIndex))callback
{
    [YFMessage alert:message
               title:@"温馨提示"
         cancelTitle:cancelTitle
        conformTitle:conformTitle
         clickedBack:callback];
}

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
  clickedBack:(void(^_Nullable)(NSString *_Nonnull actionTitle, NSInteger actionIndex))callback
{
    [YFMessage alert:message
               title:title
               style:UIAlertControllerStyleAlert
   cancelActionTitle:cancelTitle
   otherActionTitles:conformTitle?@[conformTitle]:nil
         clickedBack:callback];
}

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
                   clickedBack:(void(^_Nullable)(NSString * _Nonnull actionTitle, NSInteger actionIndex))callback
{
    [[YFMessage alert:message
                title:title
                style:UIAlertControllerStyleAlert
    cancelActionTitle:cancelTitle
    otherActionTitles:conformTitle?@[conformTitle]:nil
          clickedBack:callback] addTextFieldWithConfigurationHandler:textFieldConfigHandler];
}

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
  clickedBack:(void(^_Nullable)(NSString * _Nonnull actionTitle, NSInteger actionIndex))callback
{
    UIAlertController *alert = [YFMessage alert:message
                                          title:title
                                          style:UIAlertControllerStyleAlert
                              cancelActionTitle:cancelTitle
                              otherActionTitles:conformTitle?@[conformTitle]:nil
                                    clickedBack:callback];
    
    UIView *subView1 = [alert.view.subviews firstObject];
    UIView *subView2 = [subView1.subviews firstObject];
    UIView *subView3 = [subView2.subviews firstObject];
    UIView *subView4 = [subView3.subviews firstObject];
    UIView *subView5 = [subView4.subviews firstObject];
    
    if (subView5.subviews.count>2) {
        UILabel *message = subView5.subviews[1];
        message.textAlignment = textAlign;
    }
}

//获取当前屏幕显示的viewcontroller
+ (UIViewController *)getCurrentVC
{
    UIViewController *rootViewController = [UIApplication sharedApplication].keyWindow.rootViewController;
    
    UIViewController *currentVC = [self getCurrentVCFrom:rootViewController];
    
    return currentVC;
}

+ (UIViewController *)getCurrentVCFrom:(UIViewController *)rootVC
{
    UIViewController *currentVC;
    
    if ([rootVC presentedViewController]) {
        // 视图是被presented出来的
        
        rootVC = [rootVC presentedViewController];
    }
    
    if ([rootVC isKindOfClass:[UITabBarController class]]) {
        // 根视图为UITabBarController
        
        currentVC = [self getCurrentVCFrom:[(UITabBarController *)rootVC selectedViewController]];
        
    } else if ([rootVC isKindOfClass:[UINavigationController class]]){
        // 根视图为UINavigationController
        
        currentVC = [self getCurrentVCFrom:[(UINavigationController *)rootVC visibleViewController]];
        
    } else {
        // 根视图为非导航类
        
        currentVC = rootVC;
    }
    
    return currentVC;
}

@end

@implementation YFMessage (MBProgressHUD)

/**
 *  可以自动隐藏的提示
 *
 *  @param message 提示的内容
 *  @param view    提示视图要显示在的视图
 *  @param flag    是否自动隐藏
 */
+ (void)show:(id _Nullable )message onView:(UIView *_Nonnull)view autoHidden:(BOOL)flag
{
    MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:view];
    [view addSubview:HUD];
    HUD.mode = MBProgressHUDModeText;
    
    HUD.customView = [[UIImageView alloc] initWithImage:nil];
    HUD.detailsLabelText = message;
    HUD.detailsLabelFont = [UIFont fontWithName:@"Arial" size:16];
    
    [HUD show:YES];
    if (flag) {
        [HUD hide:YES afterDelay:2];
    }
    //    [YFMessage shareMessage].hudView = HUD;
}

/**
 *  创建并显示小菊花
 *
 *  @param view 显示所在的视图
 */
+ (void)showActiveViewOnView:(UIView *_Nonnull)view
{
    if ([NSThread isMainThread]) {
        [YFMessage showActiveViewWithTipString:@"加载中..." onView:view];
    }else{
        dispatch_async(dispatch_get_main_queue(), ^{
            [YFMessage showActiveViewWithTipString:@"加载中..." onView:view];
        });
    }
}

/**
 *  创建并显示小菊花
 *
 *  @param tipString 提示的文字
 *  @param view      显示所在的视图
 */
+ (void)showActiveViewWithTipString:(NSString *_Nullable)tipString
                             onView:(UIView *_Nonnull)view
{
    if ([YFMessage shareMessage].hudView == nil) {
        [YFMessage shareMessage].hudView = [[MBProgressHUD alloc] init];
    }
    [view addSubview:[YFMessage shareMessage].hudView];
    [YFMessage shareMessage].hudView.mode = MBProgressHUDModeIndeterminate;
    [YFMessage shareMessage].hudView.detailsLabelText = tipString;
    [YFMessage shareMessage].hudView.detailsLabelFont = [UIFont fontWithName:@"Arial" size:16];
    [[YFMessage shareMessage].hudView show:YES];
    
    [[YFMessage shareMessage].hudView hide:YES afterDelay:20];
}

+ (void)showActiveViewMessage:(NSString *_Nonnull)tipString
                       onView:(UIView *_Nonnull)view
{
    if ([YFMessage shareMessage].hudView == nil) {
        [YFMessage shareMessage].hudView = [[MBProgressHUD alloc] init];
    }
    
    [view addSubview:[YFMessage shareMessage].hudView];
    [YFMessage shareMessage].hudView.mode = MBProgressHUDModeIndeterminate;
    [YFMessage shareMessage].hudView.detailsLabelText = tipString;
    [YFMessage shareMessage].hudView.detailsLabelFont = [UIFont fontWithName:@"Arial" size:16];
    [[YFMessage shareMessage].hudView show:YES];
}

/**
 *  隐藏小菊花
 */
+ (void)hideActiveView
{
    [[YFMessage shareMessage].hudView hide:YES];
    [[YFMessage shareMessage].hudView removeFromSuperview];
    [YFMessage shareMessage].hudView = nil;
}

+ (void)show:(id _Nullable )message
       image:(UIImage *_Nullable)image
    delegate:(__kindof UIViewController *_Nonnull)viewController
  autoHidden:(BOOL)autoHidden
{
    [[YFMessage shareMessage] showHUD:message image:image delegate:viewController autoHidden:autoHidden];
}

- (void)showHUD:(id)message
          image:(UIImage *)image
       delegate:(__kindof UIViewController *)viewController
     autoHidden:(BOOL)autoHidden
{
    MBProgressHUD *HUD;
    if (viewController!=nil) {
        HUD = [[MBProgressHUD alloc] initWithView:viewController.view];
    }else{
        HUD = [[MBProgressHUD alloc] initWithView:[UIApplication sharedApplication].delegate.window];
    }
    [viewController.view addSubview:HUD];
    
    HUD.mode = MBProgressHUDModeCustomView;
    
    HUD.customView = [[UIImageView alloc] initWithImage:image];
    HUD.labelText = message;
    
    [HUD show:YES];
    if (autoHidden) {
        [HUD hide:YES afterDelay:1];
    }
    self.hudView = HUD;
}

@end
