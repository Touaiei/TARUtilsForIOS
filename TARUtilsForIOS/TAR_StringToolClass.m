//
//  TAR_StringToolClass.m
//  LLG
//
//  Created by GL on 16/11/4.
//  Copyright © 2016年 beijiguang. All rights reserved.
//

#import "TAR_StringToolClass.h"
#import <CoreGraphics/CoreGraphics.h>
#import <UIKit/UIKit.h>
#import <CommonCrypto/CommonDigest.h>

@implementation TAR_StringToolClass
/*
 计算单行文本宽度
 */
+(CGSize)calculateTextSize:(NSString *)text andFont:(double)fontSize andMaxW:(double)maxW andMaxH:(double)maxH
{
    //这个frame是初设的，没关系，后面还会重新设置其size。
    NSString *str = text;
    NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:fontSize],};
    /**
     *  @param 200 限制的最大宽度
     *  @param 50 限制最大高度
     */
    CGSize textSize = [str boundingRectWithSize:CGSizeMake(maxW, maxH) options:NSStringDrawingTruncatesLastVisibleLine attributes:attributes context:nil].size;
    return textSize;
}
/*
 计算多行文本高度(不带行间距的情况)
 */
+(CGSize)calculateTextHeightWithText:(NSString *)text andFont:(double)fontSize andWidth:(double)width
{
    if (fontSize <= 0) {
        fontSize = 17.0;
    }
    NSString *textContent = text;
    CGSize titleSize = [textContent boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:fontSize]} context:nil].size;
    return titleSize;
}

/*
 设置多行文本（带有行间距的情况）
 */
+(void)setTextLineSpaceWithLabel:(UILabel*)label withSpace:(CGFloat)lineSpace withValue:(NSString*)str withFont:(UIFont*)font {
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    paraStyle.lineBreakMode = NSLineBreakByCharWrapping;
    paraStyle.alignment = NSTextAlignmentLeft;
    paraStyle.lineSpacing = lineSpace; //设置行间距
    paraStyle.hyphenationFactor = 1.0;
    paraStyle.firstLineHeadIndent = 0.0;
    paraStyle.paragraphSpacingBefore = 0.0;
    paraStyle.headIndent = 0;
    paraStyle.tailIndent = 0;
    //设置字间距 NSKernAttributeName:@1.5f
    NSDictionary *dic = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paraStyle, NSKernAttributeName:@1.5f
                          };
    NSAttributedString *attributeStr = [[NSAttributedString alloc] initWithString:str attributes:dic];
    label.attributedText = attributeStr;
}
/*
 计算多行文本高度(带有行间距的情况)
 */
+(CGSize)getTextLineSpaceHeightWithValue:(NSString*)str withFont:(UIFont*)font withWidth:(CGFloat)width withSpace:(CGFloat)lineSpace withMaxH:(CGFloat)maxH
{
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    paraStyle.lineBreakMode = NSLineBreakByCharWrapping;
    paraStyle.alignment = NSTextAlignmentLeft;
    paraStyle.lineSpacing = lineSpace;
    paraStyle.hyphenationFactor = 1.0;
    paraStyle.firstLineHeadIndent = 0.0;
    paraStyle.paragraphSpacingBefore = 0.0;
    paraStyle.headIndent = 0;
    paraStyle.tailIndent = 0;
    
    NSDictionary *dic = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paraStyle, NSKernAttributeName:@1.5f
                          };
    CGSize size = [str boundingRectWithSize:CGSizeMake(width, maxH) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil].size;
    return size;
}




/*
 创建UIImage，通过UIColor转换成UIImage
 */
+(UIImage*)createImageWithColor:(UIColor*)color
{
    CGRect rect=CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}


/**
 将String里面的每个字符取出来转换成ASCII码，然后依顺序拼接成新的ASCII码String
 @param string 需要转换的String
 @return 返回转换后的ASCII码String
 */
