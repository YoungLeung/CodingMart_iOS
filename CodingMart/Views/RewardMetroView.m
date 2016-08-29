//
//  RewardMetroView.m
//  CodingMart
//
//  Created by Ease on 16/4/22.
//  Copyright © 2016年 net.coding. All rights reserved.
//

#define kRewardMetroViewStageHeight 20.0
#define kRewardMetroViewStagePadding 5.0


#import "RewardMetroView.h"
#import <BlocksKit/BlocksKit.h>

@interface RewardMetroView ()
@property (strong, nonatomic) NSMutableArray *dotList, *lineList, *statusLList, *stageVList;
@property (strong, nonatomic) UIView *stageBGView;

@property (assign, nonatomic, readonly) CGFloat contentPadding, stageWidth, stageHeight, stagePadding, dotWidth, dotPadding, lineHeight, statusLWidth, dotStartX;
@property (assign, nonatomic, readonly) CGFloat statusWidth, viewHeight, dotY, statusLY, lineY;

@end

@implementation RewardMetroView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self p_initConfig];
    }
    return self;
}

- (void)awakeFromNib{
    [self p_initConfig];
}

- (void)p_initConfig{
    _contentPadding = 15;
    _stageWidth = 35;
    _stageHeight = kRewardMetroViewStageHeight;
    _stagePadding = kRewardMetroViewStagePadding;
    _dotWidth = 6;
    _dotPadding = 2;
    _lineHeight = 1;
    _statusLWidth = 40;
    _dotStartX = _contentPadding + _statusLWidth/2;
}


- (void)setCurRewardP:(RewardPrivate *)curRewardP{
    _curRewardP = curRewardP;
    [self setupUI];
}

- (void)setupUI{
    [[self subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    _dotList = @[].mutableCopy;
    _lineList = @[].mutableCopy;
    _statusLList = @[].mutableCopy;
    _stageVList = @[].mutableCopy;
    _stageBGView = nil;
    
    if (_curRewardP.metro.metroStatus.count < 2) {
        return;
    }
    NSArray *metroStatus = _curRewardP.metro.metroStatus;
    
    _statusWidth = (kScreen_Width - _dotStartX* 2 - _dotWidth)/(metroStatus.count - 1);
    _viewHeight = [RewardMetroView heightWithObj:_curRewardP];
    _dotY = _viewHeight/ 2 - 10;
    _statusLY = _dotY + 20;
    _lineY = _dotY + _dotWidth/2 - _lineHeight /2;

    for (int index = 0; index < metroStatus.count; index++) {
        NSNumber *status = metroStatus[index];
        [self p_addStatus:status name:_curRewardP.metro.allStatus[status.stringValue] index:index];
    }
    
    CGFloat viewWidth = [(UIView *)_dotList.lastObject right] + _dotStartX;
    self.contentSize = CGSizeMake(viewWidth, _viewHeight);
}

- (void)p_addStatus:(NSNumber *)status name:(NSString *)name index:(NSInteger)index{
    DebugLog(@"p_addStatus - %@", name);
    NSArray *metroStatus = _curRewardP.metro.metroStatus;
    BOOL statusIsCurStatus = [status isEqual:_curRewardP.basicInfo.status];
    
    if (_curRewardP.basicInfo.status.integerValue == RewardStatusDeveloping &&
        _curRewardP.metro.roles.count > 0 &&
        index > 0 &&
        [metroStatus[index -1] integerValue] == RewardStatusDeveloping) {//项目当前状态是开发中 & 有阶段划分 & 上一个状态是开发中
        
        CGFloat roleCount = _curRewardP.metro.roles.count;
        CGFloat maxStageCount = 0;
        for (RewardMetroRole *role in _curRewardP.metro.roles) {
            maxStageCount = MAX(maxStageCount, role.stages.count);
        }
        CGFloat stageBGHeight = roleCount * _stageHeight + (roleCount+ 1)* _stagePadding;
        CGFloat stageBGWidth = maxStageCount * _stageWidth + (maxStageCount +1)* _stagePadding;
        CGFloat lineWidth = (_statusWidth - 2* (_dotWidth + _dotPadding))/ 2;
        CGPoint leftLinePosition = CGPointMake([(UIView *)_dotList.lastObject right] + _dotPadding, _lineY);
        CGPoint rightLinePosition = CGPointMake(leftLinePosition.x + lineWidth + stageBGWidth, _lineY);
        CGPoint dotPosition = CGPointMake(rightLinePosition.x + lineWidth + _dotPadding, _dotY);
        CGPoint statusLPosition = CGPointMake(dotPosition.x + _dotWidth/ 2 - _statusLWidth/2, _statusLY);
        CGPoint stageBGPosition = CGPointMake(leftLinePosition.x + lineWidth, (_viewHeight - stageBGHeight)/ 2);
        
        [self p_addLineViewToPosition:leftLinePosition width:lineWidth];

        _stageBGView = [[UIView alloc] initWithFrame:CGRectMake(stageBGPosition.x, stageBGPosition.y, stageBGWidth, stageBGHeight)];
        [_stageBGView doBorderWidth:1.0 color:[UIColor colorWithHexString:@"0xCCCCCC"] cornerRadius:2.0];
        
        for (int indexY = 0; indexY < _curRewardP.metro.roles.count; indexY++) {
            RewardMetroRole *role = _curRewardP.metro.roles[indexY];
            [_stageVList addObject:@[].mutableCopy];
            for (int indexX = 0; indexX < role.stages.count; indexX++) {
                RewardMetroRoleStage *stage = role.stages[indexX];
                UIView *stageV =[self p_addStageVToIndexX:indexX indexY:indexY stage:stage roleColor:role.roleColor];
                [_stageVList[indexY] addObject:stageV];
            }
        }
        [self addSubview:_stageBGView];
        
        [self p_addLineViewToPosition:rightLinePosition width:lineWidth];
        [self p_addDotViewToPosition:dotPosition statusIsCurStatus:statusIsCurStatus];
        [self p_addStatusLToPosition:statusLPosition name:name statusIsCurStatus:statusIsCurStatus];
    }else{
        CGPoint dotPosition, statusLPosition;
        if (index == 0) {
            dotPosition = CGPointMake(_dotStartX, _dotY);
            statusLPosition = CGPointMake(_contentPadding, _statusLY);
        }else{
            CGFloat lineWidth = _statusWidth - _dotWidth - 2* _dotPadding;
            CGPoint linePosition = CGPointMake([(UIView *)_dotList.lastObject right] + _dotPadding, _lineY);
            UIView *lineV = [self p_addLineViewToPosition:linePosition width:lineWidth];

            dotPosition = CGPointMake(lineV.right+ _dotPadding, _dotY);
            statusLPosition = CGPointMake(dotPosition.x + _dotWidth/ 2 - _statusLWidth/2, _statusLY);
        }
        [self p_addDotViewToPosition:dotPosition statusIsCurStatus:statusIsCurStatus];
        [self p_addStatusLToPosition:statusLPosition name:name statusIsCurStatus:statusIsCurStatus];
    }
}

- (UIView *)p_addLineViewToPosition:(CGPoint)position width:(CGFloat)width{
    UIView *lineV = ({
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(position.x, position.y, width, _lineHeight)];
        view.backgroundColor = [UIColor colorWithHexString:@"0xCCCCCC"];
        view;
    });
    [self addSubview:lineV];
    [_lineList addObject:lineV];
    return lineV;
}

- (UIView *)p_addDotViewToPosition:(CGPoint)position statusIsCurStatus:(BOOL)statusIsCurStatus{
    UIView *dotV = ({
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(position.x, position.y, _dotWidth, _dotWidth)];
        view.backgroundColor = [UIColor colorWithHexString:statusIsCurStatus? @"0x68C20D": @"0x808080"];
        view.cornerRadius = _dotWidth/2;
        view;
    });
    [self addSubview:dotV];
    [_dotList addObject:dotV];
    return dotV;
}

