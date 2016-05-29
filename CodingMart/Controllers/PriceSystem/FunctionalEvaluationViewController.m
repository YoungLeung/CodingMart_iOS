//
//  FunctionalEvaluationViewController.m
//  CodingMart
//
//  Created by Frank on 16/5/25.
//  Copyright © 2016年 net.coding. All rights reserved.
//

#import "FunctionalEvaluationViewController.h"
#import "UIView+BlocksKit.h"
#import "FunctionMenu.h"
#import "FunctionalSecondMenuCell.h"

@interface FunctionalEvaluationViewController () <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) UIView *backgroundView;
@property (strong, nonatomic) UIScrollView *topMenuView;
@property (strong, nonatomic) UIView *selectView;
@property (strong, nonatomic) NSDictionary *data;
@property (assign, nonatomic) NSInteger selectedIndex, selectedFirstIndex;
@property (strong, nonatomic) UIScrollView *firstMenuScrollView;
@property (strong, nonatomic) UIView *firstMenuSelectView; // 第一级菜单选中的背景
@property (strong, nonatomic) NSMutableArray *firstMenuArray, *secondMenuArray;
@property (strong, nonatomic) UITableView *secondMenuTableView;

@end

@implementation FunctionalEvaluationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
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
    
    _data = [NSObject loadResponseWithPath:@"priceListData"];
    _firstMenuArray = [NSMutableArray array];
    _secondMenuArray = [NSMutableArray array];

    // 加载顶部菜单
    [self addTopMenu];
}

- (void)addTopMenu {
    if (_topMenuView) {
        [_topMenuView removeFromSuperview];
        _topMenuView = nil;
    }
    _topMenuView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, kScreen_Width, 44)];
    [_topMenuView setBackgroundColor:[UIColor whiteColor]];
    [_topMenuView setShowsHorizontalScrollIndicator:NO];
    [_topMenuView setShowsVerticalScrollIndicator:NO];
    [self.view addSubview:_topMenuView];
    
    // 增加菜单
    float lastX = 0;
    UIButton *firstButton;
    for (int i = 0; i < _selectedMenuArray.count; i++) {
        NSString *title = _selectedMenuArray[i];
        CGSize size = [title getSizeWithFont:[UIFont systemFontOfSize:14.0f] constrainedToSize:CGSizeMake(CGFLOAT_MAX, 44)];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:title forState:UIControlStateNormal];
        [button setBackgroundColor:[UIColor whiteColor]];
        [button setFrame:CGRectMake(lastX, 0, size.width + 20, 44)];
        [button setTitleColor:[UIColor colorWithHexString:@"222222"] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor colorWithHexString:@"4289DB"] forState:UIControlStateSelected];
        [button.titleLabel setFont:[UIFont systemFontOfSize:14.0f]];
        [button setTag:i];
        [button addTarget:self action:@selector(selectButtonAtIndex:) forControlEvents:UIControlEventTouchUpInside];
        float scrollWith = _topMenuView.contentSize.width;
        scrollWith += button.frame.size.width;
        [_topMenuView setContentSize:CGSizeMake(scrollWith, _topMenuView.frame.size.height)];
        [_topMenuView addSubview:button];
        lastX = CGRectGetMaxX(button.frame);
        if (i == 0) {
            firstButton = button;
        }
    }
    
    // 选中指示条
    _selectView = [[UIView alloc] initWithFrame:CGRectMake(0, 42, 100, 2)];
    [_selectView setBackgroundColor:[UIColor colorWithHexString:@"4289DB"]];
    [_topMenuView addSubview:_selectView];
    
    [self selectButtonAtIndex:firstButton];
}

