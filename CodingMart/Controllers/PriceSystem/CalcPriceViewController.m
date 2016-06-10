//
//  CalcPriceViewController.m
//  CodingMart
//
//  Created by Frank on 16/6/9.
//  Copyright © 2016年 net.coding. All rights reserved.
//

#import "CalcPriceViewController.h"
#import "Coding_NetAPIManager.h"
#import "CalcResult.h"
#import "PriceListViewController.h"

@interface CalcPriceViewController ()<UITextViewDelegate>

@property (strong, nonatomic) UIView *backgroundView, *bgView, *savePriceView;
@property (strong, nonatomic) UIButton *recalcButton, *saveButton;
@property (strong, nonatomic) UILabel *priceLabel, *platformLabel, *timeLabel, *placeHoderLabel;
@property (strong, nonatomic) UITextField *nameTextField;
@property (strong, nonatomic) UITextView *descContent;
@property (strong, nonatomic) NSNumber *listID;

@end

@implementation CalcPriceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"计算结果";
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithIcon:@"price_selected_menu_list" showBadge:NO target:self action:@selector(toFunctionList)];
    
    _backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 64 + 15, kScreen_Width, 222)];
    [_backgroundView setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:_backgroundView];
    
    // tip
    UILabel *tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 15, _backgroundView.width - 30, 27)];
    [tipLabel setText:@"码市提供报价参考，实际价格会有专业人员与您商定"];
    [tipLabel setFont:[UIFont systemFontOfSize:12.0f]];
    [tipLabel setTextColor:[UIColor colorWithHexString:@"F5A623"]];
    [tipLabel setBackgroundColor:[UIColor colorWithHexString:@"FFF6DD"]];
    [tipLabel setTextAlignment:NSTextAlignmentCenter];
    [tipLabel setCornerRadius:1.5f];
    [_backgroundView addSubview:tipLabel];
    
    // 报价描述
    UILabel *descriptionLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, tipLabel.bottom + 15, tipLabel.width, 20)];
    [descriptionLabel setText:@"码市预估报价："];
    [descriptionLabel setFont:[UIFont systemFontOfSize:14.0f]];
    [_backgroundView addSubview:descriptionLabel];
    
    // 报价
    _priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, descriptionLabel.bottom + 15, tipLabel.width, 32)];
    [_priceLabel setFont:[UIFont systemFontOfSize:24.0f]];
    [_priceLabel setTextColor:[UIColor colorWithHexString:@"F5A623"]];
    [_backgroundView addSubview:_priceLabel];
    
    // 分割线
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(15, _priceLabel.bottom + 15, tipLabel.width, 1)];
    [lineView setBackgroundColor:[UIColor colorWithHexString:@"DDDDDD"]];
    [_backgroundView addSubview:lineView];
    
    // 平台模块数据
    _platformLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, lineView.bottom + 15, tipLabel.width, 18)];
    [_platformLabel setFont:[UIFont systemFontOfSize:14.0f]];
    [_backgroundView addSubview:_platformLabel];
    
    // 预估时间
    _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, _platformLabel.bottom + 15, tipLabel.width, 18)];
    [_timeLabel setFont:[UIFont systemFontOfSize:14.0f]];
    [_backgroundView addSubview:_timeLabel];
    
    _recalcButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_recalcButton setFrame:CGRectMake(15, CGRectGetMaxY(_backgroundView.frame) + 15, kScreen_Width * 0.43, 44)];
    [_recalcButton setTitle:@"调整需求重新记算" forState:UIControlStateNormal];
    [_recalcButton setTitleColor:[UIColor colorWithHexString:@"4289DB"] forState:UIControlStateNormal];
    [_recalcButton setBackgroundColor:[UIColor whiteColor]];
    [_recalcButton.titleLabel setFont:[UIFont systemFontOfSize:15.0f]];
    [_recalcButton.layer setBorderColor:[UIColor colorWithHexString:@"DDDDDD"].CGColor];
    [_recalcButton.layer setBorderWidth:0.5f];
    [_recalcButton setCornerRadius:3.0f];
    [_recalcButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_recalcButton];
    
    _saveButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_saveButton setFrame:CGRectMake(_recalcButton.right + 15, CGRectGetMaxY(_backgroundView.frame) + 15, kScreen_Width * 0.43, 44)];
    [_saveButton setTitle:@"保存报价" forState:UIControlStateNormal];
    [_saveButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_saveButton setBackgroundColor:[UIColor colorWithHexString:@"4289DB"]];
    [_saveButton.titleLabel setFont:[UIFont systemFontOfSize:15.0f]];
    [_saveButton setCornerRadius:3.0f];
    [_saveButton addTarget:self action:@selector(savePrice) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_saveButton];
    
    __weak typeof(self)weakSelf = self;
    [[Coding_NetAPIManager sharedManager] post_calcPrice:@{@"codes":_parameter, @"webPageCount":_webPageNumber} block:^(id data, NSError *error) {
        if (!error) {
            CalcResult *result = data;
            [weakSelf updateView:result];
        }
    }];
}

