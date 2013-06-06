//
//  Based on DACircularProgress from Daniel Amitay (2012)
//

#import "AJProgressView.h"
#import <QuartzCore/QuartzCore.h>

#define PROGRESS_RADIUS 40.0f

@interface DACircularProgressLayer : CALayer
@property(nonatomic, weak) UIColor *tintColor;
@property(nonatomic) CGFloat thickness;
@property(nonatomic) CGFloat progress;
@end

@implementation DACircularProgressLayer

@dynamic tintColor;
@dynamic thickness;
@dynamic progress;

+ (BOOL)needsDisplayForKey:(NSString *)key
{
    return [key isEqualToString:@"progress"] ? YES : [super needsDisplayForKey:key];
}

- (void)drawInContext:(CGContextRef)context
{
    CGRect boundsRect = self.bounds;
    CGPoint centerPoint = CGPointMake(boundsRect.size.height / 2, boundsRect.size.width / 2);
    CGFloat radius = MIN(boundsRect.size.height, boundsRect.size.width) / 2;
    
    CGFloat progress = MIN(self.progress, 1.f - FLT_EPSILON);
    CGFloat radians = (progress * 2 * M_PI) - M_PI_2;
    
    // Create background circle
    CGContextSetFillColorWithColor(context, [self.tintColor colorWithAlphaComponent:0.4].CGColor);
    CGMutablePathRef trackPath = CGPathCreateMutable();
    CGPathMoveToPoint(trackPath, NULL, centerPoint.x, centerPoint.y);
    CGPathAddArc(trackPath, NULL, centerPoint.x, centerPoint.y, radius, 3 * M_PI_2, -M_PI_2, NO);
    CGPathCloseSubpath(trackPath);
    CGContextAddPath(context, trackPath);
    CGContextFillPath(context);
    CGPathRelease(trackPath);
    
    if (progress > 0.f)
    {
        // Create progress circle
        CGContextSetFillColorWithColor(context, self.tintColor.CGColor);
        CGMutablePathRef progressPath = CGPathCreateMutable();
        CGPathMoveToPoint(progressPath, NULL, centerPoint.x, centerPoint.y);
        CGPathAddArc(progressPath, NULL, centerPoint.x, centerPoint.y, radius, 3 * M_PI_2, radians, NO);
        CGPathCloseSubpath(progressPath);
        CGContextAddPath(context, progressPath);
        CGContextFillPath(context);
        CGPathRelease(progressPath);
    
        // Add circles to start and end of line for rounded corners
        CGFloat pathWidth = radius * self.thickness;
        CGFloat xOffset = radius * (1.f + ((1 - (self.thickness / 2.f)) * cosf(radians)));
        CGFloat yOffset = radius * (1.f + ((1 - (self.thickness / 2.f)) * sinf(radians)));
        CGPoint endPoint = CGPointMake(xOffset, yOffset);
        
        CGContextAddEllipseInRect(context, CGRectMake(centerPoint.x - pathWidth / 2, 0, pathWidth, pathWidth));
        CGContextFillPath(context);
        
        CGContextAddEllipseInRect(context, CGRectMake(endPoint.x - pathWidth / 2, endPoint.y - pathWidth / 2, pathWidth, pathWidth));
        CGContextFillPath(context);
    }
    
    // Create inner circle
    CGContextSetBlendMode(context, kCGBlendModeClear);
    CGFloat innerRadius = radius * (1.f - self.thickness);
    CGPoint newCenterPoint = CGPointMake(centerPoint.x - innerRadius, centerPoint.y - innerRadius);
    CGContextAddEllipseInRect(context, CGRectMake(newCenterPoint.x, newCenterPoint.y, innerRadius * 2, innerRadius * 2));
    CGContextFillPath(context);
}

@end

@implementation AJProgressView

+ (void) initialize
{
    if (self != [AJProgressView class])
        return;
    
    id appearance = [self appearance];
    [appearance setTintColor:[UIColor whiteColor]];
    [appearance setThickness:0.3f];
}

+ (Class)layerClass
{
    return [DACircularProgressLayer class];
}

- (DACircularProgressLayer *)circularProgressLayer
{
    return (DACircularProgressLayer *)self.layer;
}

- (id)init
{
    return [self initWithFrame:CGRectMake(0.0f, 0.0f, 40.0f, 40.0f)];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (id)initInCenterOfFrame:(CGRect)frame
{
    float x = (frame.size.width-PROGRESS_RADIUS)/2;
    float y = (frame.size.height-PROGRESS_RADIUS)/2;
    self = [super initWithFrame:CGRectMake(x, y, PROGRESS_RADIUS, PROGRESS_RADIUS)];
    if (self)
    {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)didMoveToWindow
{
    self.circularProgressLayer.contentsScale = [UIScreen mainScreen].scale;
}

#pragma mark - Progress

-(CGFloat)progress
{
    return self.circularProgressLayer.progress;
}

- (void)setProgress:(CGFloat)progress
{
    CGFloat pinnedProgress = MIN(MAX(progress, 0.f), 1.f);
    [self.circularProgressLayer setNeedsDisplay];
    self.circularProgressLayer.progress = pinnedProgress;
}

#pragma mark - UIAppearance methods

- (UIColor *)tintColor
{
    return self.circularProgressLayer.tintColor;
}

- (void)setTintColor:(UIColor *)tintColor
{
    self.circularProgressLayer.tintColor = tintColor;
    [self.circularProgressLayer setNeedsDisplay];
}


-(CGFloat)thickness
{
    return self.circularProgressLayer.thickness;
}

- (void)setThickness:(CGFloat)thickness
{
    self.circularProgressLayer.thickness = MIN(MAX(thickness, 0.f), 1.f);
    [self.circularProgressLayer setNeedsDisplay];
}

@end
