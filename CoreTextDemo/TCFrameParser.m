//
//  TCFrameParser.m
//  CoreTextDemo
//
//  Created by 曹福涛 on 15/12/5.
//  Copyright © 2015年 曹福涛. All rights reserved.
//
#define kWIDTH 100
#import "TCFrameParser.h"
#import <UIKit/UIKit.h>

@implementation TCFrameParser

static CGFloat ascentCallback(void *ref){
    return 10;
}

static CGFloat descentCallback(void *ref){
    return 0;
}

static CGFloat widthCallback(void* ref){
    return 20;
}

+ (NSMutableDictionary *)attributesWithConfig {
    CGFloat fontSize = 12.0f;
    CTFontRef fontRef = CTFontCreateWithName((CFStringRef)@"ArialMT", fontSize, NULL);
    CGFloat lineSpacing = 7.0f;
    const CFIndex kNumberOfSettings = 3;
    
    CTParagraphStyleSetting theSettings[kNumberOfSettings] = {
        { kCTParagraphStyleSpecifierLineSpacingAdjustment, sizeof(CGFloat), &lineSpacing },
        { kCTParagraphStyleSpecifierMaximumLineSpacing, sizeof(CGFloat), &lineSpacing },
        { kCTParagraphStyleSpecifierMinimumLineSpacing, sizeof(CGFloat), &lineSpacing }
    };
    
    CTParagraphStyleRef theParagraphRef = CTParagraphStyleCreate(theSettings, kNumberOfSettings);
    
    
    UIColor * textColor = [UIColor blackColor];
    
    NSMutableDictionary * dict = [NSMutableDictionary dictionary];
    dict[(id)kCTForegroundColorAttributeName] = (id)textColor.CGColor;
    dict[(id)kCTFontAttributeName] = (__bridge id)fontRef;
    dict[(id)kCTParagraphStyleAttributeName] = (__bridge id)theParagraphRef;
    
    CFRelease(theParagraphRef);
    CFRelease(fontRef);
    return dict;
}

+ (CoreTextData *)parseContent:(NSString *)content {
    NSMutableArray *imageArray = [NSMutableArray array];
    
    NSAttributedString *attrString = [self attributedStringWithContent:content imageArray:imageArray];
    CoreTextData *data = [self parseAttributedContent:attrString];
    data.imageArray = imageArray;
    
    return data;
}

+ (NSAttributedString *)attributedStringWithContent:(NSString *)content imageArray:(NSMutableArray *)imageArray{
    NSArray *array = [content componentsSeparatedByString:@"#"];
    NSMutableAttributedString *result = [[NSMutableAttributedString alloc] init];
    
    for (NSString *str in array) {
        if ([str isEqualToString:@"1"]||[str isEqualToString:@"2"] || [str isEqualToString:@"3"] || [str isEqualToString:@"4"]) {
            // 创建 CoreTextImageData
            CoreTextImageData *imageData = [[CoreTextImageData alloc] init];
            imageData.name = str;
            switch ([str intValue]) {
                case 1:
                    imageData.name = @"icon_aircraft_comment";
                    break;
                case 2:
                    imageData.name = @"icon_train_comment";
                    break;
                case 3:
                    imageData.name = @"icon_bus_comment";
                    break;
                case 4:
                    imageData.name = @"icon_train_comment";
                    break;
                default:
                    break;
            }
            imageData.position = [result length];
            [imageArray addObject:imageData];
            // 创建空白占位符，并且设置它的CTRunDelegate信息
            NSAttributedString *as = [self parseImageDataWithString:str];
            [result appendAttributedString:as];
        }
        else
        {
            NSDictionary *attrs = [self attributesWithConfig];
           
            NSAttributedString *as = [[NSAttributedString alloc] initWithString:str attributes:attrs];
            
            [result appendAttributedString:as];
        }
    }
    return result;
}

+ (NSAttributedString *)parseImageDataWithString:(NSString *)str {
    CTRunDelegateCallbacks callbacks;
    memset(&callbacks, 0, sizeof(CTRunDelegateCallbacks));
    callbacks.version = kCTRunDelegateVersion1;
    callbacks.getAscent = ascentCallback;
    callbacks.getDescent = descentCallback;
    callbacks.getWidth = widthCallback;
    CTRunDelegateRef delegate = CTRunDelegateCreate(&callbacks, (__bridge void *)(str));
    
    // 使用0xFFFC作为空白的占位符
    unichar objectReplacementChar = 0xFFFC;
    NSString * content = [NSString stringWithCharacters:&objectReplacementChar length:1];
    
    NSDictionary *attrs = [self attributesWithConfig];
    NSMutableAttributedString * space = [[NSMutableAttributedString alloc] initWithString:content attributes:attrs];
    CFAttributedStringSetAttribute((CFMutableAttributedStringRef)space, CFRangeMake(0, 1),
                                   kCTRunDelegateAttributeName, delegate);
    CFRelease(delegate);
    return space;
}

+ (CoreTextData *)parseAttributedContent:(NSAttributedString *)content {
    
    //1. 创建CTFramesetterRef实例
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)content);
    
    // 获得要绘制的区域的高度
    CGSize restrictSize = CGSizeMake(kWIDTH, CGFLOAT_MAX);
    CGSize coreTextSize = CTFramesetterSuggestFrameSizeWithConstraints(framesetter, CFRangeMake(0,0), nil, restrictSize, nil);
    CGFloat textHeight = coreTextSize.height;
    
    // 生成CTFrameRef实例
    CTFrameRef frame = [self createFrameWithFramesetter:framesetter height:textHeight];
    
    // 将生成好的CTFrameRef实例和计算好的缓制高度保存到CoreTextData实例中，最后返回CoreTextData实例
    CoreTextData *data = [[CoreTextData alloc] init];
    data.ctFrame = frame;
    data.height = textHeight;
    data.content = content;
    
    // 释放内存
    CFRelease(frame);
    CFRelease(framesetter);
    return data;
}

+ (CTFrameRef)createFrameWithFramesetter:(CTFramesetterRef)framesetter
                                  height:(CGFloat)height {
    
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, NULL, CGRectMake(0, 0, kWIDTH, height));
    
    CTFrameRef frame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, 0), path, NULL);
    CFRelease(path);
    return frame;
}

@end
