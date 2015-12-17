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
#import "LCActionSheet.h"
#import "Coding_NetAPIManager.h"
#import "IdentityAuthenticationModel.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "TableViewFooterButton.h"
#import <QuickLook/QuickLook.h>
#import "UIButton+WebCache.h"
#import "UITableView+FDTemplateLayoutCell.h"
#import "UIImageView+WebCache.h"
#import "NSString+Verify.h"


//buton  的tag 对于此
typedef NS_ENUM(NSInteger, UIIdentityMode)
{
    identity_img_front=87,
    identity_img_back=88,
    identity_img_auth=89
};

//示例Action tag 【87-身份证正面；88-身份证背面；89-授权文件】
//选择照片Action tag【87-身份证正面；88-身份证背面；89-授权文件】


#define kDownloadPath @"https://mart.coding.net/api/download/auth_file"
#define kUploadImgPath @"https://mart.coding.net/api/upload"

@interface IdentityAuthenticationViewController ()<UITextFieldDelegate,LCActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,QLPreviewControllerDataSource>


@property(nonatomic,assign) NSInteger currentSelectImgTag;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *textViewHeight;
@property (weak, nonatomic) IBOutlet UITextField *userNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *identityIDTextFiled;
@property (weak, nonatomic) IBOutlet UITextField *aliyPayTextField;
@property (weak, nonatomic) IBOutlet UIButton *checkBox;

@property (weak, nonatomic) IBOutlet UIButton *identity_img_front_Button;
@property (weak, nonatomic) IBOutlet UIButton *identity_img_back_Button;
@property (weak, nonatomic) IBOutlet UIButton *identity_img_auth_Button;

@property (weak, nonatomic) IBOutlet UIButton *identity_img_front_DeleteBtn;
@property (weak, nonatomic) IBOutlet UIButton *identity_img_back_DeleteBtn;
@property (weak, nonatomic) IBOutlet UIButton *identity_img_auth_DeleteBtn;

@property (weak, nonatomic) IBOutlet UIProgressView *identity_img_front_Progress;
@property (weak, nonatomic) IBOutlet UIImageView *identity_img_front_StatusIcon;
@property (weak, nonatomic) IBOutlet UILabel *identity_img_front_StatusLabel;

@property (weak, nonatomic) IBOutlet UIProgressView *identity_img_back_Progress;
@property (weak, nonatomic) IBOutlet UIImageView *identity_img_back_StatusIcon;
@property (weak, nonatomic) IBOutlet UILabel *identity_img_back_StatusLabel;

@property (weak, nonatomic) IBOutlet UIProgressView *identity_img_auth_Progress;
@property (weak, nonatomic) IBOutlet UIImageView *identity_img_auth_StatusIcon;
@property (weak, nonatomic) IBOutlet UILabel *identity_img_auth_StatusLabel;

@property (weak, nonatomic) IBOutlet UIButton *download_identity_img_auth_Button;
@property (weak, nonatomic) IBOutlet TableViewFooterButton *submitBtn;
@property (weak, nonatomic) IBOutlet UITextView *userAgreementTextView;


@property (strong,nonatomic)IdentityAuthenticationModel *model;
@property (strong,nonatomic)IdentityAuthenticationModel *originalModel;
@property (strong,nonatomic)KLCPopup* popup;
@property (assign,nonatomic)BOOL canEedit;
@property (assign,nonatomic)BOOL isUploadingImg;
@property (assign,nonatomic)CGFloat userAgreementTextViewHeight;



- (IBAction)showExampleAction:(id)sender;
- (IBAction)selectImgAction:(id)sender;
- (IBAction)downloadAction:(id)sender;
- (IBAction)submitAction:(id)sender;
- (IBAction)identityImgDeleteAction:(id)sender;

@end

@implementation IdentityAuthenticationViewController

+ (instancetype)storyboardVC{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"UserInfo" bundle:nil];
    return [storyboard instantiateViewControllerWithIdentifier:@"IdentityAuthenticationViewController"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"身份认证";
    [self configUI];
    // Do any additional setup after loading the view.
}

-(void)dealloc
{
//    self.idCard1Img=nil;
//    self.idCard2Img=nil;
//    self.documentImg=nil;
}

