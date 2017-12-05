//
//  TAR_DatePicker.m
//  EmployeesAPP
//
//  Created by TAR on 2017/8/17.
//  Copyright © 2017年 TAR. All rights reserved.
//

#import "TAR_DatePicker.h"
#import "TAR_StringToolClass.h"


@interface TAR_DatePicker()
<
UIAlertViewDelegate
>
{
    UIDatePickerMode _pickerType;
    UIDatePicker *_activityTimeDatePicker;//活动时间_日期选择器
    NSString *selectedCurrentDate;
    
}
@property (nonatomic,strong) NSString *dateOrTime;
@property (nonatomic,strong) NSString *dateOrTimeFormat;

@end
@implementation TAR_DatePicker

- (instancetype)init
{
    self = [super init];
    if (self) {
        _datePickerMode = TAR_DatePickerMode_DateAndTime;
        _datePickerReturnStyle = TAR_DatePickerReturnStyle_yyyy_MM_dd_HH_mm;
        _preferredStyle = UIAlertControllerStyleActionSheet;
        
    }
    return self;
}

-(void)setMinimumDate:(NSString *)minimumDate dateOrTimeFormat:(NSString *)dateOrTimeFormat
{
    NSTimeInterval timeInterval = [self dateConverter:minimumDate dateFormat:dateOrTimeFormat];
    _minimumDate = [NSDate dateWithTimeIntervalSince1970:timeInterval];
}
// 设置最大时间
-(void)setMaximumDate:(NSString *)maximumDate dateOrTimeFormat:(NSString *)dateOrTimeFormat
{
    NSTimeInterval timeInterval = [self dateConverter:maximumDate dateFormat:dateOrTimeFormat];
    _maximumDate = [NSDate dateWithTimeIntervalSince1970:timeInterval];
}

- (void)setFormatWithDateOrTime:(NSString *_Nonnull)dateOrTime dateOrTimeFormat:(NSString *_Nonnull)dateOrTimeFormat
{
    if ([dateOrTime isKindOfClass:[NSNull class]]) {
        _dateOrTime = @"";
    }else{
        _dateOrTime = dateOrTime;
    }
    if ([dateOrTimeFormat isKindOfClass:[NSNull class]]) {
        _dateOrTimeFormat = @"";
    }else{
        _dateOrTimeFormat = dateOrTimeFormat;
    }
}
-(void)startDatePickerWithTarget:(_Nonnull id)target confirmHandler:(void (^ _Nonnull)(NSString * _Nonnull))confirmHandler
{
    [self alertControllerAddSubViewWithViewController:target];
    
    self.dateBlock = ^(NSString *date) {
        confirmHandler(date);
    };
}

-(void)initDateFormatter
{
    //实例化一个NSDateFormatter对象
    _dateFormatter = [[NSDateFormatter alloc] init];
    switch (_datePickerReturnStyle) {
        case TAR_DatePickerReturnStyle_yyyy_MM_dd_HH_mm:
            [_dateFormatter setDateFormat:@"yyyy年MM月dd日 HH:mm"];//设定返回时间格式
            break;
        case TAR_DatePickerReturnStyle_yyyy_MM_dd_HH_mm_ss:
            [_dateFormatter setDateFormat:@"yyyy年MM月dd日 HH:mm:ss"];//设定返回时间格式
            break;
        case TAR_DatePickerReturnStyle_yyyy_MM_dd:
            [_dateFormatter setDateFormat:@"yyyy年MM月dd日"];//设定返回时间格式
            break;
        case TAR_DatePickerReturnStyle_yyyy_MM_dd_EEEE:
            [_dateFormatter setDateFormat:@"yyyy年MM月dd日 EEEE"];//设定返回时间格式
            break;
        case TAR_DatePickerReturnStyle_HH_mm:
            [_dateFormatter setDateFormat:@"HH:mm"];//设定返回时间格式
            break;
        case TAR_DatePickerReturnStyle_HH_mm_ss:
            [_dateFormatter setDateFormat:@"HH:mm:ss"];//设定返回时间格式
            break;
        default:
            break;
    }
    NSString *dateString = [_dateFormatter stringFromDate:_datePicker.date];
    selectedCurrentDate = dateString;
}

