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
#import "FunctionalThirdCell.h"
#import "FunctionalHeaderView.h"

@interface FunctionalEvaluationViewController () <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) UIView *backgroundView;
@property (strong, nonatomic) UIScrollView *topMenuView;
@property (strong, nonatomic) UIView *selectView;
@property (strong, nonatomic) NSDictionary *data;
@property (assign, nonatomic) NSInteger selectedIndex, selectedFirstIndex, selectedSecondIndex;
@property (strong, nonatomic) UIScrollView *firstMenuScrollView;
@property (strong, nonatomic) UIView *firstMenuSelectView; // 第一级菜单选中的背景
@property (strong, nonatomic) NSMutableArray *firstMenuArray, *secondMenuArray;
@property (strong, nonatomic) NSMutableDictionary *thirdMenuDict;
@property (strong, nonatomic) UITableView *secondMenuTableView, *thirdMenuTableView;

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
    _thirdMenuDict = [NSMutableDictionary dictionary];

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
    
    [UIView animateWithDuration:0.2 animations:^{
        [_thirdMenuTableView setX:kScreen_Width];
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
        for (id v in _firstMenuScrollView.subviews) {
            [v removeFromSuperview];
        }
        [_firstMenuScrollView setWidth:kScreen_Width * 0.33];
    } else {
        _firstMenuScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_topMenuView.frame), kScreen_Width * 0.33, kScreen_Height - 44 - 64)];
        [_firstMenuScrollView setBackgroundColor:[UIColor colorWithHexString:@"8796A8"]];
        [self.view addSubview:_firstMenuScrollView];
    }
    [_firstMenuArray removeAllObjects];
    
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
        
        // 分割线
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(button.frame), _firstMenuScrollView.frame.size.width - 20, 1)];
        [lineView setBackgroundColor:[UIColor whiteColor]];
        [lineView setTag:i+20];
        [_firstMenuScrollView addSubview:lineView];
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
        [_secondMenuTableView setX:CGRectGetMaxX(_firstMenuScrollView.frame)];
        [_secondMenuTableView setWidth:kScreen_Width - _firstMenuScrollView.frame.size.width];
        [_secondMenuTableView reloadData];
    }
    
    if (_firstMenuScrollView.width == 34.0f) {
        [self reduceFirstMenu];
    }
}


#pragma mark - 二级菜单
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
    [_secondMenuTableView setSeparatorColor:[UIColor colorWithHexString:@"DDDDDD"]];
    [_secondMenuTableView registerClass:[FunctionalSecondMenuCell class] forCellReuseIdentifier:[FunctionalSecondMenuCell cellID]];
    [self.view addSubview:_secondMenuTableView];
    [self setExtraCellLineHidden:_secondMenuTableView];
}

#pragma mark - 三级菜单
- (void)addThirdMenu {
    [self generateThirdMenu];
    _thirdMenuTableView = [[UITableView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_secondMenuTableView.frame), CGRectGetMaxY(_topMenuView.frame), kScreen_Width - CGRectGetMaxX(_secondMenuTableView.frame), _secondMenuTableView.frame.size.height) style:UITableViewStylePlain];
    [_thirdMenuTableView setDelegate:self];
    [_thirdMenuTableView setDataSource:self];
    [_thirdMenuTableView setSeparatorColor:[UIColor colorWithHexString:@"DDDDDD"]];
    [_thirdMenuTableView registerClass:[FunctionalThirdCell class] forCellReuseIdentifier:[FunctionalThirdCell cellID]];
    [_thirdMenuTableView registerClass:[FunctionalHeaderView class] forHeaderFooterViewReuseIdentifier:[FunctionalHeaderView viewID]];
    [_thirdMenuTableView setMultipleTouchEnabled:YES];
    [self.view addSubview:_thirdMenuTableView];
}

- (void)generateThirdMenu {
    [_thirdMenuDict removeAllObjects];
    NSMutableDictionary *allMenuDict = [_data objectForKey:@"quotations"];

    for (int i = 0; i < _secondMenuArray.count; i++) {
        FunctionMenu *menu = [_secondMenuArray objectAtIndex:i];
        NSArray *array = [menu.children componentsSeparatedByString:@","];
        NSMutableArray *mArray = [NSMutableArray array];
        for (int j = 0; j < array.count; j++) {
            FunctionMenu *thirdMenu = [NSObject objectOfClass:@"FunctionMenu" fromJSON:[allMenuDict objectForKey:array[j]]];
            [mArray addObject:thirdMenu];
        }
        [_thirdMenuDict setObject:[mArray copy] forKey:menu.code];
    }
}

