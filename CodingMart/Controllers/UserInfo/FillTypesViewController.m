//
//  FillTypesViewController.m
//  CodingMart
//
//  Created by Ease on 15/10/28.
//  Copyright © 2015年 net.coding. All rights reserved.
//

#import "FillTypesViewController.h"
#import "FillUserInfoViewController.h"
#import "FillSkillsViewController.h"
#import "Coding_NetAPIManager.h"
#import "Login.h"
#import "IdentityAuthenticationModel.h"
#import "CodingMarkTestViewController.h"

@interface FillTypesViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *userinfoCheckV;
@property (weak, nonatomic) IBOutlet UIImageView *skillsCheckV;
@property (weak, nonatomic) IBOutlet UIImageView *testingCheckV;
@property (weak, nonatomic) IBOutlet UIImageView *statusCheckV;
@property (weak, nonatomic) IBOutlet UILabel *identityStatusLabel;
@property (strong, nonatomic) User *curUser;
@end

@implementation FillTypesViewController
+ (instancetype)storyboardVC{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"UserInfo" bundle:nil];
    return [storyboard instantiateViewControllerWithIdentifier:@"FillTypesViewController"];
}
- (void)viewDidLoad{
    [super viewDidLoad];
    self.title = @"完善资料";
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (!_curUser) {
        self.curUser = [Login curLoginUser];
    }else{
        [self refresh];
    }
 
    [self refreshIdCardCheck];
}

- (void)refresh{

    [[Coding_NetAPIManager sharedManager] get_CurrentUserBlock:^(id data, NSError *error) {
        if (data) {
            self.curUser = data;
        }
    }];
    
}

-(void)refreshIdCardCheck
{
    WEAKSELF
    [[Coding_NetAPIManager sharedManager]get_AppInfo:^(id data, NSError *error)
     {
         if (data)
         {
             NSLog(@"===[%@]",data);
//             未认证 0
//             认证通过 1
//             认证失败 2
//             认证中 3
             NSDictionary *dataDic =data[@"data"];
             NSInteger status=[dataDic[@"status"] integerValue];
             
             IdentityAuthenticationModel *model =[[IdentityAuthenticationModel alloc]initForlocalCache];
             model.alipay=dataDic[@"alipay"];
             model.identity=dataDic[@"identity"];
             model.identity_img_auth=dataDic[@"identity_img_auth"];
             model.identity_img_back=dataDic[@"identity_img_back"];
             model.identity_img_front=dataDic[@"identity_img_front"];
             model.name=dataDic[@"name"];
             model.identityIsPass=dataDic[@"status"];
             
             if (status==2)
             {
                 weakSelf.statusCheckV.hidden=YES;
                 weakSelf.identityStatusLabel.hidden=NO;
                 weakSelf.identityStatusLabel.textColor=[UIColor colorWithHexString:@"FF4B80"];
                 weakSelf.identityStatusLabel.text=@"认证失败";
             }else if(status==3)
             {
                 weakSelf.statusCheckV.hidden=YES;
                 weakSelf.identityStatusLabel.hidden=NO;
                 weakSelf.identityStatusLabel.text=@"认证中";

             }else
             {
                 weakSelf.statusCheckV.hidden=NO;
                 weakSelf.identityStatusLabel.hidden=YES;
    
             }
             
         }
         
     }];
}

- (void)setCurUser:(User *)curUser
{
    _curUser = curUser;
    _userinfoCheckV.image = [UIImage imageNamed:_curUser.fullInfo.boolValue? @"fill_checked": @"fill_unchecked"];
    _skillsCheckV.image = [UIImage imageNamed:_curUser.fullSkills.boolValue? @"fill_checked": @"fill_unchecked"];
    
    _testingCheckV.image = [UIImage imageNamed:_curUser.passingSurvey.boolValue? @"fill_checked": @"fill_unchecked"];
    _statusCheckV.image = [UIImage imageNamed:_curUser.status.boolValue? @"fill_checked": @"fill_unchecked"];
    
    
}

#pragma mark Table M

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 1 &&indexPath.section==0)
    {
        if (!self.curUser.fullInfo.boolValue) {
            [NSObject showHudTipStr:@"请先完善个人信息"];
            return;
        }
        FillSkillsViewController *vc = [FillSkillsViewController storyboardVC];
        [self.navigationController pushViewController:vc animated:YES];
    }else if (indexPath.section==2 &&indexPath.row==0)
    {
        

        CodingMarkTestViewController *vc = [CodingMarkTestViewController storyboardVC];
        vc.hasPassTheTesting=_curUser.passingSurvey.boolValue;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section==0)
    {
        return 30;
    }
    else if(section==1)
    {
        return 20;
    }else if (section==2)
    {
        return 8;
    }else
    {
        return 1;
    }
}
@end
