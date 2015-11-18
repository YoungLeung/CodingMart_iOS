//
//  IdentityAuthenticationViewController.m
//  CodingMart
//
//  Created by HuiYang on 15/11/17.
//  Copyright © 2015年 net.coding. All rights reserved.
//

#import "IdentityAuthenticationViewController.h"
#import "KLCPopup.h"
#import <QuartzCore/QuartzCore.h>
#import "ExampleView.h"

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

    
    ExampleView *exmp =[ExampleView createExameView];
    
    
    if (tag==87 || tag==88)
    {
        if (tag==87)
        {
            [exmp.exampleImgView setImage:[UIImage imageNamed:@"IDCard1_example"]];
            exmp.aTitleLabel.text=@"上传手持身份证正面图片";
        }else
        {
             [exmp.exampleImgView setImage:[UIImage imageNamed:@"IDCard2_example"]];
            exmp.aTitleLabel.text=@"上传手持身份证背面图片";
        }

        CGFloat width =kScreen_Width-20-20;
        
        [exmp setFrame:CGRectMake(0, 0, width, width)];
        
        
        
    }else
    {
        [exmp.exampleImgView setImage:[UIImage imageNamed:@"Document_example"]];
        exmp.aTitleLabel.text=@"上传授权说明图片";
        
        CGFloat width =kScreen_Width-20-20;
        
        [exmp setFrame:CGRectMake(0, 0, width, 1.5*width)];
        
    }
    
    KLCPopupLayout layout = KLCPopupLayoutMake(KLCPopupHorizontalLayoutCenter, KLCPopupVerticalLayoutCenter);
    
    KLCPopup* popup = [KLCPopup popupWithContentView:exmp showType:KLCPopupShowTypeBounceInFromTop dismissType:KLCPopupDismissTypeBounceOutToBottom maskType:KLCPopupMaskTypeDimmed dismissOnBackgroundTouch:NO dismissOnContentTouch:NO];
    
    [popup showWithLayout:layout];

    
}



@end
