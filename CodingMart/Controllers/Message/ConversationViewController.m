//
//  ConversationViewController.m
//  CodingMart
//
//  Created by Ease on 2017/3/15.
//  Copyright © 2017年 net.coding. All rights reserved.
//

#import "ConversationViewController.h"
#import "QBImagePickerController.h"
#import "ConversationContactsViewController.h"
#import "UIMessageInputView.h"
#import "MessageCell.h"
#import "Helper.h"

@interface ConversationViewController ()<UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate, UITextViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, QBImagePickerControllerDelegate, UIMessageInputViewDelegate>
@property (nonatomic, strong) UITableView *myTableView;
@property (nonatomic, strong) UIMessageInputView *myMsgInputView;
@property (nonatomic, assign) CGFloat preContentHeight;

@end

@implementation ConversationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = _eaConversation.nick;
    //    添加myTableView
    _myTableView = ({
        UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        tableView.backgroundColor = [UIColor clearColor];
        tableView.dataSource = self;
        tableView.delegate = self;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [tableView registerClass:[MessageCell class] forCellReuseIdentifier:kCellIdentifier_Message];
        [tableView registerClass:[MessageCell class] forCellReuseIdentifier:kCellIdentifier_MessageMedia];
        [self.view addSubview:tableView];
        [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
        tableView;
    });
    
    _myMsgInputView = [UIMessageInputView messageInputViewWithType:UIMessageInputViewContentTypePriMsg placeHolder:@"请输入私信内容"];
    _myMsgInputView.isAlwaysShow = YES;
    _myMsgInputView.delegate = self;
    
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0, 0, CGRectGetHeight(_myMsgInputView.frame), 0);
    self.myTableView.contentInset = contentInsets;
    self.myTableView.scrollIndicatorInsets = contentInsets;
    
    _myMsgInputView.toUser = _eaConversation.contact.toUser;
    [self refreshLoadMore:NO];
    
    if (_eaConversation.isTribe) {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav_icon_more"] style:UIBarButtonItemStylePlain target:self action:@selector(navBtnClicked)];
    }
}


- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    if (_myMsgInputView) {
        [_myMsgInputView prepareToDismiss];
    }
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    //    键盘
    if (_myMsgInputView) {
        [_myMsgInputView prepareToShow];
    }
    [self.myTableView reloadData];
}

