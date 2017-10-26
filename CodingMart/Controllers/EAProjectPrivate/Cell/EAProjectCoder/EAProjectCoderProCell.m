//
//  EAProjectCoderProCell.m
//  CodingMart
//
//  Created by Easeeeeeeeee on 2017/10/23.
//  Copyright © 2017年 net.coding. All rights reserved.
//

#import "EAProjectCoderProCell.h"
#import "UITTTAttributedLabel.h"

@interface EAProjectCoderProCell ()
@property (weak, nonatomic) IBOutlet UILabel *nameL;
@property (weak, nonatomic) IBOutlet UILabel *projectTypeNameL;
@property (weak, nonatomic) IBOutlet UILabel *timeL;
@property (weak, nonatomic) IBOutlet UILabel *industryNameL;
@property (weak, nonatomic) IBOutlet UITTTAttributedLabel *linkL;
@property (weak, nonatomic) IBOutlet UITTTAttributedLabel *filesL;
@property (weak, nonatomic) IBOutlet UILabel *dutyL;
@property (weak, nonatomic) IBOutlet UILabel *descriptionL;

@end

@implementation EAProjectCoderProCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.fd_enforceFrameLayout = YES;
}

- (void)setPro:(SkillPro *)pro{
    _pro = pro;
    _nameL.text = _pro.project_name;
    _projectTypeNameL.text = _pro.projectTypeName.length > 0? _pro.projectTypeName: @"未填写";
    _timeL.text = [NSString stringWithFormat:@"%@ - %@", [_pro.start_time stringWithFormat:@"yyyy.MM"], _pro.until_now.boolValue? @"至今": [_pro.finish_time stringWithFormat:@"yyyy.MM"]];
    _industryNameL.text = _pro.industryName.length > 0? _pro.industryName: @"未填写";
    _linkL.text = _pro.link.length > 0? _pro.link: @"未填写";
    [_linkL addLinkToStr:_pro.link value:_pro.link hasUnderline:NO clickedBlock:^(id value) {
        NSURL *url = [NSURL URLWithString:value];
        if (!url) {
            [NSObject showHudTipStr:@"无效链接"];
        }else{
            [[UIViewController presentingVC] goToWebVCWithUrlStr:value title:nil];
        }
    }];
    if (_pro.files.count > 0) {
        _filesL.text = [[_pro.files valueForKey:@"filename"] componentsJoinedByString:@"\n\n"];
        for (MartFile *file in _pro.files) {
            [_filesL addLinkToStr:file.filename value:file hasUnderline:NO clickedBlock:^(MartFile *value) {
                [[UIViewController presentingVC] goToWebVCWithUrlStr:value.url title:value.filename];
            }];
        }
    }else{
        _filesL.text = @"未上传";
    }
    _dutyL.text = _pro.duty.length > 0? _pro.duty: @"未填写";
    _descriptionL.text = _pro.description_mine.length > 0 ? _pro.description_mine: @"未填写";
}

- (CGSize)sizeThatFits:(CGSize)size{
    size.height = 405;
    
    CGFloat contentWidth = kScreen_Width - 30 - 75 - 12;
    size.height +=MAX(0, [_industryNameL sizeThatFits:CGSizeMake(contentWidth, CGFLOAT_MAX)].height - 20);
    size.height +=MAX(0, [_linkL sizeThatFits:CGSizeMake(contentWidth, CGFLOAT_MAX)].height - 20);
    size.height +=MAX(0, [_filesL sizeThatFits:CGSizeMake(contentWidth, CGFLOAT_MAX)].height - 20);
    
    contentWidth = kScreen_Width - 30 - 24;
    size.height +=MAX(0, [_dutyL sizeThatFits:CGSizeMake(contentWidth, CGFLOAT_MAX)].height - 20);
    size.height +=MAX(0, [_descriptionL sizeThatFits:CGSizeMake(contentWidth, CGFLOAT_MAX)].height - 20);
    return size;
}
@end
