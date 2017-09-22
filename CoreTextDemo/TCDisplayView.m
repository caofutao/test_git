//
//  TCDisplayView.m
//  CoreTextDemo
//
//  Created by 曹福涛 on 15/12/5.
//  Copyright © 2015年 曹福涛. All rights reserved.
//

#import "TCDisplayView.h"
#import <CoreText/CoreText.h>

@implementation TCDisplayView


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    
    [super drawRect:rect];
    
    // 步骤 1
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // 步骤 2
    CGContextSetTextMatrix(context, CGAffineTransformIdentity);
    CGContextTranslateCTM(context, 0, self.bounds.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    
    // 步骤 3
//    CGMutablePathRef path = CGPathCreateMutable();
//    CGPathAddRect(path, NULL, self.bounds);
    
    // 步骤 4
//    NSAttributedString *attString = [[NSAttributedString alloc] initWithString:@"Hello World!"];
//    CTFramesetterRef framesetter =
//    CTFramesetterCreateWithAttributedString((CFAttributedStringRef)attString);
//    CTFrameRef frame =
//    CTFramesetterCreateFrame(framesetter,
//                             CFRangeMake(0, [attString length]), path, NULL);
    
    // 步骤 5
    CTFrameDraw(self.data.ctFrame, context);
    
    for (CoreTextImageData * imageData in self.data.imageArray) {
        UIImage *image = [UIImage imageNamed:imageData.name];
        if (image) {
            CGContextDrawImage(context, imageData.imagePosition, image.CGImage);
        }
    }
    
    // 步骤 6
//    CFRelease(frame);
//    CFRelease(path);
//    CFRelease(framesetter);
}


@end
