//
//  ViewController.m
//  Where
//
//  Created by Danil Tulin on 11/25/16.
//  Copyright © 2016 Daniil Tulin. All rights reserved.
//

#import "WhereController.h"

#import "MapController.h"

@interface WhereController ()

@end

@implementation WhereController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self presentMapController];
}

- (void)presentMapController {
    CLLocationCoordinate2D centerCoordinate = CLLocationCoordinate2DMake(40.730610, -73.935242);
    MKCoordinateSpan span = MKCoordinateSpanMake(.3f, .3f);
    MKCoordinateRegion region = MKCoordinateRegionMake(centerCoordinate, span);
    MapController *controller = [MapController mapControllerWithRegion:region];
    [self.navigationController pushViewController:controller
                                         animated:YES];
}

@end
