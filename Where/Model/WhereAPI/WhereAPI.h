//
//  WhereAPI.h
//  Where
//
//  Created by Danil Tulin on 11/25/16.
//  Copyright © 2016 Daniil Tulin. All rights reserved.
//

#import <Foundation/Foundation.h>

@import MapKit;


@interface Request : NSObject

@property (nonatomic, copy, readonly) NSString *query;
@property (nonatomic, readonly) NSUInteger rowsQty;
@property (nonatomic, readonly) NSUInteger columnsQty;
@property (nonatomic, readonly) MKCoordinateRegion region;

+ (instancetype)requestWithQuery:(NSString *)query
                         rowsQty:(NSUInteger)rowsQty
                      columnsQty:(NSUInteger)columnsQty
                       andRegion:(MKCoordinateRegion)region;

@end

@interface Coloring : NSObject

@property (readonly) NSUInteger rowsQty;
@property (readonly) NSUInteger columnsQty;

@property (nonatomic) NSArray<NSArray<NSNumber *> *> *matrix;

@end

typedef void (^ColoringHandler)(Coloring *);

@interface WhereAPI : NSObject

+ (void)obtainColoring:(Request *)request
           withHandler:(ColoringHandler)handler;

@end
