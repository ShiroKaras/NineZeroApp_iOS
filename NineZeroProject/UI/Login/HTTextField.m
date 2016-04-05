//
//  HTTextField.m
//  NineZeroProject
//
//  Created by HHHHTTTT on 15/12/23.
//  Copyright © 2015年 HHHHTTTT. All rights reserved.
//

#import "HTTextField.h"

@implementation HTTextField

- (CGRect)caretRectForPosition:(UITextPosition *)position {
    CGRect originalRect = [super caretRectForPosition:position];
    originalRect.size.height = self.font.lineHeight + 10;
    return originalRect;
}

@end
