//
//  ApplyCoderViewController.m
//  CodingMart
//
//  Created by Ease on 16/5/5.
//  Copyright © 2016年 net.coding. All rights reserved.
//

#import "ApplyCoderViewController.h"

@interface ApplyCoderViewController ()
@property (strong, nonatomic) RewardApplyCoder *curCoder;
@property (strong, nonatomic) Reward *curReward;

@property (weak, nonatomic) IBOutlet UILabel *nameL;
@property (weak, nonatomic) IBOutlet UILabel *roleTypeL;
@property (weak, nonatomic) IBOutlet UILabel *skillsL;
@property (weak, nonatomic) IBOutlet UILabel *messageL;
@property (weak, nonatomic) IBOutlet UILabel *idL;
@property (weak, nonatomic) IBOutlet UILabel *phoneL;
@property (weak, nonatomic) IBOutlet UILabel *qqL;
@property (weak, nonatomic) IBOutlet UILabel *reward_roleL;

@end

@implementation ApplyCoderViewController

+ (instancetype)vcWithCoder:(RewardApplyCoder *)coder reward:(Reward *)reward{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Independence" bundle:nil];
    ApplyCoderViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"ApplyCoderViewController"];
    vc.curCoder = coder;
    vc.curReward = reward;
    return vc;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    
    self.title = @"码市报名信息";
    
    _nameL.text = _curCoder.name;
    _roleTypeL.text = _curCoder.role_type;
    _skillsL.text = _curCoder.good_at.length > 0? _curCoder.good_at: @"未填写";
    _messageL.text = _curCoder.message;
    _idL.text = _curCoder.global_key;
    _phoneL.text = _curCoder.mobile;
    _qqL.text = _curCoder.qq;
    _reward_roleL.text = _curCoder.reward_roleDisplay;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat rowHeight;
    NSInteger row = indexPath.row;
    
    if (_curReward.status.integerValue > RewardStatusRecruiting) {
        rowHeight = row > 4? 0.0: 44.0;
    }else{
        rowHeight = (row == 0 || row == 4)? 0.0: 44.0;
        NSString *contentStr = row == 5? _curCoder.good_at: row == 7? _curCoder.message: nil;
        if (contentStr.length > 0) {
            rowHeight = MAX(rowHeight,
                            [contentStr getHeightWithFont:[UIFont systemFontOfSize:15] constrainedToSize:CGSizeMake(kScreen_Width - 15* 2 - 90, CGFLOAT_MAX)] + 24.0);
        }
    }
    return rowHeight;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    [super tableView:tableView willDisplayCell:cell forRowAtIndexPath:indexPath];
    cell.separatorInset = UIEdgeInsetsMake(0, 15, 0, 15);
}

@end
