//
//  TAR_CategoryScrollView.m
//  JiaDuanAPP
//
//  Created by TAR on 2016/12/12.
//  Copyright © 2016年 TAR. All rights reserved.
//
/*
 TAR的 类别View
 */
#import "TAR_CategoryScrollView.h"
#import "TAR_StringToolClass.h"


//#define cellW ([UIScreen mainScreen].bounds.size.width)/5
#define SingleLineCell_W self.bounds.size.width/4.0
#define SingleLineCell_H 50
#define H_Screen [UIScreen mainScreen].bounds.size.height
#define W_Screen [UIScreen mainScreen].bounds.size.width
#define CELL_INDEX 100
#pragma mark - ----- init frame

@interface TAR_CategoryScrollView()
{
    int maxRowNumber;
    UIScrollView *BGScrollView;
    
}

@end
@implementation TAR_CategoryScrollView

-(id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setFrame:frame];

        [self initData];
        
    }
    return self;
}
-(instancetype)init
{
    self = [super init];
    if (self) {
        [self initData];
    }
    return self;
}
-(void)initData
{
    if (!_dataArray) {
        self.dataArray = [[NSArray alloc]init];
    }
    //        [self setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
    
    _isShowRemindMark = NO;
    _categoryStyle = CategoryViewStyle_TwoLine;//分类视图的风格枚举（默认风格）
    _categoryBackView_W = self.bounds.size.width/1.0;
    _categoryBackView_H = 200;
    _cell_W = _categoryBackView_W/4.0;
    _cell_H = _categoryBackView_W/4.0;;

}

-(void)addMyScrollSubViewsWithArray:(NSArray<TARCategoryViewItemModel *> *)array
{
    self.dataArray = array;
    
    [self initBGScrollView];
    
    
    switch (_categoryStyle) {
        case CategoryViewStyle_OneLine:
            maxRowNumber = 1;
//            [self categoryViewStyle_OneLine];
            
            [self categoryViewStyle_OneLine2];
            
            break;
        case CategoryViewStyle_TwoLine:
            maxRowNumber = 2;

            [self categoryViewStyle_TwoLine];
            break;
            
        case CategoryViewStyle_ThreeLine:
            maxRowNumber = 3;

            [self categoryViewStyle_ThreeLine];
            break;
            
        case CategoryViewStyle_MoreLine:
            maxRowNumber = MAXFLOAT;

            [self categoryViewStyle_MoreLine];
            break;
            
        default:
            //...
            break;
    }
}


-(void)initBGScrollView
{
    BGScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height)];
//    _repairProgressBGView.backgroundColor = [UIColor greenColor];
//    BGScrollView.layer.borderColor = [UIColor redColor].CGColor;
//    BGScrollView.layer.borderWidth = 1;
    [self addSubview:BGScrollView];
}