- (void)updateView:(CalcResult *)result {
    [_priceLabel setText:[NSString stringWithFormat:@"¥ %@ - %@  元", result.fromPrice, result.toPrice]];
    NSMutableDictionary *fontDict = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                     NSFontAttributeName, [UIFont systemFontOfSize:14.0f],
                                     NSForegroundColorAttributeName, [UIColor colorWithHexString:@"999999"],
                                     nil];
    
    NSString *moduleCountString = [NSString stringWithFormat:@"%@", result.moduleCount];
    NSString *fromTermString = [NSString stringWithFormat:@"%@", result.fromTerm];
    NSString *toTermString = [NSString stringWithFormat:@"%@", result.toTerm];
    
    NSString *platformString = [NSString stringWithFormat:@"共有 %@ 个平台，%@ 个功能模块", result.platformCount, result.moduleCount];
    NSString *timeString = [NSString stringWithFormat:@"预计开发周期：%@ - %@ 个工作日", result.fromTerm, result.toTerm];
    NSMutableAttributedString *platformAttributedString = [[NSMutableAttributedString alloc] initWithString:platformString attributes:fontDict];
    NSMutableAttributedString *timeAttributedString = [[NSMutableAttributedString alloc] initWithString:timeString attributes:fontDict];
    
    [platformAttributedString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"4289DB"] range:NSMakeRange([platformString rangeOfString:@"，"].location + 1, moduleCountString.length)];
    [timeAttributedString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"4289DB"] range:NSMakeRange([timeString rangeOfString:fromTermString].location, fromTermString.length + toTermString.length + 3)];
    
    [_platformLabel setAttributedText:platformAttributedString];
    [_timeLabel setAttributedText:timeAttributedString];
}