+(NSString *)stringToASCIICodeFromString:(NSString *)string
{
    NSMutableString *ASCIICodeString = [[NSMutableString alloc]init];
    for (int i=0 ;i<string.length;i++)
    {
        int asciiCode = [string characterAtIndex:i]; //65
//        NSLog(@"asciiCode==%d",asciiCode);
        [ASCIICodeString appendString:[NSString stringWithFormat:@"%d",asciiCode]];
    }
    return ASCIICodeString;
}
/**
 把传入的字典参数按Key排序（从第一个字母开始，如果第一个字母无法排出结果，就排第二个，依次后推），最后取出对应的value依次拼接形成一个字符串，再把该字符串传入MD5加密方法加密，形成最终的签名字符串
 @return 返回排序后的签名字符串
 */
+(NSString *)getSignWithDictionary:(NSDictionary *)Dic
{
    NSString *signString = [[NSString alloc]init];
    NSArray *keysArray = [self arraySortASC:[Dic allKeys]];
    for (NSString *key in keysArray) {
        NSString *value = [Dic objectForKey:key];
        //        [muString stringByAppendingString:value];
        signString = [NSString stringWithFormat:@"%@%@",signString,value];
    }
//    signString = [signString stringByAppendingString:@"jdkjzn_app_sign"];
    
    signString = [self addJiaDuanSuffix:signString];
    //    NSLog(@"signString==%@",signString);
    return signString;
}
+(NSString *)addJiaDuanSuffix:(NSString *)dfd
{
    NSString *JiaDuanSignString = [[NSString alloc]init];
    JiaDuanSignString = [dfd stringByAppendingString:@"jdkjzn_app_sign"];
    return JiaDuanSignString;
}

#pragma mark -- 数组按首字母排序方法（升序）
/**
 数组排序按首字母排序（升序）
 @param oldArray 需要排序的旧数组
 @return 排序后的新数组
 */
+(NSArray *)arraySortASC:(NSArray *)oldArray{
    NSMutableArray *firstLetterArray = [NSMutableArray new];
    //对数组进行排序
    for (int i = 0; i<oldArray.count; i++) {
        NSString *firstLetter = [[oldArray objectAtIndex:i] substringToIndex:1];//截取下标1之前的字符串（不含下标1）
        //        NSString *string2 = [[oldArray objectAtIndex:i] substringFromIndex:1];//截取从下标1之后的字符串（包含下标1）
        [firstLetterArray addObject:firstLetter];
    }
    NSArray *resultArray = [oldArray sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        //        NSLog(@"%@~%@",obj1,obj2); //3~4 2~1 3~1 3~2
        return [obj1 compare:obj2]; //升序
        //        return [obj2 compare:obj1]; //降序
    }];
    //    NSLog(@"resultArray==%@",resultArray);
    return resultArray;
}


#pragma mark //--关于json转换--
/*
 传入字典，返回转义之后的json格式的字符串
 */
+(NSString *)arrayOrDictionaryToJSONString:(id)arrayOrDictionaryObject
{
    NSError *parseError;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:arrayOrDictionaryObject options:NSJSONWritingPrettyPrinted error:&parseError];
    NSString *jsonStr = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
    jsonStr = [NSString stringWithFormat:@"%@",jsonStr];
    return jsonStr;
    
}

/*
 传入NSString字符串，返回转义之后的json格式的字符串
 */
+(NSString *)NSStringToJSONString:(NSString *)aString {
    NSMutableString *s = [NSMutableString stringWithString:aString];
    [s replaceOccurrencesOfString:@"\"" withString:@"\\\"" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [s length])];
    [s replaceOccurrencesOfString:@"/" withString:@"\\/" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [s length])];
    [s replaceOccurrencesOfString:@"\n" withString:@"\\n" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [s length])];
    [s replaceOccurrencesOfString:@"\b" withString:@"\\b" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [s length])];
    [s replaceOccurrencesOfString:@"\f" withString:@"\\f" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [s length])];
    [s replaceOccurrencesOfString:@"\r" withString:@"\\r" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [s length])];
    [s replaceOccurrencesOfString:@"\t" withString:@"\\t" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [s length])];
    return [NSString stringWithString:s];
}

/*
 传入json格式的字符串，返回转义之后的字典
 */
+ (NSDictionary *)JsonStringToDictionary:(NSString *)jsonString {
    if (jsonString == nil) {
        return nil;
    }
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err) {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}
/*
 传入json格式的字符串，返回转义之后的数组
 */
