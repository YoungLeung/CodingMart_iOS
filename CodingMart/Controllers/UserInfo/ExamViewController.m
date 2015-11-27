//
//  ExamViewController.m
//  CodingMart
//
//  Created by HuiYang on 15/11/13.
//  Copyright © 2015年 net.coding. All rights reserved.
//

#import "ExamViewController.h"
#import "iCarousel.h"
#import "ExamCardView.h"
#import "ShowAllanswsViewController.h"
#import "Coding_NetAPIManager.h"
#import "CodingTestResultViewController.h"


#define kHeardHeight 55

@interface ExamViewController ()<iCarouselDataSource,iCarouselDelegate,ShowAllanswsViewControllerDelegate,CodingTestResultViewControllerDelegate>
@property(nonatomic,strong)UILabel *titleLabel;
@property(nonatomic,strong)UIButton *showAllBtn;
@property(nonatomic,strong)iCarousel *carousel;




@end

@implementation ExamViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self buildUI];
    // Do any additional setup after loading the view.
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)buildUI
{
    self.view.backgroundColor=[UIColor whiteColor];
    self.title=self.viewerModel?@"查看题目":@"码市测试";
    
    self.titleLabel=[UILabel new];
    self.titleLabel.textColor=[UIColor colorWithHexString:@"44C07F"];
    self.titleLabel.font=[UIFont boldSystemFontOfSize:18];
    self.titleLabel.text=@"lsdjkvbnl";
    
    [self.view addSubview:self.titleLabel];
    
    self.showAllBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [self.showAllBtn setImage:[UIImage imageNamed:@"icon-showAll"] forState:UIControlStateNormal ];
    [self.showAllBtn addTarget:self action:@selector(showAllAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.showAllBtn];
    
    if (!self.viewerModel)
    {

     self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithTitle:@"提交" style:UIBarButtonItemStyleDone target:self action:@selector(submitAction)];
    }
    
    UIView *line =[UIView new];
    line.backgroundColor=[UIColor colorWithHexString:@"DDDDDD"];
    [self.view addSubview:line];
    
    self.carousel =[[iCarousel alloc]initWithFrame:self.view.bounds];
    self.carousel.delegate=self;
    self.carousel.dataSource=self;
    self.carousel.pagingEnabled=YES;
    self.carousel.bounces=NO;
    [self.carousel scrollToItemAtIndex:self.scorIndex animated:NO];
    [self.view setClipsToBounds:YES];
    
    [self.view addSubview:self.carousel];
    [self.carousel mas_makeConstraints:^(MASConstraintMaker *make)
     {
         make.top.equalTo(line.mas_bottom);
         make.left.equalTo(self.view.mas_left);
         make.right.equalTo(self.view.mas_right);
         make.bottom.equalTo(self.view.mas_bottom);
     }];
    
    [self.carousel setNeedsLayout];
    [self.carousel layoutIfNeeded];

    
    
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(15);
        make.right.equalTo(self.view.mas_right).offset(-15);
        make.top.equalTo(self.view.mas_top).offset(55);
        make.height.equalTo(@1);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(15);
        make.height.equalTo(@(35));
        make.width.equalTo(@200);
        make.top.equalTo(@(55/2-35/2));
     
        
    }];
    
    [self.showAllBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view.mas_right).offset(-10);
        make.size.mas_equalTo(CGSizeMake(40, 40));
        make.top.equalTo(@(55/2-40/2));
    }];
    
    
    self.showAllBtn.imageEdgeInsets=UIEdgeInsetsMake(5, 5, 5, 5);
    
    [self.carousel reloadData];
    [self updateLabelState:1];
    
    if (self.viewerModel)
    {
        self.showAllBtn.hidden=YES;
    
    }else
    {
         [NSObject showHudTipStr:@"左右滑动,切换上下题"];
    }
}

-(void)setScorIndex:(NSInteger)scorIndex
{
    _scorIndex=scorIndex;
     [self.carousel scrollToItemAtIndex:self.scorIndex animated:NO];
}

#pragma mark iCarousel methods

