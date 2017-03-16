//
//  UIMessageInputView.m
//  Coding_iOS
//
//  Created by 王 原闯 on 14-9-11.
//  Copyright (c) 2014年 Coding. All rights reserved.
//

#define kKeyboardView_Height 216.0
#define kMessageInputView_Height 50.0
#define kMessageInputView_HeightMax 120.0
#define kMessageInputView_PadingHeight 7.0
#define kMessageInputView_Width_Tool 35.0
#define kMessageInputView_MediaPadding 1.0

#import "UIMessageInputView.h"
#import "UIPlaceHolderTextView.h"
#import "UIMessageInputView_Add.h"
#import <ReactiveCocoa/ReactiveCocoa.h>

//at某人的功能
//#import "UsersViewController.h"
//#import "ProjectMemberListViewController.h"
//#import "Users.h"
#import "Login.h"

#import "QBImagePickerController.h"
#import "FunctionTipsManager.h"

static NSMutableDictionary *_inputStrDict;


@interface UIMessageInputView () <AGEmojiKeyboardViewDelegate, AGEmojiKeyboardViewDataSource>


@property (strong, nonatomic) AGEmojiKeyboardView *emojiKeyboardView;

@property (strong, nonatomic) UIMessageInputView_Add *addKeyboardView;

@property (strong, nonatomic) UIScrollView *contentView;
@property (strong, nonatomic) UIPlaceHolderTextView *inputTextView;

@property (strong, nonatomic) UIButton *addButton, *emotionButton, *photoButton;

@property (assign, nonatomic) CGFloat viewHeightOld;

@property (assign, nonatomic) UIMessageInputViewState inputState;
@end

@implementation UIMessageInputView


- (void)setFrame:(CGRect)frame{
    CGFloat oldheightToBottom = kScreen_Height - CGRectGetMinY(self.frame);
    CGFloat newheightToBottom = kScreen_Height - CGRectGetMinY(frame);
    [super setFrame:frame];
    if (fabs(oldheightToBottom - newheightToBottom) > 0.1) {
        DebugLog(@"heightToBottom-----:%.2f", newheightToBottom);
        if (oldheightToBottom > newheightToBottom) {//降下去的时候保存
            [self saveInputStr];
        }
        if (_delegate && [_delegate respondsToSelector:@selector(messageInputView:heightToBottomChenged:)]) {
            [self.delegate messageInputView:self heightToBottomChenged:newheightToBottom];
        }
    }
}

- (void)setInputState:(UIMessageInputViewState)inputState{
    if (_inputState != inputState) {
        _inputState = inputState;
        switch (_inputState) {
            case UIMessageInputViewStateSystem:
            {
                [self.addButton setImage:[UIImage imageNamed:@"keyboard_add"] forState:UIControlStateNormal];
                [self.emotionButton setImage:[UIImage imageNamed:@"keyboard_emotion"] forState:UIControlStateNormal];
            }
                break;
            case UIMessageInputViewStateEmotion:
            {
                [self.addButton setImage:[UIImage imageNamed:@"keyboard_add"] forState:UIControlStateNormal];
                [self.emotionButton setImage:[UIImage imageNamed:@"keyboard_keyboard"] forState:UIControlStateNormal];
            }
                break;
            case UIMessageInputViewStateAdd:
            {
                [self.addButton setImage:[UIImage imageNamed:@"keyboard_keyboard"] forState:UIControlStateNormal];
                [self.emotionButton setImage:[UIImage imageNamed:@"keyboard_emotion"] forState:UIControlStateNormal];
            }
                break;
            default:
                break;
        }
        [self updateContentViewBecauseOfMedia:NO];
    }
}
- (void)setPlaceHolder:(NSString *)placeHolder{
    _placeHolder = placeHolder;
    if (_inputTextView && ![_inputTextView.placeholder isEqualToString:placeHolder]) {
        _inputTextView.placeholder = placeHolder;
    }
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = kColorBGLight;
        [self addLineUp:YES andDown:NO andColor:kColorTextLightCC];
        _viewHeightOld = CGRectGetHeight(frame);
        _inputState = UIMessageInputViewStateSystem;
        _isAlwaysShow = NO;
        UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(didPan:)];
        [self addGestureRecognizer:panGesture];
    }
    return self;
}
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didPan:(UIPanGestureRecognizer *)panGesture
{
    if (panGesture.state == UIGestureRecognizerStateChanged) {
        CGFloat verticalDiff = [panGesture translationInView:self].y;
        if (verticalDiff > 60) {
            [self isAndResignFirstResponder];
        }
    }
}

