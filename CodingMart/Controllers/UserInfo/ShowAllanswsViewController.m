//
//  ShowAllanswsViewController.m
//  CodingMart
//
//  Created by HuiYang on 15/11/16.
//  Copyright © 2015年 net.coding. All rights reserved.
//

#import "ShowAllanswsViewController.h"
#import "RDHCollectionViewGridLayout.h"
#import "AnswsCollectionCell.h"
#import "CodingExamModel.h"

@interface ShowAllanswsViewController ()<UICollectionViewDataSource,UICollectionViewDelegate>
@property(nonatomic,strong)UICollectionView *collectionView;

@end

@implementation ShowAllanswsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self buildUI];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)buildUI
{
    self.view.backgroundColor=[UIColor whiteColor];
    
    RDHCollectionViewGridLayout* layout= [RDHCollectionViewGridLayout new];
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    layout.sectionsStartOnNewLine = YES;
    layout.lineSpacing = 10;
    layout.itemSpacing = 10;
    layout.lineItemCount = 5;
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    [self.collectionView registerClass:[AnswsCollectionCell class] forCellWithReuseIdentifier:@"AnswsCollectionCell"];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    self.collectionView.showsHorizontalScrollIndicator = NO;
    self.collectionView.scrollEnabled = NO;
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    
    [self.view addSubview:self.collectionView];
    
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(100);
        make.left.equalTo(self.view.mas_left).offset(30);
        make.right.equalTo(self.view.mas_right).offset(-30);
        make.bottom.equalTo(self.view.mas_bottom).offset(-50);
    }];
}

-(void)setDataSource:(NSMutableArray *)dataSource
{
    _dataSource=dataSource;
}

-(void)setIsShowAll:(BOOL)isShowAll
{
    _isShowAll=isShowAll;
    if (isShowAll)
    {
        self.title=@"查看未做";
        [self addNoticeBottomlabel];
    }else
    {
        self.title=@"考试结果";
    }
    
    [self.collectionView reloadData];
}

#pragma mark - UICollectionViewDataSource Methods

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{

    return self.dataSource.count;
//    return 20;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    AnswsCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"AnswsCollectionCell" forIndexPath:indexPath];
    
     CodingExamModel *mode =[self.dataSource objectAtIndex:indexPath.row];
    if (self.isShowAll)
    {
        cell.ansModel=AnswerModel_ShowAll;
    }else
    {
        cell.ansModel=AnswerModel_ShowFail;
    }
    
    if (mode.isAnswer)
    {
        cell.isMark=YES;
    }else
    {
        cell.isMark=NO;
    }
    
    cell.aTitle=[NSString stringWithFormat:@"%d",mode.sort.intValue];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    if ([self.delegate respondsToSelector:@selector(tapItemForIndex:)])
    {
        [self.delegate tapItemForIndex:indexPath.row];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

-(void)addNoticeBottomlabel
{
    UILabel *tips =[UILabel new];
    tips.text=@"绿色为已经回答的题目";
    tips.textAlignment=NSTextAlignmentCenter;
    
    [self.view addSubview:tips];
    [tips mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.height.equalTo(@20);
        make.bottom.equalTo(self.view.mas_bottom).offset(-120);
    }];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