#pragma mark Navigation
- (BOOL)navigationShouldPopOnBackButton{
    [self.view endEditing:YES];
    if ([self.model isSameTo:self.originalModel]) {
        return YES;
    }else{
        __weak typeof(self) weakSelf = self;
        [[UIActionSheet bk_actionSheetCustomWithTitle:@"返回后，修改的数据将不会被保存" buttonTitles:@[@"确定返回"] destructiveTitle:nil cancelTitle:@"取消" andDidDismissBlock:^(UIActionSheet *sheet, NSInteger index) {
            if (index == 0) {
                [weakSelf.navigationController popViewControllerAnimated:YES];
            }
        }] showInView:self.view];
        return NO;
    }
}



-(void)configUI
{
    [self hideAllStatusEx];
    
    if ([self isDocumentExistsAtPath])
    {
        [self.download_identity_img_auth_Button setTitle:@"打开模板" forState:UIControlStateNormal];
    }else
    {
        [self.download_identity_img_auth_Button setTitle:@"下载模板" forState:UIControlStateNormal];
    }
    [self setupDefValue];
    [self setupEvent];
    //计算textview高度
//     self.userAgreementTextViewHeight =[IdentityAuthenticationViewController heightForString:[self userProtocol] fontSize:14 andWidth:kScreen_Width-30]+230;
    
         self.userAgreementTextViewHeight =[IdentityAuthenticationViewController heightForString:[self userProtocol] fontSize:14 andWidth:kScreen_Width-30]+15;
     self.textViewHeight.constant=self.userAgreementTextViewHeight;
    

}

-(void)setupEvent
{
    WEAKSELF
    [self.userNameTextField.rac_textSignal subscribeNext:^(NSString *newText)
     {
         weakSelf.userNameTextField.textColor=[UIColor blackColor];
         weakSelf.model.name = newText;
         [weakSelf checkSubmitBtnEnabledStatus];
         
     }];
    
    [self.identityIDTextFiled.rac_textSignal subscribeNext:^(NSString *newText){
        weakSelf.identityIDTextFiled.textColor=[UIColor blackColor];
        weakSelf.model.identity = newText;
        [weakSelf checkSubmitBtnEnabledStatus];
        
    }];
    [self.aliyPayTextField.rac_textSignal subscribeNext:^(NSString *newText){
        weakSelf.aliyPayTextField.textColor=[UIColor blackColor];
        weakSelf.model.alipay = newText;
        [weakSelf checkSubmitBtnEnabledStatus];
        
    }];
    [RACObserve(self, model.isAgree) subscribeNext:^(id x) {
//        [self.checkBox setImage:[UIImage imageNamed:(_model.isAgree? @"checkbox_checked": @"checkbox_check")] forState:UIControlStateNormal];
        [self.checkBox setImage:[UIImage imageNamed:(self.model.isAgree? @"fill_checked": @"fill_unchecked")] forState:UIControlStateNormal];
    }];
    
}

-(void)checkSubmitBtnEnabledStatus
{
    BOOL isEnable =NO;
    if (self.model.name.length>0&& self.model.identity.length>0 &&self.model.identity_img_back.length>0 &&self.model.identity_img_front.length>0 &&self.model.identity_img_auth.length>0 && self.model.isAgree &&self.model.alipay.length>0 )
    {
        isEnable=YES;
    }else
    {
        isEnable=NO;
    }
    self.submitBtn.enabled=isEnable;
}

