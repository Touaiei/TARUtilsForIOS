//
//  TARBaseUITableView.h
//  YouJiaApp
//
//  Created by TAR on 2017/9/6.
//  Copyright © 2017年 TAR. All rights reserved.
//
/*
 基础TableView
 */
#import <UIKit/UIKit.h>

@protocol MapKeywordsSearchTableViewDelegate <NSObject>

-(void)baseUITableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;

-(void)mapKeywordsSearchListView:(id)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath info:(NSString *)info latitude:(NSString *)latitude longitude:(NSString *)longitude;

@end

@interface TARBaseUITableView : UITableView

@end
