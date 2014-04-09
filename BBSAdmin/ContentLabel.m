//
//  ContentLabel.m
//  BBSAdmin
//
//  Created by HE BIAO on 3/17/14.
//  Copyright (c) 2014 newsmth. All rights reserved.
//

#import "ContentLabel.h"

@implementation ContentLabel

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setContentInfo:(NSString *)text
{
    attString = [[NSMutableAttributedString alloc] initWithString:@""];
    
    UIFont * font = [self font];
    CTFontRef font_ref = CTFontCreateWithName((CFStringRef)font.fontName, font.pointSize, nil);
    
    prev_line_empty = false;
    
    [text enumerateLinesUsingBlock:^(NSString *line, BOOL *stop) {
        bool is_quota = false;
        
        unsigned long len = [line length];
        
        if(len == 0){
            prev_line_empty = true;
            return;
        }else{
            if(len >= 2){
                NSString * head = [line substringToIndex:2];
                if([head isEqualToString:@": "]){
                    is_quota = true;
                }
                if(len == 2 && [head isEqualToString:@"--"]){
                    *stop = YES;
                    return;
                }
            }
            
            if(prev_line_empty){
                NSDictionary * attrs = [NSDictionary dictionaryWithObjectsAndKeys:(id)[UIColor blackColor].CGColor, kCTForegroundColorAttributeName, font_ref, kCTFontAttributeName, [UIColor whiteColor].CGColor, (NSString *)kCTStrokeColorAttributeName, [NSNumber numberWithFloat:0.0f],(NSString *)kCTStrokeWidthAttributeName, nil];
                
                [attString appendAttributedString:[[NSAttributedString alloc] initWithString:@"\n" attributes:attrs]];
                prev_line_empty = false;
            }
        }

        if(is_quota){
            NSDictionary * attrs = [NSDictionary dictionaryWithObjectsAndKeys:(id)[UIColor grayColor].CGColor, kCTForegroundColorAttributeName, font_ref, kCTFontAttributeName, [UIColor whiteColor].CGColor, (NSString *)kCTStrokeColorAttributeName, [NSNumber numberWithFloat:0.0f],(NSString *)kCTStrokeWidthAttributeName, nil];
            
            [attString appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@\n",line] attributes:attrs]];
        }else{
            NSDictionary * attrs = [NSDictionary dictionaryWithObjectsAndKeys:(id)[UIColor blackColor].CGColor, kCTForegroundColorAttributeName, font_ref, kCTFontAttributeName, [UIColor whiteColor].CGColor, (NSString *)kCTStrokeColorAttributeName, [NSNumber numberWithFloat:0.0f],(NSString *)kCTStrokeWidthAttributeName, nil];
            
            [attString appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@\n",line] attributes:attrs]];
        }
    }];
    
    CFRelease(font_ref);
}

- (CGFloat)get_height
{
    CGFloat total_height = 0;
    
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)attString);
    CGRect drawingRect = CGRectMake(0, 0, self.frame.size.width, 50000);  //这里的高要设置足够大
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, NULL, drawingRect);
    CTFrameRef textFrame = CTFramesetterCreateFrame(framesetter,CFRangeMake(0,0), path, NULL);
    CGPathRelease(path);
    CFRelease(framesetter);
    
    NSArray *linesArray = (NSArray *) CTFrameGetLines(textFrame);
    if([linesArray count] == 0){
        return 0;
    }
    
    CGPoint origins[[linesArray count]];
    CTFrameGetLineOrigins(textFrame, CFRangeMake(0, 0), origins);
    
    CGFloat line_y = origins[[linesArray count] -1].y;  //最后一行line的原点y坐标
    
    CGFloat ascent;
    CGFloat descent;
    CGFloat leading;
    
    CTLineRef line = (__bridge CTLineRef) [linesArray objectAtIndex:[linesArray count]-1];
    CTLineGetTypographicBounds(line, &ascent, &descent, &leading);
    
    total_height = 50000 - line_y + descent +1;    //+1为了纠正descent转换成int小数点后舍去的值
    
    CFRelease(textFrame);
    
    return total_height;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetTextMatrix(context, CGAffineTransformIdentity);
    CGContextTranslateCTM(context, 0, self.bounds.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, NULL, self.bounds);
    
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)attString);
    CTFrameRef frame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, [attString length]), path, NULL);
    CTFrameDraw(frame, context);
    
    CFRelease(frame);
    CFRelease(path);
    CFRelease(framesetter);
}

@end
