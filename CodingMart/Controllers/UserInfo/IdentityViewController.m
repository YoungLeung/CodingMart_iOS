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
#import "IdentityAuthenticationModel.h"
#import "UIImageView+WebCache.h"
#import <BlocksKit/BlocksKit+UIKit.h>
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "EAXibTipView.h"
#import "JTSImageViewController.h"
#import "Coding_NetAPIManager.h"

@interface IdentityViewController ()<JTSImageViewControllerOptionsDelegate>
@property (weak, nonatomic) IBOutlet UIView *headerV;
@property (weak, nonatomic) IBOutlet UILabel *headerL;
@property (weak, nonatomic) IBOutlet UITextField *nameF;
@property (weak, nonatomic) IBOutlet UITextField *identityNumF;
@property (weak, nonatomic) IBOutlet UIImageView *frontImageV;
@property (weak, nonatomic) IBOutlet UIImageView *backImageV;
@property (weak, nonatomic) IBOutlet UILabel *authDescL;
@property (weak, nonatomic) IBOutlet UIButton *bottomBtn;
@property (weak, nonatomic) IBOutlet UITTTAttributedLabel *bottomL;
@property (strong, nonatomic) IBOutlet UIView *demoV;
@property (strong, nonatomic) EAXibTipView *demoTipV;

@property (strong,nonatomic) IdentityAuthenticationModel *model, *originalModel;

@end

@implementation IdentityViewController

+ (id)vcWithIdetityDict:(NSDictionary *)identity_server_CacheDataDic{
    Class classObj = [identity_server_CacheDataDic[@"status"] integerValue] == 1? [IdentityPassedViewController class]: [IdentityViewController class];//status == 1 是认证通过
    UIViewController *vc = [classObj vcInStoryboard:@"UserInfo"];
    [vc setValue:identity_server_CacheDataDic forKey:@"identity_server_CacheDataDic"];
    return vc;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    //认证失败
    if (_model.status.integerValue == 2 && _model.reject_reason_text.length > 0) {
        _headerL.text = [NSString stringWithFormat:@"原因：%@%@。请核对信息后，重新提交",
                                _model.reject_reason_text,
                                (_model.reject_detail.length > 0? [NSString stringWithFormat:@" - %@", _model.reject_detail]: @"")];
    }else{
        _headerL.text = nil;
    }
    CGFloat failureReasonLHeight = [_headerL.text getHeightWithFont:_headerL.font constrainedToSize:CGSizeMake(kScreen_Width - 30, CGFLOAT_MAX)];
    _headerV.height = _headerL.text.length > 0? 40 + failureReasonLHeight: 0;
    //数据显示
    _nameF.text = _model.name;
    _identityNumF.text = _model.identity;
    _frontImageV.hidden = _model.identity_img_front.length <= 0;
    _backImageV.hidden = _model.identity_img_back.length <= 0;
    [_frontImageV sd_setImageWithURL:[_model.identity_img_front urlWithCodingPath]];
    [_backImageV sd_setImageWithURL:[_model.identity_img_back urlWithCodingPath]];
    
    //时间绑定
    WEAKSELF;
    [_nameF.rac_textSignal subscribeNext:^(NSString *value) {
        weakSelf.model.name = value;
    }];
    [_identityNumF.rac_textSignal subscribeNext:^(NSString *value) {
        weakSelf.model.identity = value;
    }];
    [_frontImageV bk_whenTapped:^{
        [weakSelf showImageWithFront:YES];
    }];
    [_backImageV bk_whenTapped:^{
        [weakSelf showImageWithFront:NO];
    }];
    [_bottomL addLinkToStr:@"《身份认证授权与承诺书》" value:nil hasUnderline:NO clickedBlock:^(id value) {
        [weakSelf goToAgreement];
    }];

}

