//
//  TAR_DatePicker.h
//  EmployeesAPP
//
//  Created by TAR on 2017/8/17.
//  Copyright © 2017年 TAR. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


//typedef void(^refreshResule)(NSString * _Nullable date);
typedef void(^dateResult)(NSString * _Nonnull date);


typedef NS_ENUM(NSInteger, TAR_DatePickerMode) {
    TAR_DatePickerMode_DateAndTime = UIDatePickerModeDateAndTime,
    TAR_DatePickerMode_Date = UIDatePickerModeDate,
    TAR_DatePickerMode_Time = UIDatePickerModeTime,
    TAR_DatePickerMode_CountDownTimer = UIDatePickerModeCountDownTimer
};
typedef NS_ENUM(NSInteger, TAR_DatePickerReturnStyle) {
    TAR_DatePickerReturnStyle_yyyy_MM_dd_HH_mm,
    TAR_DatePickerReturnStyle_yyyy_MM_dd_HH_mm_ss,
    TAR_DatePickerReturnStyle_yyyy_MM_dd,
    TAR_DatePickerReturnStyle_yyyy_MM_dd_EEEE,
    TAR_DatePickerReturnStyle_HH_mm,
    TAR_DatePickerReturnStyle_HH_mm_ss
};
@interface TAR_DatePicker : NSObject
{
    
}
@property (nonatomic, readonly) UIAlertControllerStyle preferredStyle;
@property (nonatomic,strong) NSDateFormatter * _Nonnull dateFormatter;
@property (nonatomic,strong) UIDatePicker * _Nonnull datePicker;
@property (nonatomic, strong) NSDate * _Nullable minimumDate;// specify min/max date range. default is nil. When min > max, the values are ignored. Ignored in countdown timer mode
@property (nonatomic, strong) NSDate * _Nullable maximumDate;// default is nil
@property (nonatomic,assign) TAR_DatePickerMode datePickerMode;// default is UIDatePickerModeDateAndTime
@property (nonatomic,assign) TAR_DatePickerReturnStyle datePickerReturnStyle;
@property (nonatomic,copy) dateResult _Nonnull dateBlock;

- (void)setFormatWithDateOrTime:(NSString *_Nonnull)dateOrTime dateOrTimeFormat:(NSString *_Nonnull)dateOrTimeFormat;
-(void)setMinimumDate:(NSString *_Nonnull)minimumDate dateOrTimeFormat:(NSString *_Nonnull)dateOrTimeFormat;
-(void)setMaximumDate:(NSString *_Nonnull)maximumDate dateOrTimeFormat:(NSString *_Nonnull)dateOrTimeFormat;


-(void)startDatePickerWithTarget:(_Nonnull id)target confirmHandler:(void(^_Nonnull)(NSString * _Nonnull date))confirmHandler;

@end