- (void)back {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)savePrice {
    // 背景
    _bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, kScreen_Height)];
    [_bgView setBackgroundColor:[UIColor colorWithHexString:@"000000" andAlpha:0.4]];
    UITapGestureRecognizer *tgr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)];
    [_bgView addGestureRecognizer:tgr];
    [kKeyWindow addSubview:_bgView];
    
    _savePriceView = [[UIView alloc] initWithFrame:CGRectMake(15, kScreen_Height, _bgView.width - 30, 499)];
    [_savePriceView setBackgroundColor:[UIColor whiteColor]];
    [_savePriceView setCornerRadius:2.0f];
    [kKeyWindow addSubview:_savePriceView];
    
    // 关闭按钮
    UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [closeButton setFrame:CGRectMake(_savePriceView.width - 30, 15, 15, 15)];
    [closeButton setImage:[UIImage imageNamed:@"price_icon_close"] forState:UIControlStateNormal];
    [closeButton addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    [_savePriceView addSubview:closeButton];
    
    // 标题
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 25, _savePriceView.width, 25)];
    [titleLabel setText:@"保存报价"];
    [titleLabel setFont:[UIFont systemFontOfSize:18.0f]];
    [titleLabel setTextColor:[UIColor colorWithHexString:@"4289DB"]];
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    [_savePriceView addSubview:titleLabel];
    
    // 提示
    UILabel *tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, titleLabel.bottom + 15, _savePriceView.width - 30, 27)];
    [tipLabel setText:@"您保存／提交的项目，可在我发布的悬赏列表查看或编辑"];
    [tipLabel setBackgroundColor:[UIColor colorWithHexString:@"FFF6DD"]];
    [tipLabel setTextColor:[UIColor colorWithHexString:@"EEA551"]];
    [tipLabel setFont:[UIFont systemFontOfSize:12.0f]];
    [tipLabel setTextAlignment:NSTextAlignmentCenter];
    
    [tipLabel setCornerRadius:1.5f];
    [_savePriceView addSubview:tipLabel];
    
    // 项目名称
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, tipLabel.bottom + 15, tipLabel.width, 21)];
    [nameLabel setText:@"项目名称* "];
    [nameLabel setFont:[UIFont systemFontOfSize:15.0f]];
    [_savePriceView addSubview:nameLabel];
    
    // 项目名称Label
    _nameTextField = [[UITextField alloc] initWithFrame:CGRectMake(15, nameLabel.bottom + 15, tipLabel.width, 40)];
    [_nameTextField setPlaceholder:@"填写项目名称（必填）"];
    [_nameTextField setBackgroundColor:[UIColor colorWithHexString:@"F6F6F6"]];
    [_nameTextField setTextColor:[UIColor blackColor]];
    [_nameTextField setFont:[UIFont systemFontOfSize:14.0f]];
    [_nameTextField.layer setBorderWidth:0.5f];
    [_nameTextField.layer setCornerRadius:1.0f];
    [_nameTextField.layer setBorderColor:[UIColor colorWithHexString:@"DDDDDD"].CGColor];
    UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 15, 40)];
    [_nameTextField setLeftView:leftView];
    [_nameTextField setLeftViewMode:UITextFieldViewModeAlways];
    [_savePriceView addSubview:_nameTextField];
    
    // 项目描述
    UILabel *descLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, _nameTextField.bottom + 15, tipLabel.width, 21)];
    [descLabel setText:@"项目描述"];
    [descLabel setFont:[UIFont systemFontOfSize:15.0f]];
    [_savePriceView addSubview:descLabel];
    
    // 项目描述内容
    _descContent = [[UITextView alloc] initWithFrame:CGRectMake(15, descLabel.bottom + 15, tipLabel.width, 197)];
    [_descContent setFont:[UIFont systemFontOfSize:14.0f]];
    [_descContent setTextContainerInset:UIEdgeInsetsMake(10, 10, 10, 10)];
    [_descContent setBackgroundColor:[UIColor colorWithHexString:@"F6F6F6"]];
    [_descContent setTextColor:[UIColor blackColor]];
    [_descContent setFont:[UIFont systemFontOfSize:14.0f]];
    [_descContent.layer setBorderWidth:0.5f];
    [_descContent.layer setCornerRadius:1.0f];
    [_descContent.layer setBorderColor:[UIColor colorWithHexString:@"DDDDDD"].CGColor];
    [_descContent setShowsHorizontalScrollIndicator:NO];
    [_descContent setDelegate:self];
    [_savePriceView addSubview:_descContent];
    
    _placeHoderLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, _descContent.width - 30, 20)];
    [_placeHoderLabel setText:@"填写项目描述"];
    [_placeHoderLabel setFont:[UIFont systemFontOfSize:14.0f]];
    [_placeHoderLabel setTextColor:[UIColor colorWithHexString:@"CCCCCC"]];
    [_descContent addSubview:_placeHoderLabel];
    
    // 保存按钮
    UIButton *saveButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [saveButton setFrame:CGRectMake(15, _descContent.bottom + 15, tipLabel.width, 44)];
    [saveButton setBackgroundColor:[UIColor colorWithHexString:@"4289DB"]];
    [saveButton setTitle:@"确认保存" forState:UIControlStateNormal];
    [saveButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [saveButton.layer setCornerRadius:3.0f];
    [saveButton addTarget:self action:@selector(confirmSave) forControlEvents:UIControlEventTouchUpInside];
    [_savePriceView addSubview:saveButton];
    
    [UIView animateWithDuration:0.2 animations:^{
        [_savePriceView setCenterY:kScreen_CenterY];
    }];
}