- (void)navBtnClicked{
    ConversationContactsViewController *vc = [ConversationContactsViewController vcInStoryboard:@"Message"];
    vc.eaConversation = _eaConversation;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark Blank & Error Page

- (void)dataChangedWithError:(BOOL)hasError scrollToBottom:(BOOL)scrollToBottom animated:(BOOL)animated{
    [self.myTableView reloadData];
    if (scrollToBottom) {
        [self scrollToBottomAnimated:animated];
    }
    [self configBlankPageHasError:hasError hasData:(self.eaConversation.dataList.count > 0)];
}

- (void)configBlankPageHasError:(BOOL)hasError hasData:(BOOL)hasData{
    __weak typeof(self) weakSelf = self;
    if (hasData) {
        [self.myTableView removeBlankPageView];
    }else if (hasError){
        [self.myTableView configBlankPageErrorBlock:^(id sender) {
            [weakSelf refreshLoadMore:NO];
        }];
    }else{
        [self.myTableView configBlankPageImage:kBlankPageImageMessage tipStr:@"这里还没有消息"];
    }
}

//- (void)refreshUserInfo{
//    __weak typeof(self) weakSelf = self;
//    [[Coding_NetAPIManager sharedManager] request_UserInfo_WithObj:self.eaConversation.curFriend andBlock:^(id data, NSError *error) {
//        if (data) {
//            weakSelf.eaConversation.curFriend = data;
//            weakSelf.myMsgInputView.toUser = weakSelf.eaConversation.curFriend;
//            weakSelf.title = weakSelf.eaConversation.curFriend.name;
//        }
//    }];
//}

#pragma mark onNewMessage
- (void)onNewMessage:(NSArray<TIMMessage *> *)msgs{
    NSString *curReceiver = _eaConversation.timCon.getReceiver;
    NSMutableArray *msgsOfCurConversation = @[].mutableCopy;
    for (TIMMessage *msg in msgs) {
        NSString *uid = msg.getConversation.getReceiver;
        if ([uid isEqualToString:curReceiver]) {
            [msgsOfCurConversation addObject:msg];
        }
    }
    if (msgsOfCurConversation.count > 0) {
        [self.eaConversation configWithPushList:msgsOfCurConversation];
        [self dataChangedWithError:NO scrollToBottom:YES animated:YES];
    }
}

#pragma mark UIMessageInputViewDelegate
- (void)messageInputView:(UIMessageInputView *)inputView sendText:(NSString *)text{
    [self sendEAChatMessage:text];
}

- (void)messageInputView:(UIMessageInputView *)inputView sendBigEmotion:(NSString *)emotionName{
    [self sendEAChatMessage:emotionName];
}

- (void)messageInputView:(UIMessageInputView *)inputView addIndexClicked:(NSInteger)index{
    [self inputViewAddIndex:index];
}

- (void)messageInputView:(UIMessageInputView *)inputView heightToBottomChenged:(CGFloat)heightToBottom{
    UIEdgeInsets contentInsets = UIEdgeInsetsMake([self navBottomY], 0, MAX(CGRectGetHeight(inputView.frame), heightToBottom), 0);
    self.myTableView.contentInset = contentInsets;
    self.myTableView.scrollIndicatorInsets = contentInsets;
    //调整内容
    static BOOL keyboard_is_down = YES;
    static CGPoint keyboard_down_ContentOffset;
    static CGFloat keyboard_down_InputViewHeight;
    if (heightToBottom > CGRectGetHeight(inputView.frame)) {
        if (keyboard_is_down) {
            keyboard_down_ContentOffset = self.myTableView.contentOffset;
            keyboard_down_InputViewHeight = CGRectGetHeight(inputView.frame);
        }
        keyboard_is_down = NO;
        
        CGPoint contentOffset = keyboard_down_ContentOffset;
        CGFloat spaceHeight = MAX(0, CGRectGetHeight(self.myTableView.frame) - self.myTableView.contentSize.height - keyboard_down_InputViewHeight);
        contentOffset.y += MAX(0, heightToBottom - keyboard_down_InputViewHeight - spaceHeight);
        NSLog(@"\nspaceHeight:%.2f heightToBottom:%.2f diff:%.2f Y:%.2f", spaceHeight, heightToBottom, MAX(0, heightToBottom - CGRectGetHeight(inputView.frame) - spaceHeight), contentOffset.y);
        self.myTableView.contentOffset = contentOffset;
    }else{
        keyboard_is_down = YES;
    }
}

#pragma mark refresh
- (void)refreshLoadMore:(BOOL)willLoadMore{
    if (!_eaConversation ||
        _eaConversation.isLoading ||
        (willLoadMore && !_eaConversation.canLoadMore)) {
        return;
    }
    _eaConversation.willLoadMore = willLoadMore;
    __weak typeof(self) weakSelf = self;
    [_eaConversation get_EAMessageListBlock:^(id data, NSString *errorMsg) {
        if (data) {
            [weakSelf.myTableView reloadData];
            if (!weakSelf.eaConversation.willLoadMore) {
                [weakSelf scrollToBottomAnimated:NO];
            }else{
                CGFloat curContentHeight = weakSelf.myTableView.contentSize.height;
                [weakSelf.myTableView setContentOffset:CGPointMake(0, (curContentHeight -_preContentHeight)+weakSelf.myTableView.contentOffset.y)];
            }
        }
        [weakSelf configBlankPageHasError:(errorMsg != nil) hasData:(weakSelf.eaConversation.dataList.count > 0)];
    }];
}

#pragma mark Table M

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _eaConversation.dataList.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MessageCell *cell;
    NSUInteger curIndex = ([_eaConversation.dataList count] -1) - indexPath.row;
    EAChatMessage *curMsg = [_eaConversation.dataList objectAtIndex:curIndex];
    if (curMsg.hasMedia) {
        cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier_MessageMedia forIndexPath:indexPath];
    }else{
        cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier_Message forIndexPath:indexPath];
    }
    EAChatMessage *preMsg = nil;
    if (curIndex +1 < _eaConversation.dataList.count) {
        preMsg = [_eaConversation.dataList objectAtIndex:curIndex+1];
    }
    cell.tapUserIconBlock = ^(User *sender){
//        UserInfoViewController *vc = [[UserInfoViewController alloc] init];
//        vc.curUser = sender;
//        [self.navigationController pushViewController:vc animated:YES];
    };
    __weak typeof(self) weakSelf = self;
    cell.resendMessageBlock = ^(EAChatMessage *curMessage){
        [weakSelf showAlertToResendMessage:curMessage];
    };
    [cell setCurPriMsg:curMsg andPrePriMsg:preMsg];
    cell.refreshMessageMediaCCellBlock = ^(CGFloat diff){
        if (ABS(diff) > 1) {
            [weakSelf.myTableView reloadData];
        }
    };
    NSMutableArray *menuItemArray = [[NSMutableArray alloc] init];
    BOOL hasTaxtToCopy = (curMsg.content && ![curMsg.content isEmpty]);
    if (hasTaxtToCopy) {
        [menuItemArray addObject:curMsg.hasMedia? @"拷贝文字": @"拷贝"];
    }
