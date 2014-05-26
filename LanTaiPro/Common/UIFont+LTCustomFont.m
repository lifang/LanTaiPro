//
//  UIFont+LTCustomFont.m
//  LanTaiPro
//
//  Created by comdosoft on 14-5-20.
//  Copyright (c) 2014年 LanTaiPro. All rights reserved.
//

#import "UIFont+LTCustomFont.h"
#import <objc/runtime.h>

@implementation UIFont (LTCustomFont)

static NSDictionary *iBCustomFontsDict;

+(void)load {
    iBCustomFontsDict = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"LTCustomFonts"];
    NSArray *methods = @[@"fontWithName:size:", @"fontWithName:size:traits:", @"fontWithDescriptor:size:"];
    for (NSString* methodName in methods) {
        Method from = class_getClassMethod([UIFont class], NSSelectorFromString(methodName)), to = class_getClassMethod([UIFont class], NSSelectorFromString([NSString stringWithFormat:@"new_%@",methodName]));
        if (from && to && strcmp(method_getTypeEncoding(from), method_getTypeEncoding(to)) == 0) method_exchangeImplementations(from, to);
    }
}
+(UIFont*)new_fontWithName:(NSString*)fontName size:(CGFloat)fontSize {
	return [self new_fontWithName:[iBCustomFontsDict objectForKey:fontName] ?: fontName size:fontSize];
}
+(UIFont*)new_fontWithName:(NSString*)fontName size:(CGFloat)fontSize traits:(int)traits {
	return [self new_fontWithName:[iBCustomFontsDict objectForKey:fontName] ?: fontName size:fontSize traits:traits];
}

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 70000
+(UIFont*)new_fontWithDescriptor:(UIFontDescriptor*)descriptor size:(CGFloat)fontSize {
    NSString* newName = [iBCustomFontsDict objectForKey:[descriptor.fontAttributes objectForKey:UIFontDescriptorNameAttribute]];
    return [self new_fontWithDescriptor: newName ? [UIFontDescriptor fontDescriptorWithName:newName size:fontSize] : descriptor size:fontSize];
}
#endif


@end
