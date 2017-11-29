//
//  TAREmailTextFieldView.m
//  YouJiaApp
//
//  Created by TAR on 2017/3/9.
//  Copyright © 2017年 TAR. All rights reserved.
//

#import "TAREmailTextFieldView.h"

@implementation TAREmailTextFieldView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self initUI];
        [self initData];
        
    }
    return self;
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initUI];
        [self initData];

    }
    return self;
}

-(void)initUI
{
//    _emailTextField = [self emailTextField];
    [self initEmailTextField];
    
}
-(void)initData
{
    
}


-(void)initEmailOptionArray
{
    if (_emailOptionArray == nil) {
        _emailOptionArray = [NSArray arrayWithObjects:@"qq.com",@"163.com",@"126.com",@"yeah.net",@"sina.com",@"sohu.com",@"sogou.com",@"gmail.com",@"yahoo.com",@"hotmail.com", nil];
        
    }
}


-(void)initEmailTextField
{
    if (_emailTextField == nil) {
        //    UITextField *textField = [[UITextField alloc]initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height)];
        UITextField *textField = [[UITextField alloc]init];
        textField.delegate = self;
        textField.clearButtonMode = UITextFieldViewModeAlways;//清空小叉叉
        _emailTextField = textField;
        [self addSubview:textField];
        [textField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
    }
}
-(void)initEmailListTableView
{
    if (_emailListTableView == nil) {
        UITableView *tableVeiw = [[UITableView alloc]init];
        tableVeiw.delegate = self;
        tableVeiw.dataSource = self;
        tableVeiw.layer.borderColor = [UIColor lightGrayColor].CGColor;
        tableVeiw.layer.borderWidth = 1;
        _emailListTableView.userInteractionEnabled = YES;
//        tableVeiw.backgroundColor = [UIColor blackColor];
//        tableVeiw.alpha = 1;
        tableVeiw.hidden = NO;
        //        [_emailTextField addSubview:tableVeiw];
        _emailListTableView = tableVeiw;
//        [self addSubview:tableVeiw];
//        [[self superview] insertSubview:tableVeiw atIndex:0];
//        [[self superview]addSubview:tableVeiw];
        [[UIApplication sharedApplication].keyWindow addSubview:tableVeiw];
        [tableVeiw mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_bottom);
            make.centerX.equalTo(self);
            make.width.mas_equalTo(self);
            make.height.mas_equalTo(_emailOptionArray.count * tableViewCell_H).priorityLow();
        }];
        [_emailListTableView.superview layoutIfNeeded];
        
    }
}


-(NSString *)getEmailText
{
    if (_emailTextField.text.length>0) {
        return _emailTextField.text;
    }else{
        return @"";
    }
}
-(void)initEmailOptionData
{
    switch (_textFieldStyle) {
        case TARTextFieldStyle_Default:{
            
            
        }
            break;
        case TARTextFieldStyle_Email:{
            if (_emailListDataArray == nil) {
                _emailListDataArray = [[NSMutableArray alloc]init];
            }
            [self initEmailOptionArray];
            [self initEmailListTableView];

        }
            break;
        case TARTextFieldStyle_PhoneNumber:
            
            break;
        default:
            
            break;
    }
    

}
-(void)setTextFieldStyle:(TARTextFieldStyle)textFieldStyle
{
    _textFieldStyle = textFieldStyle;
    switch (textFieldStyle) {
        case TARTextFieldStyle_Email:
            _emailTextField.keyboardType = UIKeyboardTypeASCIICapable;
            break;
        case TARTextFieldStyle_PhoneNumber:
            _emailTextField.keyboardType = UIKeyboardTypeNumberPad;
            break;
        default:
            _emailTextField.keyboardType = UIKeyboardTypeDefault;
            break;
    }
}

-(void)setShowEmailList:(BOOL)showEmailList
{
    _showEmailList = showEmailList;
    _emailListTableView.hidden = !showEmailList;
}


#pragma mark --textFieldDelegate--
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSLog(@"shouldChangeCharactersInRange");
    NSString *toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    NSLog(@"toBeString==%@",toBeString);
    
    if (_textFieldStyle == TARTextFieldStyle_PhoneNumber) {
        if (toBeString.length > 11) {
            textField.text = [toBeString substringToIndex:11];
            return NO;
        }
    }
    if (_textFieldStyle == TARTextFieldStyle_Email) {
        [self initEmailOptionData];
        if (textField == _emailTextField) {
            //是否包含@
            //判断text是否输入过@如果输入过则不出现下啦菜单
            if ([toBeString containsString:@"@"]) {
                //抱歉 这是IOS8方法  此处可以替换为      （[text rangeOfString:@"@"].location !=NSNotFound）
                [self setShowEmailList:YES];
                [_emailListDataArray removeAllObjects];
                //范围
                NSRange range = [toBeString rangeOfString:@"@"];
                if ((range.location + range.length) == toBeString.length) {
                    for (NSString *str in _emailOptionArray) {
                        [_emailListDataArray addObject:[NSString stringWithFormat:@"%@%@",toBeString,str]];
                    }
                }else{
                    NSString *suffix = [toBeString substringWithRange:NSMakeRange(range.location+range.length, toBeString.length-(range.location+range.length))];
                    NSString *headText = [toBeString substringWithRange:NSMakeRange(0,range.location+range.length)];
                    for (NSString *str in _emailOptionArray) {
                        //匹配
                        if ([str hasPrefix:suffix]) {
                            [_emailListDataArray addObject:[NSString stringWithFormat:@"%@%@",headText,str]];
                        }
                    }
                    if (_emailListDataArray.count<=0) {
                        
                        [self setShowEmailList:NO];
                    }
                }
                [_emailListTableView reloadData];
            }else{
                
                [self setShowEmailList:NO];
            }
        }
        return [self validateNumber:string];
    }
    return YES;
}
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    NSLog(@"textFieldDidBeginEditing");
    
}
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    NSLog(@"textFieldDidEndEditing");

}

-(BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    NSLog(@"textFieldShouldEndEditing");
    return YES;
}
-(void)textFieldDidEndEditing:(UITextField *)textField reason:(UITextFieldDidEndEditingReason)reason
{
    NSLog(@"UITextFieldDidEndEditingReason");

}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    NSLog(@"textFieldShouldReturn");
    return YES;
}
-(BOOL)textFieldShouldClear:(UITextField *)textField
{
    NSLog(@"textFieldShouldClear");

    [self setShowEmailList:NO];
    return YES;
}
/**
 限制输入字符集
 */
- (BOOL)validateNumber:(NSString*)number {
    BOOL res = YES;
    NSCharacterSet* tmpSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789._@abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"];
    int i = 0;
    while (i < number.length) {
        NSString * string = [number substringWithRange:NSMakeRange(i, 1)];
        NSRange range = [string rangeOfCharacterFromSet:tmpSet];
        if (range.length == 0) {
            res = NO;
            break;
        }
        i++;
    }
    return res;
}

#pragma mark --tableViewDelegate--
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    [_emailListTableView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(_emailListDataArray.count*tableViewCell_H).priorityHigh();
    }];
    
    return _emailListDataArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifer = @"cellIdentifer";
    UITableViewCell *cell = [_emailListTableView dequeueReusableCellWithIdentifier:identifer];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifer];
    }
    cell.textLabel.text = [_emailListDataArray objectAtIndex:indexPath.row];
    cell.textLabel.textColor = [UIColor darkGrayColor];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return tableViewCell_H;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    _emailTextField.text = [_emailListDataArray objectAtIndex:indexPath.row];
    [self setShowEmailList:NO];
}
@end



