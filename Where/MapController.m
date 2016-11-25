//
//  MapController.m
//  Where
//
//  Created by Danil Tulin on 11/25/16.
//  Copyright © 2016 Daniil Tulin. All rights reserved.
//

#import "MapController.h"

#import <Masonry/Masonry.h>

@import MapKit;


@interface MapController ()

@property (nonatomic) MKMapView *mapView;

@end

@implementation MapController

- (instancetype)init {
    if (self = [super init]) {
        self.mapView = [[MKMapView alloc] init];
        self.mapView.zoomEnabled = NO;
        self.mapView.pitchEnabled = NO;
        self.mapView.rotateEnabled = NO;
        self.mapView.scrollEnabled = NO;
    }
    return self;
}

- (instancetype)initWithRegion:(MKCoordinateRegion)region {
    if (self = [self init]) {
        self.mapView.region = region;
    }
    return self;
}

+ (instancetype)mapControllerWithRegion:(MKCoordinateRegion)region {
    MapController *controller = [[MapController alloc] initWithRegion:region];
    return controller;
}

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.mapView];
    [self.view setNeedsUpdateConstraints];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)updateViewConstraints {
    [self.mapView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.equalTo(self.view);
    }];

    [super updateViewConstraints];
}


@end