#pragma mark remember input

- (NSMutableDictionary *)shareInputStrDict{
    if (!_inputStrDict) {
        _inputStrDict = [[NSMutableDictionary alloc] init];
    }
    return _inputStrDict;
}

- (NSString *)inputKey{
    NSString *inputKey = nil;
    if (_contentType == UIMessageInputViewContentTypePriMsg) {
        inputKey = [NSString stringWithFormat:@"privateMessage_%@", self.toUser.global_key];
    }
    return inputKey;
}

- (NSString *)inputStr{
    NSString *inputKey = [self inputKey];
    if (inputKey) {
        return [[self shareInputStrDict] objectForKey:inputKey];
    }
    return nil;
}

- (void)deleteInputData{
    NSString *inputKey = [self inputKey];
    if (inputKey) {
        [[self shareInputStrDict] removeObjectForKey:inputKey];
    }
}

- (void)saveInputStr{
    NSString *inputStr = _inputTextView.text;
    NSString *inputKey = [self inputKey];
    if (inputKey && inputKey.length > 0) {
        if (inputStr && inputStr.length > 0) {
            [[self shareInputStrDict] setObject:inputStr forKey:inputKey];
        }else{
            [[self shareInputStrDict] removeObjectForKey:inputKey];
        }
    }
}

- (void)setToUser:(User *)toUser{
    _toUser = toUser;
    NSString *inputStr = [self inputStr];
    if (_inputTextView) {

        if (_contentType != UIMessageInputViewContentTypePriMsg) {
            _inputTextView.placeholder = _toUser? [NSString stringWithFormat:@"回复 %@", _toUser.name]: _placeHolder;
        }else{
            self.placeHolder = _placeHolder;
        }
        _inputTextView.selectedRange = NSMakeRange(0, _inputTextView.text.length);
        [_inputTextView insertText:inputStr? inputStr: @""];
    }
}