-(void)setupDefValue
{

    self.model =self.identity_server_CacheDataDic?[NSObject objectOfClass:@"IdentityAuthenticationModel" fromJSON:self.identity_server_CacheDataDic]:[IdentityAuthenticationModel new];
    self.originalModel =self.identity_server_CacheDataDic?[NSObject objectOfClass:@"IdentityAuthenticationModel" fromJSON:self.identity_server_CacheDataDic]:[IdentityAuthenticationModel new];
    
    if ([IdentityAuthenticationModel getcacheUserName])
    {
        self.model.name=[IdentityAuthenticationModel getcacheUserName];
        self.originalModel.name=[IdentityAuthenticationModel getcacheUserName];
    }
    
    self.userNameTextField.text=self.model.name;
    self.identityIDTextFiled.text=self.model.identity;
    self.aliyPayTextField.text=self.model.alipay;
    
    self.identity_img_auth_DeleteBtn.hidden=YES;
    self.identity_img_back_DeleteBtn.hidden=YES;
    self.identity_img_front_DeleteBtn.hidden=YES;
    
    self.identity_img_front_Button.imageView.contentMode=UIViewContentModeScaleAspectFill;
    self.identity_img_back_Button.imageView.contentMode=UIViewContentModeScaleAspectFill;
    self.identity_img_auth_Button.imageView.contentMode=UIViewContentModeScaleAspectFill;
    
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 5;// 字体的行间距
    
    NSDictionary *attributes = @{
                                 NSFontAttributeName:[UIFont systemFontOfSize:14],
                                 NSParagraphStyleAttributeName:paragraphStyle
                                 };
    self.userAgreementTextView.attributedText = [[NSAttributedString alloc] initWithString:[self userProtocol] attributes:attributes];
    
    self.userAgreementTextView.textContainerInset=UIEdgeInsetsMake(10, 5, 0, 10);
    
    
    
    UIImage *defImg =[UIImage imageNamed:@"image_ia_addfile"];
    
    
    if (self.model.identity_img_front)
    {
        [self.identity_img_front_Button sd_setImageWithURL:[NSURL URLWithString:self.model.identity_img_front]  forState:UIControlStateNormal placeholderImage:defImg] ;
    }
    if (self.model.identity_img_back)
    {
        [self.identity_img_back_Button sd_setImageWithURL:[NSURL URLWithString:self.model.identity_img_back] forState:UIControlStateNormal placeholderImage:defImg];
    }
    if (self.model.identity_img_auth)
    {
        [self.identity_img_auth_Button sd_setImageWithURL:[NSURL URLWithString:self.model.identity_img_auth] forState:UIControlStateNormal placeholderImage:defImg];
    }
    
    if ([self.model.identityIsPass integerValue]==3 ||[self.model.identityIsPass integerValue]==1)
    {
        self.canEedit=NO;
    }else
    {
        self.canEedit=YES;
    }
    
}

-(void)checkIdentityCardValidity
{
    if (self.model.identity.length<15)
    {
        [NSObject showHudTipStr:@"身份证格式错误，请重新填写:身份证证号不能少于15位"];
//        KAlert(@"身份证格式错误，请重新填写:身份证证号不能少于15位");
    }else if (self.model.identity.length>18)
    {
        [NSObject showHudTipStr:@"身份证格式错误，请重新填写:身份证证号不能多于18位"];
//        KAlert(@"身份证格式错误，请重新填写:身份证证号不能多于18位");
    }
}

-(void)setCanEedit:(BOOL)canEedit
{
    _canEedit=canEedit;
    
    self.userNameTextField.enabled=canEedit;
    self.identityIDTextFiled.enabled=canEedit;
    self.aliyPayTextField.enabled=canEedit;
//    self.identity_img_front_Button.enabled=canEedit;
//    self.identity_img_back_Button.enabled=canEedit;
//    self.identity_img_auth_Button.enabled=canEedit;
    self.submitBtn.enabled=canEedit;
    
    if(self.model.identity_img_front.length>2)
    {
      self.identity_img_front_DeleteBtn.hidden=!canEedit;
    }
    if (self.model.identity_img_back.length>2)
    {
     self.identity_img_back_DeleteBtn.hidden=!canEedit;
    }
    if (self.model.identity_img_auth.length>2)
    {
        self.identity_img_auth_DeleteBtn.hidden=!canEedit;
    }
    
    if (!canEedit)
    {
        NSString *aTitle =@"";
        if ([self.model.identityIsPass integerValue]==3)
        {
              aTitle=@"等待认证";
        }else if ( [self.model.identityIsPass integerValue]==1)
        {
              aTitle=@"认证通过";
        }
        
        [self.submitBtn setBackgroundColor:[UIColor colorWithHexString:@"D8D8D8"]];
        [self.submitBtn setTitle:aTitle forState:UIControlStateNormal];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    [super tableView:tableView willDisplayCell:cell forRowAtIndexPath:indexPath];
    switch (indexPath.row)
    {

        case 3:
            cell.separatorInset = UIEdgeInsetsMake(0, kScreen_Width, 0, 0);//隐藏掉它
            break;
        case 4:
            cell.separatorInset = UIEdgeInsetsMake(0, kScreen_Width, 0, 0);//隐藏掉它
            break;
        case 5:
            cell.separatorInset = UIEdgeInsetsMake(0, kScreen_Width, 0, 0);//隐藏掉它
            break;
        default:
            cell.separatorInset = UIEdgeInsetsMake(0, 15, 0, 15);
            break;
    }
}

//132-80-75-182-147-148-636

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row)
    {
        case 0:
            return 132;
            break;
        case 1:
            return 80;
            break;
        case 2:
            return 75;
            break;
        case 3:
            return 182;
            break;
        case 4:
            return 147;
            break;
        case 5:
            return 148;
            break;
        case 6:
        {
            CGFloat height =self.userAgreementTextViewHeight;
            if (kDevice_Is_iPhone5)
            {
                height= height+100;
            }else if (kDevice_Is_iPhone6)
            {
                height= height+100;

            }else if (kDevice_Is_iPhone6Plus)
            {
                height= height+100;
            }
            return height;
            break;
        }
            
        default:
            return 0;
            break;
    }
}



