//
//  EaseDropListView.m
//  CodingMart
//
//  Created by Ease on 16/3/21.
//  Copyright © 2016年 net.coding. All rights reserved.
//

#define kCellIdentifier_EaseDropListCell @"EaseDropListCell"
#define kEaseDropListView_CellHeight 44.0
#define kEaseDropListView_ShowingBGAlpha 0.4

#import "EaseDropListView.h"
#import <BlocksKit/BlocksKit+UIKit.h>
#import "MPayOrderMapper.h"

@interface EaseDropListView ()<UITableViewDataSource, UITableViewDelegate>
@property (strong, nonatomic) UIView *bgView;
@property (strong, nonatomic) UITableView *myTableView;
@property (strong, nonatomic) UIView *footerV;
@end

@implementation EaseDropListView

- (instancetype)init
{
    self = [super init];
    if (self) {
        _bgView = ({
            UIView *view = [UIView new];
            view.backgroundColor = [UIColor blackColor];
            view.alpha = 0.0;
            __weak typeof(self) weakSelf = self;
            [view bk_whenTapped:^{
                [weakSelf dismissSendAction:NO];
            }];
            [self addSubview:view];
            [view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(self);
            }];
            view;
        });
        
        _myTableView = ({
            UITableView *tableView = [UITableView new];
            tableView.backgroundColor = [UIColor whiteColor];
            tableView.delegate = self;
            tableView.dataSource = self;
            [tableView registerClass:[EaseDropListCell class] forCellReuseIdentifier:kCellIdentifier_EaseDropListCell];
            [self addSubview:tableView];
            tableView.rowHeight = kEaseDropListView_CellHeight;
            tableView;
        });
    }
    return self;
}

- (void)showInView:(UIView *)view underTheView:(UIView *)theView maxHeight:(CGFloat)maxHeight{
    [view insertSubview:self belowSubview:theView];
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(view);
    }];
    CGFloat tableViewHeight = MIN(maxHeight, kEaseDropListView_CellHeight * self.dataList.count + (_isMutiple? 60: 0));
    self.myTableView.frame = CGRectMake(0, theView.bottom, view.width, self.myTableView.height);
    [self.myTableView reloadData];
    [UIView animateWithDuration:0.3 animations:^{
        _bgView.alpha = kEaseDropListView_ShowingBGAlpha;
    }];
    [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.7 initialSpringVelocity:0.7 options:UIViewAnimationOptionCurveLinear animations:^{
        self.myTableView.height = tableViewHeight;
    } completion:nil];
}
- (void)dismissSendAction:(BOOL)sendAction{
    if (self.actionBlock) {
        self.actionBlock(self, sendAction);
    }

    [UIView animateWithDuration:0.3 animations:^{
        self.myTableView.height = 0;
        self.bgView.alpha = 0.0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (BOOL)isShowing{
    return self.bgView.alpha > 0.1;
}

#pragma mark - Table
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    EaseDropListCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier_EaseDropListCell forIndexPath:indexPath];
    BOOL selected;
    if (_isMutiple) {
        selected = [_selectedDataList containsObject:self.dataList[indexPath.row]];
    }else{
        selected = indexPath.row == self.selectedIndex;
    }
    cell.accessoryType = selected? UITableViewCellAccessoryCheckmark: UITableViewCellAccessoryNone;
    cell.textLabel.textColor = selected? kColorBrandBlue: kColorTextLight66;
    NSObject *rowData = self.dataList[indexPath.row];
    NSString *title = nil;
    if ([rowData isKindOfClass:[NSString class]]) {
        title = (NSString *) rowData;
        if (self.helpDictionary) {
            title = self.helpDictionary[title];
        }
    }else if ([rowData isKindOfClass:[MPayOrderMapperTime class]]) {
        title = [(MPayOrderMapperTime *)rowData text];
    } else if ([rowData isKindOfClass:[MPayOrderMapperTrade class]]) {
        title = [(MPayOrderMapperTrade *)rowData title];
    }
    cell.titleStr = title;
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    cell.separatorInset = UIEdgeInsetsMake(0, 15, 0, 0);//默认左边空 15
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (_isMutiple) {
        BOOL willSelected = ![_selectedDataList containsObject:_dataList[indexPath.row]];
        if (willSelected) {
            [_selectedDataList addObject:_dataList[indexPath.row]];
        }else{
            [_selectedDataList removeObject:_dataList[indexPath.row]];
        }
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        cell.accessoryType = willSelected? UITableViewCellAccessoryCheckmark: UITableViewCellAccessoryNone;
        cell.textLabel.textColor = willSelected? kColorBrandBlue: kColorTextLight66;
    }else{
        if (indexPath.row != self.selectedIndex) {
            self.selectedIndex = indexPath.row;
            [self dismissSendAction:YES];
        }else{
            [self dismissSendAction:NO];
        }
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (!_isMutiple) {
        return nil;
    }
    if (!_footerV) {
        _footerV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, 60)];
        _footerV.backgroundColor = [UIColor whiteColor];
        WEAKSELF;
        CGFloat buttonWidth = (kScreen_Width - 3* 15)/ 2;
        UIButton *cancelBtn = ({
            UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(15, 10, buttonWidth, 40)];
            button.backgroundColor = [UIColor whiteColor];
            button.titleLabel.font = [UIFont systemFontOfSize:15];
            [button setTitleColor:[UIColor colorWithHexString:@"0x222222"] forState:UIControlStateNormal];
            [button setTitle:@"取消" forState:UIControlStateNormal];
            [button doBorderWidth:0.5 color:[UIColor colorWithHexString:@"0xB5B5B5"] cornerRadius:3.0];
            [button bk_addEventHandler:^(id sender) {
                [weakSelf dismissSendAction:NO];
            } forControlEvents:UIControlEventTouchUpInside];
            button;
        });
        UIButton *doneBtn = ({
            UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(buttonWidth+ 2* 15, 10, (kScreen_Width - 3* 15)/ 2, 40)];
            button.backgroundColor = kColorBrandBlue;
            button.titleLabel.font = [UIFont systemFontOfSize:15];
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [button setTitle:@"确定" forState:UIControlStateNormal];
            [button doBorderWidth:0.0 color:nil cornerRadius:3.0];
            [button bk_addEventHandler:^(id sender) {
                [weakSelf dismissSendAction:YES];
            } forControlEvents:UIControlEventTouchUpInside];
            button;
        });
        
        [_footerV addSubview:cancelBtn];
        [_footerV addSubview:doneBtn];
        [_footerV addLineUp:YES andDown:YES andColor:[UIColor colorWithHexString:@"0xdddddd"]];
    }
    return _footerV;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return _isMutiple? 60: 0;
}
@end

