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

@interface ChooseProjectViewController ()

@property (nonatomic, strong) NSArray *cellImageArray, *cellNameArray;

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
    
    [self.collectionView registerClass:[NextStepCollectionViewCell class] forCellWithReuseIdentifier:nextStepReuseIdentifier];
    [self.collectionView setAllowsMultipleSelection:YES];
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
    FunctionalEvaluationViewController *vc = [[FunctionalEvaluationViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