- (IBAction)showExampleAction:(id)sender
{
    UIButton *btn =(UIButton*)sender;
    [self showExampleViewWithTag:btn.tag];
}

- (IBAction)selectImgAction:(id)sender
{
    
    UIButton *btn =(UIButton*)sender;

    if (btn.tag==identity_img_front && self.model.identity_img_front.length>3)
    {
        [self showBigIdentityImgWithImgPath:self.model.identity_img_front];
    }else if (btn.tag==identity_img_back && self.model.identity_img_back.length>3)
    {
        [self showBigIdentityImgWithImgPath:self.model.identity_img_back];
    }else if (btn.tag==identity_img_auth && self.model.identity_img_auth.length>3)
    {
        [self showBigIdentityImgWithImgPath:self.model.identity_img_auth];
    }else
    {
        if(self.isUploadingImg)
            return;
        
      self.currentSelectImgTag=btn.tag;
       [self showSelectImgView];
    }
}

- (IBAction)downloadAction:(id)sender
{

    if ([self isDocumentExistsAtPath])
    {
//        KAlert(@"打开");
        [self viewerDocument];
    }else
    {
        //下载
        NSString *savedPath = [NSHomeDirectory() stringByAppendingString:@"/Documents/condingDev.docx"];
        [self downloadFileWithPath:savedPath];
    }
    
}

-(void)viewerDocument
{
    QLPreviewController *ql = [[QLPreviewController alloc]init];
//    ql.navigationController.navigationBarHidden = YES;
    // Set data source
    ql.dataSource =self;
//    ql.title=@"授权说明文件";
    
    // Which item to preview
    [ql setCurrentPreviewItemIndex:0];

//    ql.edgesForExtendedLayout = UIRectEdgeNone;
//    ql.automaticallyAdjustsScrollViewInsets=YES;
//    UINavigationBar *navBar =  [UINavigationBar appearanceWhenContainedIn:[QLPreviewController class], nil];
//    
//    navBar.translucent = NO;
//    [navBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
//    [navBar setShadowImage:[UIImage new]];
//    navBar.barTintColor = kNavBarTintColor;
    
    
    
//    [self presentViewController:ql animated:YES completion:nil];
    
//    CGRect cgr =ql.view.frame;
//    ql.view.frame=CGRectMake(0, 64, cgr.size.width, cgr.size.height);
    
    UIViewController *vc =[[UIViewController alloc]init];
    vc.view.backgroundColor=[UIColor whiteColor];
    vc.title=@"授权说明文件";
    [vc.view setFrame:self.view.bounds];
    [vc.view addSubview:ql.view];
    [self.navigationController pushViewController:vc animated:YES];
   
}

-(BOOL)isDocumentExistsAtPath
{
    NSString *savedPath = [self documentLocalPath];
    
    NSFileManager * fileManager = [[NSFileManager alloc]init];
    
    BOOL fileExit =[fileManager fileExistsAtPath:savedPath];
    
    return fileExit;
}

-(NSString*)documentLocalPath
{
    NSString *savedPath = [NSHomeDirectory() stringByAppendingString:@"/Documents/condingDev.docx"];
    return savedPath;
}

-(void)downloadFileWithPath:(NSString*)aPth
{
    WEAKSELF
    [[CodingNetAPIClient sharedJsonClient]downloadFileWithOption:nil withInferface:kDownloadPath savedPath:aPth downloadSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         DebugLog(@"下载模板成功");
         [weakSelf.download_identity_img_auth_Button setTitle:@"打开模板" forState:UIControlStateNormal];
         
     } downloadFailure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         DebugLog(@"下载模板失败");
     } progress:^(float progress)
    {
         
     }];
}

