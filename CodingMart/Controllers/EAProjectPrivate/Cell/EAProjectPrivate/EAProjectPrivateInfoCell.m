//
//  EAProjectPrivateInfoCell.m
//  CodingMart
//
//  Created by Easeeeeeeeee on 2017/10/19.
//  Copyright © 2017年 net.coding. All rights reserved.
//

#import "EAProjectPrivateInfoCell.h"
#import "UITTTAttributedLabel.h"

@interface EAProjectPrivateInfoCell ()
@property (weak, nonatomic) IBOutlet UILabel *idL;
@property (weak, nonatomic) IBOutlet UILabel *typeL;
@property (weak, nonatomic) IBOutlet UILabel *developerTypeL;

@property (weak, nonatomic) IBOutlet UILabel *nameL;
@property (weak, nonatomic) IBOutlet UILabel *industryNameL;
@property (weak, nonatomic) IBOutlet UILabel *priceL;
@property (weak, nonatomic) IBOutlet UILabel *durationL;
@property (weak, nonatomic) IBOutlet UILabel *descriptionL;
@property (weak, nonatomic) IBOutlet UILabel *sampleL;
@property (weak, nonatomic) IBOutlet UITTTAttributedLabel *fileL;
@property (weak, nonatomic) IBOutlet UILabel *rewardDemandL;

@property (weak, nonatomic) IBOutlet UILabel *contactNameL;
@property (weak, nonatomic) IBOutlet UILabel *contactEmailL;
@property (weak, nonatomic) IBOutlet UILabel *contactMobileL;
@end

@implementation EAProjectPrivateInfoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.fd_enforceFrameLayout = YES;
}

- (void)setProM:(EAProjectModel *)proM{
    _proM = proM;
    
    _idL.text = [NSString stringWithFormat:@"NO.%@", _proM.id];
    _typeL.text = _proM.typeText;
    _developerTypeL.text = [_proM.developerType isEqualToString:@"PERSONAL"]? @"个人开发者": @"团队开发者";
    
    _nameL.text = _proM.name;
    _industryNameL.text = _proM.industryName;
    _priceL.text = [NSString stringWithFormat:@"%@ 元%@", _proM.price, _proM.bargain.boolValue? @"（可议价）": @""];
    _durationL.text = [NSString stringWithFormat:@"%@ 天", _proM.duration];
    _descriptionL.text = _proM.description_mine;

    NSMutableArray *sampleList = @[].mutableCopy;
    if (_proM.firstSample) {
        [sampleList addObject:_proM.firstSample];
    }
    if (_proM.secondSample) {
        [sampleList addObject:_proM.secondSample];
    }
    _sampleL.text = sampleList.count > 0? [sampleList componentsJoinedByString:@"，"]: @"无";
    if (_proM.files.count > 0) {
        _fileL.text = [[_proM.files valueForKey:@"filename"] componentsJoinedByString:@"\n\n"];
        for (MartFile *file in _proM.files) {
            [_fileL addLinkToStr:file.filename value:file hasUnderline:YES clickedBlock:^(MartFile *value) {
                [[UIViewController presentingVC] goToWebVCWithUrlStr:value.url title:value.filename];
            }];
        }
    }else{
        _fileL.text = @"无";
    }
    _rewardDemandL.text = _proM.rewardDemand;
    
    _contactNameL.text = _proM.contactName;
    _contactEmailL.text = _proM.contactEmail;
    _contactMobileL.text = _proM.contactMobile;
}

- (CGSize)sizeThatFits:(CGSize)size{
    CGFloat contentWidth = kScreen_Width - 95 - 12 - 30;
    size.height = 712;
    size.height +=MAX(0, [_nameL sizeThatFits:CGSizeMake(contentWidth, CGFLOAT_MAX)].height - 20);
    size.height +=MAX(0, [_industryNameL sizeThatFits:CGSizeMake(contentWidth, CGFLOAT_MAX)].height - 20);
    size.height +=MAX(0, [_descriptionL sizeThatFits:CGSizeMake(contentWidth, CGFLOAT_MAX)].height - 20);
    size.height +=MAX(0, [_sampleL sizeThatFits:CGSizeMake(contentWidth, CGFLOAT_MAX)].height - 20);
    size.height +=MAX(0, [_fileL sizeThatFits:CGSizeMake(contentWidth, CGFLOAT_MAX)].height - 20);
    size.height +=MAX(0, [_rewardDemandL sizeThatFits:CGSizeMake(contentWidth, CGFLOAT_MAX)].height - 20);
    return size;
}

@end

//{
//    "ownerId": 501001,
//    "name": "hhhhhhh",
//    "description": "fghjkk to the n...",
//    "cover": "https://dn-coding-net-production-pp.qbox.me/....png",
//    "price": "100",
//    "roles": "iOS开发",
//    "type": "WECHAT",
//    "status": "DEVELOPING",
//    "duration": 56,
//    "contactName": "周春萍",
//    "contactEmail": "fromperri+13@gmail.com",
//    "contactMobile": "15214444444",
//    "applyCount": 1,
//    "serviceFee": "0",
//    "rewardDemand": "is the one in the...",
//    "phoneCountryCode": "+86",
//    "id": 3184,
//    "createdAt": "1506650140000",
//    "developerType": "PERSONAL",
//    "developerRole": 4,
//    "industry": "12,11",
//    "industryName": "大神在,青海",
//    "bargain": true,
//    "statusText": "开发中",
//    "typeText": "微信公众号",
//    "visitCount": 2
//}