// 保存成功
- (void)saveSuccess {
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 30, _savePriceView.width, 31)];
    [titleLabel setText:@"预估报价保存成功！"];
    [titleLabel setTextColor:[UIColor colorWithHexString:@"4289DB"]];
    [titleLabel setFont:[UIFont systemFontOfSize:22.0f]];
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    [_savePriceView addSubview:titleLabel];
    
    UIButton *priceListButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [priceListButton setFrame:CGRectMake(0, titleLabel.bottom + 15, titleLabel.width * 0.47, 44)];
    [priceListButton setCenterX:titleLabel.centerX];
    [priceListButton setTitle:@"查看我的报价列表" forState:UIControlStateNormal];
    [priceListButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [priceListButton setBackgroundColor:[UIColor colorWithHexString:@"4289DB"]];
    [priceListButton addTarget:self action:@selector(toMyPriceList) forControlEvents:UIControlEventTouchUpInside];
    [priceListButton.layer setCornerRadius:3.0f];
    [_savePriceView addSubview:priceListButton];
    
    UILabel *tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, priceListButton.bottom + 30, titleLabel.width*0.75, 0)];
    [tipLabel setCenterX:kScreen_CenterX];
    [tipLabel setNumberOfLines:0];
    [tipLabel setText:@"您可以在发布悬赏的过程中，将预估功能的报价作为参考链接提供给开发者。"];
    [tipLabel setFont:[UIFont systemFontOfSize:14.0f]];
    [tipLabel setTextColor:[UIColor colorWithHexString:@"999999"]];
    [tipLabel sizeThatFits:CGSizeMake(titleLabel.width*0.75, MAXFLOAT)];
    [tipLabel sizeToFit];
    [_savePriceView addSubview:tipLabel];
}

- (void)dismissSaveView {
    for (UIView *v in _savePriceView.subviews) {
        [v removeFromSuperview];
    }
    
    [UIView animateWithDuration:0.2 animations:^{
        [_savePriceView setHeight:217.5];
        [_savePriceView setCenterY:kScreen_CenterY];
        [self saveSuccess];
    }];
}

- (void)dismiss {
    [UIView animateWithDuration:0.2 animations:^{
        [_savePriceView setTop:kScreen_Height];
    } completion:^(BOOL finished) {
        [_savePriceView removeFromSuperview];
        _savePriceView = nil;
        
        [_bgView removeFromSuperview];
        _bgView = nil;
    }];
}

- (void)confirmSave {
    NSDictionary *parameter = [NSDictionary dictionaryWithObjectsAndKeys:
                               _parameter, @"codes",
                               _webPageNumber, @"webPageCount",
                               _nameTextField.text, @"name",
                               _descContent.text, @"description",
                               nil];
    
    __weak typeof(self)weakSelf = self;
    [[Coding_NetAPIManager sharedManager] post_savePrice:parameter block:^(id data, NSError *error) {
        if (!error) {
            weakSelf.listID = data;
            [weakSelf dismissSaveView];
        }
    }];
}

- (void)toMyPriceList {
    [self dismiss];
    PriceListViewController *vc = [[PriceListViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)toFunctionList {
    
}

#pragma mark - textViewDelegate
- (void)textViewDidBeginEditing:(UITextView *)textView {
    [_placeHoderLabel setHidden:YES];
}

- (void)textViewDidChange:(UITextView *)textView {
    if (textView.text.length > 0) {
        [_placeHoderLabel setHidden:YES];
    } else {
        [_placeHoderLabel setHidden:NO];
    }
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
