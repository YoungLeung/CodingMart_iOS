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

@property (weak, nonatomic) IBOutlet UILabel *nameL;
@property (weak, nonatomic) IBOutlet UILabel *roleTypeL;
@property (weak, nonatomic) IBOutlet UILabel *skillsL;
@property (weak, nonatomic) IBOutlet UILabel *messageL;

@end

@implementation ApplyCoderViewController

+ (instancetype)vcWithCoder:(RewardApplyCoder *)coder{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Independence" bundle:nil];
    ApplyCoderViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"ApplyCoderViewController"];
    vc.curCoder = coder;
    return vc;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    
    self.title = @"码市报名信息";
    
    _nameL.text = _curCoder.name;
    _roleTypeL.text = _curCoder.role_type;
    _skillsL.text = _curCoder.skills.length > 0? _curCoder.skills: @"未填写";
    _messageL.text = _curCoder.message;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat rowHeight = 0;
    NSString *contentStr;
    if (indexPath.row == 2) {
        contentStr = _curCoder.skills;
    }else if (indexPath.row == 3){
        contentStr = _curCoder.message;
    }
    if (contentStr) {
        rowHeight = [contentStr getHeightWithFont:[UIFont systemFontOfSize:15] constrainedToSize:CGSizeMake(kScreen_Width - 15* 2 - 90, CGFLOAT_MAX)] + 24.0;
    }
    return MAX(rowHeight, 44.0);
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    [super tableView:tableView willDisplayCell:cell forRowAtIndexPath:indexPath];
    cell.separatorInset = UIEdgeInsetsMake(0, 15, 0, 15);
}

@end
