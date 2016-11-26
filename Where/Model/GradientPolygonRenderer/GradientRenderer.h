//
//  GradientPolygonRenderer.h
//  Where
//
//  Created by Danil Tulin on 11/26/16.
//  Copyright © 2016 Daniil Tulin. All rights reserved.
//

#import <MapKit/MapKit.h>

@interface PointObject : NSObject

@property CGFloat x;
@property CGFloat y;

+ (instancetype)pointWithX:(CGFloat)x
                      andY:(CGFloat)y;

@end

@interface GradientRenderer : MKPolygonRenderer

+ (instancetype)rendererWithPolygon:(MKPolygon *)polygon
                    andCornerColors:(NSArray<UIColor *> *)colors;

@end
