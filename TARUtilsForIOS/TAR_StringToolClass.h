//
//  TAR_StringToolClass.h
//  LLG
//
//  Created by GL on 16/11/4.
//  Copyright © 2016年 beijiguang. All rights reserved.
//
//前老板娘电话(微信):188 8333 3422

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>



@interface TAR_StringToolClass : NSObject
/*字体大小枚举*/
typedef NS_ENUM(NSInteger, FontSize){
    FontSize10 = 10,
    FontSize11 = 11,
    FontSize12 = 12,
    FontSize13 = 13,
    FontSize14 = 14,
    FontSize15 = 15,
    FontSize16 = 16,
    FontSize17 = 17,
    FontSize18 = 18
};
/**
 动态计算Text宽度，适用于单行文本
 *  @param text     需要计算大小的文本信息
 *  @param fontSize 指定文本字体大小
 *  @param maxW     最大宽度
 *  @param maxH     最大高度
 *  @return 计算后得到的大小
 */
+(CGSize)calculateTextSize:(NSString *_Nonnull)text andFont:(double)fontSize andMaxW:(double)maxW andMaxH:(double)maxH;

/**
 动态计算Text高度，适用于多行文本
 @param text 需要计算大小的文本信息
 @param fontSize 指定文本字体大小
 @param width 指定宽度
 @return 计算后得到的大小
 */
+(CGSize)calculateTextHeightWithText:(NSString *_Nullable)text andFont:(double)fontSize andWidth:(double)width;

+(void)setTextLineSpaceWithLabel:(UILabel*_Nullable)label withSpace:(CGFloat)lineSpace withValue:(NSString*_Nullable)str withFont:(UIFont*_Nullable)font;

+(CGSize)getTextLineSpaceHeightWithValue:(NSString*_Nullable)str withFont:(UIFont*_Nullable)font withWidth:(CGFloat)width withSpace:(CGFloat)lineSpace withMaxH:(CGFloat)maxH;


/**
 通过Color来创建Image
 @param color 指定Color
 @return 返回创建好的Image
 */
+(UIImage*_Nonnull)createImageWithColor:(UIColor*_Nonnull)color;


+(NSString *_Nonnull)arrayOrDictionaryToJSONString:(id _Nonnull )arrayOrDictionaryObject;
+ (NSDictionary *_Nonnull)JsonStringToDictionary:(NSString *_Nonnull)jsonString;
+(NSArray *_Nonnull)JsonStringToArray:(NSString *_Nonnull)jsonString;
+(NSString *_Nonnull)NSStringToJSONString:(NSString *_Nonnull)aString;
+(UIFont *_Nonnull)returnFont:(FontSize)size;
+(NSString *_Nonnull)MD5_32Bit:(NSString *_Nonnull)str;


/**
 判断NSDictionary中 KEY及对应Value 是否为空(单层判断)
 @param dict 目标NSDictionary
 @param key 需要判断的 KEY
 @return 为空返回YES，不为空返回NO
 */
+(BOOL)isEqualEmptyFromSingleLayerWithDictionary:(NSDictionary *_Nonnull)dict withKey:(NSString *_Nonnull)key;
/**
 判断NSDictionary中 KEY及对应Value 是否为空(多层判断)
 @param dict 目标NSDictionary
 @param key 需要判断的 KEY
 @return 为空返回YES，不为空返回NO
 */
+(BOOL)isEqualEmptyFromMoreLayerWithDictionary:(NSDictionary *_Nonnull)dict withKey:(NSString *_Nonnull)key;

/**
 判断字符串是否为纯浮点数
 */
+(BOOL)isEqualPureFloat:(NSString*_Nonnull)string;

/**
 判断字符串是否为纯整数
 */
+(BOOL)isEqualPureInt:(NSString *_Nonnull)string;

/**
 判断String 是否为空
 @param string 需要判断的 string
 @return 为空返回YES，不为空返回NO
 */
+(BOOL)isEqualEmptyWithString:(NSString *_Nonnull)string;

/**
 判断Array 是否为空
 @param array 需要判断的 array
 @return 为空返回YES，不为空返回NO
 */
+(BOOL)isEqualEmptyWithArray:(NSArray *_Nonnull)array;

/**
 判断Dictionary 是否为空
 @param dictionary 需要判断的 dictionary
 @return 为空返回YES，不为空返回NO
 */
