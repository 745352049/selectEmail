//
//  ViewController.m
//  选择邮箱
//
//  Created by 水晶岛 on 2018/11/13.
//  Copyright © 2018 水晶岛. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () <UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *tableArray;
@property (nonatomic, strong) UIView *coverView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.navigationItem.title = @"选择邮箱";
    self.emailTextField.delegate = self;
}

#pragma mark - UITableViewDelegate UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.tableArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CELLID"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CELLID"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.text = [self.tableArray objectAtIndex:indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.emailTextField.text = [self.tableArray objectAtIndex:indexPath.row];
    [self.emailTextField resignFirstResponder];
    [self.coverView removeFromSuperview];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 40.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.1;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return nil;
}

#pragma mark - UITextField Delegate
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if (textField.text.length) {
        [self.tableArray removeAllObjects];
        for (NSString *str in [self getEmailType]) {
            [self.tableArray addObject:[NSString stringWithFormat:@"%@%@",textField.text,str]];
        }
        [self.view addSubview:self.coverView];
        [self.tableView reloadData];
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    [self.tableArray removeAllObjects];
    [self.coverView removeFromSuperview];
    [textField resignFirstResponder];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    [self.tableArray removeAllObjects];
    [self.view addSubview:self.coverView];
    if (textField.text.length) {
        if ([textField.text substringToIndex:textField.text.length-1].length==0 && string.length == 0) {
            [self.coverView setHidden:YES];
        } else {
            [self.coverView setHidden:NO];
        }
    } else {
        [self.coverView setHidden:NO];
    }
    
    if (string.length) {
        for (NSString *str in [self getEmailType]) {
            [self.tableArray addObject:[NSString stringWithFormat:@"%@%@%@",textField.text,string,str]];
        }
    } else {
        for (NSString *str in [self getEmailType]) {
            [self.tableArray addObject:[NSString stringWithFormat:@"%@%@", [textField.text substringToIndex:textField.text.length-1],str]];
        }
    }
    [self.tableView reloadData];
    
    return YES;
}

- (BOOL)textFieldShouldClear:(UITextField *)textField {
    [self.coverView removeFromSuperview];
    [self.tableArray removeAllObjects];
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self.coverView removeFromSuperview];
    [self.tableArray removeAllObjects];
    [textField resignFirstResponder];
    return YES;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.coverView.bounds style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}

- (UIView *)coverView {
    if (!_coverView) {
        _coverView = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.emailTextField.frame), CGRectGetMaxY(self.emailTextField.frame), CGRectGetWidth(self.emailTextField.frame), [self getEmailType].count > 4 ? 140.0 : [self getEmailType].count*40.0)];
        // 设置阴影颜色
        _coverView.layer.shadowColor = [UIColor blackColor].CGColor;
        // 往x方向偏移-5 y方向偏移5
        _coverView.layer.shadowOffset = CGSizeMake(-5, 5);
        // 设置阴影透明度
        _coverView.layer.shadowOpacity = 0.5;
        // 设置阴影半径
        _coverView.layer.shadowRadius = 4;
        // 这个必须设置 不然没效果
        _coverView.clipsToBounds = NO;
        [_coverView addSubview:self.tableView];
    }
    return _coverView;
}

- (NSArray *)getEmailType {
    return @[@"@163.com",@"@qq.com",@"@sina.com",@"@139.com",@"@yahoo.com",@"@163.net"];
}

- (NSMutableArray *)tableArray {
    if (!_tableArray) {
        _tableArray = [[NSMutableArray alloc] init];
    }
    return _tableArray;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
