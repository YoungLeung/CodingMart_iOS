//
//  IdentityViewController.m
//  CodingMart
//
//  Created by Ease on 16/8/26.
//  Copyright © 2016年 net.coding. All rights reserved.
//

#import "IdentityViewController.h"
#import "IdentityPassedViewController.h"
#import "UITTTAttributedLabel.h"
#import "UIImageView+WebCache.h"
#import <BlocksKit/BlocksKit+UIKit.h>
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "EAXibTipView.h"
#import "JTSImageViewController.h"
#import "Coding_NetAPIManager.h"
#import <MBProgressHUD/MBProgressHUD.h>
#import "EnterpriseAttachment.h"
#import "EnterpriseCertificate.h"
#import "IdentityResultViewController.h"

@interface IdentityViewController () <JTSImageViewControllerOptionsDelegate>
@property(weak, nonatomic) IBOutlet UIView *headerV;
@property(weak, nonatomic) IBOutlet UILabel *headerL;
@property(weak, nonatomic) IBOutlet UITextField *nameF;
@property(weak, nonatomic) IBOutlet UITextField *identityNumF;
@property(weak, nonatomic) IBOutlet UIImageView *frontImageV;
@property(weak, nonatomic) IBOutlet UIImageView *backImageV;
@property(weak, nonatomic) IBOutlet UILabel *authDescL;
@property(weak, nonatomic) IBOutlet UIButton *bottomBtn;
@property(weak, nonatomic) IBOutlet UITTTAttributedLabel *bottomL;
@property(strong, nonatomic) IBOutlet UIView *demoV;
@property(strong, nonatomic) EAXibTipView *demoTipV;

@property(strong, nonatomic) EnterpriseAttachment *attachment;
@property(strong, nonatomic) NSString *name;
@property(strong, nonatomic) NSString *identity;

@end

@implementation IdentityViewController

//+ (id)vcWithIdetityDict:(NSDictionary *)identity_server_CacheDataDic {
//    Class classObj = [identity_server_CacheDataDic[@"status"] integerValue] == 1 ? [IdentityPassedViewController class] : [IdentityViewController class];//status == 1 是认证通过
//    UIViewController *vc = [classObj vcInStoryboard:@"UserInfo"];
//    [vc setValue:identity_server_CacheDataDic forKey:@"identity_server_CacheDataDic"];
//    return vc;
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    //认证失败
    _headerL.text = nil;

    CGFloat failureReasonLHeight = [_headerL.text getHeightWithFont:_headerL.font constrainedToSize:CGSizeMake(kScreen_Width - 30, CGFLOAT_MAX)];
    _headerV.height = _headerL.text.length > 0 ? 40 + failureReasonLHeight : 0;
    //数据显示
    _frontImageV.hidden = YES;

    //时间绑定
    WEAKSELF;
    [_nameF.rac_textSignal subscribeNext:^(NSString *value) {
        weakSelf.name = value;
    }];
    [_identityNumF.rac_textSignal subscribeNext:^(NSString *value) {
        weakSelf.identity = value;
    }];
    [_frontImageV bk_whenTapped:^{
        [weakSelf showImageWithFront];
    }];

}

#pragma mark Image_Front_Back

- (void)showImageWithFront {
    JTSImageInfo *imageInfo = [JTSImageInfo new];
    imageInfo.imageURL = [_attachment.url urlWithCodingPath];
    UIImageView *imageV = _frontImageV;
    imageInfo.referenceRect = imageV.frame;
    imageInfo.referenceView = imageV.superview;
    JTSImageViewController *imageViewer = [[JTSImageViewController alloc] initWithImageInfo:imageInfo mode:JTSImageViewControllerMode_Image backgroundStyle:JTSImageViewControllerBackgroundOption_None];
    WEAKSELF;
    imageViewer.deleteBlock = ^(JTSImageViewController *obj) {
        [obj dismiss:YES];
        weakSelf.attachment = nil;
        weakSelf.frontImageV.hidden = YES;
    };
    imageViewer.optionsDelegate = self;
    [imageViewer showFromViewController:self transition:JTSImageViewControllerTransition_FromOriginalPosition];
}

- (CGFloat)alphaForBackgroundDimmingOverlayInImageViewer:(JTSImageViewController *)imageViewer {
    return 1.0;
}

#pragma mark Action

- (IBAction)bottomBtnClicked:(id)sender {
    NSString *tipStr;
    if (_name.length <= 0) {
        tipStr = @"请填写公司名";
    } else if (_identity.length <= 0) {
        tipStr = @"请填写企业执照编号";
    } else if (_attachment == nil) {
        tipStr = @"请上传营业执照扫描件";
    }

    if (tipStr.length > 0) {
        [NSObject showHudTipStr:tipStr];
        return;
    }

    [NSObject showHUDQueryStr:@"正在提交企业认证..."];

    NSMutableDictionary *params = @{}.mutableCopy;
    params[@"legalRepresentative"] = _name;
    params[@"businessLicenceNo"] = _identity;
    params[@"businessLicenceImg"] = _attachment.id.stringValue;

    WEAKSELF
    [[Coding_NetAPIManager sharedManager] post_EnterpriseAuthentication:params block:^(id data, NSError *error) {
        [NSObject hideHUDQuery];
        if (data) {
            EnterpriseCertificate *certificate = (EnterpriseCertificate *) data;

            UINavigationController *navigation = weakSelf.navigationController;
            [navigation popViewControllerAnimated:NO];
            UIViewController *vc = [IdentityResultViewController vcInStoryboard:certificate];
            [navigation pushViewController:vc animated:NO];
        }
    }];
}

