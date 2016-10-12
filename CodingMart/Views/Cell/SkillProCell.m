//
//  SkillProCell.m
//  CodingMart
//
//  Created by Ease on 16/4/11.
//  Copyright © 2016年 net.coding. All rights reserved.
//

#import "SkillProCell.h"
#import "NSDate+Helper.h"
#import "UITTTAttributedLabel.h"

@interface SkillProCell ()

@property (weak, nonatomic) IBOutlet UILabel *nameL;
@property (weak, nonatomic) IBOutlet UILabel *timeL;
@property (weak, nonatomic) IBOutlet UILabel *projectTypeNameL;
@property (weak, nonatomic) IBOutlet UILabel *descriptionL;
@property (weak, nonatomic) IBOutlet UILabel *industryNameL;
@property (weak, nonatomic) IBOutlet UILabel *dutyL;
@property (weak, nonatomic) IBOutlet UITTTAttributedLabel *linkL;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *fileButtonList;
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *fileLabelList;

@end

@implementation SkillProCell

- (void)setPro:(SkillPro *)pro{
    _pro = pro;
    _nameL.text = _pro.project_name;
    _timeL.text = [NSString stringWithFormat:@"%@ - %@", [_pro.start_time stringWithFormat:@"yyyy.MM"], _pro.until_now.boolValue? @"至今": [_pro.finish_time stringWithFormat:@"yyyy.MM"]];
    _descriptionL.text = _pro.description_mine.length > 0 ? _pro.description_mine: @"未填写";
    _dutyL.text = _pro.duty.length > 0? _pro.duty: @"未填写";
    _projectTypeNameL.text = _pro.projectTypeName.length > 0? _pro.projectTypeName: @"未填写";
    _industryNameL.text = _pro.industryName.length > 0? _pro.industryName: @"未填写";

    _linkL.text = _pro.link.length > 0? _pro.link: @"未填写";
    if (_pro.link.length > 0) {
        [_linkL addLinkToStr:_pro.link value:_pro.link hasUnderline:NO clickedBlock:^(id value) {
            NSURL *url = [NSURL URLWithString:value];
            if (!url) {
                [NSObject showHudTipStr:@"无效链接"];
            }else{
                [[UIViewController presentingVC] goToWebVCWithUrlStr:value title:nil];
            }
        }];
        [_linkL addLongPressForCopy];
    }
    
    [_fileButtonList enumerateObjectsUsingBlock:^(UIButton * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.hidden = _pro.files.count <= idx;
    }];
    [_fileLabelList enumerateObjectsUsingBlock:^(UILabel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (_pro.files.count > idx) {
            obj.text = [(MartFile *)_pro.files[idx] filename];
        }
    }];
}

- (IBAction)fileBtnClicked:(id)sender {
    NSUInteger index = [self.fileButtonList indexOfObject:sender];
    if (_clickedFileBlock) {
        _clickedFileBlock(_pro.files[index]);
    }
}

- (IBAction)headerViewClicked:(id)sender {
    if (_editProBlock) {
        _editProBlock(_pro);
    }
}

+ (CGFloat)cellHeightWithObj:(id)obj{
    CGFloat height = 0;
    if ([obj isKindOfClass:[SkillPro class]]) {
        SkillPro *pro = obj;
        height += 8+ 8+ 44;
        
        UIFont *font = [UIFont systemFontOfSize:14];
        CGFloat width = kScreen_Width - (15+ 10)* 2 - (70+ 10);
        
        height += 15+ MAX(20, [pro.description_mine getHeightWithFont:font constrainedToSize:CGSizeMake(width, CGFLOAT_MAX)]);
        height += 15+ MAX(20, [pro.duty getHeightWithFont:font constrainedToSize:CGSizeMake(width, CGFLOAT_MAX)]);
        height += 15+ MAX(20, [pro.link getHeightWithFont:font constrainedToSize:CGSizeMake(width, CGFLOAT_MAX)]);
        height += 15+ MAX(20, [pro.projectTypeName getHeightWithFont:font constrainedToSize:CGSizeMake(width, CGFLOAT_MAX)]);
        height += 15+ MAX(20, [pro.industryName getHeightWithFont:font constrainedToSize:CGSizeMake(width, CGFLOAT_MAX)]);
        height += 15;
        if (pro.files.count > 0) {
            height += 15;
            height += pro.files.count * (40+ 10);
            height += 5;
        }
    }
    return height;
}
@end
