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

@interface IdentityAuthenticationViewController ()<UITextFieldDelegate,LCActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,QLPreviewControllerDataSource,BEMCheckBoxDelegate>


@property(nonatomic,assign) NSInteger currentSelectImgTag;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *textViewHeight;
@property (weak, nonatomic) IBOutlet UITextField *userNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *identityIDTextFiled;
@property (weak, nonatomic) IBOutlet UITextField *aliyPayTextField;
@property (weak, nonatomic) IBOutlet BEMCheckBox *codingCheckBox;

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
@property (strong,nonatomic)KLCPopup* popup;
@property (assign,nonatomic)BOOL canEedit;




- (IBAction)showExampleAction:(id)sender;
- (IBAction)selectImgAction:(id)sender;
- (IBAction)downloadAction:(id)sender;
- (IBAction)submitAction:(id)sender;
- (IBAction)identityImgDeleteAction:(id)sender;

@end

@implementation IdentityAuthenticationViewController

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
    self.codingCheckBox.on=YES;
    self.codingCheckBox.onCheckColor=[UIColor colorWithHexString:@"65C279"];
    self.codingCheckBox.lineWidth=2;
    self.codingCheckBox.onTintColor=[UIColor colorWithHexString:@"E8E8E8"];
    self.codingCheckBox.onFillColor=[UIColor colorWithHexString:@"F4F4F4"];
    self.codingCheckBox.delegate=self;
    
    self.model =[[IdentityAuthenticationModel alloc]initForlocalCache];
    
    [self setupDefValue];
    [self setupEvent];
    
    if (kDevice_Is_iPhone5)
    {
        self.textViewHeight.constant=self.textViewHeight.constant-110;
        
    }else if(kDevice_Is_iPhone6)
    {
        self.textViewHeight.constant=self.textViewHeight.constant-180;
    }else if(kDevice_Is_iPhone6Plus)
    {
        self.textViewHeight.constant=self.textViewHeight.constant-195;
    }
}

-(void)setupEvent
{
    WEAKSELF
    [self.userNameTextField.rac_textSignal subscribeNext:^(NSString *newText){
        if (newText.length<1)
            return ;
        
        weakSelf.model.name = newText;
        
    }];
    
    [self.identityIDTextFiled.rac_textSignal subscribeNext:^(NSString *newText){
        if (newText.length<1)
            return ;
        
        weakSelf.model.identity = newText;
        
    }];
    [self.aliyPayTextField.rac_textSignal subscribeNext:^(NSString *newText){
        if (newText.length<1)
            return ;
        
        [weakSelf checkIdentityCardValidity];
        weakSelf.model.alipay = newText;
        
    }];
    
    RAC(self, submitBtn.enabled) = [RACSignal combineLatest:@[RACObserve(self, model.name),
                                                              RACObserve(self, model.identity),
                                                              RACObserve(self, model.alipay),
                                                              RACObserve(self, model.identity_img_auth),
                                                              RACObserve(self, model.identity_img_back),
                                                              RACObserve(self, model.identity_img_front),
                                                              RACObserve(self, codingCheckBox.on),
                                                              
                                                              ] reduce:^(NSNumber *isCheckOn){
                                                                  return @([weakSelf.model canPost] && [isCheckOn boolValue]);
                                                              }];
   
  
}