- (NSUInteger)numberOfItemsInCarousel:(iCarousel *)carousel
{
    //return the total number of items in the carousel
    return self.dataSource.count;
}

- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSUInteger)index reusingView:(UIView *)view
{
    
    //create new view if no view is available for recycling
    if (view == nil)
    {
        //don't do anything specific to the index within
        //this `if (view == nil) {...}` statement because the view will be
        //recycled and used with other index values later
        view = [[ExamCardView alloc] initWithFrame:self.carousel.bounds];
        
    }
    
    
    ExamCardView *vv  = (ExamCardView *)view;
    CodingExamModel *model =[self.dataSource objectAtIndex:index];
    vv.model=model;
    vv.userAnswers=self.userSelectAnswers;
    vv.viewerModel=self.viewerModel;

    return view;
}

- (void)carouselDidScroll:(iCarousel *)carousel
{
    NSInteger current =[carousel currentItemIndex];
    
    [self updateLabelState:current+1];
}

-(void)updateLabelState:(NSInteger )index
{
    self.titleLabel.text=[NSString stringWithFormat:@"第%ld/%lu题",(long)index,(unsigned long)self.dataSource.count];
}

-(void)showAllAction
{
      
    ShowAllanswsViewController *av =[[ShowAllanswsViewController alloc]init];
    av.dataSource=self.dataSource;
    av.isShowAll=YES;
    av.delegate=self;
    [self.navigationController pushViewController:av animated:YES];
}

-(void)submitAction
{
   
    
    if ([self.userSelectAnswers allKeys].count!=self.dataSource.count)
    {
        NSInteger undo =self.dataSource.count-self.userSelectAnswers.count;
        NSString *tips =[NSString stringWithFormat:@"您还剩(%ld)题没完成，请继续完成再提交",(long)undo];
        [NSObject showHudTipStr:tips];
        return;
    }
    
    
    [NSObject showHUDQueryStr:@"正在提交试题..."];
    NSDictionary *postData =[NSDictionary dictionaryWithObject:self.userSelectAnswers forKey:@"answers"];
    
    
//    [[NSUserDefaults standardUserDefaults]setObject:postData forKey:@"myTesting2"];
////
//    NSDictionary *postDataMM =[[NSUserDefaults standardUserDefaults]objectForKey:@"myTesting2"];
//

    WEAKSELF
    [[Coding_NetAPIManager sharedManager]post_CodingExamTesting:postData block:^(id reSpdata, NSError *error)
    {
        [NSObject hideHUDQuery];
        NSInteger code =[reSpdata[@"code"] integerValue];
        if (code==0)
        {
            //成功
            NSDictionary *score=reSpdata[@"data"][@"score"];
            NSNumber *correct=score[@"correct"];
            NSNumber *total=score[@"total"];
            
            if ([correct intValue]==[total intValue])
            {
                //pass
                 [weakSelf isPassForTesting:YES];
            }else
            {
                //失败
                [weakSelf isPassForTesting:NO];
            }
            
           
        }else
        {
            [NSObject showHudTipStr:@"发生一个错误"];
            
        }
        
    }];
    
}


-(void)isPassForTesting:(BOOL)pass
{
    CodingTestResultViewController *av =[CodingTestResultViewController new];
    av.dataSource=self.dataSource;
    av.isPass=pass;
    av.delegate=self;
    av.userSelectAnswers=self.userSelectAnswers;
    [self.navigationController pushViewController:av animated:YES];
}
//查看未做
-(void)tapItemForIndex:(NSInteger)index
{
    [self.carousel scrollToItemAtIndex:index animated:NO];
}

//查看错题,有答案
-(void)testResultTapItemForIndex:(NSInteger)index
{

}



-(NSMutableArray*)dataSource
{
    if (!_dataSource)
    {
        _dataSource=[NSMutableArray new];
    }
    return _dataSource;
}
-(NSMutableDictionary*)userSelectAnswers
{
    if (!_userSelectAnswers) {
        _userSelectAnswers =[NSMutableDictionary new];
    }
    return _userSelectAnswers;
}


@end
