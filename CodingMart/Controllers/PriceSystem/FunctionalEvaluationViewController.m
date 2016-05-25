//
//  FunctionalEvaluationViewController.m
//  CodingMart
//
//  Created by Frank on 16/5/25.
//  Copyright © 2016年 net.coding. All rights reserved.
//

#import "FunctionalEvaluationViewController.h"
#import "UIView+BlocksKit.h"

@interface FunctionalEvaluationViewController ()

@property (strong, nonatomic) UIView *backgroundView;

@end

@implementation FunctionalEvaluationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setTitle:@"功能评估"];
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setFrame:CGRectMake(0, 0, 100, 40)];
    [backButton setTitle:@"修改平台" forState:UIControlStateNormal];
    [backButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [backButton.titleLabel setFont:[UIFont systemFontOfSize:14.0f]];
    [backButton addTarget:self action:@selector(changePlatform) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    UIBarButtonItem *space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    space.width = -25;
    [self.navigationItem setRightBarButtonItems:@[space, backItem]];
}

- (void)changePlatform {
    __weak typeof(self)weakSelf = self;
    if (!_backgroundView) {
        _backgroundView = [[UIView alloc] initWithFrame:kScreen_Bounds];
        [_backgroundView setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:0.3]];
        [_backgroundView bk_whenTapped:^{
            [weakSelf dismiss];
        }];
        [kKeyWindow addSubview:_backgroundView];
    }
    
    // 选择平台窗口
    UIView *platformView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width - 30, 250)];
    [platformView setCenterX:kScreen_CenterX];
    [platformView setCenterY:270.0f];
    [platformView setBackgroundColor:[UIColor whiteColor]];
    [platformView.layer setCornerRadius:2.0f];
    [_backgroundView addSubview:platformView];
    
    // 修改平台
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 15, 100, 21)];
    [label setText:@"修改平台"];
    [label setTextColor:[UIColor blackColor]];
    [label setFont:[UIFont systemFontOfSize:15.0f]];
    [platformView addSubview:label];
    
    // 分割线
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(15, 45, platformView.frame.size.width - 30, 1)];
    [lineView setBackgroundColor:[UIColor colorWithHexString:@"4289DB"]];
    [platformView addSubview:lineView];
    
    // 平台按钮
    NSArray *menuArray = @[@"Web 网站", @"微信应用", @"iOS APP", @"Android APP", @"HTML5 应用", @"其他"];
    float buttonWidth = (platformView.frame.size.width-15*3)/2;
    float buttonY = CGRectGetMaxY(lineView.frame);
    
    for (int i = 0; i < menuArray.count; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        UIImage *normalImage = [UIImage imageWithColor:[UIColor colorWithHexString:@"F3F3F3"]];
        UIImage *selectedImage = [UIImage imageWithColor:[UIColor colorWithHexString:@"4289DB"]];
        [button setBackgroundImage:normalImage forState:UIControlStateNormal];
        [button setBackgroundImage:selectedImage forState:UIControlStateSelected | UIControlStateHighlighted];
        [button setTitle:menuArray[i] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor colorWithHexString:@"666666"] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected | UIControlStateHighlighted];
        [button.titleLabel setFont:[UIFont systemFontOfSize:15.0f]];
        [button setFrame:CGRectMake(i%2*buttonWidth + i%2*15 + 15, buttonY + i/2*36 + i/2*10 + 15, buttonWidth, 36)];
        [button.layer setCornerRadius:2.0f];
        [button setClipsToBounds:YES];
        [platformView addSubview:button];
    }
    
    float viewWidth = CGRectGetWidth(platformView.frame);
    float viewHeight = CGRectGetHeight(platformView.frame);
    
    // 底部分割线
    UIView *bottomLineView = [[UIView alloc] initWithFrame:CGRectMake(0, viewHeight - 45, platformView.frame.size.width, 1)];
    [bottomLineView setBackgroundColor:[UIColor colorWithHexString:@"CCCCCC"]];
    [platformView addSubview:bottomLineView];
    
    // 取消按钮
    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancelButton setFrame:CGRectMake(0, viewHeight - 44, viewWidth/2, 44)];
    [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    [cancelButton setTitleColor:[UIColor colorWithHexString:@"222222"] forState:UIControlStateNormal];
    [cancelButton.titleLabel setFont:[UIFont systemFontOfSize:15.0f]];
    [cancelButton addTarget:self action:@selector(cancelButtonPress) forControlEvents:UIControlEventTouchUpInside];
    [platformView addSubview:cancelButton];
    
    // 确定按钮
    UIButton *confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [confirmButton setFrame:CGRectMake(viewWidth/2, viewHeight - 44, viewWidth/2, 44)];
    [confirmButton setTitle:@"确定" forState:UIControlStateNormal];
    [confirmButton setTitleColor:[UIColor colorWithHexString:@"222222"] forState:UIControlStateNormal];
    [confirmButton.titleLabel setFont:[UIFont systemFontOfSize:15.0f]];
    [confirmButton addTarget:self action:@selector(confirmButtonPress) forControlEvents:UIControlEventTouchUpInside];
    [platformView addSubview:confirmButton];
    
    // 按钮分割线
    UIView *buttonLine = [[UIView alloc] initWithFrame:CGRectMake(viewWidth/2, viewHeight-44, 1, 44)];
    [buttonLine setBackgroundColor:[UIColor colorWithHexString:@"CCCCCC"]];
    [platformView addSubview:buttonLine];
}

- (void)cancelButtonPress {
    [self dismiss];
}

- (void)confirmButtonPress {
    
}

+ (UIImage *)imageWithColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

- (void)dismiss {
    [_backgroundView removeFromSuperview];
    _backgroundView = nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
