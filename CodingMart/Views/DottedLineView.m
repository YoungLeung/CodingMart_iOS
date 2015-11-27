//
//  DottedLineView.m
//  CodingMart
//
//  Created by HuiYang on 15/11/20.
//  Copyright © 2015年 net.coding. All rights reserved.
//

#import "DottedLineView.h"

@interface DottedLineView ()

{
    CAShapeLayer  *_shapeLayer;
}

@end

@implementation DottedLineView

-(id)initWithCoder:(NSCoder *)aDecoder
{
    self =[super initWithCoder:aDecoder];
    if (self)
    {
    
        [self buildUI];
    }
    
    return self;
}

-(void)buildUI
{
    CGRect rec =self.bounds;
    rec.size.width=kScreen_Width-30;
    UIBezierPath *path      = [UIBezierPath bezierPathWithRect:rec];
    _shapeLayer             = (CAShapeLayer *)self.layer;
    _shapeLayer.fillColor   = [UIColor clearColor].CGColor;
    _shapeLayer.strokeStart = 0.001;
    _shapeLayer.strokeEnd   = 0.499;
    _shapeLayer.lineWidth   = 0.5;
    _shapeLayer.path        = path.CGPath;
    
    self.lineDashPattern = @[@5, @5];
    self.endOffset       = 0.495;
    self.backgroundColor = [UIColor colorWithHexString:@"CCCCCC"];
}

//- (id)initWithFrame:(CGRect)frame
//{
//    self = [super initWithFrame:frame];
//    if (self)
//    {
//        UIBezierPath *path      = [UIBezierPath bezierPathWithRect:self.bounds];
//        _shapeLayer             = (CAShapeLayer *)self.layer;
//        _shapeLayer.fillColor   = [UIColor clearColor].CGColor;
//        _shapeLayer.strokeStart = 0.001;
//        _shapeLayer.strokeEnd   = 0.499;
//        _shapeLayer.lineWidth   = frame.size.height;
//        _shapeLayer.path        = path.CGPath;
//    }
//    return self;
//}


- (instancetype)initWithFrame:(CGRect)frame
              lineDashPattern:(NSArray *)lineDashPattern
                    endOffset:(CGFloat)endOffset
{
    DottedLineView *lineDashView   = [[DottedLineView alloc] initWithFrame:frame];
    lineDashView.lineDashPattern = lineDashPattern;
    lineDashView.endOffset       = endOffset;
    
    return lineDashView;
}

#pragma mark - 修改view的backedLayer为CAShapeLayer
+ (Class)layerClass
{
    return [CAShapeLayer class];
}

#pragma mark - 改写属性的getter,setter方法
@synthesize lineDashPattern = _lineDashPattern;
- (void)setLineDashPattern:(NSArray *)lineDashPattern
{
    _lineDashPattern            = lineDashPattern;
    _shapeLayer.lineDashPattern = lineDashPattern;
}
- (NSArray *)lineDashPattern
{
    return _lineDashPattern;
}

@synthesize endOffset = _endOffset;
- (void)setEndOffset:(CGFloat)endOffset
{
    _endOffset = endOffset;
    if (endOffset < 0.499 && endOffset > 0.001)
    {
        _shapeLayer.strokeEnd = _endOffset;
    }
}
- (CGFloat)endOffset
{
    return _endOffset;
}

#pragma mark - 重写了系统的backgroundColor属性
- (void)setBackgroundColor:(UIColor *)backgroundColor
{
    _shapeLayer.strokeColor = backgroundColor.CGColor;
}
- (UIColor *)backgroundColor
{
    return [UIColor colorWithCGColor:_shapeLayer.strokeColor];
}

@end