//    BOOL canDelete = (curMsg.sendStatus != EAChatMessageStatusSending);
//    if (canDelete) {
//        [menuItemArray addObject:@"删除"];
//    }
    
    [cell.bgImgView addLongPressMenu:menuItemArray clickBlock:^(NSInteger index, NSString *title) {
        if ([title hasPrefix:@"拷贝"]) {
            [[UIPasteboard generalPasteboard] setString:curMsg.content];
        }else if ([title isEqualToString:@"删除"]){
            [weakSelf showAlertToDeleteMessage:curMsg];
        }
    }];
    
    return cell;
}

- (void)showAlertToDeleteMessage:(EAChatMessage *)toDeleteMsg{
    __weak typeof(self) weakSelf = self;
    [self.myMsgInputView isAndResignFirstResponder];
    UIActionSheet *actionSheet = [UIActionSheet bk_actionSheetCustomWithTitle:@"删除后将不会出现在你的私信记录中" buttonTitles:nil destructiveTitle:@"确认删除" cancelTitle:@"取消" andDidDismissBlock:^(UIActionSheet *sheet, NSInteger index) {
        if (index == 0 && toDeleteMsg) {
            [weakSelf deleteEAChatMessageWithMsg:toDeleteMsg];
        }
    }];
    [actionSheet showInView:self.view];
}

- (void)showAlertToResendMessage:(EAChatMessage *)toResendMsg{
    __weak typeof(self) weakSelf = self;
    [self.myMsgInputView isAndResignFirstResponder];
    UIActionSheet *actionSheet = [UIActionSheet bk_actionSheetCustomWithTitle:@"重新发送" buttonTitles:@[@"发送"] destructiveTitle:nil cancelTitle:@"取消" andDidDismissBlock:^(UIActionSheet *sheet, NSInteger index) {
        if (index == 0 && toResendMsg) {
            [weakSelf sendEAChatMessageWithMsg:toResendMsg];
            
        }
    }];
    [actionSheet showInView:self.view];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    EAChatMessage *preMessage = nil;
    NSUInteger curIndex = ([_eaConversation.dataList count] -1) - indexPath.row;
    if (curIndex +1 < _eaConversation.dataList.count) {
        preMessage = [_eaConversation.dataList objectAtIndex:curIndex+1];
    }
    return [MessageCell cellHeightWithObj:[_eaConversation.dataList objectAtIndex:curIndex] preObj:preMessage];
}

- (void)scrollToBottomAnimated:(BOOL)animated
{
    NSInteger rows = [self.myTableView numberOfRowsInSection:0];
    if(rows > 0) {
        [self.myTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:rows - 1 inSection:0]
                                atScrollPosition:UITableViewScrollPositionBottom
                                        animated:animated];
    }
}

