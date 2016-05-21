//
//  ChooseSystemPayView.m
//  CodingMart
//
//  Created by Frank on 16/5/21.
//  Copyright © 2016年 net.coding. All rights reserved.
//

#import "ChooseSystemPayView.h"
#import "UIView+BlocksKit.h"
#import "PayMethodTableViewCell.h"

@interface ChooseSystemPayView () <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) UIView *bgView;
@property (strong, nonatomic) UIView *contentView;

@property (strong, nonatomic) UINavigationController *nav;
@property (strong, nonatomic) UITableViewController *tabVC;
@property (strong, nonatomic) NSArray *menuArray;

@end

@implementation ChooseSystemPayView

- (instancetype)init {
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.frame = kScreen_Bounds;
        
        if (!_bgView) {
            _bgView = ({
                UIView *view = [[UIView alloc] initWithFrame:kScreen_Bounds];
                view.backgroundColor = [UIColor blackColor];
                view.alpha = 0;
                [view bk_whenTapped:^{
                    [self dismiss];
                }];
                view;
            });
            [self addSubview:_bgView];
        }
        if (!_contentView) {
            _contentView = [UIView new];
            _contentView.backgroundColor = [UIColor colorWithHexString:@"0xF0F0F0"];
//        if (!_titleL) {
//            _titleL = ({
//                UILabel *label = [UILabel new];
//                label.textAlignment = NSTextAlignmentCenter;
//                label.font = [UIFont systemFontOfSize:14];
//                label.textColor = [UIColor colorWithHexString:@"0x666666"];
//                label;
//            });
//            [_contentView addSubview:_titleL];
//            [_titleL mas_makeConstraints:^(MASConstraintMaker *make) {
//                make.left.right.equalTo(_contentView);
//                make.top.equalTo(_contentView).offset(10);
//                make.height.mas_equalTo(20);
//            }];
//        }
        }
        
        _menuArray = @[@"付款方式", @"付款金额"];
        self.tabVC = [[UITableViewController alloc] init];
        [self.tabVC.view setFrame:CGRectMake(0, kScreen_Height - 270, kScreen_Width, 270)];
        [self.tabVC.tableView setDelegate:self];
        [self.tabVC.tableView setDataSource:self];
        [self.tabVC.tableView registerClass:[PayMethodTableViewCell class] forCellReuseIdentifier:[PayMethodTableViewCell cellID]];
        [self.tabVC setTitle:@"付款详情"];

        self.nav = [[UINavigationController alloc] initWithRootViewController:self.tabVC];
        [self.nav.view setFrame:CGRectMake(0, kScreen_Height - 270, kScreen_Width, 270)];
        [self addSubview:self.nav.view];
        
        [self show];
    }
    return self;
}

- (void)show {
    [kKeyWindow addSubview:self];
    
    //animate to show
    CGPoint endCenter = self.contentView.center;
    endCenter.y -= CGRectGetHeight(self.contentView.frame);
    
    [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.bgView.alpha = 0.3;
        self.contentView.center = endCenter;
    } completion:nil];
}

- (void)dismiss{
    //animate to dismiss
    CGPoint endCenter = self.contentView.center;
    endCenter.y += CGRectGetHeight(self.contentView.frame);
    
    [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.bgView.alpha = 0.0;
        self.contentView.center = endCenter;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

#pragma mark - TableView Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PayMethodTableViewCell *cell = (PayMethodTableViewCell *)[tableView dequeueReusableCellWithIdentifier:[PayMethodTableViewCell cellID]];
    NSInteger index = indexPath.row;
    [cell updateCellWithTitleName:_menuArray[index] andSubTitle:@"支付宝"];
    return cell;
}

@end
