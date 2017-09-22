//
//  TCFrameParser.h
//  CoreTextDemo
//
//  Created by 曹福涛 on 15/12/5.
//  Copyright © 2015年 曹福涛. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CoreTextData.h"
@interface TCFrameParser : NSObject

+ (CoreTextData *)parseContent:(NSString *)content;
+ (CoreTextData *)parseAttributedContent:(NSAttributedString *)content;

@end
