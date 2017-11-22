//
//  YFMessage.m
//
//  Created by Dandre on 16/3/22.
//  Copyright © 2016年 Dandre. All rights reserved.
//

#import "YFMessage.h"

@implementation YFMessage

static YFMessage *yfMsg = nil;
+ (YFMessage *)shareMessage
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        yfMsg = [[YFMessage alloc] init];
        yfMsg.hudView = [[MBProgressHUD alloc] init];
        
        UIImageView *imageView = [YFView createImageViewFrame:CGRectMake(0, 0, 0, 0)
                                                    imageName:nil
                                                  isUIEnabled:NO];
        imageView.tag = 0x10000;
        UILabel *tipLabel = [YFView createLabelWithFrame:CGRectMake(0, 0, 0, 0)
                                                    text:nil
                                               TextAlign:center
                                                 bgColor:nil
                                                fontSize:16
                                                  radius:0];
        tipLabel.tag = 0x10001;
        tipLabel.textColor = [UIColor colorWithWhite:200/255.0 alpha:1];
        tipLabel.numberOfLines = 0;
        yfMsg.noContentTipView = [YFView createViewWithFrame:CGRectMake(0, 0, 0, 0)
                                                     bgColor:[UIColor clearColor]
                                                      radius:0];
        yfMsg.noContentTipView.userInteractionEnabled = NO;
        [yfMsg.noContentTipView addSubview:imageView];
        [yfMsg.noContentTipView addSubview:tipLabel];
    });
    
    return yfMsg;
}

/**
 *  提示框
 *
 *  @param message 提示的内容
 */
+ (void)alert:(NSString *)massage
{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:YFCulture(@"温馨提示") message:massage delegate:nil cancelButtonTitle:YFCulture(@"确定") otherButtonTitles:nil, nil];
    [alert show];
}

/**
 *  提示框
 *
 *  @param message 提示的内容
 */
+ (void)show:(NSString *)massage title:(NSString *)title
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:massage delegate:nil cancelButtonTitle:YFCulture(@"确定") otherButtonTitles:nil, nil];
    [alert show];
}

/**
 *  提示框
 *
 *  @param message 提示的内容
 */
+ (void)show:(id)message
{
    [self alert:[NSString stringWithFormat:@"%@",message]];
}

/**
 *  提示框
 *
 *  @param message 提示的内容
 */
- (void)show:(id)message okTitle:(NSString *)title Clicked:(AlertButtonClickedBlock)block
{
    _block = block;
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:YFCulture(@"温馨提示") message:[NSString stringWithFormat:@"%@",message] delegate:self cancelButtonTitle:title otherButtonTitles:title == nil?YFCulture(@"确定"):YFCulture(@"取消"), nil];
    alert.delegate = self;
    [alert show];
}

/**
 *  提示框
 *
 *  @param message 提示的内容
 */
- (void)show:(id)message tipTitle:(NSString *)tipTitle okTitle:(NSString *)okTitle Clicked:(AlertButtonClickedBlock)block
{
    _block = block;
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:tipTitle message:[NSString stringWithFormat:@"%@",message] delegate:self cancelButtonTitle:okTitle otherButtonTitles:okTitle == nil?YFCulture(@"确定"):YFCulture(@"取消"), nil];
    alert.delegate = self;
    [alert show];
}

/**
 *  提示框
 *
 *  @param message 提示的内容
 */
- (void)show:(id)message tipTitle:(NSString *)tipTitle oneTitle:(NSString *)okTitle Clicked:(AlertButtonClickedBlock)block
{
    _block = block;
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:tipTitle message:[NSString stringWithFormat:@"%@",message] delegate:self cancelButtonTitle:okTitle==nil?YFCulture(@"确定"):okTitle otherButtonTitles:nil, nil];
    alert.delegate = self;
    [alert show];
}

/**
 *  提示框
 *
 *  @param message 提示的内容
 *  @param title  确定按钮现实的文字
 */
+ (void)show:(id)message okTitle:(NSString *)title Clicked:(AlertButtonClickedBlock)block
{
    [[YFMessage shareMessage] show:message okTitle:title Clicked:block];
}

/**
 *  提示框
 *
 *  @param tipTitle 提示的标题
 *  @param message  提示的内容
 *  @param okTitle  确定按钮现实的文字
 */
+ (void)show:(id)message tipTitle:(NSString *)tipTitle okTitle:(NSString *)okTitle Clicked:(AlertButtonClickedBlock)block
{
    [[YFMessage shareMessage] show:message tipTitle:tipTitle okTitle:okTitle Clicked:block];
}

/**
 *  可以自动隐藏的提示
 *
 *  @param message 提示的内容
 *  @param view    提示视图要显示在的视图
 *  @param flag    是否自动隐藏
 */
