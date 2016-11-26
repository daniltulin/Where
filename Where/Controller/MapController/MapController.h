//
//  MapController.h
//  Where
//
//  Created by Danil Tulin on 11/25/16.
//  Copyright © 2016 Daniil Tulin. All rights reserved.
//

#import <UIKit/UIKit.h>

@import MapKit;

@interface MapController : UIViewController

+ (instancetype)mapControllerWithRegion:(MKCoordinateRegion)region;

@end