- (IBAction)demoBtnClicked:(id)sender {
    if (!_demoTipV) {
        CGFloat demoWidth = kScreen_Width - 30;
        _demoV.size = CGSizeMake(demoWidth, _demoV.height / _demoV.width * demoWidth);
        _demoTipV = [EAXibTipView instancetypeWithXibView:_demoV];
    }
    [_demoTipV showInView:self.view];
}

- (IBAction)demoDissmissBtnClicked:(id)sender {
    [_demoTipV dismiss];
}

- (IBAction)frontBtnClicked:(id)sender {
    [self selectImageAlertWithFront:YES];
}

- (IBAction)backBtnClicked:(id)sender {
    [self selectImageAlertWithFront:NO];
}

- (void)selectImageAlertWithFront:(BOOL)isFront {
    [self.view endEditing:YES];
    __weak typeof(self) weakSelf = self;
    [[UIActionSheet bk_actionSheetCustomWithTitle:nil buttonTitles:@[@"拍照", @"从相册选择"] destructiveTitle:nil cancelTitle:@"取消" andDidDismissBlock:^(UIActionSheet *sheet, NSInteger index) {
        [weakSelf selectImageActionIndex:index withFront:isFront];
    }] showInView:self.view];
}

- (void)selectImageActionIndex:(NSInteger)index withFront:(BOOL)isFront {
    if (index >= 2) {
        return;
    }
    WEAKSELF;
    UIImagePickerController *imagePicker = [UIImagePickerController new];
    imagePicker.sourceType = index == 0 ? UIImagePickerControllerSourceTypeCamera : UIImagePickerControllerSourceTypePhotoLibrary;
    imagePicker.allowsEditing = NO;
    {//UINavigationBar
        UINavigationBar *navBar = [UINavigationBar appearanceWhenContainedIn:[UIImagePickerController class], nil];
        navBar.translucent = NO;
        [navBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
        [navBar setShadowImage:[UIImage new]];
        navBar.barTintColor = kColorBrandBlue;
    }
    imagePicker.bk_didCancelBlock = ^(UIImagePickerController *vc) {
        [vc dismissViewControllerAnimated:YES completion:nil];
    };
    imagePicker.bk_didFinishPickingMediaBlock = ^(UIImagePickerController *vc, NSDictionary *info) {
        [vc dismissViewControllerAnimated:YES completion:nil];
        [weakSelf uploadImage:info[@"UIImagePickerControllerOriginalImage"] name:isFront ? @"front" : @"back" isFront:isFront];
    };
    [self presentViewController:imagePicker animated:YES completion:nil];
}

- (void)uploadImage:(UIImage *)image name:(NSString *)name isFront:(BOOL)isFront {
    MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:kKeyWindow animated:YES];;
    HUD.mode = MBProgressHUDModeDeterminateHorizontalBar;
    HUD.labelText = @"正在上传图片...";
    HUD.removeFromSuperViewOnHide = YES;
    WEAKSELF
    [[CodingNetAPIClient sharedJsonClient] uploadImage:image path:@"api/upload" name:name successBlock:^(AFHTTPRequestOperation *operation, id responseObject) {
        HUD.hidden = YES;

        _attachment = [NSObject objectOfClass:@"EnterpriseAttachment" fromJSON:responseObject[@"data"]];
        if (_attachment != nil) {
            weakSelf.frontImageV.hidden = NO;
            weakSelf.frontImageV.image = image;
        }

    }                                     failureBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        HUD.hidden = YES;
    }                                    progerssBlock:^(CGFloat progressValue) {
        HUD.progress = MAX(0, progressValue - 0.05);
    }];
}

#pragma mark Table
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [UIView new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 1.0 / [UIScreen mainScreen].scale;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat rowH;
    if (indexPath.section == 0) {
        rowH = indexPath.row == 0 ? 130 : indexPath.row == 1 ? 80 : 15;
    } else if (indexPath.section == 1) {
        rowH = 66 + ((kScreen_Width - 30) * 160 / 350) + 15;
    } else {
        rowH = 50 + 15 + 30 + [_authDescL.text getHeightWithFont:_authDescL.font constrainedToSize:CGSizeMake((kScreen_Width - 30 - 20), CGFLOAT_MAX)] + 2;//这个 +2 只是对高度计算不准确的冗余处理
    }
    return rowH;
}

#pragma mark VC

- (void)goToAgreement {
    NSString *urlStr = @"https://dn-coding-net-production-public-file.qbox.me/%E8%BA%AB%E4%BB%BD%E8%AE%A4%E8%AF%81%E6%8E%88%E6%9D%83%E4%B8%8E%E6%89%BF%E8%AF%BA%E4%B9%A6_160816.pdf";
    [self goToWebVCWithUrlStr:urlStr title:@"身份认证授权与承诺书"];
}

@end
