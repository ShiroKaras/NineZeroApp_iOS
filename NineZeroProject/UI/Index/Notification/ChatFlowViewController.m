//
//  ChatFlowViewController.m
//  ChatFlow
//
//  Created by SinLemon on 2017/2/16.
//  Copyright © 2017年 ShiroKaras. All rights reserved.
//

#import "ChatFlowViewController.h"
#import "ChatFlowCell.h"
#import <Masonry.h>
#import "HTUIHeader.h"

@interface ChatFlowViewController () <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray<SKChatObject*> *dataArray;
@property (nonatomic, strong) UIView *inputView;
@property (nonatomic, strong) UITextField *inputTextField;
@end

@implementation ChatFlowViewController {
    int     page;
    int     totalPage;//总页数
    BOOL    isFirstCome; //第一次加载帖子时候不需要传入此关键字，当需要加载下一页时：需要传入加载上一页时返回值字段“maxtime”中的内容。
    BOOL    isJuhua;//是否正在下拉刷新或者上拉加载。default NO。
}

-(void)viewWillAppear:(BOOL)animated
{
//    [self.tableView.mj_header beginRefreshing];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    isFirstCome = YES;
}

- (void)viewDidLoad {
    page = 1;
    isFirstCome = YES;
    isJuhua = NO;
    _dataArray = [NSMutableArray array];
    
    [super viewDidLoad];
    
    [self createUI];
    [self refresh];
}

- (void)createUI {
    self.view.backgroundColor = [UIColor blackColor];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldTextDidChange:) name:UITextFieldTextDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardDidHideNotification object:nil];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height-60) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor blackColor];
    [self.tableView registerClass:[ChatFlowCell class] forCellReuseIdentifier:NSStringFromClass([ChatFlowCell class])];
    [self.view addSubview:self.tableView];
    
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadMore)];
    header.lastUpdatedTimeLabel.hidden = YES;
    [header setTitle:@"加载完毕" forState:MJRefreshStateIdle];
    [header setTitle:@"松开加载更多" forState:MJRefreshStatePulling];
    [header setTitle:@"加载更多消息..." forState:MJRefreshStateRefreshing];
    //默认【下拉刷新】
    self.tableView.mj_header = header;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard:)];
    tap.numberOfTapsRequired = 1;
    [self.tableView addGestureRecognizer:tap];
    
    _inputView = [UIView new];
    _inputView.backgroundColor = [UIColor blackColor];
    _inputView.frame = CGRectMake(0, self.view.height - 60, self.view.width, 60);
    [self.view addSubview:_inputView];
    
    _inputTextField = [[UITextField alloc] initWithFrame:CGRectMake(14, 14, self.view.width-28, 32)];
    _inputTextField.delegate = self;
    _inputTextField.returnKeyType = UIReturnKeySend;
    _inputTextField.font = PINGFANG_FONT_OF_SIZE(12);
    _inputTextField.layer.cornerRadius = 5;
    _inputTextField.layer.borderColor = [UIColor colorWithHex:0x989696].CGColor;
    _inputTextField.layer.borderWidth = 2;
    _inputTextField.placeholder = @"您有什么想对我说的吗~";
    [_inputTextField setValue:[UIColor colorWithHex:0x989696] forKeyPath:@"_placeholderLabel.textColor"];
    _inputTextField.textColor = [UIColor colorWithHex:0x989696];
    _inputTextField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 32)];
    _inputTextField.leftViewMode = UITextFieldViewModeAlways;
    [_inputView addSubview:_inputTextField];
}