-(void)uploadImage:(UIImage*)img
{
    if (self.currentSelectImgTag==identity_img_front)
    {
        self.identity_img_front_Button.alpha=0.5;
        self.identity_img_front_Button.enabled=NO;
        
    }else if (self.currentSelectImgTag==identity_img_back)
    {
        self.identity_img_back_Button.alpha=0.5;
        self.identity_img_back_Button.enabled=NO;
    }else
    {
        self.identity_img_auth_Button.alpha=0.5;
        self.identity_img_auth_Button.enabled=NO;
    }
    self.isUploadingImg=YES;
    
    WEAKSELF
    [[CodingNetAPIClient sharedJsonClient]uploadImage:img path:kUploadImgPath name:@"111" successBlock:^(AFHTTPRequestOperation *operation, id responseObject)
    {

        NSInteger code =[responseObject[@"code"] integerValue];
        if (code==0)
        {
            NSString *imgPath =responseObject[@"data"][@"url"];
            [weakSelf updateImgState:imgPath];
        }else
        {
            [weakSelf updateImgState:nil];
        }
        
    } failureBlock:^(AFHTTPRequestOperation *operation, NSError *error)
    {
        [weakSelf updateImgState:nil];
    } progerssBlock:^(CGFloat progressValue)
    {
        [weakSelf updateImgProgressValue:progressValue];
        
    }];
}

-(void)updateImgState:(NSString *)imgPath
{
    if (self.currentSelectImgTag==identity_img_front)
    {
        self.identity_img_front_StatusIcon.hidden=NO;
        self.identity_img_front_StatusLabel.hidden=NO;
        self.identity_img_front_Progress.hidden=YES;
        self.identity_img_front_Button.alpha=1;
        self.identity_img_front_Button.enabled=YES;
       
        
        if (imgPath)
        {
            //成功
            self.identity_img_front_StatusIcon.image=[UIImage imageNamed:@"fill_checked"];
            self.identity_img_front_StatusLabel.text=@"上传成功";
            self.model.identity_img_front=imgPath;
            self.identity_img_front_DeleteBtn.hidden=NO;
        }else
        {
            self.identity_img_front_StatusIcon.image=[UIImage imageNamed:@"fail_pass"];
            self.identity_img_front_StatusLabel.text=@"上传失败";
        }
    }else if (self.currentSelectImgTag==identity_img_back)
    {
        self.identity_img_back_StatusIcon.hidden=NO;
        self.identity_img_back_StatusLabel.hidden=NO;
        self.identity_img_back_Progress.hidden=YES;
        self.identity_img_back_Button.alpha=1;
        self.identity_img_back_Button.enabled=YES;
        if (imgPath)
        {
            //成功
            self.identity_img_back_StatusIcon.image=[UIImage imageNamed:@"fill_checked"];
            self.identity_img_back_StatusLabel.text=@"上传成功";
            self.model.identity_img_back=imgPath;
            self.identity_img_back_DeleteBtn.hidden=NO;
        }else
        {
            self.identity_img_back_StatusIcon.image=[UIImage imageNamed:@"fail_pass"];
            self.identity_img_back_StatusLabel.text=@"上传失败";
        }
    }else
    {
        self.identity_img_auth_StatusIcon.hidden=NO;
        self.identity_img_auth_StatusLabel.hidden=NO;
        self.identity_img_auth_Progress.hidden=YES;
        self.identity_img_auth_Button.alpha=1;
        self.identity_img_auth_Button.enabled=YES;
        if (imgPath)
        {
            //成功
            self.identity_img_auth_StatusIcon.image=[UIImage imageNamed:@"fill_checked"];
            self.identity_img_auth_StatusLabel.text=@"上传成功";
            self.model.identity_img_auth=imgPath;
            self.identity_img_auth_DeleteBtn.hidden=NO;
        }else
        {
            self.identity_img_auth_StatusIcon.image=[UIImage imageNamed:@"fail_pass"];
            self.identity_img_auth_StatusLabel.text=@"上传失败";
        }
    }
    
    self.isUploadingImg=NO;
    [self checkSubmitBtnEnabledStatus];
}

-(void)updateImgProgressValue:(CGFloat)progressValue
{
    if (self.currentSelectImgTag==identity_img_front)
    {
        self.identity_img_front_Progress.hidden=NO;
        self.identity_img_front_Progress.progress=progressValue;
    }else if (self.currentSelectImgTag==identity_img_back)
    {
        self.identity_img_back_Progress.hidden=NO;
        self.identity_img_back_Progress.progress=progressValue;
    }else
    {
        self.identity_img_auth_Progress.hidden=NO;
        self.identity_img_auth_Progress.progress=progressValue;
    }
}