#pragma mark --单行可滚动风格--
-(void)categoryViewStyle_OneLine
{
    myScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height)];
    [myScrollView setBackgroundColor:[UIColor whiteColor]];
    [myScrollView setScrollEnabled:YES];
    [myScrollView setShowsHorizontalScrollIndicator:NO];
    [myScrollView setShowsVerticalScrollIndicator:NO];
    [myScrollView setAlwaysBounceVertical:NO];
    [myScrollView setContentSize:CGSizeMake(SingleLineCell_W*([_dataArray count]>0?[_dataArray count]:0), myScrollView.bounds.size.height)];
    [myScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    [self addSubview:myScrollView];
    
    UIImageView *jiantouImageView = [[UIImageView alloc]initWithFrame:CGRectMake(W_Screen-10, SingleLineCell_H/2-20, 10, 40)];
    [jiantouImageView setImage:[UIImage imageNamed:@"箭头"]];
    //    [self addSubview:jiantouImageView];
    
    for (int i = 0; i < ([_dataArray count]>0?[_dataArray count]:0); i++)
    {
        UIView *cellView = [[UIView alloc]initWithFrame:CGRectMake(SingleLineCell_W*i, 0, SingleLineCell_W, SingleLineCell_H)];
        if (_isSetBac) {
            if (i==self.selectIndex) {
                [cellView setBackgroundColor:[UIColor lightGrayColor]];
                [cellView setUserInteractionEnabled:NO];
            }
        }else
        {
            
        }
        
        cellView.tag = CELL_INDEX+i;
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGestureClick:)];
        singleTap.numberOfTapsRequired = 1;
        singleTap.numberOfTouchesRequired  = 1;
        [cellView addGestureRecognizer:singleTap];
        
        double imageView_W_H = SingleLineCell_W*(3.5/10.0);
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake((cellView.width - imageView_W_H)/2.0, 5, imageView_W_H, imageView_W_H)];

        TARCategoryViewItemModel *itemModel = [_dataArray objectAtIndex:i];
        NSString *imagePath = itemModel.imagePath;
        NSString *title = itemModel.name;

        if ([imagePath hasPrefix:@"http"]) {
            [imageView sd_setImageWithURL:[NSURL URLWithString:imagePath] placeholderImage:nil];
        }else{
            imageView.image = [UIImage imageNamed:imagePath];
        }
        [imageView.layer setCornerRadius:(imageView_W_H)/2.0];
        imageView.layer.masksToBounds = YES;
        
        UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(imageView.frame), SingleLineCell_W, SingleLineCell_H-CGRectGetMaxY(imageView.frame))];
        titleLabel.textColor = Color_TitleText;
        [titleLabel setText:title];
        
        titleLabel.textAlignment = NSTextAlignmentCenter;
        [titleLabel setFont:[UIFont systemFontOfSize:13.5]];
        titleLabel.textColor = [UIColor darkGrayColor];
        [cellView addSubview:imageView];
        [cellView addSubview:titleLabel];
        [myScrollView addSubview:cellView];
        [self.viewsArray addObject:cellView];
        
    }
}
-(void)categoryViewStyle_OneLine2
{
    [self removeAllSubviews];
    
    
    UIView *categoryBackView = [[UIView alloc]initWithFrame:CGRectMake((self.bounds.size.width-_categoryBackView_W)/2.0, 0, _categoryBackView_W, _categoryBackView_H)];
//    categoryBackView.layer.borderColor = [UIColor redColor].CGColor;
//    categoryBackView.layer.borderWidth = 0.5;
    categoryBackView.layer.cornerRadius = 10;
    [self addSubview:categoryBackView];
    //    if (_dataArray.count >=9) {
    //        categoryView.height = categoryView_H + cellH;
    //        categoryView.frame. = categoryView.frame.origin.y - cellH;
    //    }else if (_dataArray.count >=9){
    //        categoryView.height = categoryView_H + cellH*2;
    //        categoryView.y = categoryView.y - cellH*2;
    //    }
    int columnsNumber = 4;//列数（每行item个数）
    int rowNumber = 1;//行数（每列item个数）
    
    for (int i = 0; i < ([_dataArray count]>0?[_dataArray count]:0); i ++) {
        rowNumber = i/columnsNumber + 1;
        UIView *cellView = [[UIView alloc]initWithFrame:CGRectMake(i%columnsNumber *_cell_W, i/columnsNumber*_cell_H+0, _cell_W, _cell_H)];
//        cellView.layer.borderColor = [UIColor yellowColor].CGColor;
//        cellView.layer.borderWidth = 0.5;
        //        cellView.backgroundColor = [UIColor redColor];
        //        [categoryView addSubview:cellView];
        [categoryBackView addSubview:cellView];
        
        CGFloat labelTopSpace = 5;
        CGFloat label_H = 20;
//
        float image_W_H = _cell_W*(3.0/10);
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake((_cell_W-image_W_H)/2.0, (_cell_H-(image_W_H+labelTopSpace+label_H))/2.0, image_W_H, image_W_H)];
        [cellView addSubview:imageView];
        
        TARCategoryViewItemModel *itemModel = [_dataArray objectAtIndex:i];
        NSString *imagePath = itemModel.imagePath;
        NSString *title = itemModel.name;
        
        if ([imagePath hasPrefix:@"http"]) {
            [imageView sd_setImageWithURL:[NSURL URLWithString:imagePath] placeholderImage:nil];
        }else{
            imageView.image = [UIImage imageNamed:imagePath];
        }
        
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(imageView.frame)+labelTopSpace, cellView.bounds.size.width, label_H)];
//        label.layer.borderColor = [UIColor greenColor].CGColor;
//        label.layer.borderWidth = 0.5;
        [label setText:title];
        label.textColor = Color_TitleText;
        [label setTextAlignment:NSTextAlignmentCenter];
        [label setFont:[UIFont systemFontOfSize:13.5]];
        label.backgroundColor = [UIColor whiteColor];
        [cellView addSubview:label];
        
        cellView.tag = CELL_INDEX+i;
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGestureClick:)];
        singleTap.numberOfTapsRequired = 1;
        singleTap.numberOfTouchesRequired  = 1;
        [cellView addGestureRecognizer:singleTap];
        
    }
    categoryBackView.height = rowNumber*_cell_H;//从新指定背景视图高度
    contentViewHight = categoryBackView.height;//设置内容视图高度
    
}







