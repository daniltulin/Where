//
//  WhereAPI.m
//  Where
//
//  Created by Danil Tulin on 11/25/16.
//  Copyright © 2016 Daniil Tulin. All rights reserved.
//

#import "WhereAPI.h"

#include <math.h>

@interface Request ()

@property (nonatomic, copy, readwrite) NSString *query;
@property (nonatomic, readwrite) NSUInteger rowsQty;
@property (nonatomic, readwrite) NSUInteger columnsQty;
@property (nonatomic, readwrite) MKCoordinateRegion region;

@end

@implementation Request

+ (instancetype)requestWithQuery:(NSString *)query
                         rowsQty:(NSUInteger)rowsQty
                      columnsQty:(NSUInteger)columnsQty
                       andRegion:(MKCoordinateRegion)region {
    Request *request = [[Request alloc] init];
    request.query = [query copy];
    request.rowsQty = rowsQty;
    request.columnsQty = columnsQty;
    request.region = region;
    return request;
}

@end

@interface Coloring ()

@end

@implementation Coloring

@end

bool in_circle(float x, float y, float a, float b) {
    return pow(x / a, 2) + pow(y / b, 2) <= 1;
}

float z_centered(float x, float y, float a, float b) {
    if (in_circle(x, y, a, b))
        return sqrt(1 - (pow(x / a, 2) + pow(y / b, 2)));
    else
        return 0;
}

float z(float x, float y, float a, float b) {
    return z_centered(x - a, y - b, a, b);
}

@implementation WhereAPI

+ (void)obtainColoring:(Request *)request
           withHandler:(ColoringHandler)handler {
    Coloring *coloring = [[Coloring alloc] init];

    NSUInteger rowsQty = request.rowsQty, columnsQty = request.columnsQty;

    NSMutableArray *rows = [NSMutableArray arrayWithCapacity:rowsQty];
    for (int row = 0; row < rowsQty; row++) {
        rows[row] = [NSMutableArray arrayWithCapacity:columnsQty];
        for (int column = 0; column < columnsQty; column++) {
            float z_ = z(row, column,
                        columnsQty/2, rowsQty/2);
            rows[row][column] = [NSNumber numberWithFloat:z_];
            NSLog(@"%d %d %f", row, column, z_);
        }
    }

    dispatch_block_t wrapper = ^{
        if (handler != nil)
            handler(coloring);
    };
    dispatch_block_t completion_block = ^{
        dispatch_async(dispatch_get_main_queue(), wrapper);
    };
    dispatch_async(dispatch_get_global_queue(QOS_CLASS_BACKGROUND, 0), ^{
        sleep(1);
        completion_block();
    });
}

@end
