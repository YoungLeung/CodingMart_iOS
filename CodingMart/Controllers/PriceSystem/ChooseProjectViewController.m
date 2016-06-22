//
//  ChooseProjectViewController.m
//  
//
//  Created by Frank on 16/5/21.
//
//

#import "ChooseProjectViewController.h"
#import "ChoosePriceCollectionViewCell.h"
#import "NextStepCollectionViewCell.h"
#import "FunctionalEvaluationViewController.h"
#import "Coding_NetAPIManager.h"
#import "Reward.h"
#import "PublishRewardViewController.h"

@interface ChooseProjectViewController () <UIAlertViewDelegate>

@property (strong, nonatomic) NSArray *cellImageArray, *cellNameArray, *menuIDArray;
@property (strong, nonatomic) NextStepCollectionViewCell *cell;

@end

@implementation ChooseProjectViewController

static NSString * const reuseIdentifier = @"Cell";
static NSString * const nextStepReuseIdentifier = @"NextStepCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Register cell classes
    self.view.backgroundColor = kColorBGDark;
    self.collectionView.backgroundColor = kColorBGDark;
    
    _cellImageArray = @[@"price_icon_Web",
                        @"price_icon_Wechat",
                        @"price_icon_iOS_APP",
                        @"price_icon_Android _APP",
                        @"price_icon_HTML5",
                        @"price_icon_other",
                        ];
    
    _cellNameArray = @[@"Web 网站",
                        @"微信公众号",
                        @"iOS App",
                        @"Android App",
                        @"前端项目",
                        @"其他",
                        ];
    
    _menuIDArray = @[@"P001",
                     @"P004",
                     @"P002",
                     @"P003",
                     @"P005",
                     @"P006",
                     ];
    
    [self.collectionView registerClass:[NextStepCollectionViewCell class] forCellWithReuseIdentifier:nextStepReuseIdentifier];
    [self.collectionView setAllowsMultipleSelection:YES];

    // 加载菜单数据
    [[Coding_NetAPIManager sharedManager] get_quoteFunctions:^(id data, NSError *error) {
        if (!error) {
            [NSObject saveResponseData:data toPath:@"priceListData"];
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 2;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (section == 0) {
        return 6;
    }
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        ChoosePriceCollectionViewCell *cell = (ChoosePriceCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
        
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

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        float cellWidth = (kScreen_Width / 2)-0.5;
        float cellHeight = cellWidth * 0.85;
        if (kDevice_Is_iPhone5) cellHeight = cellWidth * 0.8;
        return CGSizeMake(cellWidth, cellHeight);
    } else {
        float cellWidth = kScreen_Width;
        float cellHeight = cellWidth/4;
        return CGSizeMake(cellWidth, cellHeight);
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    ChoosePriceCollectionViewCell *cell = (ChoosePriceCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    [cell setSelected:cell.selected];
    float count = collectionView.indexPathsForSelectedItems.count;
    if (indexPath.section == 1) {
        count--;
    }
    if (count > 0) {
            [_cell setButtonEnable:YES];
    } else {
        [_cell setButtonEnable:NO];
    }
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (collectionView.indexPathsForSelectedItems.count == 0) {
        [_cell setButtonEnable:NO];
    }
}

#pragma mark <UICollectionViewDelegate>

- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)nextStep {
    NSArray *array = [NSMutableArray arrayWithArray:self.collectionView.indexPathsForSelectedItems];
    NSMutableArray *selectedArray = [NSMutableArray array];
    NSMutableArray *selectedIDArray = [NSMutableArray array];
    if (array.count) {
        for (int i = 0; i < array.count; i++) {
            NSIndexPath *indexPath = [array objectAtIndex:i];
            NSString *name = [_cellNameArray objectAtIndex:indexPath.row];
            if (![selectedArray containsObject:name]) {
                [selectedArray addObject:name];
            }
            [selectedIDArray addObject:[_menuIDArray objectAtIndex:indexPath.row]];
        }
        if ([selectedArray containsObject:@"其他"]) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"选择「其它」类型，将直接进入「快捷发布悬赏」页面" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            [alert show];
        } else {
            [selectedIDArray addObject:@"P006"];
            [selectedArray addObject:@"管理后台"];
            FunctionalEvaluationViewController *vc = [[FunctionalEvaluationViewController alloc] init];
            vc.menuArray = _cellNameArray;
            vc.menuIDArray = selectedIDArray;
            vc.selectedMenuArray = selectedArray;
            vc.allIDArray = _menuIDArray;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
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

@end
