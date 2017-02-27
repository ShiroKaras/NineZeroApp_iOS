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

@interface ChatFlowViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) UIView *inputView;
@property (nonatomic, strong) UITextField *inputTextField;
@end

@implementation ChatFlowViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldTextDidChange:) name:UITextFieldTextDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardDidHideNotification object:nil];
    
    _dataArray = [NSMutableArray array];
    for (int i=0; i<10; i++) {
        [_dataArray addObject:@(1)];
    }
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height-60) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor blackColor];
    [self.tableView registerClass:[ChatFlowCell class] forCellReuseIdentifier:NSStringFromClass([ChatFlowCell class])];
    [self.view addSubview:self.tableView];
    [self.tableView reloadData];
    [self scrollViewToBottom:YES];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard:)];
    tap.numberOfTapsRequired = 1;
    [self.tableView addGestureRecognizer:tap];
    
    _inputView = [UIView new];
    _inputView.backgroundColor = [UIColor blackColor];
    _inputView.frame = CGRectMake(0, self.view.height - 60, self.view.width, 60);
    [self.view addSubview:_inputView];
    
    _inputTextField = [[UITextField alloc] initWithFrame:CGRectMake(14, 14, self.view.width-28, 32)];
    _inputTextField.font = PINGFANG_FONT_OF_SIZE(12);
    _inputTextField.layer.cornerRadius = 5;
    _inputTextField.layer.borderColor = [UIColor colorWithHex:0x989696].CGColor;
    _inputTextField.layer.borderWidth = 2;
    _inputTextField.placeholder = @"您有什么想对我说的吗~";
    _inputTextField.textColor = [UIColor colorWithHex:0x989696];
    _inputTextField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 32)];
    _inputTextField.leftViewMode = UITextFieldViewModeAlways;
    [_inputView addSubview:_inputTextField];
    
    [self loadData];
}

- (void)loadData {
    [[[SKServiceManager sharedInstance] secretaryService] showSecretaryWithCallback:^(BOOL success, NSArray<SKChatObject *> *chatFlowArray) {
        DLog(@"chatArray: %@", chatFlowArray);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Action

- (void)addChatData {
    [_dataArray addObject:@(arc4random()%2+1)];
    [self.tableView reloadData];
    [self scrollViewToBottom:YES];
}

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
    
    [cell setObject:nil withType:[_dataArray[indexPath.row] intValue]];
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