- (IBAction)submitAction:(id)sender
{
    if (![self checkVerify])
    {
        [self.tableView reloadData];
        return;
    }
    
    [NSObject showHUDQueryStr:@"正在提交身份认证..."];
    WEAKSELF
    [[Coding_NetAPIManager sharedManager]post_Authentication:[self.model toParams] block:^(id data, NSError *error)
    {
        [NSObject hideHUDQuery];
        if (data) {
            [NSObject showHudTipStr:@"身份认证提交成功"];
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }

        
    }];
}

-(BOOL)checkVerify
{
    BOOL isRight =NO;
    if (self.model.name.length<2)
    {
        isRight=NO;
        [NSObject showHudTipStr:@"姓名填写格式不正确"];
        self.userNameTextField.textColor=[UIColor colorWithHexString:@"ff4b80"];
    }else if (self.model.identity.length<15||self.model.identity.length>18)
    {
        isRight=NO;
        [NSObject showHudTipStr:@"身份证号填写格式不正确"];
        self.identityIDTextFiled.textColor=[UIColor colorWithHexString:@"ff4b80"];
    }else if (!([self.model.alipay validateEmail] ||[self.model.alipay validateMobile]))
    {
        isRight=NO;
        [NSObject showHudTipStr:@"支付宝账号填写格式不正确"];
        self.aliyPayTextField.textColor=[UIColor colorWithHexString:@"ff4b80"];
    }else
    {
        isRight=YES;
    }
    
    
    return isRight;
}

- (IBAction)identityImgDeleteAction:(id)sender
{
     UIButton *btn =(UIButton*)sender;
    if (btn.tag==identity_img_front)
    {
//        KAlert(@"删除正面");
        self.model.identity_img_front=@"";
        self.identity_img_front_StatusIcon.hidden=YES;
        self.identity_img_front_StatusLabel.hidden=YES;
        self.identity_img_front_Progress.hidden=YES;
        self.identity_img_front_DeleteBtn.hidden=YES;
        [self.identity_img_front_Button setImage:[UIImage imageNamed:@"image_ia_addfile"] forState:UIControlStateNormal];
        
    }else if (btn.tag==identity_img_back)
    {
        self.model.identity_img_back=@"";
        self.identity_img_back_StatusIcon.hidden=YES;
        self.identity_img_back_StatusLabel.hidden=YES;
        self.identity_img_back_Progress.hidden=YES;
        self.identity_img_back_DeleteBtn.hidden=YES;
        [self.identity_img_back_Button setImage:[UIImage imageNamed:@"image_ia_addfile"] forState:UIControlStateNormal];
    }else
    {
        self.model.identity_img_auth=@"";
        self.identity_img_auth_StatusIcon.hidden=YES;
        self.identity_img_auth_StatusLabel.hidden=YES;
        self.identity_img_auth_Progress.hidden=YES;
        self.identity_img_auth_DeleteBtn.hidden=YES;
        [self.identity_img_auth_Button setImage:[UIImage imageNamed:@"image_ia_addfile"] forState:UIControlStateNormal];
    }
    
     [self checkSubmitBtnEnabledStatus];
    [self.tableView reloadData];
}


-(void)showSelectImgView
{
    [self.view endEditing:YES];
    __weak typeof(self) weakSelf = self;
    [[UIActionSheet bk_actionSheetCustomWithTitle:nil buttonTitles:@[@"拍照",@"从相册选择"] destructiveTitle:nil cancelTitle:@"取消" andDidDismissBlock:^(UIActionSheet *sheet, NSInteger index)
    {

            if (index!= 2)
            {
                [weakSelf actionSheetDidClickedButtonAtIndex:index];
            }
    }] showInView:self.view];

}


-(void)hideAllStatusEx
{
    self.identity_img_front_Progress.hidden=YES;
    self.identity_img_front_StatusIcon.hidden=YES;
    self.identity_img_front_StatusLabel.hidden=YES;
    
    self.identity_img_back_Progress.hidden=YES;
    self.identity_img_back_StatusIcon.hidden=YES;
    self.identity_img_back_StatusLabel.hidden=YES;
    
    self.identity_img_auth_Progress.hidden=YES;
    self.identity_img_auth_StatusIcon.hidden=YES;
    self.identity_img_auth_StatusLabel.hidden=YES;
}