#pragma mark Public M
- (void)prepareToShow{
    if ([self superview] == kKeyWindow) {
        return;
    }
    [self setY:kScreen_Height];
    [kKeyWindow addSubview:self];
    [kKeyWindow addSubview:_emojiKeyboardView];
    [kKeyWindow addSubview:_addKeyboardView];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardChange:) name:UIKeyboardWillChangeFrameNotification object:nil];
    
    if (_isAlwaysShow && ![self isCustomFirstResponder]) {
        [UIView animateWithDuration:0.25 animations:^{
            [self setY:kScreen_Height - CGRectGetHeight(self.frame)];
        }];
    }
}
- (void)prepareToDismiss{
    if ([self superview] == nil) {
        return;
    }
    [self isAndResignFirstResponder];
    [UIView animateWithDuration:0.25 delay:0.0 options:UIViewAnimationOptionTransitionFlipFromBottom animations:^{
        [self setY:kScreen_Height];
    } completion:^(BOOL finished) {
        [_emojiKeyboardView removeFromSuperview];
        [_addKeyboardView removeFromSuperview];
        [self removeFromSuperview];
    }];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (BOOL)notAndBecomeFirstResponder{
    self.inputState = UIMessageInputViewStateSystem;
    if ([_inputTextView isFirstResponder]) {
        return NO;
    }else{
        [_inputTextView becomeFirstResponder];
        return YES;
    }
}
- (BOOL)isAndResignFirstResponder{
    if (self.inputState == UIMessageInputViewStateAdd || self.inputState == UIMessageInputViewStateEmotion) {
        [UIView animateWithDuration:0.25 delay:0.0f options:UIViewAnimationOptionTransitionFlipFromBottom animations:^{
            [_emojiKeyboardView setY:kScreen_Height];
            [_addKeyboardView setY:kScreen_Height];
            if (self.isAlwaysShow) {
                [self setY:kScreen_Height- CGRectGetHeight(self.frame)];
            }else{
                [self setY:kScreen_Height];
            }
        } completion:^(BOOL finished) {
            self.inputState = UIMessageInputViewStateSystem;
        }];
        return YES;
    }else{
        if ([_inputTextView isFirstResponder]) {
            [_inputTextView resignFirstResponder];
            return YES;
        }else{
            return NO;
        }
    }
}

- (BOOL)isCustomFirstResponder{
    return ([_inputTextView isFirstResponder] || self.inputState == UIMessageInputViewStateAdd || self.inputState == UIMessageInputViewStateEmotion);
}

+ (instancetype)messageInputViewWithType:(UIMessageInputViewContentType)type{
    return [self messageInputViewWithType:type placeHolder:nil];
}
+ (instancetype)messageInputViewWithType:(UIMessageInputViewContentType)type placeHolder:(NSString *)placeHolder{
    UIMessageInputView *messageInputView = [[UIMessageInputView alloc] initWithFrame:CGRectMake(0, kScreen_Height, kScreen_Width, kMessageInputView_Height)];
    [messageInputView customUIWithType:type];
    if (placeHolder) {
        messageInputView.placeHolder = placeHolder;
    }else{
        messageInputView.placeHolder = @"撰写评论";
    }
    return messageInputView;
}

- (void)customUIWithType:(UIMessageInputViewContentType)type{
    _contentType = type;
    CGFloat contentViewHeight = kMessageInputView_Height -2*kMessageInputView_PadingHeight;
    
    NSInteger toolBtnNum;
    BOOL hasEmotionBtn, hasAddBtn;
    BOOL showBigEmotion;
    switch (_contentType) {
        case UIMessageInputViewContentTypePriMsg:
        {
            toolBtnNum = 2;
            hasEmotionBtn = YES;
            hasAddBtn = YES;
            showBigEmotion = NO;
        }
            break;
        default:
            toolBtnNum = 1;
            hasEmotionBtn = YES;
            hasAddBtn = NO;
            showBigEmotion = NO;
            break;
    }
    
    __weak typeof(self) weakSelf = self;
    if (!_contentView) {
        _contentView = [[UIScrollView alloc] init];
        _contentView.backgroundColor = [UIColor whiteColor];
        _contentView.layer.borderWidth = 0.5;
        _contentView.layer.borderColor = [UIColor lightGrayColor].CGColor;
        _contentView.layer.cornerRadius = contentViewHeight/2;
        _contentView.layer.masksToBounds = YES;
        _contentView.alwaysBounceVertical = YES;
        [self addSubview:_contentView];
        [_contentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self).insets(UIEdgeInsetsMake(kMessageInputView_PadingHeight, kPaddingLeftWidth, kMessageInputView_PadingHeight, kPaddingLeftWidth + toolBtnNum *kMessageInputView_Width_Tool));
        }];
    }
    
    if (!_inputTextView) {
        _inputTextView = [[UIPlaceHolderTextView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width - kPaddingLeftWidth - toolBtnNum *kMessageInputView_Width_Tool - kPaddingLeftWidth, contentViewHeight)];
        _inputTextView.font = [UIFont systemFontOfSize:16];
        _inputTextView.returnKeyType = UIReturnKeySend;
        _inputTextView.scrollsToTop = NO;
        _inputTextView.delegate = self;
        
        //输入框缩进
        UIEdgeInsets insets = _inputTextView.textContainerInset;
        insets.left += 8.0;
        insets.right += 8.0;
        _inputTextView.textContainerInset = insets;
        
        [self.contentView addSubview:_inputTextView];
    }
    
    if (hasEmotionBtn && !_emotionButton) {
        _emotionButton = [[UIButton alloc] initWithFrame:CGRectMake(kScreen_Width - kPaddingLeftWidth/2 - toolBtnNum * kMessageInputView_Width_Tool, (kMessageInputView_Height - kMessageInputView_Width_Tool)/2, kMessageInputView_Width_Tool, kMessageInputView_Width_Tool)];
        [_emotionButton setImage:[UIImage imageNamed:@"keyboard_emotion"] forState:UIControlStateNormal];
        [_emotionButton addTarget:self action:@selector(emotionButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_emotionButton];
    }
    _emotionButton.hidden = !hasEmotionBtn;
    
    if (hasAddBtn && !_addButton) {
        _addButton = [[UIButton alloc] initWithFrame:CGRectMake(kScreen_Width - kPaddingLeftWidth/2 -kMessageInputView_Width_Tool, (kMessageInputView_Height - kMessageInputView_Width_Tool)/2, kMessageInputView_Width_Tool, kMessageInputView_Width_Tool)];
        
        [_addButton setImage:[UIImage imageNamed:@"keyboard_add"] forState:UIControlStateNormal];
        [_addButton addTarget:self action:@selector(addButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_addButton];
    }
    _addButton.hidden = !hasAddBtn;
    
    if (hasEmotionBtn && !_emojiKeyboardView) {
        _emojiKeyboardView = [[AGEmojiKeyboardView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, kKeyboardView_Height) dataSource:self showBigEmotion:showBigEmotion];
        _emojiKeyboardView.delegate = self;
        [_emojiKeyboardView setY:kScreen_Height];
    }
    
    if (hasAddBtn && !_addKeyboardView) {
        _addKeyboardView = [[UIMessageInputView_Add alloc] initWithFrame:CGRectMake(0, kScreen_Height, kScreen_Width, kKeyboardView_Height)];
        _addKeyboardView.addIndexBlock = ^(NSInteger index){
            if ([weakSelf.delegate respondsToSelector:@selector(messageInputView:addIndexClicked:)]) {
                [weakSelf.delegate messageInputView:weakSelf addIndexClicked:index];
            }
        };
    }

    if (_inputTextView) {
        [[RACObserve(self.inputTextView, contentSize) takeUntil:self.rac_willDeallocSignal] subscribeNext:^(NSValue *contentSize) {
            [weakSelf updateContentViewBecauseOfMedia:NO];
        }];
    }
}

- (void)updateContentViewBecauseOfMedia:(BOOL)becauseOfMedia{
    
    CGSize textSize = _inputTextView.contentSize, mediaSize = CGSizeZero;
    if (!becauseOfMedia) {
        if (ABS(CGRectGetHeight(_inputTextView.frame) - textSize.height) > 0.5) {
            [_inputTextView setHeight:textSize.height];
        }
    }
    if (_contentView.hidden) {
        textSize.height = kMessageInputView_Height - 2*kMessageInputView_PadingHeight;
    }
    CGSize contentSize = CGSizeMake(textSize.width, textSize.height + mediaSize.height);
    CGFloat selfHeight = MAX(kMessageInputView_Height, contentSize.height + 2*kMessageInputView_PadingHeight);
    
    CGFloat maxSelfHeight = kScreen_Height/2;
    if (kDevice_Is_iPhone5){
        maxSelfHeight = 230;
    }else if (kDevice_Is_iPhone6) {
        maxSelfHeight = 290;
    }else if (kDevice_Is_iPhone6Plus){
        maxSelfHeight = kScreen_Height/2;
    }else{
        maxSelfHeight = 140;
    }
    
    selfHeight = MIN(maxSelfHeight, selfHeight);
    CGFloat diffHeight = selfHeight - _viewHeightOld;
    if (ABS(diffHeight) > 0.5) {
        CGRect selfFrame = self.frame;
        selfFrame.size.height += diffHeight;
        selfFrame.origin.y -= diffHeight;
        [self setFrame:selfFrame];
        self.viewHeightOld = selfHeight;
    }
    [self.contentView setContentSize:contentSize];
    
    CGFloat bottomY = becauseOfMedia? contentSize.height: textSize.height;
    CGFloat offsetY = MAX(0, bottomY - (CGRectGetHeight(self.frame)- 2* kMessageInputView_PadingHeight));
    [self.contentView setContentOffset:CGPointMake(0, offsetY) animated:YES];
}

#pragma mark addButton M
- (void)addButtonClicked:(id)sender{
    CGFloat endY = kScreen_Height;
    if (self.inputState == UIMessageInputViewStateAdd) {
        self.inputState = UIMessageInputViewStateSystem;
        [_inputTextView becomeFirstResponder];
    }else{
        self.inputState = UIMessageInputViewStateAdd;
        [_inputTextView resignFirstResponder];
        endY = kScreen_Height - kKeyboardView_Height;
    }
    [UIView animateWithDuration:0.25 delay:0.0f options:UIViewAnimationOptionTransitionFlipFromBottom animations:^{
        [_addKeyboardView setY:endY];
        [_emojiKeyboardView setY:kScreen_Height];
        if (ABS(kScreen_Height - endY) > 0.1) {
            [self setY:endY- CGRectGetHeight(self.frame)];
        }
    } completion:^(BOOL finished) {
    }];
}
- (void)emotionButtonClicked:(id)sender{
    CGFloat endY = kScreen_Height;
    if (self.inputState == UIMessageInputViewStateEmotion) {
        self.inputState = UIMessageInputViewStateSystem;
        [_inputTextView becomeFirstResponder];
    }else{
        self.inputState = UIMessageInputViewStateEmotion;
        [_inputTextView resignFirstResponder];
        endY = kScreen_Height - kKeyboardView_Height;
    }
    [UIView animateWithDuration:0.25 delay:0.0f options:UIViewAnimationOptionTransitionFlipFromBottom animations:^{
        [_emojiKeyboardView setY:endY];
        [_addKeyboardView setY:kScreen_Height];
        if (ABS(kScreen_Height - endY) > 0.1) {
            [self setY:endY- CGRectGetHeight(self.frame)];
        }
    } completion:^(BOOL finished) {
    }];
}

#pragma mark UITextViewDelegate M
- (void)sendTextStr{
    [self deleteInputData];
    NSMutableString *sendStr = [NSMutableString stringWithString:self.inputTextView.text];
    if (sendStr && ![sendStr isEmpty] && _delegate && [_delegate respondsToSelector:@selector(messageInputView:sendText:)]) {
        [self.delegate messageInputView:self sendText:sendStr];
    }
    _inputTextView.selectedRange = NSMakeRange(0, _inputTextView.text.length);
    [_inputTextView insertText:@""];
    [self updateContentViewBecauseOfMedia:NO];
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@"\n"]) {
        if (![self.inputTextView.text hasListenChar]) {
            [self sendTextStr];
        }
        return NO;
    }
