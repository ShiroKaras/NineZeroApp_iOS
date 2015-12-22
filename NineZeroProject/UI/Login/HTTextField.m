//
//  HTTextField.m
//  NineZeroProject
//
//  Created by ronhu on 15/12/23.
//  Copyright © 2015年 ronhu. All rights reserved.
//

#import "HTTextField.h"

@implementation HTTextField

- (CGRect)caretRectForPosition:(UITextPosition *)position {
    CGRect originalRect = [super caretRectForPosition:position];
    originalRect.size.height = self.font.lineHeight + 10;
    return originalRect;
}

@end
