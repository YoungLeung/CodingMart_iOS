//
//  ExamCardView.m
//  CodingMart
//
//  Created by HuiYang on 15/11/15.
//  Copyright © 2015年 net.coding. All rights reserved.
//

#import "ExamCardView.h"

#import "ExamCardAnswCell.h"
#import "ExamCardQuestionCell.h"
#import "ExamCardTitleCell.h"

#import <UITableView+FDTemplateLayoutCell.h>



@interface ExamCardView ()<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)NSString *questionID;
@property(nonatomic,assign)BOOL isShowAnswer;


@end

@implementation ExamCardView


-(instancetype)initWithFrame:(CGRect)frame
{
    if (self=[super initWithFrame:frame])
    {
        [self buildUI];
    }
    return self;
}

-(void)buildUI
{
    [self addSubview:self.tableView];
    
}

-(void)setModel:(CodingExamModel *)model
{
    _model=model;
    
    self.questionID=[model.id stringValue];
    [self.tableView reloadData];
}

-(UITableView*)tableView
{
    if (!_tableView)
    {
        _tableView=[[UITableView alloc]initWithFrame:self.bounds];
        _tableView.backgroundColor=[UIColor whiteColor];
        _tableView.tableFooterView=[UIView new];
        _tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
        _tableView.delegate=self;
        _tableView.dataSource=self;
        
        [_tableView registerClass:[ExamCardTitleCell class] forCellReuseIdentifier:@"ExamCardTitleCell"];
        [_tableView registerClass:[ExamCardQuestionCell class] forCellReuseIdentifier:@"ExamCardQuestionCell"];
        [_tableView registerClass:[ExamCardAnswCell class] forCellReuseIdentifier:@"ExamCardAnswCell"];
        
        
    }
    return _tableView;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.model)
    {
        if (self.isShowAnswer)
        {
            return 6;
        }else
        {
           return 5;
        }
        
    }else
    {
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==0)
    {
        ExamCardTitleCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ExamCardTitleCell"];
        [cell updateExamCardTitleCell:self.model];
        return cell;
        
    }else if(indexPath.row==5)
    {
        ExamCardAnswCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ExamCardAnswCell"];
        [cell updateContentData:self.model];
        return cell;
    }else
    {
        ExamCardQuestionCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ExamCardQuestionCell"];
        CodingExamOptionsModel *modelOption =[self.model.options objectAtIndex:indexPath.row-1];
        
        [cell updateExamCardQuestionCell:modelOption];
        cell.markFail=self.viewerModel;
        
        NSArray *temp =[self.userAnswers objectForKey:self.questionID];
        if ([temp containsObject:modelOption.id])
        {
            cell.markSelect=YES;
        }else
        {
            cell.markSelect=NO;
        }
        
        return cell;
    }
    
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==0)
    {
        WEAKSELF
        return [tableView fd_heightForCellWithIdentifier:@"ExamCardTitleCell" cacheByIndexPath:indexPath configuration:^(id cell)
                {
           [cell updateExamCardTitleCell:weakSelf.model];
        }]+20;
        
    }else if(indexPath.row==5)
    {
        return 50;
    }else
    {
        WEAKSELF
        return [tableView fd_heightForCellWithIdentifier:@"ExamCardQuestionCell" cacheByIndexPath:indexPath configuration:^(id cell)
                {
                    CodingExamOptionsModel *modelOption =[weakSelf.model.options objectAtIndex:indexPath.row-1];
                    [cell updateExamCardQuestionCell:modelOption];

                }]+20;
    }
   
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==0 ||indexPath.row==5 || self.viewerModel)
        return;
    
    NSMutableArray *temp =[self.userAnswers objectForKey:self.questionID];
    CodingExamOptionsModel *modelOption =[self.model.options objectAtIndex:indexPath.row-1];
    
    
    if (temp)
    {
        if ([temp containsObject:modelOption.id])
        {
            [temp removeObject:modelOption.id];
        }else
        {
           //如果单选,重新赋值
            if(self.model.type.intValue==0)
            {
                temp =[NSMutableArray new];
                [temp addObject:modelOption.id];
                [self.userAnswers setObject:temp forKey:self.questionID];
            }else
            {
                [temp addObject:modelOption.id];
                [self.userAnswers setObject:temp forKey:self.questionID];
            }
        }
    }else
    {
        temp =[NSMutableArray new];
        [temp addObject:modelOption.id];
        [self.userAnswers setObject:temp forKey:self.questionID];
    }
    
    [self.model.currentSelect removeAllObjects];
    [self.model.currentSelect addObjectsFromArray:[self.userAnswers objectForKey:self.questionID]];
    
    [tableView reloadData];
}

-(BOOL)isShowAnswer
{
    if ( self.viewerModel && !self.model.isRight)
    {
        return YES;
    }else
    {
        return NO;
    }
}

@end