- (NSTimeInterval )dateConverter:(NSString *)dateOrTime dateFormat:(NSString *)dateFormat
{
    NSString *dateString = dateOrTime;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    // if format doesn't match you'll get nil from your string, so be careful
    [dateFormatter setDateFormat:dateFormat];
    NSDate *date = [[NSDate alloc] init];
    date = [dateFormatter dateFromString:dateString];
    NSLog(@"dateFromString = %@", date);
    //date to timestamp
    NSTimeInterval timeInterval = [date timeIntervalSince1970];
    return timeInterval;
}
-(void)initDatePickerWithCGRect:(CGRect)aaa
{
    UIDatePicker *datePicker = [[UIDatePicker alloc] initWithFrame:aaa];
    datePicker.datePickerMode = (UIDatePickerMode)_datePickerMode;
    datePicker.minimumDate = _minimumDate;
    datePicker.maximumDate = _maximumDate;    
    
    NSTimeInterval dateTimeInterval = [self dateConverter:_dateOrTime dateFormat:_dateOrTimeFormat];
    if (dateTimeInterval == 0 || [TAR_StringToolClass isEqualEmptyWithString:_dateOrTime]) {
        [datePicker setDate:[NSDate dateWithTimeIntervalSinceNow:dateTimeInterval]];
    }else{
        [datePicker setDate:[NSDate dateWithTimeIntervalSince1970:dateTimeInterval]];
    }
    _datePicker = datePicker;
}

-(NSString *)replaceDateSeparator:(NSString *)dateStr;
{
    //替换字符串（把"年"替换成"-"）
    NSString *strUrl = [dateStr stringByReplacingOccurrencesOfString:@"年" withString:@"-"];
    NSString *strUrl2 = [strUrl stringByReplacingOccurrencesOfString:@"月" withString:@"-"];
    NSString *strUrl3 = [strUrl2 stringByReplacingOccurrencesOfString:@"日" withString:@""];
    return strUrl3;
}

#pragma mark --自定义alert视图--
//IOS8 UIAlertController弹出框中添加视图（例如日期选择器等等）
- (void)alertControllerAddSubViewWithViewController:(UIViewController *)viewController
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"选择时间" message:@"\n\n\n\n\n\n\n\n\n\n" preferredStyle:_preferredStyle];
    
    [self initDatePickerWithCGRect:CGRectMake(0, 40, alertController.view.width-20, 200)];
    [alertController.view addSubview:_datePicker];
    
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [self initDateFormatter];
        self.dateBlock(selectedCurrentDate);
    }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
    }];
    [alertController addAction:ok];
    [alertController addAction:cancel];
    [viewController presentViewController:alertController animated:YES completion:^{
        
    }];
}


//解决ios7以上版本UIAlertView调用addSubview无效问题
- (void)alertViewAddSubView:(UIDatePickerMode)type{
    _pickerType = type;
    
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"选择日期" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alertView.delegate = self;
    _activityTimeDatePicker = [[UIDatePicker alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
    if (_pickerType == UIDatePickerModeDate) {
        _activityTimeDatePicker.datePickerMode = UIDatePickerModeDate;
    }if (_pickerType == UIDatePickerModeTime) {
        _activityTimeDatePicker.datePickerMode = UIDatePickerModeTime;
    }
    //    datePicker.backgroundColor = [UIColor redColor];
    //check if os version is 7 or above
    if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_6_1) {
        [alertView setValue:_activityTimeDatePicker forKey:@"accessoryView"];
    }else{
        [alertView addSubview:_activityTimeDatePicker];
    }
    [alertView show];
}
#pragma mark --UIAlertViewDelegate--

@end
