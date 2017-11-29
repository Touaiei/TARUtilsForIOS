//
//  TAREmailTextFieldView.h
//  YouJiaApp
//
//  Created by TAR on 2017/3/9.
//  Copyright © 2017年 TAR. All rights reserved.
//

#import <UIKit/UIKit.h>

#define tableViewCell_H 35


typedef NS_ENUM(NSInteger, TARTextFieldStyle) {
    TARTextFieldStyle_Default = 0,
    TARTextFieldStyle_Email = 1,
    TARTextFieldStyle_PhoneNumber = 2,
    
};


@interface TAREmailTextFieldView : UIView<UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)UITextField *emailTextField;
@property(nonatomic,strong)UITableView *emailListTableView;
@property(nonatomic,strong)NSArray *emailOptionArray;
@property(nonatomic,strong)NSMutableArray *emailListDataArray;
@property(nonatomic,assign)BOOL showEmailList;



@property(nonatomic,assign)TARTextFieldStyle textFieldStyle;


-(NSString *)getEmailText;

@end