+(NSArray *)JsonStringToArray:(NSString *)jsonString {
    if (jsonString == nil) {
        return nil;
    }
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSArray *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                   options:NSJSONReadingMutableContainers
                                                     error:&err];
    if(err) {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}
/*
 传入json格式的字符串，返回转义之后的数组或者字典
  */
+(id)JSONToArray:(NSString *)str;
{
    NSData* data = [str dataUsingEncoding:NSUTF8StringEncoding];
    __autoreleasing NSError* error = nil;
    id result = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    if (error != nil) return nil;
    return result;
}
/*
 传入json格式的字符串，返回转义之后的数组或者字典
 */
+(id)JsonToArrayOrDictionary:(NSString *)str{
    NSError *error = nil;
    NSData *jsonData = [str dataUsingEncoding:NSUTF8StringEncoding];
    id jsonObject = [NSJSONSerialization JSONObjectWithData:jsonData
                                                          options:NSJSONReadingAllowFragments
                                                            error:&error];
    if (jsonObject != nil && error == nil){
        return jsonObject;
    }else{
        // 解析错误
        return nil;
    }
}




/*设备区域*/
#define IS_IPHONE_5 ((int)[[UIScreen mainScreen] bounds].size.width == 320?1:0)
#define IS_IPHONE_6 ((int)[[UIScreen mainScreen] bounds].size.width == 375?1:0)
#define IS_IPHONE_6P ((int)[[UIScreen mainScreen] bounds].size.width == 414?1:0)
/*
 return 返回UIFont对象
 parameter size 传入字体大小（FontSize枚举）
 以iPhone5屏幕大小为基准，iPhone6屏幕字体大小+2，iPhone6P屏幕字体大小+4
 */
+(UIFont *)returnFont:(FontSize)size
{
    if (IS_IPHONE_5) {
        return [UIFont systemFontOfSize:size+0];
    }else if (IS_IPHONE_6){
        return [UIFont systemFontOfSize:size+0];
    }else if (IS_IPHONE_6P){
        return [UIFont systemFontOfSize:size+0];
    }else{
        return [UIFont systemFontOfSize:size];
    }
}