@implementation EaseDropListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.textLabel.font = [UIFont systemFontOfSize:14];
    }
    return self;
}

- (void)setTitleStr:(NSString *)titleStr{
    _titleStr = titleStr;
    self.textLabel.text = titleStr;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    [self.textLabel setX:15];
}

@end


@implementation UIView (EaseDropListView)

- (void)setEaseDropListView:(EaseDropListView *)easeDropListView{
    objc_setAssociatedObject(self, @selector(easeDropListView), easeDropListView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (EaseDropListView *)easeDropListView{
    return objc_getAssociatedObject(self, @selector(easeDropListView));
}

- (void)showDropListWithData:(NSArray *)dataList selectedIndex:(NSInteger)selectedIndex inView:(UIView *)view maxHeight:(CGFloat)maxHeight actionBlock:(void(^)(EaseDropListView *dropView, BOOL isComfirmed))block{
    if (!self.easeDropListView) {
        EaseDropListView *dropView = [EaseDropListView new];
        self.easeDropListView = dropView;
    }
    self.easeDropListView.isMutiple = NO;
    self.easeDropListView.dataList = dataList;
    self.easeDropListView.selectedIndex = selectedIndex;
    self.easeDropListView.actionBlock = block;
    [self.easeDropListView showInView:view underTheView:self maxHeight:maxHeight];
}
- (void)showDropListMutiple:(BOOL)isMutiple withData:(NSArray *)dataList selectedDataList:(NSArray *)selectedDataList inView:(UIView *)view maxHeight:(CGFloat)maxHeight helpDictionary:(NSDictionary *)helpDictionary actionBlock:(void(^)(EaseDropListView *dropView, BOOL isComfirmed))block{
    if (!self.easeDropListView) {
        EaseDropListView *dropView = [EaseDropListView new];
        self.easeDropListView = dropView;
    }

    self.easeDropListView.isMutiple = isMutiple;
    self.easeDropListView.dataList = dataList;
    self.easeDropListView.helpDictionary = helpDictionary;

    if (!isMutiple) {
        if (selectedDataList.count > 0) {
            self.easeDropListView.selectedIndex = [dataList indexOfObject:selectedDataList.firstObject];
        }else{
            self.easeDropListView.selectedIndex = NSNotFound;
        }
    }
    self.easeDropListView.selectedDataList = selectedDataList? selectedDataList.mutableCopy : @[].mutableCopy;
    self.easeDropListView.actionBlock = block;
    [self.easeDropListView showInView:view underTheView:self maxHeight:maxHeight];
}

@end