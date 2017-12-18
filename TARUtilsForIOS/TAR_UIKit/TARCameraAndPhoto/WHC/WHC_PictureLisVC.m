//
//  WHC_PictureLisVC.m
//  photoPlay
//
//  Created by GL on 16/3/7.
//  Copyright © 2016年 zhoujia. All rights reserved.
//

#import "WHC_PictureLisVC.h"
#import "WHC_ChoicePictureVC.h"

#import <AssetsLibrary/AssetsLibrary.h>

#define kWHC_CellHeight    (60.0)
#define kWHC_CellName      (@"WHC_PictureListVC")

@interface WHC_PictureLisVC ()<UITableViewDelegate,UITableViewDataSource>{
    ALAssetsLibrary * _assetsLibray;
    NSMutableArray  * _assetsGroupArr;
    NSArray         * _imageArr;
    
    UITableView * _tableView;
}




@end

@implementation WHC_PictureLisVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"相册";
    [self initData];
    [self layoutUI];
    [self getPhotoGroup];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    UIView * view = [UIView new];
    [_tableView setTableFooterView:view];
    
    
}

-(void)layoutUI{

    UIBarButtonItem * cancelBarItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStyleDone target:self action:@selector(clickCancelBarItem:)];
    self.navigationItem.hidesBackButton = YES;
    self.navigationItem.leftBarButtonItem = cancelBarItem;
    
}

-(void)initData{
    _assetsGroupArr = [NSMutableArray new];
    _assetsLibray = [ALAssetsLibrary new];
}

-(void)getPhotoGroup{
    __weak  typeof(self)  sf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        void  (^assetGroupEnumerator)(ALAssetsGroup  * ,BOOL * ) = ^(ALAssetsGroup * group,BOOL * stop){
            if(group){
                NSString  * groupPropertyName = [group valueForProperty:ALAssetsGroupPropertyName];
                NSUInteger  groupType = [[group valueForProperty:ALAssetsGroupPropertyType] integerValue];
                if([[groupPropertyName lowercaseString] isEqualToString:@"camera roll"] &&
                   groupType == ALAssetsGroupSavedPhotos){
                    [_assetsGroupArr insertObject:group atIndex:0];
                }else{
                    [_assetsGroupArr addObject:group];
                }
                NSLog(@"%lu",(unsigned long)_assetsGroupArr.count);
                [sf performSelectorOnMainThread:@selector(updateTableView) withObject:Nil waitUntilDone:YES];
            }
        };
        void  (^assetGroupEnumberatorFailure)(NSError *) = ^(NSError * err){
            NSString  * msg = [NSString stringWithFormat:@"相册错误:%@-%@",[err localizedDescription],[err localizedRecoverySuggestion]];
            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:msg message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        };
        [_assetsLibray enumerateGroupsWithTypes:ALAssetsGroupAll usingBlock:assetGroupEnumerator failureBlock:assetGroupEnumberatorFailure];
    });
}

-(void)updateTableView{
//    [_pictureList reloadData];
    [_tableView reloadData];
}
-(void)clickCancelBarItem:(UIBarButtonItem *)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return kWHC_CellHeight;
    
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return [UIView new];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return _assetsGroupArr.count;
}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:kWHC_CellName];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kWHC_CellName];
    }
    ALAssetsGroup * temGroup = _assetsGroupArr[indexPath.row];
    [temGroup setAssetsFilter:[ALAssetsFilter allAssets]];
    NSUInteger count = [temGroup numberOfAssets];
    cell.textLabel.text = [NSString stringWithFormat:@"%@ (%lu)",[temGroup valueForProperty:ALAssetsGroupPropertyName],(unsigned long)count];
    cell.imageView.image = [UIImage imageWithCGImage:[temGroup posterImage]];
    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
//    cell.textLabel.text = @"1";
    return cell;

}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"select");
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    WHC_ChoicePictureVC * vc = [WHC_ChoicePictureVC new];
    vc.delegate = _delegate;
    vc.maxChoiceImageNumber = _maxChoiceImageNumberumber;
    vc.assetsGroup = _assetsGroupArr[indexPath.row];
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