-(void)setupDefValue
{
    self.userNameTextField.text=self.model.name;
    self.identityIDTextFiled.text=self.model.identity;
    self.aliyPayTextField.text=self.model.alipay;
    self.identity_img_auth_DeleteBtn.hidden=YES;
    self.identity_img_back_DeleteBtn.hidden=YES;
    self.identity_img_front_DeleteBtn.hidden=YES;
    
    UIImage *defImg =[UIImage imageNamed:@"image_ia_addfile"];
    
    
    if (self.model.identity_img_front)
    {
        [self.identity_img_front_Button sd_setBackgroundImageWithURL:[NSURL URLWithString:self.model.identity_img_front]  forState:UIControlStateNormal placeholderImage:defImg] ;
    }
    if (self.model.identity_img_back)
    {
        [self.identity_img_back_Button sd_setBackgroundImageWithURL:[NSURL URLWithString:self.model.identity_img_back] forState:UIControlStateNormal placeholderImage:defImg];
    }
    if (self.model.identity_img_auth)
    {
        [self.identity_img_auth_Button sd_setBackgroundImageWithURL:[NSURL URLWithString:self.model.identity_img_auth] forState:UIControlStateNormal placeholderImage:defImg];
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
    self.identity_img_auth_DeleteBtn.hidden=!canEedit;
    self.identity_img_back_DeleteBtn.hidden=!canEedit;
    self.identity_img_front_DeleteBtn.hidden=!canEedit;
    
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
            CGFloat height =636;
            if (kDevice_Is_iPhone5)
            {
                height= height-73;
            }else if (kDevice_Is_iPhone6)
            {
                height= height-140;

            }else if (kDevice_Is_iPhone6Plus)
            {
                height= height-160;
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
    self.currentSelectImgTag=btn.tag;
    
    if (self.currentSelectImgTag==identity_img_front && self.model.identity_img_front.length>3)
    {
        [self showBigIdentityImgWithImgPath:self.model.identity_img_front];
    }else if (self.currentSelectImgTag==identity_img_back && self.model.identity_img_back.length>3)
    {
        [self showBigIdentityImgWithImgPath:self.model.identity_img_back];
    }else if (self.currentSelectImgTag==identity_img_auth && self.model.identity_img_auth.length>3)
    {
        [self showBigIdentityImgWithImgPath:self.model.identity_img_auth];
    }else
    {
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

    ql.edgesForExtendedLayout = UIRectEdgeNone;
    ql.automaticallyAdjustsScrollViewInsets=NO;
    UINavigationBar *navBar =  [UINavigationBar appearanceWhenContainedIn:[QLPreviewController class], nil];
    
    navBar.translucent = NO;
    [navBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    [navBar setShadowImage:[UIImage new]];
    navBar.barTintColor = kNavBarTintColor;
    

    [self presentViewController:ql animated:YES completion:nil];
   

   
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
        [self.identity_img_front_Button setBackgroundImage:[UIImage imageNamed:@"image_ia_addfile"] forState:UIControlStateNormal];
        
    }else if (btn.tag==identity_img_back)
    {
        self.model.identity_img_back=@"";
        self.identity_img_back_StatusIcon.hidden=YES;
        self.identity_img_back_StatusLabel.hidden=YES;
        self.identity_img_back_Progress.hidden=YES;
        self.identity_img_back_DeleteBtn.hidden=YES;
        [self.identity_img_back_Button setBackgroundImage:[UIImage imageNamed:@"image_ia_addfile"] forState:UIControlStateNormal];
    }else
    {
        self.model.identity_img_auth=@"";
        self.identity_img_auth_StatusIcon.hidden=YES;
        self.identity_img_auth_StatusLabel.hidden=YES;
        self.identity_img_auth_Progress.hidden=YES;
        self.identity_img_auth_DeleteBtn.hidden=YES;
        [self.identity_img_auth_Button setBackgroundImage:[UIImage imageNamed:@"image_ia_addfile"] forState:UIControlStateNormal];
    }
    
    [self.tableView reloadData];
}


-(void)showSelectImgView
{
    [self.view endEditing:YES];
    //增加照片选择功能
    LCActionSheet *sheet = [LCActionSheet sheetWithTitle:nil
                                            buttonTitles:@[@"拍照", @"从相册选择"]
                                          redButtonIndex:-1
                                                delegate:self];
    [sheet show];

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
    
    
    if (tag==identity_img_front || tag==identity_img_back)
    {
        if (tag==identity_img_front)
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
    
    self.popup = [KLCPopup popupWithContentView:exmp showType:KLCPopupShowTypeBounceInFromTop dismissType:KLCPopupDismissTypeBounceOutToBottom maskType:KLCPopupMaskTypeDimmed dismissOnBackgroundTouch:YES dismissOnContentTouch:NO];
    
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

    
    [imgBig sd_setImageWithURL:[NSURL URLWithString:imgPath] placeholderImage:[UIImage imageNamed:@"blankpage_image_Sleep"]];
    
    KLCPopupLayout layout = KLCPopupLayoutMake(KLCPopupHorizontalLayoutCenter, KLCPopupVerticalLayoutCenter);
    
    self.popup = [KLCPopup popupWithContentView:contentView showType:KLCPopupShowTypeBounceIn dismissType:KLCPopupDismissTypeBounceOut maskType:KLCPopupMaskTypeDimmed dismissOnBackgroundTouch:YES dismissOnContentTouch:YES];
    
    [self.popup showWithLayout:layout];
    
}

#pragma mark -- LCActionSheetDelegate
- (void)actionSheet:(LCActionSheet *)actionSheet didClickedButtonAtIndex:(NSInteger)buttonIndex {
    
    NSLog(@"> Clicked Index: %ld", (long)buttonIndex);
    
    
    switch (buttonIndex) {
        case 0://照相机
        {
            UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
            imagePicker.delegate = self;
            imagePicker.allowsEditing = YES;
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
            imagePicker.allowsEditing = YES;
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
    UIImage *image = info[@"UIImagePickerControllerEditedImage"];
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
        [self.identity_img_front_Button setBackgroundImage:imgV forState:UIControlStateNormal];
    }else if (self.currentSelectImgTag==identity_img_back)
    {
        [self.identity_img_back_Button setBackgroundImage:imgV forState:UIControlStateNormal];
    }else
    {
        [self.identity_img_auth_Button setBackgroundImage:imgV forState:UIControlStateNormal];
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

- (void)didTapCheckBox:(BEMCheckBox*)checkBox
{
    self.model.isAgree=checkBox.on;
}

@end