- (void)setIdentity_server_CacheDataDic:(NSDictionary *)identity_server_CacheDataDic{
    _identity_server_CacheDataDic = identity_server_CacheDataDic;
    _model = _identity_server_CacheDataDic? [NSObject objectOfClass:@"IdentityAuthenticationModel" fromJSON:_identity_server_CacheDataDic]: [IdentityAuthenticationModel new];
    _originalModel = _identity_server_CacheDataDic? [NSObject objectOfClass:@"IdentityAuthenticationModel" fromJSON:_identity_server_CacheDataDic]: [IdentityAuthenticationModel new];
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

#pragma mark Image_Front_Back
- (void)showImageWithFront:(BOOL)isFront{
    JTSImageInfo *imageInfo = [JTSImageInfo new];
    imageInfo.imageURL = [isFront? _model.identity_img_front: _model.identity_img_back urlWithCodingPath];
    UIImageView *imageV = isFront? _frontImageV: _backImageV;
    imageInfo.referenceRect = imageV.frame;
    imageInfo.referenceView = imageV.superview;
    JTSImageViewController *imageViewer = [[JTSImageViewController alloc] initWithImageInfo:imageInfo mode:JTSImageViewControllerMode_Image backgroundStyle:JTSImageViewControllerBackgroundOption_None];
    imageViewer.optionsDelegate = self;
    [imageViewer showFromViewController:self transition:JTSImageViewControllerTransition_FromOriginalPosition];
}

- (CGFloat)alphaForBackgroundDimmingOverlayInImageViewer:(JTSImageViewController *)imageViewer{
    return 1.0;
}

#pragma mark Action
- (IBAction)bottomBtnClicked:(id)sender {
    NSString *tipStr;
    if (_model.name.length <= 0) {
        tipStr = @"请填写姓名";
    }else if (_model.identity.length <= 0){
        tipStr = @"请填写身份证号";
    }else if (_model.identity_img_front.length <= 0){
        tipStr = @"请上传身份证正面图片";
    }else if (_model.identity_img_back.length <= 0){
        tipStr = @"请上传身份证背面图片";
    }
    if (tipStr.length > 0) {
        [NSObject showHudTipStr:tipStr];
        return;
    }

    [NSObject showHUDQueryStr:@"正在提交身份认证..."];
    WEAKSELF
    [[Coding_NetAPIManager sharedManager] post_Authentication:[self.model toParams] block:^(id data, NSError *error){
         [NSObject hideHUDQuery];
         if (data) {
             [NSObject showHudTipStr:@"身份认证提交成功"];
             [weakSelf.navigationController popViewControllerAnimated:YES];
         }
    }];
}

- (IBAction)demoBtnClicked:(id)sender {
    if (!_demoTipV) {
        _demoTipV = [EAXibTipView instancetypeWithXibView:_demoV];
    }
    [_demoTipV showInView:self.view];
}

- (IBAction)demoDissmissBtnClicked:(id)sender {
    [_demoTipV dismiss];
}

- (IBAction)frontBtnClicked:(id)sender {
}

- (IBAction)backBtnClicked:(id)sender {
}

#pragma mark Table
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 20;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [UIView new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 1.0/[UIScreen mainScreen].scale;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat rowH;
    if (indexPath.section == 0) {
        rowH = indexPath.row == 0? 112: 80;
    }else if (indexPath.section == 1){
        rowH = 66 + 2* ((kScreen_Width - 30)* 160/ 350) + 15 + 60;
    }else{
        rowH = 50 + 15 + 30 + [_authDescL.text getHeightWithFont:_authDescL.font constrainedToSize:CGSizeMake((kScreen_Width - 30 - 20), CGFLOAT_MAX)] + 2;//这个 +2 只是对高度计算不准确的冗余处理
    }
    return rowH;
}

#pragma mark VC
- (void)goToAgreement{
    [self goToWebVCWithUrlStr:@"https://coding.net/api/project/81234/files/histories/944147/download" title:@"身份认证授权与承诺书"];
}

@end
