//
//  RootQuoteViewController.m
//  
//
//  Created by Frank on 16/5/21.
//
//

#import "RootQuoteViewController.h"
#import "ChoosePriceCollectionViewCell.h"
#import "NextStepCollectionViewCell.h"
#import "FunctionalEvaluationViewController.h"
#import "Coding_NetAPIManager.h"
#import "Reward.h"
#import "PublishRewardViewController.h"
#import "LoginViewController.h"
#import "Login.h"
#import "PriceListViewController.h"
#import "AppDelegate.h"

@interface RootQuoteViewController () <UIAlertViewDelegate>

@property (strong, nonatomic) NSArray *cellImageArray, *cellNameArray, *menuIDArray;
@property (strong, nonatomic) NextStepCollectionViewCell *cell;

@end

@implementation RootQuoteViewController

static NSString * const nextStepReuseIdentifier = @"NextStepCell";

+ (instancetype)storyboardVC{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Root" bundle:nil];
    return [storyboard instantiateViewControllerWithIdentifier:@"RootQuoteViewController"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = kColorBGDark;
    self.collectionView.backgroundColor = kColorBGDark;
    self.collectionView.contentInset = UIEdgeInsetsMake(15, 15, self.rdv_tabBarController.tabBar.height, 15);

    _cellImageArray = @[@"quote_icon_web",
                        @"quote_icon_wechat",
                        @"quote_icon_ios",
                        @"quote_icon_android",
                        @"quote_icon_front",
                        @"quote_icon_h5",
                        @"quote_icon_crawler",
                        ];
    _cellNameArray = @[@"Web 网站",
                       @"微信公众号",
                       @"iOS App",
                       @"Android App",
                       @"前端项目",
                       @"H5 游戏",
                       @"爬虫类",
                       ];
    _menuIDArray = @[@"P001",
                     @"P004",
                     @"P002",
                     @"P003",
                     @"P005",
//                     @"P006",//管理后台
                     @"P007",
                     @"P008",
                     ];
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithBtnTitle:@"我的报价" target:self action:@selector(myPriceList)];
    [self.collectionView registerClass:[NextStepCollectionViewCell class] forCellWithReuseIdentifier:nextStepReuseIdentifier];
    [self.collectionView setAllowsMultipleSelection:YES];
    // 加载菜单数据
    [[Coding_NetAPIManager sharedManager] get_quoteFunctions:^(id data, NSError *error) {
        if (!error) {
            [NSObject saveResponseData:data toPath:@"priceListData"];
        }
    }];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    //更新 tab 视图，放在这里
    if ([Login isLogin]) {
        if (![Login curLoginUser].isDemandSide) {
            [self changeTabVCList];
        }else {
            [(RootTabViewController *)self.rdv_tabBarController checkUpdateTabVCListWithSelectedIndex:1];
        }
    }
}

- (void)changeTabVCList{
    [NSObject showHUDQueryStr:@"正在切换视图..."];
    [[Coding_NetAPIManager sharedManager] post_LoginIdentity:@2 andBlock:^(id data, NSError *error) {
        [NSObject hideHUDQuery];
        if (data) {
            [UIViewController updateTabVCListWithSelectedIndex:1];
        }
    }];
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 2;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return section == 0? 7: 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        ChoosePriceCollectionViewCell *cell = (ChoosePriceCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:indexPath.row < 5? kCCellIdentifier_ChoosePriceCollectionViewCell_Big: kCCellIdentifier_ChoosePriceCollectionViewCell_Small forIndexPath:indexPath];
        NSInteger index = indexPath.row;
        [cell updateCellWithImageName:_cellImageArray[index] andName:_cellNameArray[index]];
        return cell;
    } else {
        __weak typeof(self)weakSelf = self;
        _cell = (NextStepCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:nextStepReuseIdentifier forIndexPath:indexPath];
        _cell.nextStepBlock = ^(){
            [weakSelf nextStep];
        };
        return _cell;
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section > 0) {
        [collectionView deselectItemAtIndexPath:indexPath animated:NO];
    }
    [_cell setButtonEnable:collectionView.indexPathsForSelectedItems.count > 0];
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    [_cell setButtonEnable:collectionView.indexPathsForSelectedItems.count > 0];
}