- (void)loadData {

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - MJRefresh

/**
 *  停止刷新
 */
-(void)endRefresh{
    if (page == 1) {
        [self.tableView.mj_footer endRefreshing];
    }
    [self.tableView.mj_header endRefreshing];
}

-(void)refresh
{
    [self getNetworkData:YES];
}
-(void)loadMore
{
    [self getNetworkData:NO];
}

- (void)getNetworkData:(BOOL)isRefresh {
    if (isRefresh) {
        page = 1;
        isFirstCome = YES;
    }else{
        page++;
    }
    
    [[[SKServiceManager sharedInstance] secretaryService] showSecretaryWithPage:page callback:^(BOOL success, NSArray<SKChatObject *> *chatFlowArray) {
        [self endRefresh];
        NSMutableArray *dataArray = [NSMutableArray arrayWithArray:chatFlowArray];
        [dataArray addObjectsFromArray:_dataArray];
        _dataArray = dataArray;
        if (chatFlowArray.count == 0 && page== 1) {
            SKChatObject *object = [SKChatObject new];
            object.content = @"Bibo！我是零仔小秘书~在九零APP中遇到任何问题都可以跟我进行反馈哟，不一定第一时间，但是小秘书一定会回复的:)";
            NSString *date = [NSString stringWithFormat:@"%lu", (long)[[NSDate date] timeIntervalSince1970]];
            object.created_time = date;
            object.type = @"1";
            [_dataArray addObject:object];
        }
        
        [self.tableView reloadData];
        if (isRefresh) {
            [self scrollViewToBottom:YES];
        }
        isFirstCome = NO;
    }];
}
#pragma mark - Action

- (void)scrollViewToBottom:(BOOL)animated
{
    if (self.tableView.contentSize.height > self.tableView.frame.size.height)
    {
        CGPoint offset = CGPointMake(0, self.tableView.contentSize.height - self.tableView.frame.size.height);
        [self.tableView setContentOffset:offset animated:animated];
    }
}

#pragma mark - UITableView Delegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ChatFlowCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ChatFlowCell class])];
    if (cell==nil) {
        cell = [[ChatFlowCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([ChatFlowCell class])];
    }
    
    [cell setObject:_dataArray[indexPath.row] withType:[_dataArray[indexPath.row].type intValue]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    ChatFlowCell *cell = (ChatFlowCell *)[self tableView:tableView cellForRowAtIndexPath:indexPath];
    return cell.cellHeight;
}

#pragma mark - UITableView DataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArray.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

#pragma mark - UITextFieldDelegate

- (void)textFieldTextDidChange:(NSNotification *)notification {

}

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    NSString *content = textField.text;
    textField.text = @"";
    
    SKChatObject *object = [SKChatObject new];
    object.content = content;
    NSString *date = [NSString stringWithFormat:@"%lu", (long)[[NSDate date] timeIntervalSince1970]];
    object.created_time = date;
    object.type = @"0";
    [_dataArray addObject:object];
    
    [self.tableView reloadData];
    [self scrollViewToBottom:YES];
    
    [[[SKServiceManager sharedInstance] secretaryService] sendFeedback:content callback:^(BOOL success, SKResponsePackage *response) {
        
        if (response.result != 0)
            return;
        
        SKChatObject *object = [SKChatObject new];
        object.content = response.data[@"reply"];
        NSString *date = response.data[@"time"];
        object.created_time = date;
        object.type = @"1";
        [_dataArray addObject:object];
        
        [self.tableView reloadData];
        [self scrollViewToBottom:YES];
        textField.text = @"";
    }];
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - Keyboard

- (void)keyboardWillShow:(NSNotification *)notification {
    NSDictionary *info = [notification userInfo];
    CGRect keyboardRect = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    _inputView.frame = CGRectMake(0, self.view.height - keyboardRect.size.height - 60, self.view.width, 60);
    self.tableView.bottom = _inputView.top;
}

- (void)keyboardWillHide:(NSNotification *)notification {
    _inputView.frame = CGRectMake(0, self.view.height - 60, self.view.width, 60);
    self.tableView.bottom = _inputView.top;
}

- (void)keyboardDidHide:(NSNotification *)notification {
    
}

- (void)dismissKeyboard:(id)sender {
    [_inputTextField resignFirstResponder];
}

@end
