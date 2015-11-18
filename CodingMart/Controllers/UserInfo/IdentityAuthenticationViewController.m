//
//  IdentityAuthenticationViewController.m
//  CodingMart
//
//  Created by HuiYang on 15/11/17.
//  Copyright © 2015年 net.coding. All rights reserved.
//

#import "IdentityAuthenticationViewController.h"

@interface IdentityAuthenticationViewController ()<UITextFieldDelegate>

//示例Action tag 【87-身份证正面；88-身份证背面；89-授权文件】
//选择照片Action tag【87-身份证正面；88-身份证背面；89-授权文件】

@property (weak, nonatomic) IBOutlet UITextField *userNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *identityIDTextFiled;
@property (weak, nonatomic) IBOutlet UITextField *aliyPayTextField;
@property (weak, nonatomic) IBOutlet BEMCheckBox *codingCheckBox;

- (IBAction)showExampleAction:(id)sender;
- (IBAction)selectImgAction:(id)sender;
- (IBAction)downloadAction:(id)sender;
- (IBAction)submitAction:(id)sender;

@end

@implementation IdentityAuthenticationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"身份认证";
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
//    [super tableView:tableView willDisplayCell:cell forRowAtIndexPath:indexPath];
//    if (indexPath.row == 2) {
//        cell.separatorInset = UIEdgeInsetsMake(0, kScreen_Width, 0, 0);//隐藏掉它
//    }else{
//        cell.separatorInset = UIEdgeInsetsMake(0, 15, 0, 15);
//    }
//}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)showExampleAction:(id)sender
{
    UIButton *btn =(UIButton*)sender;
    [self showExampleViewWithTag:btn.tag];
}

- (IBAction)selectImgAction:(id)sender
{
}

- (IBAction)downloadAction:(id)sender
{
}
- (IBAction)submitAction:(id)sender
{
    
}

-(void)showExampleViewWithTag:(NSInteger)tag
{
    UIView *bgView =[[UIView alloc]init];
    bgView.backgroundColor=[UIColor blackColor];
//    bgView.alpha=0.5;
    bgView.tag=999;
    
    UIView *contentView =[UIView new];
    contentView.backgroundColor=[UIColor whiteColor];
    contentView.layer.masksToBounds=YES;
    contentView.layer.cornerRadius=10;
    
    UILabel *titleLb =[UILabel new];
    titleLb.textAlignment=NSTextAlignmentLeft;
    titleLb.font=[UIFont systemFontOfSize:17];
    
    UIButton *closeBtn =[UIButton buttonWithType:UIButtonTypeCustom];
    [closeBtn setBackgroundImage:[UIImage imageNamed:@"icon-showAll"] forState:UIControlStateNormal];
    [closeBtn addTarget:self action:@selector(closeExAction) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *line =[UIView new];
    line.backgroundColor=[UIColor grayColor];
    
    UIImageView *contentImgView =[UIImageView new];
    contentImgView.contentMode=UIViewContentModeScaleToFill;
    
    [contentView addSubview:titleLb];
    [contentView addSubview:closeBtn];
    [contentView addSubview:line];
    [contentView addSubview:contentImgView];
    
    [bgView addSubview:contentView];
    
    [self.view insertSubview:bgView atIndex:1];
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    if (tag==87 || tag==88)
    {
        if (tag==87)
        {
            [contentImgView setImage:[UIImage imageNamed:@"IDCard1_example"]];
        }else
        {
             [contentImgView setImage:[UIImage imageNamed:@"IDCard1_example"]];
        }
        //ui
        [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(bgView.mas_left).offset(20);
            make.right.equalTo(bgView.mas_right).offset(-20);
            make.height.equalTo(contentView.mas_width);
            make.centerY.equalTo(bgView.mas_centerY).offset(100);
        }];
        
        [contentImgView mas_makeConstraints:^(MASConstraintMaker *make)
        {
            make.left.equalTo(contentView.mas_left).offset(10);
            make.right.equalTo(contentView.mas_right).offset(-10);
            make.height.equalTo(contentImgView.mas_width);
            make.bottom.equalTo(contentView.mas_bottom).offset(-10);
        }];
        
    }else
    {
        
    }
    
    
}

-(void)closeExAction
{
    UIView *showView =[self.view viewWithTag:999];
    [showView removeFromSuperview];
    
}

@end
