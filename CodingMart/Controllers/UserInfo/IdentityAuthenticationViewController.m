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


#define kDownloadPath @"https://mart.coding.net/api/download/auth_file"
#define kUploadImgPath @"https://mart.coding.net/api/upload"

@interface IdentityAuthenticationViewController ()<UITextFieldDelegate,LCActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,QLPreviewControllerDataSource,BEMCheckBoxDelegate>

//示例Action tag 【87-身份证正面；88-身份证背面；89-授权文件】
//选择照片Action tag【87-身份证正面；88-身份证背面；89-授权文件】

@property(nonatomic,assign) NSInteger currentSelectImgTag;

@property (weak, nonatomic) IBOutlet UITextField *userNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *identityIDTextFiled;
@property (weak, nonatomic) IBOutlet UITextField *aliyPayTextField;
@property (weak, nonatomic) IBOutlet BEMCheckBox *codingCheckBox;
@property (weak, nonatomic) IBOutlet UIButton *idCard1AddButton;
@property (weak, nonatomic) IBOutlet UIButton *idCard2AddButton;
@property (weak, nonatomic) IBOutlet UIButton *documentAddButton;

@property (weak, nonatomic) IBOutlet UIProgressView *idCard1Progress;
@property (weak, nonatomic) IBOutlet UIImageView *idCard1StatusIcon;
@property (weak, nonatomic) IBOutlet UILabel *idCard1StatusLabel;
@property (weak, nonatomic) IBOutlet UIProgressView *idCard2Progress;
@property (weak, nonatomic) IBOutlet UIImageView *idCard2StatusIcon;
@property (weak, nonatomic) IBOutlet UILabel *idCard2StatusLabel;
@property (weak, nonatomic) IBOutlet UIProgressView *documentProgress;
@property (weak, nonatomic) IBOutlet UIImageView *documentStatusIcon;
@property (weak, nonatomic) IBOutlet UILabel *documentStatusLabel;
@property (weak, nonatomic) IBOutlet UIButton *downloadDCButton;
@property (weak, nonatomic) IBOutlet TableViewFooterButton *submitBtn;


@property (strong,nonatomic)UIImage *idCard1Img,*idCard2Img,*documentImg;
@property (strong,nonatomic)IdentityAuthenticationModel *model;
@property (assign,nonatomic)BOOL canEedit;




- (IBAction)showExampleAction:(id)sender;
- (IBAction)selectImgAction:(id)sender;
- (IBAction)downloadAction:(id)sender;
- (IBAction)submitAction:(id)sender;

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
    self.idCard1Img=nil;
    self.idCard2Img=nil;
    self.documentImg=nil;
}

-(void)configUI
{
    [self hideAllStatusEx];
    
    if ([self isDocumentExistsAtPath])
    {
        [self.downloadDCButton setTitle:@"打开模板" forState:UIControlStateNormal];
    }else
    {
        [self.downloadDCButton setTitle:@"下载模板" forState:UIControlStateNormal];
    }
    self.codingCheckBox.onCheckColor=[UIColor colorWithHexString:@"65C279"];
    self.codingCheckBox.lineWidth=2;
    self.codingCheckBox.onTintColor=[UIColor colorWithHexString:@"E8E8E8"];
    self.codingCheckBox.onFillColor=[UIColor colorWithHexString:@"F4F4F4"];
    self.codingCheckBox.delegate=self;
    
    self.model =[[IdentityAuthenticationModel alloc]initForlocalCache];
    
    [self setupDefValue];
    [self setupEvent];
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
    if (self.model.identity_img_front)
    {
        [self.idCard1AddButton sd_setBackgroundImageWithURL:[NSURL URLWithString:self.model.identity_img_front] forState:UIControlStateNormal];
    }
    if (self.model.identity_img_back)
    {
        [self.idCard2AddButton sd_setBackgroundImageWithURL:[NSURL URLWithString:self.model.identity_img_back] forState:UIControlStateNormal];
    }
    if (self.model.identity_img_auth)
    {
        [self.documentAddButton sd_setBackgroundImageWithURL:[NSURL URLWithString:self.model.identity_img_auth] forState:UIControlStateNormal];
    }
    
    if ([self.model.identityIsPass integerValue]==3 ||[self.model.identityIsPass integerValue]==1)
    {
        self.canEedit=NO;
    }else
    {
        self.canEedit=YES;
    }
    
}