-(void)showExampleViewWithTag:(NSInteger)tag
{

    
    ExampleView *exmp =[ExampleView createExameView];
    exmp.contentMode=UIViewContentModeScaleAspectFill;
    
    if (tag==identity_img_front || tag==identity_img_back)
    {
        if (tag==identity_img_front)
        {
            [exmp.exampleImgView setImage:[UIImage imageNamed:@"IDCard1_example"]];
            exmp.aTitleLabel.text=@"手持身份证正面图片示例";
        }else
        {
             [exmp.exampleImgView setImage:[UIImage imageNamed:@"IDCard2_example"]];
            exmp.aTitleLabel.text=@"手持身份证背面图片示例";
        }

        CGFloat width =kScreen_Width-20-20;
        
        [exmp setFrame:CGRectMake(0, 0, width, width)];
        
        
        
    }else
    {
        [exmp.exampleImgView setImage:[UIImage imageNamed:@"Document_example"]];
        exmp.aTitleLabel.text=@"授权说明图片示例";
        
        CGFloat width =kScreen_Width-20-20;
        
        [exmp setFrame:CGRectMake(0, 0, width, 1.5*width)];
        
    }
    
    exmp.layer.cornerRadius = 2.0;
    exmp.layer.masksToBounds = YES;
    
    KLCPopupLayout layout = KLCPopupLayoutMake(KLCPopupHorizontalLayoutCenter, KLCPopupVerticalLayoutCenter);
    
    self.popup = [KLCPopup popupWithContentView:exmp showType:KLCPopupShowTypeBounceInFromBottom dismissType:KLCPopupDismissTypeBounceOutToBottom maskType:KLCPopupMaskTypeDimmed dismissOnBackgroundTouch:YES dismissOnContentTouch:NO];
    
    [self.popup showWithLayout:layout];
    
    WEAKSELF
    exmp.tapBlock=^(id obj)
    {
        [weakSelf.popup dismiss:YES];
    };
    
}

-(void)showBigIdentityImgWithImgPath:(NSString*)imgPath
{
    UIView* contentView = [[UIView alloc] init];
    contentView.translatesAutoresizingMaskIntoConstraints = NO;
    contentView.backgroundColor = [UIColor clearColor];
    [contentView setClipsToBounds:YES];
    
    UIImageView *imgBig =[[UIImageView alloc]init];
    imgBig.contentMode=UIViewContentModeScaleAspectFit;
    

    [contentView addSubview:imgBig];
    
    CGFloat width =kScreen_Width-20-20;
    [contentView setFrame:CGRectMake(0, 0, width, kScreen_Height-40)];
    [imgBig setFrame:contentView.frame];
    
    WEAKSELF
    [self.view beginLoading];
    [imgBig sd_setImageWithURL:[NSURL URLWithString:imgPath]placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL)
    {
        [weakSelf.view endLoading];
    }];
    
    KLCPopupLayout layout = KLCPopupLayoutMake(KLCPopupHorizontalLayoutCenter, KLCPopupVerticalLayoutCenter);
    
    self.popup = [KLCPopup popupWithContentView:contentView showType:KLCPopupShowTypeBounceIn dismissType:KLCPopupDismissTypeBounceOut maskType:KLCPopupMaskTypeDimmed dismissOnBackgroundTouch:YES dismissOnContentTouch:YES];
    
    [self.popup showWithLayout:layout];
    
}