//    @某人，先留着
//    else if ([text isEqualToString:@"@"]){
//        __weak typeof(self) weakSelf = self;
//        if (self.curProject) {
//            //@项目成员
//            [ProjectMemberListViewController showATSomeoneWithBlock:^(User *curUser) {
//                [weakSelf atSomeUser:curUser inTextView:textView andRange:range];
//            } withProject:self.curProject];
//        }else{
//            //@好友
//            [UsersViewController showATSomeoneWithBlock:^(User *curUser) {
//                [weakSelf atSomeUser:curUser inTextView:textView andRange:range];
//            }];
//        }
//        return NO;
//    }
    return YES;
}
- (void)atSomeUser:(User *)curUser inTextView:(UITextView *)textView andRange:(NSRange)range{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardChange:) name:UIKeyboardDidChangeFrameNotification object:nil];//英文键盘，重新弹出键盘时，没有WillChange的通知
    NSString *appendingStr;
    if (curUser) {
        appendingStr = [NSString stringWithFormat:@"@%@ ", curUser.name];
    }else{
        appendingStr = @"@";
    }
    [textView setSelectedRange:range];
    [textView insertText:appendingStr];
}
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    if (self.inputState != UIMessageInputViewStateSystem) {
        self.inputState = UIMessageInputViewStateSystem;
        [UIView animateWithDuration:0.25 delay:0.0f options:UIViewAnimationOptionTransitionFlipFromBottom animations:^{
            [_emojiKeyboardView setY:kScreen_Height];
            [_addKeyboardView setY:kScreen_Height];

        } completion:^(BOOL finished) {
            self.inputState = UIMessageInputViewStateSystem;
        }];
    }
    return YES;
}
- (BOOL)textViewShouldEndEditing:(UITextView *)textView{
    if (self.inputState == UIMessageInputViewStateSystem) {
        [UIView animateWithDuration:0.25 delay:0.0f options:UIViewAnimationOptionTransitionFlipFromBottom animations:^{
            if (_isAlwaysShow) {
                [self setY:kScreen_Height- CGRectGetHeight(self.frame)];
            }else{
                [self setY:kScreen_Height];
            }
        } completion:^(BOOL finished) {
        }];
    }
    return YES;
}
#pragma mark - KeyBoard Notification Handlers
- (void)keyboardChange:(NSNotification*)aNotification{
    if ([aNotification name] == UIKeyboardDidChangeFrameNotification) {
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidChangeFrameNotification object:nil];
    }
    if (self.inputState == UIMessageInputViewStateSystem && [self.inputTextView isFirstResponder]) {
        NSDictionary* userInfo = [aNotification userInfo];
        CGRect keyboardEndFrame = [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
        CGFloat keyboardY =  keyboardEndFrame.origin.y;

        CGFloat selfOriginY = keyboardY == kScreen_Height? self.isAlwaysShow? kScreen_Height - CGRectGetHeight(self.frame): kScreen_Height : keyboardY - CGRectGetHeight(self.frame);
        if (selfOriginY == self.frame.origin.y) {
            return;
        }
        __weak typeof(self) weakSelf = self;
        void (^endFrameBlock)() = ^(){
            [weakSelf setY:selfOriginY];
        };
        if ([aNotification name] == UIKeyboardWillChangeFrameNotification) {
            NSTimeInterval animationDuration = [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
            UIViewAnimationCurve animationCurve = [[userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] intValue];
            [UIView animateWithDuration:animationDuration delay:0.0f options:[UIView animationOptionsForCurve:animationCurve] animations:^{
                endFrameBlock();
            } completion:nil];
        }else{
            endFrameBlock();
        }
    }
}

#pragma mark AGEmojiKeyboardView
- (void)emojiKeyBoardView:(AGEmojiKeyboardView *)emojiKeyBoardView didUseEmoji:(NSString *)emoji {
    NSString *emotion_monkey = [emoji emotionSpecailName];
    if (emotion_monkey) {
        if (_delegate && [_delegate respondsToSelector:@selector(messageInputView:sendBigEmotion:)]) {
            [self.delegate messageInputView:self sendBigEmotion:emotion_monkey];
        }
    }else{
        [self.inputTextView insertText:emoji];
    }
}

- (void)emojiKeyBoardViewDidPressBackSpace:(AGEmojiKeyboardView *)emojiKeyBoardView {
    [self.inputTextView deleteBackward];
}

- (void)emojiKeyBoardViewDidPressSendButton:(AGEmojiKeyboardView *)emojiKeyBoardView{
    [self sendTextStr];
}

- (UIImage *)emojiKeyboardView:(AGEmojiKeyboardView *)emojiKeyboardView imageForSelectedCategory:(AGEmojiKeyboardViewCategoryImage)category {
    UIImage *img = [UIImage imageNamed:(category == AGEmojiKeyboardViewCategoryImageEmoji? @"keyboard_emotion_emoji":
                                        category == AGEmojiKeyboardViewCategoryImageMonkey? @"keyboard_emotion_monkey":
                                        category == AGEmojiKeyboardViewCategoryImageMonkey_Gif? @"keyboard_emotion_monkey_gif":
                                        @"")] ?: [UIImage new];
    return img;
}

- (UIImage *)emojiKeyboardView:(AGEmojiKeyboardView *)emojiKeyboardView imageForNonSelectedCategory:(AGEmojiKeyboardViewCategoryImage)category {
    return [self emojiKeyboardView:emojiKeyboardView imageForSelectedCategory:category];
}

- (UIImage *)backSpaceButtonImageForEmojiKeyboardView:(AGEmojiKeyboardView *)emojiKeyboardView {
    UIImage *img = [UIImage imageNamed:@"keyboard_emotion_delete"];
    return img;
}

@end