#pragma mark UIMessageInputView M

- (void)sendEAChatMessage:(id)obj{
    EAChatMessage *nextMsg = [EAChatMessage eaMessageWithObj:obj];
    [self sendEAChatMessageWithMsg:nextMsg];
}

- (void)sendEAChatMessageWithMsg:(EAChatMessage *)nextMsg{
    __weak typeof(self) weakSelf = self;
    [_eaConversation post_SendMessage:nextMsg andBlock:^(id data, NSString *errorMsg) {
        [weakSelf dataChangedWithError:NO scrollToBottom:YES animated:YES];
    }];
    [self dataChangedWithError:NO scrollToBottom:YES animated:YES];
}
- (void)deleteEAChatMessageWithMsg:(EAChatMessage *)curMsg{
//    __weak typeof(self) weakSelf = self;
//    if (curMsg.sendStatus == EAChatMessageStatusSendFail) {
//        [_eaConversation deleteMessage:curMsg];
//        [self dataChangedWithError:NO scrollToBottom:NO animated:NO];
//    }else if (curMsg.sendStatus == EAChatMessageStatusSendSucess) {
//        [[Coding_NetAPIManager sharedManager] request_DeleteEAChatMessage:curMsg andBlock:^(id data, NSError *error) {
//            [weakSelf.eaConversation deleteMessage:curMsg];
//            [self dataChangedWithError:NO scrollToBottom:NO animated:NO];
//        }];
//    }
}
- (void)inputViewAddIndex:(NSInteger)index{
    switch (index) {
        case 0:
        {//        相册
            if (![Helper checkPhotoLibraryAuthorizationStatus]) {
                return;
            }
            QBImagePickerController *imagePickerController = [[QBImagePickerController alloc] init];
            imagePickerController.filterType = QBImagePickerControllerFilterTypePhotos;
            imagePickerController.delegate = self;
            imagePickerController.allowsMultipleSelection = YES;
            imagePickerController.maximumNumberOfSelection = 6;
            UINavigationController *navigationController = [[EABaseNavigationController alloc] initWithRootViewController:imagePickerController];
            [self presentViewController:navigationController animated:YES completion:NULL];
        }
            break;
        case 1:
        {//        拍照
            if (![Helper checkCameraAuthorizationStatus]) {
                return;
            }
            UIImagePickerController *picker = [[UIImagePickerController alloc] init];
            picker.delegate = self;
            picker.allowsEditing = NO;//设置不可编辑
            picker.sourceType = UIImagePickerControllerSourceTypeCamera;
            [self presentViewController:picker animated:YES completion:nil];//进入照相界面
        }
            break;
        default:
            break;
    }
}

#pragma mark UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    UIImage *originalImage;
    originalImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    [self sendEAChatMessage:originalImage];
    
    // 保存原图片到相册中
    if (picker.sourceType == UIImagePickerControllerSourceTypeCamera) {
        UIImageWriteToSavedPhotosAlbum(originalImage, self, nil, NULL);
    }
    [picker dismissViewControllerAnimated:YES completion:nil];
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark QBImagePickerControllerDelegate
- (void)qb_imagePickerController:(QBImagePickerController *)imagePickerController didSelectAssets:(NSArray *)assets{
    for (ALAsset *assetItem in assets) {
        __weak typeof(self) weakSelf = self;
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            UIImage *highQualityImage = [UIImage fullScreenImageALAsset:assetItem];
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf sendEAChatMessage:highQualityImage];
            });
        });
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)qb_imagePickerControllerDidCancel:(QBImagePickerController *)imagePickerController{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark ScrollView Delegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    if (scrollView == _myTableView) {
        [_myMsgInputView isAndResignFirstResponder];
    }
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if (scrollView.contentSize.height >CGRectGetHeight(scrollView.bounds)
        && scrollView.contentOffset.y < 5) {
        _preContentHeight = self.myTableView.contentSize.height;
        [self refreshLoadMore:YES];
    }
}

@end