- (void)actionSheetDidClickedButtonAtIndex:(NSInteger)buttonIndex {
    
    NSLog(@"> Clicked Index: %ld", (long)buttonIndex);
    
    
    switch (buttonIndex) {
        case 0://照相机
        {
            UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
            imagePicker.delegate = self;
            imagePicker.allowsEditing = NO;
            imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
            UINavigationBar *navBar =  [UINavigationBar appearanceWhenContainedIn:[UIImagePickerController class], nil];
            
            navBar.translucent = NO;
            [navBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
            [navBar setShadowImage:[UIImage new]];
            navBar.barTintColor = kNavBarTintColor;
            
            //            [self presentModalViewController:imagePicker animated:YES];
            [self presentViewController:imagePicker animated:YES completion:nil];
        }
            break;
        case 1://本地相簿
        {
            UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
            imagePicker.delegate = self;
            imagePicker.allowsEditing = NO;
            imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            UINavigationBar *navBar =  [UINavigationBar appearanceWhenContainedIn:[UIImagePickerController class], nil];
            
            navBar.translucent = NO;
            [navBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
            [navBar setShadowImage:[UIImage new]];
            navBar.barTintColor = kNavBarTintColor;
            //            [self presentModalViewController:imagePicker animated:YES];
            [self presentViewController:imagePicker animated:YES completion:nil];
        }
            break;
        default:
            break;
    }
}



#pragma mark -- UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = info[@"UIImagePickerControllerOriginalImage"];
    NSData *imgData =UIImageJPEGRepresentation(image, 0.5);
    [self uploadImage:image];
    [self updateImageDataForCell:imgData];
//    NSData* imageDataHD = [UIImage compressImage:image compressType:ImageSizeHight];
//    NSData *imageData=UIImageJPEGRepresentation([UIImage imageWithData:imageDataHD],kAvatarScaleRate);
//    UIImage *compressedImage = [UIImage imageWithData:imageData];
//    
//    self.avatarImg=compressedImage;
//    [self.avtorButton setBackgroundImage:self.avatarImg forState:UIControlStateNormal];
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
     [picker dismissViewControllerAnimated:YES completion:nil];
}

-(void)updateImageDataForCell:(NSData *)imgData
{
    UIImage *imgV=[UIImage imageWithData:imgData];
    if (self.currentSelectImgTag==identity_img_front)
    {
        [self.identity_img_front_Button setImage:imgV forState:UIControlStateNormal];
    }else if (self.currentSelectImgTag==identity_img_back)
    {
        [self.identity_img_back_Button setImage:imgV forState:UIControlStateNormal];
    }else
    {
        [self.identity_img_auth_Button setImage:imgV forState:UIControlStateNormal];
    }
    
    [self.tableView reloadData];
}
#pragma mark - quicklook
- (NSInteger) numberOfPreviewItemsInPreviewController: (QLPreviewController *) controller
{
    return 1;
}
- (id <QLPreviewItem>)previewController: (QLPreviewController *)controller previewItemAtIndex:(NSInteger)index
{
    return [NSURL fileURLWithPath:[self documentLocalPath]];
    
}

- (IBAction)checkBoxClicked:(UIButton *)sender {
    self.model.isAgree = !self.model.isAgree;
}

-(NSString*)userProtocol
{
    return @"尊敬的 Coding 码市用户：\n       您好！\n       欢迎您使用 Coding 码市平台！\n       基于保障用户资金安全的原则，深圳市希云科技有限公司即 Coding 码市平台（以下简称“Coding 码市”）需要对涉及资金往来的用户进行身份认证。 为使您更好地使用 Coding 码市平台，请您认真阅读并遵守《码市平台身份认证说明》（以下简称“本说明”）。\n       用户应保证其提供给 Coding 码市的所有资料和信息的真实性、合法性、准确性和有效性；否则，Coding 码市有权终止和取消用户通过 Coding 码市获取的服务和酬金。因用户提供的资料偏差给 Coding 码市或第三方造成损害的，该用户应依法承担相应的责任。\n       保护用户信息是 Coding 码市的一项基本原则，Coding 码市会采取合理有效的措施确保用户信息的安全性，请您放心！除法律法规规定的情形外，未经用户许可 Coding 码市绝不会向任何第三方泄漏用户的资料和信息。\n       用户理解并同意：授权 Coding 码市对其提交的资料和信息进行甄别核实；Coding 码市基于法律法规对已授权的用户提供的资料和信息进行身份审核和认证。\n       请您按照需求上传手持身份证正面照、身份证背面照和授权说明书。其中手持身份证正面照应保证面部和身份证信息均清晰可见； 身份证背面照和授权说明书字体清晰无污迹。请勿用任何软件编辑修改照片； 否则，认证将不予通过。\n       感谢您的配合，祝您顺利通过认证！\n \n       Coding 码市团队";
}

+ (float) heightForString:(NSString *)value fontSize:(float)fontSize andWidth:(float)width
{
    UITextView *detailTextView = [[UITextView alloc]initWithFrame:CGRectMake(0, 0, width, 0)];
    detailTextView.font = [UIFont systemFontOfSize:fontSize];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 5;// 字体的行间距
    
    NSDictionary *attributes = @{
                                 NSFontAttributeName:[UIFont systemFontOfSize:14],
                                 NSParagraphStyleAttributeName:paragraphStyle
                                 };
    detailTextView.attributedText = [[NSAttributedString alloc] initWithString:value attributes:attributes];
    detailTextView.textContainerInset=UIEdgeInsetsMake(10, 5, 0, 10);
//    detailTextView.text = value;
    CGSize deSize = [detailTextView sizeThatFits:CGSizeMake(width,CGFLOAT_MAX)];
    return deSize.height;
}

//+(NSAttributedString*)userProtocolAttributedString
//{
//    
//}

@end