- (UIView *)p_addStatusLToPosition:(CGPoint)position name:(NSString *)name statusIsCurStatus:(BOOL)statusIsCurStatus{
    UILabel *statusL = ({
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(position.x, position.y, _statusLWidth, 20)];
        label.font = [UIFont systemFontOfSize:13];
        label.textColor = [UIColor colorWithHexString:statusIsCurStatus? @"0x68C20D": @"0x808080"];
        label.text = name;
        label;
    });
    [self addSubview:statusL];
    [_statusLList addObject:statusL];
    return statusL;
}

- (UIView *)p_addStageVToIndexX:(NSInteger)indexX indexY:(NSInteger)indexY stage:(RewardMetroRoleStage *)stage roleColor:(UIColor *)roleColor{
    CGPoint stageVPosition = CGPointMake(_stagePadding + indexX* (_stageWidth + _stagePadding),
                                          _stagePadding + indexY* (_stageHeight + _stagePadding));
    UIView *stageV = [[UIView alloc] initWithFrame:CGRectMake(stageVPosition.x, stageVPosition.y, _stageWidth, _stageHeight)];
    BOOL stageDone = stage.status.integerValue >= 3;
    stageV.backgroundColor = stageDone? roleColor: [UIColor colorWithHexString:@"0xCCCCCC"];
    stageV.cornerRadius = 2;
    
    UILabel *stageL = ({
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, _stageWidth, 15)];
        label.font = [UIFont boldSystemFontOfSize:10];
        label.textColor = [UIColor whiteColor];
        label.textAlignment = NSTextAlignmentCenter;
        label.text = stage.stage_no;
        label;
    });
    [stageV addSubview:stageL];
    
    UIView *dotV = ({
        CGFloat dotWidth = 3.0;
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake((_stageWidth - dotWidth)/2, (_stageHeight - dotWidth - 3), dotWidth, dotWidth)];
        view.backgroundColor = [UIColor colorWithHexString:stageDone? @"0xCCCCCC": @"0xFFFFFF"];
        view.cornerRadius = dotWidth/2;
        view;
    });
    [stageV addSubview:dotV];
    
    [_stageBGView addSubview:stageV];
    return stageV;
}


+ (CGFloat)heightWithObj:(id)obj{
    CGFloat height = 0;
    if ([obj isKindOfClass:[RewardPrivate class]]) {
        RewardPrivate *curRewardP = obj;
        CGFloat roleCount = curRewardP.basicInfo.status.integerValue == RewardStatusDeveloping? curRewardP.metro.roles.count: 1;
        height = roleCount * kRewardMetroViewStageHeight + (roleCount+ 1) *kRewardMetroViewStagePadding + 2* 20;
        height = MAX(height, 90);
    }
    return height;
}
@end