+(BOOL)isEqualEmptyWithDictionary:(NSDictionary *_Nonnull)dictionary;


/**
 打开系统设置
 */
+(void)openSettings;

/**
 把字符串替换成星号
 */
+(NSString *_Nonnull)replaceStringWithAsterisk:(NSString *_Nonnull)originalStr startLocation:(NSInteger)startLocation lenght:(NSInteger)lenght;

/**
 颜色渐变——>线性渐变
 @param view 目标View
 @param alpha 设置透明度alpha
 */
+(void)colorGradientForStatusBar:(UIView *_Nonnull)view alpha:(CGFloat)alpha;

/**
 颜色渐变——>线性渐变
 @param view 目标View
 @param startColor 开始颜色（可以设置透明度alpha）
 @param endColor 结束颜色（可以设置透明度alpha）
 */
+(void)colorGradientLinearForView:(UIView *_Nonnull)view startColor:(UIColor *_Nonnull)startColor endColor:(UIColor *_Nonnull)endColor;

/**
 设置View边框颜色及粗细
 */
+(void)layerBorderColorAndborderWidth:(UIView *_Nonnull)view borderColor:(UIColor *_Nonnull)bColor borderWidth:(CGFloat)bWidth;

/**
 获取当前时间戳
 */
+(NSString *_Nonnull)GetTimestamp;


/**
 *  @param input 传入的中文
 *  @return 完成转码后返回结果
 */
+(NSString *_Nonnull)encodeToPercentEscapeString:(NSString *_Nonnull)input;


/**
 比较版本号大小
 @param appStoreVersion appStoreVersion
 @param nativeVesion nativeVesion
 @return appStoreVersion > nativeVesion ? return YES : return NO
 */
+(BOOL)compareVesionWithServerVersion:(NSString *_Nonnull)appStoreVersion  nativeVesion:(NSString *_Nonnull)nativeVesion;


/**
 将String里面的每个字符取出来转换成ASCII码，然后依顺序拼接成新的ASCII码String
 @param string 需要转换的String
 @return 返回转换后的ASCII码String
 */
+(NSString *_Nonnull)stringToASCIICodeFromString:(NSString *_Nonnull)string;

/**
 把传入的字典参数Key按首字符排序后，取出对应的value依次拼接形成一个字符串，再把该字符串传入MD5加密方法加密，形成最终的签名字符串
 @return 返回排序后的签名字符串
 */
+(NSString *_Nonnull)getSignWithDictionary:(NSDictionary *_Nonnull)Dic;

/**
 序列化Dictionary，将NSDictionary中的Null类型的项目转化成@""
 @param myDic 转换前的旧Dictionary
 @return 返回转换后的新Dictionary
 */
+(NSDictionary *_Nonnull)nullToNonnullWithDictionary:(nonnull NSDictionary *)myDic;


/**
 为UIImageView设置image，同时进行判空的一系列操作
 @param imageView 需要设值的UIImageView
 @param imagePath image路径（可以是本地图片路径，也可以是网络图片路径）
 @param placeholder 占位图（可为nil）
 */
+(void)setImageWithImageView:(UIImageView *_Nonnull)imageView imagePath:(NSString *_Nullable)imagePath placeholder:(UIImage * _Nullable )placeholder;

/**
 获取一个随机整数，范围在[from,to），包括from，包括to
 @param from 从
 @param to 到
 @return 随机整数
 */
+(int)getRandomNumberWithFrom:(int)from to:(int)to;

/**
 数组内交互两个元素的位置
 @param array 需要交互元素位置的数组
 @param index1 索引1
 @param index2 索引2
 @return 返回交换后的新数组，如果交换失败则返回原数组
 */
-(NSMutableArray *_Nonnull)arrayExchangeObjectWithArray:(NSMutableArray *_Nonnull)array atIndex1:(NSUInteger)index1 atIndex2:(NSUInteger)index2;

/**
 //将string字符串转换为array数组
 @param string string字符串
 @return 转换后数组
 */
-(NSArray *_Nonnull)stringToArrayWithString:(NSString *_Nonnull)string;

/**
 //将array数组转换为string字符串,分割符是','
 @param array array数组
 @return 转换后字符串
 */
-(NSString *_Nonnull)arrayToStringWithArray:(NSArray *_Nonnull)array;




@end



