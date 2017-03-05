//
// Created by chao chen on 2017/3/2.
// Copyright (c) 2017 net.coding. All rights reserved.
//

#import "IdentityResultViewController.h"
#import "UITTTAttributedLabel.h"
#import "UIImageView+WebCache.h"
#import "UIViewController+Common.h"
#import "UIImageView+WebCache.h"
#import "JTSImageInfo.h"
#import "JTSImageViewController.h"
#import "BlocksKit+UIKit.h"

@interface IdentityResultViewController ()
@property(weak, nonatomic) IBOutlet UIImageView *resultIcon;
@property(weak, nonatomic) IBOutlet UILabel *resultTitle;
@property(weak, nonatomic) IBOutlet UITTTAttributedLabel *resultContent;

@property(weak, nonatomic) IBOutlet UILabel *enterpriseName;
@property(weak, nonatomic) IBOutlet UIImageView *passedFlag;

@property(weak, nonatomic) IBOutlet UILabel *idCard;
@property(weak, nonatomic) IBOutlet UIImageView *businessLicenceImage;

@property(strong, nonatomic) EnterpriseCertificate *certificate;
@end

@implementation IdentityResultViewController

+ (id)vcInStoryboard:(EnterpriseCertificate *)certificate {
    NSString *storyboardName = @"UserInfo";
    UIViewController *vc = [self vcInStoryboard:storyboardName withIdentifier:NSStringFromClass([self class])];
    [vc setValue:certificate forKey:@"enterprise"];
    return vc;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.tableView reloadData];

    NSString *status = _certificate.status;

    if ([status isEqualToString:@"processing"]) {
        _resultIcon.image = [UIImage imageNamed:@"ic_enterprise_process"];
        _resultTitle.text = @"认证审核中";
        _resultContent.text = @"认证审核需要 1 - 3 个工作日，如需修改认证信息请 联系客服";

        _passedFlag.hidden = YES;

    } else if ([status isEqualToString:@"failed"]) {
        _resultIcon.image = [UIImage imageNamed:@"ic_enterprise_fail"];
        _resultTitle.text = @"认证未通过！";
        _resultContent.text = [NSString stringWithFormat:@"很遗憾，您的企业认证失败。\n原因：%@。\n请重新提交认证，如有疑问请 联系客服", _certificate.rejectReason];
//        sendButton.setVisibility(View.VISIBLE);
        _passedFlag.hidden = YES;

    } else { // "successful":
        _resultIcon.image = [UIImage imageNamed:@"ic_enterprise_success"];
        _resultTitle.text = @"认证通过！";
//        name.setCompoundDrawablesRelativeWithIntrinsicBounds(0, 0, R.mipmap.ic_enterprise_flag_passed, 0);
        _resultContent.text = @"验证通过后无法自行修改。如果需要修改认证信息请 联系客服";
        _passedFlag.hidden = NO;
    }

    _enterpriseName.text = _certificate.legalRepresentative;
    _idCard.text = _certificate.businessLicenceNo;

    float width = kScreen_Width * 0.46;
    CGSize titleSize = [_resultContent.text boundingRectWithSize:CGSizeMake(width, MAXFLOAT)
                                                         options:NSStringDrawingUsesLineFragmentOrigin
                                                      attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:14.0f]}
                                                         context:nil].size;



    WEAKSELF
    [_resultContent addLinkToStr:@"联系客服" value:nil hasUnderline:NO clickedBlock:^(id value) {
        [weakSelf goToTalk];
    }];

    [_businessLicenceImage bk_whenTapped:^{
        [weakSelf clickLicenceImage];
    }];

    _businessLicenceImage.hidden = NO;
    [_businessLicenceImage sd_setImageWithURL:[_certificate.attachment.url urlWithCodingPath]];
}

- (void)setEnterprise:(EnterpriseCertificate *)certificate {
    _certificate = certificate;
}

#pragma mark Table

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [UIView new];
}

- (IBAction)businessLicenceClicked:(UIButton *)sender {
    [self clickLicenceImage];
}

- (void)clickLicenceImage {
    JTSImageInfo *imageInfo = [JTSImageInfo new];
    imageInfo.imageURL = [_certificate.attachment.url urlWithCodingPath];
    UIImageView *imageV = _businessLicenceImage;
    imageInfo.referenceRect = imageV.frame;
    imageInfo.referenceView = imageV.superview;
    JTSImageViewController *imageViewer = [[JTSImageViewController alloc] initWithImageInfo:imageInfo mode:JTSImageViewControllerMode_Image backgroundStyle:JTSImageViewControllerBackgroundOption_None];
    WEAKSELF;
    imageViewer.deleteBlock = nil;
    imageViewer.optionsDelegate = self;
    [imageViewer showFromViewController:self transition:JTSImageViewControllerTransition_FromOriginalPosition];
}

@end