+ (void)show:(id)message
      onView:(UIView *)view
  autoHidden:(BOOL)flag {
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
+ (void)showActiveViewOnView:(UIView *)view
{
    BOOL isMainThread = [NSThread isMainThread];
    if (isMainThread) {
        [YFMessage showActiveViewWithTipString:YFCulture(@"加载中...") onView:view];
    }else{
        dispatch_async(dispatch_get_main_queue(), ^{
            [YFMessage showActiveViewWithTipString:YFCulture(@"加载中...") onView:view];
        });
    }
}

/**
 *  创建并显示小菊花
 *
 *  @param tipString 提示的文字
 *  @param view      显示所在的视图
 */
+ (void)showActiveViewWithTipString:(NSString *)tipString onView:(UIView *)view
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

+ (void)showActiveViewMessage:(NSString *)tipString onView:(UIView *)view
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

/**
 *  显示无内容提示
 *
 *  @param message 提示的文字
 *  @param image   显示的图片
 *  @param view    显示所在的视图
 */
+ (UIView *)showNoContentTip:(NSString *)message image:(NSString *)image onView:(UIView *)view
{
    
    if ([YFMessage shareMessage].noContentTipView == nil) {
        UIImageView *imageView = [YFView createImageViewFrame:CGRectMake(0, 0, 0, 0)
                                                    imageName:nil
                                                  isUIEnabled:NO];
        imageView.tag = 0x10000;
        UILabel *tipLabel = [YFView createLabelWithFrame:CGRectMake(0, 0, 0, 0)
                                                    text:nil
                                               TextAlign:center
                                                 bgColor:nil
                                                fontSize:16
                                                  radius:0];
        tipLabel.tag = 0x10001;
        tipLabel.textColor = [UIColor colorWithWhite:200/255.0 alpha:1];
        tipLabel.numberOfLines = 0;
        [YFMessage shareMessage].noContentTipView = [YFView createViewWithFrame:CGRectMake(0, 0, 0, 0)
                                                                        bgColor:[UIColor clearColor]
                                                                         radius:0];
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

/**
 *  显示带文本框的AlertView
 */
+ (UIAlertView *)showEditViewWithTitle:(NSString *)title
                               message:(NSString *)msg
                         okButtonTitle:(NSString *)okTitle
                         ClickedButton:(AlertButtonClickedBlock)block
{
    return [[YFMessage shareMessage] showEditViewWithTitle:title message:msg okButtonTitle:okTitle ClickedButton:block];
}

- (UIAlertView *)showEditViewWithTitle:(NSString *)title
                               message:(NSString *)msg
                         okButtonTitle:(NSString *)okTitle
                         ClickedButton:(AlertButtonClickedBlock)block
{
    _block = block;
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                    message:YFCulture(msg)
                                                   delegate:self
                                          cancelButtonTitle:okTitle
                                          otherButtonTitles:okTitle == nil?YFCulture(@"确定"):YFCulture(@"取消"), nil];
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    [alert show];
    return alert;
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (_block) {
        _block(buttonIndex);
    }
}

+ (void)show:(id)message
       image:(UIImage *)image
    delegate:(__kindof UIViewController *)viewController
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
        HUD = [[MBProgressHUD alloc] initWithView:kAppWindow];
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

#pragma mark -
/**
 *  提示框
 *
 *  @param message 提示的内容
 */
- (void)show:(id)message
    tipTitle:(NSString *)tipTitle
     okTitle:(NSString *)okTitle
 cancelTitle:(NSString *)cancelTitle
   textAlign:(NSTextAlignment)textAlign
     Clicked:(AlertButtonClickedBlock)block
{
    _block = block;
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:tipTitle
                                                                   message:message
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    if (okTitle!=nil) {
        [alert addAction:[UIAlertAction actionWithTitle:okTitle
                                                  style:UIAlertActionStyleCancel
                                                handler:^(UIAlertAction * _Nonnull action) {
                                                    _block(0);
                                                }]];
    }else{
        [alert addAction:[UIAlertAction actionWithTitle:@"确定"
                                                  style:UIAlertActionStyleCancel
                                                handler:^(UIAlertAction * _Nonnull action) {
                                                    _block(0);
                                                }]];
    }
    
    if (cancelTitle!=nil) {
        [alert addAction:[UIAlertAction actionWithTitle:cancelTitle
                                                  style:UIAlertActionStyleDefault
                                                handler:^(UIAlertAction * _Nonnull action) {
                                                    _block(1);
                                                }]];
    }
    
    UIView *subView1 = [alert.view.subviews firstObject];
    UIView *subView2 = [subView1.subviews firstObject];
    UIView *subView3 = [subView2.subviews firstObject];
    UIView *subView4 = [subView3.subviews firstObject];
    UIView *subView5 = [subView4.subviews firstObject];
    
    if (subView5.subviews.count>2) {
        UILabel *message = subView5.subviews[1];
        message.textAlignment = textAlign;
    }
    
    if ([[EFAppDelegate shared].rootViewController isKindOfClass:[EFTabBarViewController class]]) {
        [[EFAppDelegate shared].rootViewController presentViewController:alert
                                                                       animated:YES completion:nil];
    }else{
        [[EFAppDelegate shared].window.rootViewController presentViewController:alert
                                                                              animated:YES completion:nil];
    }
}

/**
 *  提示框
 *
 *  @param message 提示的内容
 */
+ (void)show:(id)message
    tipTitle:(NSString *)tipTitle
     okTitle:(NSString *)okTitle
 cancelTitle:(NSString *)cancelTitle
   textAlign:(NSTextAlignment)textAlign
     Clicked:(AlertButtonClickedBlock)block
{
    [[YFMessage shareMessage] show:message
                          tipTitle:tipTitle
                           okTitle:okTitle
                       cancelTitle:cancelTitle
                         textAlign:textAlign
                           Clicked:block];
}

@end