- (void)nextStep {
    NSArray *array = [NSMutableArray arrayWithArray:self.collectionView.indexPathsForSelectedItems];
    NSMutableArray *selectedArray = [NSMutableArray array];
    NSMutableArray *selectedIDArray = [NSMutableArray array];
    if (array.count > 0) {
        for (int i = 0; i < array.count; i++) {
            NSIndexPath *indexPath = [array objectAtIndex:i];
            NSString *name = [_cellNameArray objectAtIndex:indexPath.row];
            [selectedArray addObject:name];
            [selectedIDArray addObject:[_menuIDArray objectAtIndex:indexPath.row]];
        }
        if ([self p_needServerInList:selectedIDArray]) {
            [selectedIDArray addObject:@"P006"];
            [selectedArray addObject:@"管理后台"];
        }
        
        FunctionalEvaluationViewController *vc = [[FunctionalEvaluationViewController alloc] init];
        vc.menuArray = _cellNameArray;
        vc.menuIDArray = selectedIDArray;
        vc.selectedMenuArray = selectedArray;
        vc.allIDArray = _menuIDArray;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (BOOL)p_needServerInList:(NSArray *)idList{
    NSSet *idSet = [[NSSet alloc] initWithArray:idList];
    return ![idSet isSubsetOfSet:[NSSet setWithObjects:@"P007", @"P008", nil]];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        // 选择了其他
        // 跳转到发布
        Reward *reward = [Reward rewardToBePublished];
        reward.type = @4;
        PublishRewardViewController *vc = [PublishRewardViewController storyboardVCWithReward:reward];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)myPriceList {
    PriceListViewController *vc = [[PriceListViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

@end


@interface QuoteViewLayout ()
@property (strong, nonatomic) NSMutableArray *attrsArr;
@end

@implementation QuoteViewLayout
- (NSMutableArray *)attrsArr{
    return _attrsArr ?: (_attrsArr = @[].mutableCopy);
}

- (void)prepareLayout {
    [super prepareLayout];
    [self.attrsArr removeAllObjects];
    NSInteger sectionNum = [self.collectionView numberOfSections];
    for (int section = 0; section < sectionNum; section++) {
        NSInteger rowNum = [self.collectionView numberOfItemsInSection:section];
        for (int row = 0; row < rowNum; row++) {
            UICollectionViewLayoutAttributes *attrs = [self layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForRow:row inSection:section]];
            [self.attrsArr addObject:attrs];
        }
    }
}

- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect{
    return self.attrsArr;
}

-(CGSize)collectionViewContentSize{
    CGFloat contentWidth = kScreen_Width - 30;
    CGFloat contentHeight = [self p_BigCellHeight] * 3 + 10 * 2 + 15 + 55;
    return CGSizeMake(contentWidth, contentHeight);
}

-(UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewLayoutAttributes * attrs=[UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    if (indexPath.section == 0) {
        CGFloat cellWidth = [self p_BigCellWidth];
        CGFloat cellHeight = [self p_BigCellHeight];
        CGFloat cellX = (indexPath.row % 2 == 0 && indexPath.row < 6)? 0: cellWidth + 10;
        CGFloat cellY = (indexPath.row / 2) * (cellHeight + 10);
        if (indexPath.row > 4) {
            cellHeight = (cellHeight - 10)/ 2;
        }
        if (indexPath.row == 6) {
            cellY -= cellHeight + 10;
        }
        attrs.frame = CGRectMake(cellX, cellY, cellWidth, cellHeight);
    }else{
        CGFloat cellWidth = kScreen_Width;
        CGFloat cellHeight = 55;
        CGFloat cellX = -15;
        CGFloat cellY = [self p_BigCellHeight] * 3 + 10 * 2 + 15;
        attrs.frame = CGRectMake(cellX, cellY, cellWidth, cellHeight);
    }
    return attrs;
}

- (CGFloat)p_BigCellWidth{
    CGFloat cellWidth = (kScreen_Width - 15 * 2 - 10) / 2;
    return cellWidth;
}

- (CGFloat)p_BigCellHeight{
    CGFloat cellHeight = ((kDevice_Is_iPhone4? 568: kScreen_Height)//iPhone4 的时候，用 iPhone5 的高度排版
                          - 64//顶 - nav
                          - 50//底 - tab
                          - 60//底 - 按钮
//                          - 15//底 - 按钮 - 底部空余
                          - 15 * 2//顶部底部间距
                          - 10 * 2//行间距
                          )/ 3;
    return cellHeight;
}

@end
