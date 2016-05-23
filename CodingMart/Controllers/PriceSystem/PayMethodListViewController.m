//
//  PayMethodListViewController.m
//  CodingMart
//
//  Created by Frank on 16/5/23.
//  Copyright © 2016年 net.coding. All rights reserved.
//

#import "PayMethodListViewController.h"

@interface PayMethodListViewController () <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) NSArray *imageArray;
@property (strong, nonatomic) NSArray *titleArray;

@end

@implementation PayMethodListViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:_selectedPayment inSection:0] animated:YES scrollPosition:UITableViewScrollPositionTop];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setTitle:@"选择付款方式"];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    _imageArray = @[@"pay_method_ali", @"price_pay_method_wechat"];
    _titleArray = @[@"支付宝支付", @"微信支付"];
    
    [self.tableView registerClass:[PayMethodListCell class] forCellReuseIdentifier:[PayMethodListCell cellID]];
    [self.tableView setDelegate:self];
    [self.tableView setDataSource:self];
    [self setExtraCellLineHidden:self.tableView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _imageArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger index = indexPath.row;
    PayMethodListCell *cell = [tableView dequeueReusableCellWithIdentifier:[PayMethodListCell cellID]];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    [cell updateCellWithImageName:_imageArray[index] andTitle:_titleArray[index]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.selectPayMethodBlock) {
        self.selectPayMethodBlock(indexPath.row);
        [self.navigationController popViewControllerAnimated:YES];
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

@end

#pragma mark - 支付方式列表cell
@interface PayMethodListCell ()

@property (strong, nonatomic) UIImageView *iconImageView;
@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UIImageView *selectImageView;

@end

@implementation PayMethodListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setSeparatorInset:UIEdgeInsetsMake(0, 15, 0, 15)];

        self.iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 15, 40, 40)];
        
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.iconImageView.frame) + 15, 0, 100, 70)];
        [self.titleLabel setFont:[UIFont systemFontOfSize:15.0f]];
        
        self.selectImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kScreen_Width - 35, 0, 20, 70)];
        [self.selectImageView setImage:[UIImage imageNamed:@"price_select_icon"]];
        [self.selectImageView setContentMode:UIViewContentModeScaleAspectFit];

        [self addSubview:self.iconImageView];
        [self addSubview:self.titleLabel];
        [self addSubview:self.selectImageView];
    }
    return self;
}

- (void)updateCellWithImageName:(NSString *)imageName andTitle:(NSString *)title {
    [self.iconImageView setImage:[UIImage imageNamed:imageName]];
    [self.titleLabel setText:title];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    if (selected) {
        [self.selectImageView setHidden:NO];
    } else {
        [self.selectImageView setHidden:YES];
    }
}

+ (NSString *)cellID {
    return @"PayMethodListID";
}

@end