-(void)setCanEedit:(BOOL)canEedit
{
    _canEedit=canEedit;
    
    self.userNameTextField.enabled=canEedit;
    self.identityIDTextFiled.enabled=canEedit;
    self.aliyPayTextField.enabled=canEedit;
    self.idCard1AddButton.enabled=canEedit;
    self.idCard2AddButton.enabled=canEedit;
    self.documentAddButton.enabled=canEedit;
    self.submitBtn.enabled=canEedit;
    
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
    UIButton *btn =(UIButton*)sender;
    self.currentSelectImgTag=btn.tag;
    [self showSelectImgView];
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
         [weakSelf.downloadDCButton setTitle:@"打开模板" forState:UIControlStateNormal];
         
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
    if (self.currentSelectImgTag==97)
    {
        self.idCard1StatusIcon.hidden=NO;
        self.idCard1StatusLabel.hidden=NO;
        self.idCard1Progress.hidden=YES;
        
        if (imgPath)
        {
            //成功
            self.idCard1StatusIcon.image=[UIImage imageNamed:@"fill_checked"];
            self.idCard1StatusLabel.text=@"上传成功";
            self.model.identity_img_front=imgPath;
        }else
        {
            self.idCard1StatusIcon.image=[UIImage imageNamed:@"fail_pass"];
            self.idCard1StatusLabel.text=@"上传失败";
        }
    }else if (self.currentSelectImgTag==98)
    {
        self.idCard2StatusIcon.hidden=NO;
        self.idCard2StatusLabel.hidden=NO;
        self.idCard2Progress.hidden=YES;
        if (imgPath)
        {
            //成功
            self.idCard2StatusIcon.image=[UIImage imageNamed:@"fill_checked"];
            self.idCard2StatusLabel.text=@"上传成功";
            self.model.identity_img_back=imgPath;
        }else
        {
            self.idCard2StatusIcon.image=[UIImage imageNamed:@"fail_pass"];
            self.idCard2StatusLabel.text=@"上传失败";
        }
    }else
    {
        self.documentStatusIcon.hidden=NO;
        self.documentStatusLabel.hidden=NO;
        self.documentProgress.hidden=YES;
        if (imgPath)
        {
            //成功
            self.documentStatusIcon.image=[UIImage imageNamed:@"fill_checked"];
            self.documentStatusLabel.text=@"上传成功";
            self.model.identity_img_auth=imgPath;
        }else
        {
            self.documentStatusIcon.image=[UIImage imageNamed:@"fail_pass"];
            self.documentStatusLabel.text=@"上传失败";
        }
    }
}

-(void)updateImgProgressValue:(CGFloat)progressValue
{
    if (self.currentSelectImgTag==97)
    {
        self.idCard1Progress.hidden=NO;
        self.idCard1Progress.progress=progressValue;
    }else if (self.currentSelectImgTag==98)
    {
        self.idCard2Progress.hidden=NO;
        self.idCard2Progress.progress=progressValue;
    }else
    {
        self.documentProgress.hidden=NO;
        self.documentProgress.progress=progressValue;
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
    self.idCard1Progress.hidden=YES;
    self.idCard1StatusIcon.hidden=YES;
    self.idCard1StatusLabel.hidden=YES;
    
    self.idCard2Progress.hidden=YES;
    self.idCard2StatusIcon.hidden=YES;
    self.idCard2StatusLabel.hidden=YES;
    
    self.documentProgress.hidden=YES;
    self.documentStatusIcon.hidden=YES;
    self.documentStatusLabel.hidden=YES;
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
    
    KLCPopup* popup = [KLCPopup popupWithContentView:exmp showType:KLCPopupShowTypeBounceInFromTop dismissType:KLCPopupDismissTypeBounceOutToBottom maskType:KLCPopupMaskTypeDimmed dismissOnBackgroundTouch:YES dismissOnContentTouch:NO];
    
    [popup showWithLayout:layout];

    
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
    if (self.currentSelectImgTag==97)
    {
        [self.idCard1AddButton setImage:imgV forState:UIControlStateNormal];
    }else if (self.currentSelectImgTag==98)
    {
        [self.idCard2AddButton setImage:imgV forState:UIControlStateNormal];
    }else
    {
        [self.documentAddButton setImage:imgV forState:UIControlStateNormal];
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