#pragma mark //--32位MD5加密方式--
+(NSString *)MD5_32Bit:(NSString *)str{
    /*
     *str-> 你需要加密的字符串
     *signResult-> 加密后的结果
     */
    const char *cStr = [str UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5( cStr, (int)strlen(cStr), digest );
    NSMutableString *signResult = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [signResult appendFormat:@"%02x", digest[i]];
    return signResult;
}


#pragma mark --判断Dictionary中key是否为空--
+(BOOL)isEqualEmptyFromSingleLayerWithDictionary:(NSDictionary *)dict withKey:(NSString *)key
{
    if (![dict isKindOfClass:[NSDictionary class]]) {
        return YES;
    }
    if ([[dict allKeys] containsObject:key]){
        if ([[dict objectForKey:key] isKindOfClass:[NSDictionary class]]) {
            NSDictionary *valueDic = [dict objectForKey:key];
            if ([valueDic isKindOfClass:[NSNull class]] || [valueDic isEqual:nil] || [valueDic count]<=0) {
                return YES;
            }else{
                //                return NO;
            }
        }else if ([[dict objectForKey:key] isKindOfClass:[NSArray class]]) {
            NSArray *valueArray = [dict objectForKey:key];
            if ([valueArray isKindOfClass:[NSNull class]] || [valueArray isEqual:nil] || [valueArray count]<=0) {
                return YES;
            }else{
                //                return NO;
            }
            
        }else{
            NSString *value = [NSString stringWithFormat:@"%@",[dict objectForKey:key]];
            if ([value isKindOfClass:[NSNull class]] || [value isEqual:nil] || [value isEqualToString:@""] || [value length]<=0) {
                return YES;
            }else{
                //                return NO;
            }
        }
        return NO;
    }else{
        return YES;
    }
//    {
//        NSString *value = [NSString stringWithFormat:@"%@",[dict objectForKey:key]];
//        if ([value isKindOfClass:[NSNull class]] || [value isEqual:nil] || value==NULL || value==nil || [value isEqualToString:@""] || [value length]<=0) {
//            return YES;
//        }else{
//            return NO;
//        }
//    }
    
}
+(BOOL)isEqualEmptyFromMoreLayerWithDictionary:(NSDictionary *)dict withKey:(NSString *)key
{
    if (![dict isKindOfClass:[NSDictionary class]]) {
        return YES;
    }
    if ([[dict allKeys] containsObject:key]) {
        if ([[dict objectForKey:key] isKindOfClass:[NSDictionary class]]) {
            NSDictionary *valueDic = [dict objectForKey:key];
            if ([valueDic isKindOfClass:[NSNull class]] || [valueDic isEqual:nil] || [valueDic count]<=0) {
                return YES;
            }else{
//                return NO;
            }
        }else if ([[dict objectForKey:key] isKindOfClass:[NSArray class]]) {
            NSArray *valueArray = [dict objectForKey:key];
            if ([valueArray isKindOfClass:[NSNull class]] || [valueArray isEqual:nil] || [valueArray count]<=0) {
                return YES;
            }else{
//                return NO;
            }
            
        }else{
            NSString *value = [NSString stringWithFormat:@"%@",[dict objectForKey:key]];
            if ([value isKindOfClass:[NSNull class]] || [value isEqual:nil] || [value isEqualToString:@""] || [value length]<=0) {
                return YES;
            }else{
//                return NO;
            }
        }
        return NO;
    }else{
        if ([[dict objectForKey:key] isKindOfClass:[NSDictionary class]]) {
            NSDictionary *valueDic = [dict objectForKey:key];
            BOOL yesOeNo = [self isEqualEmptyFromDictionary:valueDic key:key];
            if (yesOeNo == YES) {
                return YES;
            }
        }
        if ([[dict objectForKey:key] isKindOfClass:[NSArray class]]) {
            NSArray *valueArray = [dict objectForKey:key];
            for (int i = 0; i<valueArray.count; i++) {
                if ([[valueArray objectAtIndex:i] isKindOfClass:[NSDictionary class]]) {
                    NSDictionary *valueArrayDic = [valueArray objectAtIndex:i];
                    BOOL yesOeNo = [self isEqualEmptyFromDictionary:valueArrayDic key:key];
                    if (yesOeNo == YES) {
                        return YES;
                    }
                }
            }
        }else{
            NSString *value = [NSString stringWithFormat:@"%@",[dict objectForKey:key]];
            if ([value isKindOfClass:[NSNull class]] || [value isEqual:nil] || [value isEqualToString:@""] || [value length]<=0) {
                return YES;
            }
        }
        return NO;
    }
}
+(BOOL)isEqualEmptyFromDictionary:(NSDictionary *)dict key:(NSString *)key
{
    if ([[dict allKeys] containsObject:key]) {
        if ([[dict objectForKey:key] isKindOfClass:[NSDictionary class]]) {
            NSDictionary *valueDic = [dict objectForKey:key];
            if ([valueDic isKindOfClass:[NSNull class]] || [valueDic isEqual:nil] || [valueDic count]<=0) {
                return YES;
            }else{
                //                return NO;
            }
        }else if ([[dict objectForKey:key] isKindOfClass:[NSArray class]]) {
            NSArray *valueArray = [dict objectForKey:key];
            if ([valueArray isKindOfClass:[NSNull class]] || [valueArray isEqual:nil] || [valueArray count]<=0) {
                return YES;
            }else{
                //                return NO;
            }
        }else{
            NSString *value = [NSString stringWithFormat:@"%@",[dict objectForKey:key]];
            if ([value isKindOfClass:[NSNull class]] || [value isEqual:nil] || [value isEqualToString:@""] || [value length]<=0) {
                return YES;
            }else{
                //                return NO;
            }
        }
        return NO;
    }else{
        if ([[dict objectForKey:key] isKindOfClass:[NSDictionary class]]) {
            NSDictionary *valueDic = [dict objectForKey:key];
            BOOL yesOrNo = [self isEqualEmptyFromDictionary:valueDic key:key];
            if (yesOrNo == YES) {
                return YES;
            }
        }
        return NO;
    }
}
#pragma mark --判断String是否为纯浮点数--
+(BOOL)isEqualPureFloat:(NSString*)string{
    NSString *timpString = [NSString stringWithFormat:@"%@",string];
    NSScanner *scan = [NSScanner scannerWithString:timpString];
    float val;
    return[scan scanFloat:&val] && [scan isAtEnd];
}
#pragma mark --判断String是否为纯整数--
+(BOOL)isEqualPureInt:(NSString*)string{
    NSString *timpString = [NSString stringWithFormat:@"%@",string];
    NSScanner *scan = [NSScanner scannerWithString:timpString];
    int val;
    return [scan scanInt:&val] && [scan isAtEnd];
}

#pragma mark --判断String是否为空--
+(BOOL)isEqualEmptyWithString:(NSString *)string {
    if ([self isEqualPureFloat:string] || [self isEqualPureInt:string]) {
        return NO;
    }
//    NSString *str = [NSString stringWithFormat:@"%@",string];
    if (![string isKindOfClass:[NSString class]] || [string isEqualToString:@""] || [string isEqual:[NSNull class]] || [string isKindOfClass:[NSNull class]] || [string length] <= 0 || string == nil || string == NULL) {
        return YES;
    }else{
        return NO;
    }
}

#pragma mark --判断Array是否为空--
+(BOOL)isEqualEmptyWithArray:(NSArray *)array {
    if (![array isKindOfClass:[NSArray class]] || [array isKindOfClass:[NSNull class]] || [array isEqual:[NSNull class]] || [array count]<=0 || array==nil || array ==NULL) {
        return YES;
    }else{
        return NO;
    }
}

#pragma mark --判断Dictionary是否为空--
+(BOOL)isEqualEmptyWithDictionary:(NSDictionary *)dictionary {
    if (![dictionary isKindOfClass:[NSDictionary class]] || [dictionary isKindOfClass:[NSNull class]] || [dictionary isEqual:[NSNull class]] || [dictionary count]<=0 || dictionary==nil || dictionary ==NULL) {
        return YES;
    }else{
        return NO;
    }
}

/**
 打开系统设置
 */
+(void)openSettings
{
    NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
    if ([[UIApplication sharedApplication] canOpenURL:url]) {
        [[UIApplication sharedApplication] openURL:url];
    }
}

//把字符串替换成星号
+(NSString *)replaceStringWithAsterisk:(NSString *)originalStr startLocation:(NSInteger)startLocation lenght:(NSInteger)lenght
{
    if ([[self class]isEqualEmptyWithString:originalStr]) {
        return @"";
    }
    if ([originalStr length] < (startLocation + lenght)) {
        return @"";
    }
    NSString *newStr = originalStr;
    for (int i = 0; i < lenght; i++) {
        NSRange range = NSMakeRange(startLocation, 1);
        newStr = [newStr stringByReplacingCharactersInRange:range withString:@"*"];
        startLocation ++;
    }
    return newStr;
}


/**
 Dictionary转换，替换旧Dictionary中所有为空（nil NULL）的值，并返回新的Dictionary，防止后续使用造成崩溃。
 @param oldDictionary 旧Dictionary
 @return 返回新Dictionary
 */
+(NSMutableDictionary *)dictionaryToNewDictionaryWithOldDictionary:(NSDictionary *)oldDictionary
{
    NSMutableDictionary *muDict = [[NSMutableDictionary alloc]init];
    for (int i=0; i<[oldDictionary allKeys].count; i++) {
        NSString *key = [[oldDictionary allKeys] objectAtIndex:i];
        if ([[[oldDictionary allValues] objectAtIndex:i] isKindOfClass:[NSDictionary class]]) {
            NSDictionary *value = [[oldDictionary allValues] objectAtIndex:i];
            if ([[self class] isEqualEmptyWithDictionary:value]) {
                [muDict setObject:[NSDictionary new] forKey:key];
            }else{
                [muDict setObject:value forKey:key];
            }
        }else if ([[[oldDictionary allValues] objectAtIndex:i] isKindOfClass:[NSArray class]]){
            NSArray *value = [[oldDictionary allValues] objectAtIndex:i];
            if ([[self class] isEqualEmptyWithArray:value]) {
                [muDict setObject:[NSArray new] forKey:key];
            }else{
                [muDict setObject:value forKey:key];
            }
        }else{
            NSString *value = [NSString stringWithFormat:@"%@",[[oldDictionary allValues] objectAtIndex:i]];
            if ([[self class] isEqualEmptyWithString:value]) {
                [muDict setObject:[NSString new] forKey:key];
            }else{
                [muDict setObject:value forKey:key];
            }
        }
    }
    return muDict;
}


#pragma mark //--序列化，Dictionary或Array中所有Null空类型类型转换成@""--
/**
 序列化Dictionary，将NSDictionary中的Null类型的项目转化成@""
 @param myDic 转换前的旧Dictionary
 @return 返回转换后的新Dictionary
 */
+(NSDictionary *)nullToNonnullWithDictionary:(nonnull NSDictionary *)myDic
{
    NSArray *keyArr = [myDic allKeys];
    NSMutableDictionary *resDic = [[NSMutableDictionary alloc]init];
    for (int i = 0; i < keyArr.count; i ++)
    {
        id obj = [myDic objectForKey:keyArr[i]];
        
        obj = [self changeType:obj];
        
        [resDic setObject:obj forKey:keyArr[i]];
    }
    return resDic;
}
/**
 序列化NSArray，将NSArray中的Null类型的项目转化成@""
 @param myArr 转换前的旧Array
 @return 返回转换后的新Array
 */
+(NSArray *)nullToNonnullWithArray:(NSArray *)myArr
{
    NSMutableArray *resArr = [[NSMutableArray alloc] init];
    for (int i = 0; i < myArr.count; i ++)
    {
        id obj = myArr[i];
        
        obj = [self changeType:obj];
        
        [resArr addObject:obj];
    }
    return resArr;
}
/**
 将NSString类型的原路返回
 */
+(NSString *)stringToString:(NSString *)string
{
    return string;
}
//将Null类型的项目转化成@""
/**
 将Null类型的项目转化成@""
 @return @""
 */
+(NSString *)nullToString
{
    return @"";
}
/**
 将NSNumber类型的项目转化成NSString
 @param number number
 @return NSString
 */
+(NSString *)numberToString:(NSNumber *)number
{
    return [NSString stringWithFormat:@"%@",number];
}
//主要方法
//类型识别:将所有的NSNull类型转化成@""
+(id)changeType:(id)myObj
{
    if ([myObj isKindOfClass:[NSDictionary class]]){
        return [self nullToNonnullWithDictionary:myObj];
    }else if([myObj isKindOfClass:[NSArray class]]){
        return [self nullToNonnullWithArray:myObj];
    }else if([myObj isKindOfClass:[NSString class]]){
        return [self stringToString:myObj];
    }else if([myObj isKindOfClass:[NSNull class]]){
        return [self nullToString];
    }else if ([myObj isKindOfClass:[NSNumber class]]){
        return [self numberToString:myObj];
    }else{
        return myObj;
    }
}
#pragma mark --序列化，Dictionary或Array中所有Null空类型类型转换成@""--//


#pragma mark --颜色渐变--
/**
 颜色渐变——>线性渐变
 @param view 目标View
 @param alpha 设置透明度alpha
 */
+(void)colorGradientForStatusBar:(UIView *)view alpha:(CGFloat)alpha
{/*主要用于线性渐变*/
    //初始化GradientLayer
    CAGradientLayer *gradientLayer = [[CAGradientLayer alloc] init];
    UIColor *colorOne = [UIColor colorWithRed:0 green:0 blue:0 alpha:alpha];
    UIColor *colorTwo = [UIColor clearColor];
    gradientLayer.colors = @[(__bridge id)colorOne.CGColor,(__bridge id)colorTwo.CGColor];//可以指定多个渐变颜色（渐变时以该颜色顺序渐变）
    gradientLayer.locations = @[@(0.1),@(1.0)];//控制各个颜色的中心位置（范围0——1）
    //位置x,y 自己根据需求进行设置 使其从不同位置进行渐变，并控制渐变方向
    gradientLayer.startPoint = CGPointMake(0, 0);//指定渐变起始位置（渐变开始方向）
    gradientLayer.endPoint = CGPointMake(0, 1);//指定渐变结束位置（渐变结束方向）
    gradientLayer.frame = CGRectMake(0, 0, CGRectGetWidth(view.frame), CGRectGetHeight(view.frame));//指定gradientLayer frame范围
    [view.layer addSublayer:gradientLayer];
}

/**
 颜色渐变——》线性渐变
 @param view 目标View
 @param startColor 开始颜色（可以设置透明度alpha）
 @param endColor 结束颜色（可以设置透明度alpha）
 */
+(void)colorGradientLinearForView:(UIView *)view startColor:(UIColor *)startColor endColor:(UIColor *)endColor
{/*主要用于线性渐变*/
    //初始化GradientLayer
    CAGradientLayer *gradientLayer = [[CAGradientLayer alloc] init];
    //    UIColor *colorOne = [UIColor colorWithRed:0 green:0 blue:0 alpha:alpha];
    //    UIColor *colorTwo = [UIColor clearColor];
    UIColor *colorOne = startColor;
    UIColor *colorTwo = endColor;
    gradientLayer.colors = @[(__bridge id)colorOne.CGColor,(__bridge id)colorTwo.CGColor];//可以指定多个渐变颜色（渐变时以该颜色顺序渐变）
    gradientLayer.locations = @[@(0.1),@(1.0)];//控制各个颜色的中心位置（范围0——1）
    //位置x,y 自己根据需求进行设置 使其从不同位置进行渐变，并控制渐变方向
    gradientLayer.startPoint = CGPointMake(0, 0);//指定渐变起始位置（渐变开始方向）
    gradientLayer.endPoint = CGPointMake(0, 1);//指定渐变结束位置（渐变结束方向）
    gradientLayer.frame = CGRectMake(0, 0, CGRectGetWidth(view.frame), CGRectGetHeight(view.frame));//指定gradientLayer frame范围
    
    for (int i=0; i<view.layer.sublayers.count; i++) {
        CALayer *lay = [view.layer.sublayers firstObject];
        if (([lay isKindOfClass:[CALayer class]] && ![lay isKindOfClass:[NSNull class]])) {
            [lay removeFromSuperlayer];
        }
    }
    [view.layer insertSublayer:gradientLayer atIndex:0];
}

/**
 设置View边框颜色及粗细
 */
+(void)layerBorderColorAndborderWidth:(UIView *)view borderColor:(UIColor *)bColor borderWidth:(CGFloat)bWidth
{
    if (view == nil || bColor == nil || bWidth<0) {
        return;
    }
    view.layer.borderColor = bColor.CGColor;
    view.layer.borderWidth = bWidth;
}

#pragma mark --获取当前时间戳
+(NSString *)GetTimestamp
{
    /*----获取当前时间戳-----*/
    NSDate* date = [NSDate date];
    NSTimeInterval time=[date timeIntervalSince1970];//秒
    //    NSTimeInterval time=[dat timeIntervalSince1970]*1000;//毫秒
    NSString *timeStamp = [NSString stringWithFormat:@"%ld",(long)time];
    NSLog(@"时间戳timeString==>%@",timeStamp);
    /*-----获取当前时间戳-----*/
    return timeStamp;
}

#pragma mark --由于WebVeiw加载网页时,网址URL中不能含有中文,所以需要把中文转码
/**
 *  @param input 传入的中文
 *  @return 完成转码后返回结果
 */
+(NSString *)encodeToPercentEscapeString:(NSString *)input
{
    NSString *outputStr = (__bridge NSString *)CFURLCreateStringByAddingPercentEscapes(
                                                                                       NULL, /* allocator */
                                                                                       (__bridge CFStringRef)input,
                                                                                       NULL, /* charactersToLeaveUnescaped */
                                                                                       (CFStringRef)@"!*'();:@&=+$,/?%#[]",kCFStringEncodingUTF8);
    return outputStr;
}


/**
 比较版本号大小
 @param appStoreVersion appStoreVersion
 @param nativeVesion nativeVesion
 @return appStoreVersion > nativeVesion ? return YES : return NO
 */
+(BOOL)compareVesionWithServerVersion:(NSString *)appStoreVersion  nativeVesion:(NSString *)nativeVesion {
    if (appStoreVersion == nil || nativeVesion == nil) {
        return NO;
    }
    NSArray *appStoreVersionArray = [appStoreVersion componentsSeparatedByString:@"."];//服务器返回版本
    NSArray *currentVesionArray = [nativeVesion componentsSeparatedByString:@"."];//当前版本
    NSInteger count = (appStoreVersionArray.count> currentVesionArray.count)?currentVesionArray.count : appStoreVersionArray.count;
    for (int i = 0; i< count; i++) {
        NSInteger a = [[appStoreVersionArray objectAtIndex:i] integerValue];
        NSInteger b = [[currentVesionArray objectAtIndex:i] integerValue];
        //        NSInteger a = [[versionArray safeObjectAtIndex:i] integerValue];
        //        NSInteger b = [[currentVesionArray safeObjectAtIndex:i] integerValue];
        if (a > b) {
            NSLog(@"有新版本！");
            return YES;
        }
    }
    if (appStoreVersionArray.count > currentVesionArray.count) {
        NSLog(@"有新版本！");
        return YES;
    }else{
        return NO;
    }
}


/**
 为UIImageView设置image，同时进行判空的一系列操作
 @param imageView 需要设值的UIImageView
 @param imagePath image路径（可以是本地图片路径，也可以是网络图片路径）
 @param placeholder 占位图（可为nil）
 */
+(void)setImageWithImageView:(UIImageView *)imageView imagePath:(NSString * _Nullable)imagePath placeholder:(UIImage * _Nullable)placeholder
{
    if ([TAR_StringToolClass isEqualEmptyWithString:imagePath]) {
        if ([imageView isKindOfClass:[UIImageView class]]) {
            imageView.image = [placeholder isKindOfClass:[UIImage class]]?placeholder:Macro_PlaceholderImage;
        }else{
        }
    }else{
        if ([imageView isKindOfClass:[UIImageView class]]) {
            if ([imagePath hasPrefix:@"http"]) {
                [imageView sd_setImageWithURL:[NSURL URLWithString:imagePath] placeholderImage:[placeholder isKindOfClass:[UIImage class]]?placeholder:Macro_PlaceholderImage];
            }else{
                imageView.image = [UIImage imageNamed:imagePath];
            }
        }else{
        }
    }
}

/**
 获取一个随机整数，范围在[from,to），包括from，包括to
 @param from 从
 @param to 到
 @return 随机整数
 */
+(int)getRandomNumberWithFrom:(int)from to:(int)to;
{
    return (int)(from + (arc4random() % (to - from + 1)));
}

/**
 数组内交互两个元素的位置
 @param array 需要交互元素位置的数组
 @param index1 索引1
 @param index2 索引2
 @return 返回交换后的新数组，如果交换失败则返回原数组
 */
-(NSMutableArray *)arrayExchangeObjectWithArray:(NSMutableArray *)array atIndex1:(NSUInteger)index1 atIndex2:(NSUInteger)index2
{
    if (array.count > index1 && array.count > index2) {
        [array exchangeObjectAtIndex:index1 withObjectAtIndex:index2];
        return array;
    }else{
        return array;
    }
}


/**
 //将string字符串转换为array数组
 @param string string字符串
 @return 转换后数组
 */
-(NSArray *)stringToArrayWithString:(NSString *)string
{
    if (![string containsString:@","]) {
        return [[NSArray alloc]init];
    }
    NSArray *array = [string componentsSeparatedByString:@","];//分隔符逗号
    return array;
}


/**
 //将array数组转换为string字符串,分割符是','
 @param array array数组
 @return 转换后字符串
 */
-(NSString *)arrayToStringWithArray:(NSArray *)array
{
    NSString *string = [array componentsJoinedByString:@","];//分隔符逗号
    return string;
}


@end

