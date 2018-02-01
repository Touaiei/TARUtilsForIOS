//
//  TAR_ProvinceCityDistrictSelector.m
//  ZhiHuiHuanWeiAPP
//
//  Created by TAR on 2018/2/1.
//  Copyright © 2018年 TAR. All rights reserved.
//
/*
 省市区 联动选址器
 */
#import "TAR_ProvinceCityDistrictSelector.h"

@interface TAR_ProvinceCityDistrictSelector()
<UIPickerViewDataSource, UIPickerViewDelegate>
{
    NSInteger _provinceIndex;   // 省份选择 记录
    NSInteger _cityIndex;       // 市选择 记录
    NSInteger _districtIndex;   // 区选择 记录
}
@property (nonatomic, strong) UIPickerView * pickerView;
@property (nonatomic, strong) UIView * actionBar;

/**
 *  数据源
 */
@property (nonatomic, strong) NSArray * arrayDS;
@end
@implementation TAR_ProvinceCityDistrictSelector

#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height

#define PICKER_HEIGHT   216

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initialize];
    }
    return self;
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initialize];
    }
    return self;
}
- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self initialize];
    }
    return self;
}
-(void)initialize
{
    _provinceIndex = _cityIndex = _districtIndex = 0;
    _actionBar_Height = 40;
    self.backgroundColor = [UIColor groupTableViewBackgroundColor];
}
-(void)initInterfaceBuilder
{
    [self actionBar];
    [self pickerView];
    
    // 默认Picker状态
    [self resetPickerSelectRow];
}

#pragma mark - Load DataSource

// 读取本地Plist加载数据源
-(NSArray *)arrayDS
{
    if(!_arrayDS){
        NSString * path = [[NSBundle mainBundle] pathForResource:@"Province" ofType:@"plist"];
        _arrayDS = [[NSArray alloc] initWithContentsOfFile:path];
    }
    return _arrayDS;
}

// 懒加载方式
-(UIPickerView *)pickerView
{
    if(!_pickerView){
        _pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_actionBar.frame), self.width, self.height-_actionBar.height)];
        _pickerView.backgroundColor = [UIColor whiteColor];
        _pickerView.dataSource = self;
        _pickerView.delegate = self;
        [self addSubview:_pickerView];
    }
    return _pickerView;
}

-(void)resetPickerSelectRow
{
    [self.pickerView selectRow:_provinceIndex inComponent:0 animated:YES];
    [self.pickerView selectRow:_cityIndex inComponent:1 animated:YES];
    [self.pickerView selectRow:_districtIndex inComponent:2 animated:YES];
}

#pragma mark - PickerView Delegate

// 列数
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 3;
}

// 每列有多少行
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if(component == 0){
        return self.arrayDS.count;
    }
    else if (component == 1){
        return [self.arrayDS[_provinceIndex][@"citys"] count];
    }
    else{
        return [self.arrayDS[_provinceIndex][@"citys"][_cityIndex][@"districts"] count];
    }
}

// 返回每一行的内容
-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if(component == 0){
        return self.arrayDS[row][@"province"];
    }
    else if (component == 1){
        return self.arrayDS[_provinceIndex][@"citys"][row][@"city"];
    }
    else{
        return self.arrayDS[_provinceIndex][@"citys"][_cityIndex][@"districts"][row];
    }
}

// 滑动或点击选择，确认pickerView选中结果
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    
    if(component == 0){
        _provinceIndex = row;
        _cityIndex = 0;
        _districtIndex = 0;
        
        [self.pickerView reloadComponent:1];
        [self.pickerView reloadComponent:2];
    }
    else if (component == 1){
        _cityIndex = row;
        _districtIndex = 0;
        
        [self.pickerView reloadComponent:2];
    }
    else{
        _districtIndex = row;
    }
    
    // 重置当前选中项
    [self resetPickerSelectRow];
}

#pragma mark - Touch

// 确认最后选中的结果
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{

    
//    self.nameTextField.text = address;
//    [self.nameTextField resignFirstResponder];
}



-(UIView *)actionBar
{
    if(!_actionBar){
        _actionBar = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.width, _actionBar_Height)];
        _actionBar.backgroundColor = [UIColor whiteColor];
        _actionBar.layer.borderWidth = 1;
        _actionBar.layer.borderColor = [UIColor lightGrayColor].CGColor;
        [self addSubview:_actionBar];
        
        CGFloat cancelButton_Width = 40;
        CGFloat cancelButton_Height = 25;
        UIButton *cancelButton = [[UIButton alloc]initWithFrame:CGRectMake(15, (_actionBar.height-cancelButton_Height)/2.0, cancelButton_Width, cancelButton_Height)];
        [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        [cancelButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [cancelButton addTarget:self action:@selector(cancelButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [_actionBar addSubview:cancelButton];
        
        CGFloat confirmButton_Width = 40;
        CGFloat confirmButton_Height = 25;
        UIButton *confirmButton = [[UIButton alloc]initWithFrame:CGRectMake(_actionBar.width-(confirmButton_Width+15), (_actionBar.height-confirmButton_Height)/2.0, confirmButton_Width, confirmButton_Height)];
        [confirmButton setTitle:@"确认" forState:UIControlStateNormal];
        [confirmButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [confirmButton addTarget:self action:@selector(confirmButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [_actionBar addSubview:confirmButton];
    }
    return _actionBar;
}
-(void)cancelButtonClick:(UIButton *)sender
{
    [self hiddenSelf];
}
-(void)confirmButtonClick:(UIButton *)sender
{
    // 省市区地址
    #warning 看明白Province.plist的结构，理解下边内容就不再是问题
//    NSString * address = [NSString stringWithFormat:@"%@-%@-%@", self.arrayDS[_provinceIndex][@"province"], self.arrayDS[_provinceIndex][@"citys"][_cityIndex][@"city"], self.arrayDS[_provinceIndex][@"citys"][_cityIndex][@"districts"][_districtIndex]];

    NSString *province = self.arrayDS[_provinceIndex][@"province"];
    NSString *city = self.arrayDS[_provinceIndex][@"citys"][_cityIndex][@"city"];
    NSString *district = self.arrayDS[_provinceIndex][@"citys"][_cityIndex][@"districts"][_districtIndex];
    if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectedResultProvince:city:district:)]) {
        [self.delegate didSelectedResultProvince:province city:city district:district];
    }
    [self hiddenSelf];
}
-(void)hiddenSelf
{
    if (self) {
        self.hidden = YES;
        [self removeFromSuperview];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
