//
//  GradientPolygonRenderer.m
//  Where
//
//  Created by Danil Tulin on 11/26/16.
//  Copyright © 2016 Daniil Tulin. All rights reserved.
//

#import "GradientRenderer.h"

@implementation PointObject

+ (instancetype)pointWithX:(CGFloat)x
                      andY:(CGFloat)y {
    PointObject *point = [[PointObject alloc] init];
    point.x = x;
    point.y = y;
    return point;
}

@end

@interface GradientRenderer ()

@property (nonatomic, nonnull) NSArray<UIColor *> *colors;

@end

@implementation GradientRenderer

+ (instancetype)rendererWithPolygon:(MKPolygon *)polygon
                    andCornerColors:(NSArray<UIColor *> *)colors{
    GradientRenderer *renderer = [[GradientRenderer alloc] initWithPolygon:polygon];
    renderer.colors = colors;
    return renderer;
}

//- (void)drawMapRect:(MKMapRect)mapRect zoomScale:(MKZoomScale)zoomScale inContext:(CGContextRef)context
//{
//    // Get the overlay bounding rectangle.
//    MKMapRect  theMapRect = [self.overlay boundingMapRect];
//    CGRect theRect = [self rectForMapRect:theMapRect];
//    
//    // Clip the context to the bounding rectangle.
//    CGContextAddRect(context, theRect);
//    CGContextClip(context);
//    
//    // Set up the gradient color and location information.
//    CGColorSpaceRef myColorSpace = CGColorSpaceCreateDeviceRGB();
//    CGFloat locations[2] = {0.0, 1.0};
//    
//    NSArray *components = @[[UIColor colorWithRed:0 green:0 blue:1 alpha:.5f],
//                            [UIColor colorWithRed:1 green:1 blue:1 alpha:.8f]];
//    
//    // Create the gradient.
//    CGGradientRef myGradient = CGGradientCreateWithColors(myColorSpace, (CFArrayRef)components, locations);
//    CGPoint start, end;
//    start = CGPointMake(CGRectGetMinX(theRect), CGRectGetMinY(theRect));
//    end = CGPointMake(CGRectGetMaxX(theRect), CGRectGetMaxY(theRect));
//    
//    // Draw.
//    CGContextDrawLinearGradient(context, myGradient, start, end, 0);
//    
//    // Clean up.
//    CGColorSpaceRelease(myColorSpace);
//    CGGradientRelease(myGradient);
//}

- (void)drawMapRect:(MKMapRect)mapRect
          zoomScale:(MKZoomScale)zoomScale
          inContext:(CGContextRef)context {
    MKMapRect  theMapRect = [self.overlay boundingMapRect];
    CGRect rect = [self rectForMapRect:theMapRect];
    
    CGContextAddRect(context, rect);
    CGContextClip(context);
    
//    UIColor *leftTop = self.colors[0];
//    UIColor *rightTop = self.colors[1];
//    UIColor *rightBottom = self.colors[2];
//    UIColor *leftBottom = self.colors[3];
    
    float alpha = .1f;
    
    UIColor *leftTop = [UIColor colorWithRed:1.0f
                                       green:0 blue:0 alpha:alpha];
    UIColor *rightTop = [UIColor colorWithRed:.5f
                                        green:.5f blue:0 alpha:alpha];
    UIColor *rightBottom = [UIColor colorWithRed:.0f
                                           green:1.0f blue:0 alpha:alpha];
    UIColor *leftBottom = [UIColor colorWithRed:.5f
                                          green:.5f blue:0 alpha:alpha];
    
    [self addGradientToContext:context
                          path:@[[PointObject pointWithX:.0f andY:.0f],
                                 [PointObject pointWithX:1.0f andY:.0f]]
                        colors:@[leftTop, rightTop]];
    
    [self addGradientToContext:context
                          path:@[[PointObject pointWithX:.0f andY:.0f],
                                 [PointObject pointWithX:1.0f andY:1.0f]]
                        colors:@[leftTop, rightBottom]];
    
    [self addGradientToContext:context
                          path:@[[PointObject pointWithX:.0f andY:.0f],
                                 [PointObject pointWithX:.0f andY:1.0f]]
                        colors:@[leftTop, leftBottom]];
    
    [self addGradientToContext:context
                          path:@[[PointObject pointWithX:1.0f andY:.0f],
                                 [PointObject pointWithX:1.0f andY:1.0f]]
                        colors:@[rightTop, rightBottom]];
    
    [self addGradientToContext:context
                          path:@[[PointObject pointWithX:1.0f andY:.0f],
                                 [PointObject pointWithX:.0f andY:1.0f]]
                        colors:@[rightTop, leftBottom]];
    
    [self addGradientToContext:context
                          path:@[[PointObject pointWithX:1.0f andY:1.0f],
                                 [PointObject pointWithX:.0f andY:1.0f]]
                        colors:@[rightBottom, leftBottom]];
    
}

- (void)addGradientToContext:(CGContextRef)context
                        path:(NSArray<PointObject *> *)path
                      colors:(NSArray<UIColor *> *)colors {
    MKMapRect theMapRect = [self.overlay boundingMapRect];
    CGRect rect = [self rectForMapRect:theMapRect];
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGFloat locations[2] = {0.0, 1.0};
    
    UIColor *fromColor = colors[0], *toColor = colors[1];
    
    CGFloat components[8] = {0};
    for (int i = 0; i < 4; ++i) {
        components[i] = CGColorGetComponents(fromColor.CGColor)[i];
    }
    for (int i = 0; i < 4; ++i) {
        components[i + 4] = CGColorGetComponents(toColor.CGColor)[i];
    }
    
    CGGradientRef gradient = CGGradientCreateWithColorComponents(colorSpace, components,
                                                                 locations, 2);
    
    PointObject *from = path[0], *to = path[1];
    
    float width = CGRectGetWidth(rect);
    float height = CGRectGetHeight(rect);
    
    CGPoint start, end;
    start = CGPointMake(CGRectGetMinX(rect) + from.x * width,
                        CGRectGetMinY(rect) + from.y * height);
    end = CGPointMake(CGRectGetMinX(rect) + to.x * width,
                      CGRectGetMinY(rect) + to.y * height);
    
    CGContextDrawLinearGradient(context, gradient, start, end, 0);
    
    CGColorSpaceRelease(colorSpace);
    CGGradientRelease(gradient);
}

@end