- (void)selectButtonAtIndex:(UIButton *)button {
    _selectedIndex = button.tag;
    NSArray *array = _topMenuView.subviews;
    for (int i = 0; i < array.count; i++) {
        id v = [array objectAtIndex:i];
        if ([v isKindOfClass:[UIButton class]]) {
            UIButton *btn = (UIButton *)v;
            if (btn.tag == button.tag) {
                [btn setSelected:YES];
            } else {
                [btn setSelected:NO];
            }
        }
    }
    
    [_selectView setWidth:button.frame.size.width - 20];
    [UIView animateWithDuration:0.2 animations:^{
        [_selectView setCenterX:button.centerX];
    }];
    
    [self addFirstMenu];
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
    float buttonWidth = (platformView.frame.size.width-15*3)/2;
    float buttonY = CGRectGetMaxY(lineView.frame);
    
    for (int i = 0; i < _menuArray.count; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        UIImage *normalImage = [UIImage imageWithColor:[UIColor colorWithHexString:@"F3F3F3"]];
        UIImage *selectedImage = [UIImage imageWithColor:[UIColor colorWithHexString:@"4289DB"]];
        [button setBackgroundImage:normalImage forState:UIControlStateNormal];
        [button setBackgroundImage:selectedImage forState:UIControlStateSelected | UIControlStateHighlighted];
        [button setTitle:_menuArray[i] forState:UIControlStateNormal];
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

#pragma mark - 一级菜单
// 加载一级菜单
- (void)addFirstMenu {
    if (_firstMenuScrollView) {
        [_firstMenuSelectView removeFromSuperview];
        _firstMenuSelectView = nil;
    }
    [_firstMenuArray removeAllObjects];
    _firstMenuScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_topMenuView.frame), kScreen_Width * 0.33, kScreen_Height - 44 - 64)];
    [_firstMenuScrollView setBackgroundColor:[UIColor colorWithHexString:@"8796A8"]];
    [self.view addSubview:_firstMenuScrollView];
    
    NSString *platforms = [_menuIDArray objectAtIndex:_selectedIndex];
    NSMutableDictionary *allMenuDict = [_data objectForKey:@"quotations"];
    NSDictionary *menuDict = [allMenuDict objectForKey:platforms];
    FunctionMenu *menu = [NSObject objectOfClass:@"FunctionMenu" fromJSON:menuDict];
    
    // 找出子模块
    NSString *children = menu.children;
    NSArray *childrenArray = [children componentsSeparatedByString:@","];
    for (int i = 0; i < childrenArray.count; i++) {
        FunctionMenu *menu = [NSObject objectOfClass:@"FunctionMenu" fromJSON:[allMenuDict objectForKey:childrenArray[i]]];
        [_firstMenuArray addObject:menu];
    }
    
    _firstMenuSelectView = [[UIView alloc] initWithFrame:CGRectMake(5, 8, _firstMenuScrollView.frame.size.width - 10, 45)];
    [_firstMenuSelectView setBackgroundColor:[UIColor whiteColor]];
    [_firstMenuSelectView setCornerRadius:2.0f];
    [_firstMenuScrollView addSubview:_firstMenuSelectView];
    
    UIButton *firstButton;
    for (int i = 0; i < _firstMenuArray.count; i++) {
        FunctionMenu *menu = [_firstMenuArray objectAtIndex:i];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:menu.title forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor colorWithHexString:@"8796A8"] forState:UIControlStateSelected];
        [button setTitleColor:[UIColor colorWithHexString:@"8796A8"] forState:UIControlStateHighlighted];
        [button setBackgroundColor:[UIColor clearColor]];
        [button setFrame:CGRectMake(10, i*60, _firstMenuScrollView.frame.size.width - 20, 60)];
        [button setTag:i+10];
        [button.titleLabel setFont:[UIFont systemFontOfSize:14.0f]];
        [button.titleLabel setTextAlignment:NSTextAlignmentLeft];
        [button.titleLabel setNumberOfLines:0];
        [button addTarget:self action:@selector(firstMenuButtonPress:) forControlEvents:UIControlEventTouchUpInside];
        [_firstMenuScrollView addSubview:button];
        if (i == 0) {
            [button setSelected:YES];
            firstButton = button;
        }
    }
    
    [self firstMenuButtonPress:firstButton];
}

- (void)firstMenuButtonPress:(UIButton *)button {
    _selectedFirstIndex = button.tag - 10;
    NSArray *array = _firstMenuScrollView.subviews;
    for (int i = 0; i < array.count; i++) {
        id v = [array objectAtIndex:i];
        if ([v isKindOfClass:[UIButton class]]) {
            UIButton *btn = (UIButton *)v;
            if (btn.tag == button.tag) {
                [btn setSelected:YES];
            } else {
                [btn setSelected:NO];
            }
        }
    }
    
    [UIView animateWithDuration:0.2 animations:^{
        [_firstMenuSelectView setCenterY:button.centerY];
    }];
    
    // 加载二级菜单
    if (!_secondMenuTableView) {
        [self addSecondMenu];
    } else {
        // 更新二级菜单
        [self generateSecondMenu];
        [_secondMenuTableView reloadData];
    }
}

- (void)generateSecondMenu {
    [_secondMenuArray removeAllObjects];
    FunctionMenu *firstMenu = [_firstMenuArray objectAtIndex:_selectedFirstIndex];
    NSMutableDictionary *allMenuDict = [_data objectForKey:@"quotations"];
    
    // 找二级菜单
    NSString *children = firstMenu.children;
    NSArray *childrenArray = [children componentsSeparatedByString:@","];
    for (int i = 0; i < childrenArray.count; i++) {
        FunctionMenu *menu = [NSObject objectOfClass:@"FunctionMenu" fromJSON:[allMenuDict objectForKey:childrenArray[i]]];
        [_secondMenuArray addObject:menu];
    }
}

- (void)addSecondMenu {
    [self generateSecondMenu];
    _secondMenuTableView = [[UITableView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_firstMenuScrollView.frame), CGRectGetMaxY(_topMenuView.frame), kScreen_Width - _firstMenuScrollView.frame.size.width, kScreen_Height - 44 - 64)];
    [_secondMenuTableView setBackgroundColor:[UIColor colorWithHexString:@"eaecee"]];
    [_secondMenuTableView setDelegate:self];
    [_secondMenuTableView setDataSource:self];
    [_secondMenuTableView registerClass:[FunctionalSecondMenuCell class] forCellReuseIdentifier:[FunctionalSecondMenuCell cellID]];
    [self.view addSubview:_secondMenuTableView];
}

#pragma mark - UITableViewDelagate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == _secondMenuTableView) {
        return _secondMenuArray.count;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == _secondMenuTableView) {
        return 47.0f;
    }
    return 47.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FunctionalSecondMenuCell *cell = [tableView dequeueReusableCellWithIdentifier:[FunctionalSecondMenuCell cellID]];
    if (!cell) {
        cell = [[FunctionalSecondMenuCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[FunctionalSecondMenuCell cellID]];
    }
    FunctionMenu *menu = [_secondMenuArray objectAtIndex:indexPath.row];
    [cell updateCell:menu];
    return cell;
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
