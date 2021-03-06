//
//  WHC_ChoicePictureVC.m
//  photoPlay
//
//  Created by GL on 16/3/7.
//  Copyright © 2016年 zhoujia. All rights reserved.
//

#import "WHC_ChoicePictureVC.h"
#import "WHC_Asset.h"
#import "WHC_PhotoListCell.h"

#define kWHC_ShowPictureWidth     (80)           //默认展示宽度为80
#define kWHC_CellName             (@"WHC_ChoicePictureVC")

#define kChoiceTitle              (@"已选择(%d / %d)")



@interface WHC_ChoicePictureVC ()<UITableViewDelegate,UITableViewDataSource,WHC_PhotoListCellDelegate>{
    NSMutableArray * _assetArr;
    NSInteger        _listColumn;
    BOOL             _choiceState;
    UITableView     * _tableView;
    
    __weak typeof(WHC_ChoicePictureVC) * _sf;
}

@end

@implementation WHC_ChoicePictureVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = [NSString stringWithFormat:kChoiceTitle,(int)self.maxChoiceImageNumber,0];
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStylePlain];
    _tableView.delegate  = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    
    [self initData];
    [self layoutUI];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self performSelectorInBackground:@selector(scanPhoto) withObject:nil];

}

-(void)layoutUI{

    UIButton *OKButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [OKButton setTitle:@"完成" forState:UIControlStateNormal];
    [OKButton addTarget:self action:@selector(clickDone:) forControlEvents:UIControlEventTouchUpInside];
    OKButton.frame = CGRectMake(0, 0, 50, 44);
    UIBarButtonItem *doneBarItem = [[UIBarButtonItem alloc]initWithCustomView:OKButton];
    

//    UIBarButtonItem *doneBarItem = [[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(clickDone:)];
    doneBarItem.tintColor = [UIColor blackColor];
    self.navigationItem.rightBarButtonItem = doneBarItem;

}

- (void)initData{
    _sf = self;
    _assetArr = [NSMutableArray new];
    _listColumn = CGRectGetWidth([UIScreen mainScreen].bounds) / kWHC_ShowPictureWidth;
}
- (void)scanPhoto{
    if(_assetsGroup){
        [_assetsGroup enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
            if(result){
                WHC_Asset  * whcAS = [[WHC_Asset alloc]initWithAsset:result];
                [_assetArr addObject:whcAS];
            }
        }];
        dispatch_sync(dispatch_get_main_queue(), ^{
            [_tableView reloadData];
        });
    }
}

- (NSArray *)getRowAssets:(NSInteger)row{
    NSInteger index = row * _listColumn;
    NSInteger length = MIN(_listColumn, [_assetArr count] - index);
    return [_assetArr subarrayWithRange:NSMakeRange(index, length)];
}

- (void)clickDone:(UIBarButtonItem *)sender{
    NSMutableArray  *  selectedImageArr = [NSMutableArray array];
    for (WHC_Asset * whcAS in _assetArr) {
        if(whcAS.selected) {
            [selectedImageArr addObject:whcAS];
        }
    }
    if (selectedImageArr.count <1) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"请选择图片" message:nil preferredStyle:UIAlertControllerStyleAlert];
        [self presentViewController:alertController animated:YES completion:nil];
        UIAlertAction *alertCancel = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
        [alertController addAction:alertCancel];
        return;
    }
    [self performSelectorInBackground:@selector(selectedAssets:) withObject:selectedImageArr];
}

-(void)selectedAssets:(NSArray*)assets{
    
    NSMutableArray  * imageArr = [NSMutableArray array];
    for (WHC_Asset  * whcAS in assets) {
        ALAssetRepresentation  * representation = [whcAS.asset defaultRepresentation];
        CGImageRef  imageRef = [representation fullResolutionImage];
        UIImage    * image = [UIImage imageWithCGImage:imageRef scale:0 orientation:(UIImageOrientation)representation.orientation];
        [imageArr addObject:image];
    }
    dispatch_sync(dispatch_get_main_queue(), ^{
        [self dismissViewControllerAnimated:YES completion:^{
            if(_delegate){
                if([_delegate respondsToSelector:@selector(WHCChoicePictureVC:didSelectedPhotoArr:)]){
                    [_delegate WHCChoicePictureVC:_sf didSelectedPhotoArr:imageArr];
                }
            }
        }];
    });
    
}

- (NSInteger)getChoicedImageCount{
    NSInteger count = 0;
    for (WHC_Asset * whcAS in _assetArr) {
        if(whcAS.selected) {
            ++count;
        }
    }
    return count;
}

#pragma mark - WHC_PhotoListCellDelegate
- (BOOL)WHCPhotoListCurrentChoiceState:(BOOL)selected{
    BOOL isChoiced = NO;
    NSInteger count = [self getChoicedImageCount];
    if (selected) {
        self.navigationItem.title = [NSString stringWithFormat:kChoiceTitle ,(int)self.maxChoiceImageNumber , (int)count - 1];
    }else if (self.maxChoiceImageNumber > count){
        self.navigationItem.title = [NSString stringWithFormat:kChoiceTitle ,(int)self.maxChoiceImageNumber , (int)count + 1];
        isChoiced = YES;
    }
    return isChoiced;
}

- (void)WHCPhotoListCancelChoicePhoto{
    _choiceState = NO;
}

#pragma mark - UITableViewDelegate UITableViewDataSource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [WHC_PhotoListCell cellHeight];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return [UIView new];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return ceil((CGFloat)(_assetArr.count) / (CGFloat)_listColumn);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WHC_PhotoListCell * cell = [tableView dequeueReusableCellWithIdentifier:kWHC_CellName];
    if(cell == nil){
        cell = [[WHC_PhotoListCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kWHC_CellName];
    }
    cell.delegate = self;
    cell.listColumn = _listColumn;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell setAssets:[self getRowAssets:indexPath.row]];
    return cell;
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