//#define categoryBackView_W self.bounds.size.width/1.00
//#define categoryBackView_H 200
//#define cellW categoryBackView_W/4.0
//#define cellH categoryBackView_W/4.0
#define cellViewIndex 100
#pragma mark --多行可滚动风格--
-(void)categoryViewStyle_TwoLine
{
    [self removeAllSubviews];

    
    UIView *categoryBackView = [[UIView alloc]initWithFrame:CGRectMake((self.bounds.size.width-_categoryBackView_W)/2.0, 0, _categoryBackView_W, _categoryBackView_H)];
    
//    categoryBackView.backgroundColor = [UIColor lightGrayColor];
    categoryBackView.layer.cornerRadius = 10;
    [self addSubview:categoryBackView];
//    if (_dataArray.count >=9) {
//        categoryView.height = categoryView_H + cellH;
//        categoryView.frame. = categoryView.frame.origin.y - cellH;
//    }else if (_dataArray.count >=9){
//        categoryView.height = categoryView_H + cellH*2;
//        categoryView.y = categoryView.y - cellH*2;
//    }
    int columnsNumber = 4;//列数（每行item个数）
    int rowNumber = 0;//行数（每列item个数）
    
    for (int i = 0; i < ([_dataArray count]>0?[_dataArray count]:0); i ++) {
        rowNumber = i/columnsNumber + 1;
        /*cellView*/
        UIView *cellView = [[UIView alloc]initWithFrame:CGRectMake(i%columnsNumber *_cell_W, i/columnsNumber*_cell_H+0, _cell_W, _cell_H)];
        cellView.tag = CELL_INDEX+i;
//        cellView.layer.borderColor = [UIColor redColor].CGColor;
//        cellView.layer.borderWidth = 0.5;
//        cellView.backgroundColor = [UIColor redColor];
//        [categoryView addSubview:cellView];
        [categoryBackView addSubview:cellView];
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGestureClick:)];
        singleTap.numberOfTapsRequired = 1;
        singleTap.numberOfTouchesRequired  = 1;
        [cellView addGestureRecognizer:singleTap];
        
        /*imageIcon*/
        float image_W_H = _cell_W*(5.0/10);
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake((_cell_W-image_W_H)/2.0, _cell_H-image_W_H-30, image_W_H, image_W_H)];
        [cellView addSubview:imageView];

        TARCategoryViewItemModel *itemModel = [_dataArray objectAtIndex:i];
        NSString *imagePath = itemModel.imagePath;
        NSString *title = itemModel.name;
        
        if ([imagePath hasPrefix:@"http"]) {
            [imageView sd_setImageWithURL:[NSURL URLWithString:imagePath] placeholderImage:nil];
        }else{
            imageView.image = [UIImage imageNamed:imagePath];
        }
        
        /*titleName*/
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(imageView.frame)+5, cellView.bounds.size.width, 20)];
//        label.layer.borderColor = [UIColor greenColor].CGColor;
//        label.layer.borderWidth = 0.5;
        //        [label setText:@"我是人类"];
        [label setText:title];
        label.textColor = Color_TitleText;
        [label setTextAlignment:NSTextAlignmentCenter];
        [label setFont:[UIFont systemFontOfSize:13.5]];
        label.backgroundColor = [UIColor whiteColor];
        [cellView addSubview:label];
        
        /*提醒红点标记*/

        CGFloat remindMarkView_W_H = 10;
        UIView *remindMarkView  = [[UIView alloc]initWithFrame:CGRectMake(cellView.width-remindMarkView_W_H, 5, remindMarkView_W_H, remindMarkView_W_H)];
        remindMarkView.layer.cornerRadius = remindMarkView_W_H/2.0;
        remindMarkView.backgroundColor = [UIColor redColor];
        [cellView addSubview:remindMarkView];
        remindMarkView.hidden = YES;
        if (_isShowRemindMark == YES) {
            if (itemModel.isShowMark == YES) {
                remindMarkView.hidden = NO;
            }else{
                remindMarkView.hidden = YES;
            }
        }
    }
    categoryBackView.height = rowNumber*_cell_H;//从新指定背景视图高度
    contentViewHight = categoryBackView.height;//设置内容视图高度

}
-(void)categoryViewStyle_ThreeLine
{
    [self removeAllSubviews];
    
    UIView *categoryBackView = [[UIView alloc]initWithFrame:CGRectMake((self.bounds.size.width-_categoryBackView_W)/2.0, 0, _categoryBackView_W, _categoryBackView_H)];
//    categoryBackView.layer.borderColor = [UIColor redColor].CGColor;
//    categoryBackView.layer.borderWidth = 0.5;
    categoryBackView.layer.cornerRadius = 10;
    [self addSubview:categoryBackView];
    //    if (_dataArray.count >=9) {
    //        categoryView.height = categoryView_H + cellH;
    //        categoryView.frame. = categoryView.frame.origin.y - cellH;
    //    }else if (_dataArray.count >=9){
    //        categoryView.height = categoryView_H + cellH*2;
    //        categoryView.y = categoryView.y - cellH*2;
    //    }
    int columnsNumber = 4;//列数（每行item个数）
    int rowNumber = 0;//行数（每列item个数）
    
    for (int i = 0; i < ([_dataArray count]>0?[_dataArray count]:0); i ++) {
        rowNumber = i/columnsNumber + 1;
        UIView *cellView = [[UIView alloc]initWithFrame:CGRectMake(i%columnsNumber *_cell_W, i/columnsNumber*_cell_H+0, _cell_W, _cell_H)];
//        cellView.layer.borderColor = [UIColor yellowColor].CGColor;
//        cellView.layer.borderWidth = 0.5;
        //        cellView.backgroundColor = [UIColor redColor];
        //        [categoryView addSubview:cellView];
        [categoryBackView addSubview:cellView];
        
        //            float image_W_H = _cell_W*(3.5/10);
        float image_W_H = 35;
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake((_cell_W-image_W_H)/2.0, _cell_H-image_W_H-30, image_W_H, image_W_H)];
        [cellView addSubview:imageView];
        
        TARCategoryViewItemModel *itemModel = [_dataArray objectAtIndex:i];
        NSString *imagePath = itemModel.imagePath;
        NSString *title = itemModel.name;
        
        if ([imagePath hasPrefix:@"http"]) {
            [imageView sd_setImageWithURL:[NSURL URLWithString:imagePath] placeholderImage:nil];
        }else{
            imageView.image = [UIImage imageNamed:imagePath];
        }
        
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(imageView.frame)+5, cellView.bounds.size.width, 20)];
        //        label.layer.borderColor = [UIColor greenColor].CGColor;
        //        label.layer.borderWidth = 0.5;
        [label setText:title];
        label.textColor = Color_TitleText;
        [label setTextAlignment:NSTextAlignmentCenter];
        [label setFont:[UIFont systemFontOfSize:13.5]];
        label.backgroundColor = [UIColor whiteColor];
        [cellView addSubview:label];
        
        cellView.tag = CELL_INDEX+i;
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGestureClick:)];
        singleTap.numberOfTapsRequired = 1;
        singleTap.numberOfTouchesRequired  = 1;
        [cellView addGestureRecognizer:singleTap];
        
    }
    categoryBackView.height = rowNumber*_cell_H;//从新指定背景视图高度
    contentViewHight = categoryBackView.height;//设置内容视图高度
    
}
-(void)categoryViewStyle_MoreLine
{
    
}

-(void)tapGestureClick:(UITapGestureRecognizer*)tap
{
    UIView *view = tap.view;
    NSInteger index = view.tag;
    self.selectIndex = index;
    if (self.delegate && [self.delegate respondsToSelector:@selector(TARCategoryView:didSelectItemAtIndex:withArray:)]) {
        [self.delegate TARCategoryView:self didSelectItemAtIndex:index withArray:_dataArray];
        //        [self.delegate jumpToFenLeiWithIndex:index withView:view withArray:_dataArray];
    }
}
/**
 获得View内容高度
 */
-(CGFloat)getContentViewHight
{
    return contentViewHight;
}

-(void)setIsShowRemindMark:(BOOL)isShowRemindMark
{
    _isShowRemindMark = isShowRemindMark;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
