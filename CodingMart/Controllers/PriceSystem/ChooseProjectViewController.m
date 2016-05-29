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

@interface ChooseProjectViewController ()

@property (strong, nonatomic) NSArray *cellImageArray, *cellNameArray, *menuIDArray;

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
                        @"HTML5 应用",
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
    [self.collectionView selectItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:YES scrollPosition:UICollectionViewScrollPositionNone];
    
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
        NextStepCollectionViewCell *cell = (NextStepCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:nextStepReuseIdentifier forIndexPath:indexPath];
        cell.nextStepBlock = ^(){
            [weakSelf nextStep];
        };
        return cell;
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        float cellWidth = (kScreen_Width / 2)-0.5;
        float cellHeight = cellWidth * 0.85;
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
            [selectedArray addObject:[_cellNameArray objectAtIndex:indexPath.row]];
            [selectedIDArray addObject:[_menuIDArray objectAtIndex:indexPath.row]];
        }
        if ([selectedArray containsObject:@"其他"]) {
            
        } else {
            FunctionalEvaluationViewController *vc = [[FunctionalEvaluationViewController alloc] init];
            vc.menuArray = _cellNameArray;
            vc.menuIDArray = selectedIDArray;
            vc.selectedMenuArray = selectedArray;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
}

@end