#pragma mark - UITableViewDelagate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (tableView == _thirdMenuTableView) {
        return _secondMenuArray.count;
    }
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == _secondMenuTableView) {
        return _secondMenuArray.count;
    } else if (tableView == _thirdMenuTableView) {
        FunctionMenu *menu = [_secondMenuArray objectAtIndex:section];
        NSArray *array = [menu.children componentsSeparatedByString:@","];
        return array.count;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == _secondMenuTableView) {
        return 47.0f;
    } else if (tableView == _thirdMenuTableView) {
        return 72.0f;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (tableView == _thirdMenuTableView) {
        return 30.0f;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == _secondMenuTableView) {
        FunctionalSecondMenuCell *cell = [tableView dequeueReusableCellWithIdentifier:[FunctionalSecondMenuCell cellID]];
        if (!cell) {
            cell = [[FunctionalSecondMenuCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[FunctionalSecondMenuCell cellID]];
        }
        FunctionMenu *menu = [_secondMenuArray objectAtIndex:indexPath.row];
        [cell updateCell:menu];
        return cell;
    } else {
        FunctionalThirdCell *cell = [tableView dequeueReusableCellWithIdentifier:[FunctionalThirdCell cellID]];
        if (!cell) {
            cell = [[FunctionalThirdCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[FunctionalThirdCell cellID]];
        }
        FunctionMenu *menu = [_secondMenuArray objectAtIndex:indexPath.section];
        NSArray *thirdMenuArray = [_thirdMenuDict objectForKey:menu.code];
        FunctionMenu *thirdMenu = [thirdMenuArray objectAtIndex:indexPath.row];
        [cell updateCell:thirdMenu];
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == _secondMenuTableView) {
        // 缩小一级菜单
        if (_firstMenuScrollView.width != 34.0f) {
            [self reduceFirstMenu];
        }
        _selectedSecondIndex = indexPath.row;
        if (!_thirdMenuTableView) {
            [self addThirdMenu];
        } else {
            // 更新三级菜单
            [self generateThirdMenu];
            [_thirdMenuTableView setX:CGRectGetMaxX(_secondMenuTableView.frame)];
            [_thirdMenuTableView reloadData];
        }
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    FunctionMenu *menu = [_secondMenuArray objectAtIndex:section];
    FunctionalHeaderView *view = (FunctionalHeaderView *)[tableView dequeueReusableHeaderFooterViewWithIdentifier:[FunctionalHeaderView viewID]];
    if (!view) {
        view = [[FunctionalHeaderView alloc] initWithReuseIdentifier:[FunctionalHeaderView viewID]];
    }
    [view updateView:menu];
    return view;
}

- (void)reduceFirstMenu {
    // 复原
    if (_firstMenuScrollView.width == 34.0f) {
        [UIView animateWithDuration:0.2 animations:^{
            [_firstMenuScrollView setWidth:kScreen_Width * 0.33];
            [_firstMenuSelectView setWidth:_firstMenuScrollView.frame.size.width - 10];
            [_thirdMenuTableView setX:kScreen_Width];
            // 修改显示文字
            for (int i = 0; i < _firstMenuArray.count; i++) {
                UIButton *btn = [_firstMenuScrollView viewWithTag:i+10];
                if (i < _firstMenuArray.count) {
                    FunctionMenu *menu = [_firstMenuArray objectAtIndex:i];
                    [btn setTitle:menu.title forState:UIControlStateNormal];
                }
                [btn setWidth:_firstMenuScrollView.frame.size.width - 20];
                UIView *view = [_firstMenuScrollView viewWithTag:i+20];
                [view setWidth:_firstMenuScrollView.frame.size.width - 20];
            }
        }];
        
        [_secondMenuTableView setX:CGRectGetMaxX(_firstMenuScrollView.frame)];
        [_secondMenuTableView setWidth:kScreen_Width - _firstMenuScrollView.frame.size.width];
        [_thirdMenuTableView setX:kScreen_Width];
    } else {
        // 缩小
        [UIView animateWithDuration:0.2 animations:^{
            [_firstMenuScrollView setWidth:34.0f];
            [_firstMenuSelectView setWidth:24.0f];
            [_thirdMenuTableView setX:CGRectGetMaxX(_secondMenuTableView.frame)];

            // 修改显示文字
            for (int i = 0; i < _firstMenuArray.count; i++) {
                UIButton *btn = [_firstMenuScrollView viewWithTag:i+10];
                if (i < _firstMenuArray.count) {
                    FunctionMenu *menu = [_firstMenuArray objectAtIndex:i];
                    [btn setTitle:[menu.title substringToIndex:1] forState:UIControlStateNormal];
                }
                [btn setWidth:18.0f];
                UIView *view = [_firstMenuScrollView viewWithTag:i+20];
                [view setWidth:14.0f];
            }
        }];
        
        [_secondMenuTableView setX:CGRectGetMaxX(_firstMenuScrollView.frame)];
        [_secondMenuTableView setWidth:kScreen_Width*0.3];
        [_thirdMenuTableView setX:kScreen_Width];
    }
}

#pragma mark - 去除多余分割线
- (void)setExtraCellLineHidden:(UITableView *)tableView{
    UIView *view =[ [UIView alloc]init];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
    [tableView setTableHeaderView:view];
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
