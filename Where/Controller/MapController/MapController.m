//
//  MapController.m
//  Where
//
//  Created by Danil Tulin on 11/25/16.
//  Copyright © 2016 Daniil Tulin. All rights reserved.
//

#import "MapController.h"
#import "GradientRenderer.h"

#import <Masonry/Masonry.h>

@import MapKit;


@interface MapController () <MKMapViewDelegate>

@property (nonatomic, nonnull) MKMapView *mapView;
@property (nonatomic, nonnull) Coloring *coloring;

@end

@implementation MapController

- (instancetype)init {
    if (self = [super init]) {
        self.mapView = [[MKMapView alloc] init];
        self.mapView.delegate = self;
        self.mapView.zoomEnabled = NO;
        self.mapView.pitchEnabled = NO;
        self.mapView.rotateEnabled = NO;
        self.mapView.scrollEnabled = NO;
    }
    return self;
}

+ (instancetype)mapControllerWithRegion:(MKCoordinateRegion)region
                            andColoring:(Coloring *)coloring {
    MapController *controller = [[MapController alloc] init];
    controller.mapView.region = region;
    controller.coloring = coloring;
    return controller;
}

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.mapView];
    [self.view setNeedsUpdateConstraints];
}

- (void)addPolygonWithRegion:(MKCoordinateRegion)region {
    CLLocationCoordinate2D center = region.center;
    MKCoordinateSpan span = region.span;

    float top = center.latitude - span.latitudeDelta / 2;
    float bottom = center.latitude + span.latitudeDelta / 2;

    float left = center.longitude - span.longitudeDelta / 2;
    float right = center.longitude + span.longitudeDelta / 2;

    CLLocationCoordinate2D leftTop = CLLocationCoordinate2DMake(top, left);
    CLLocationCoordinate2D rightTop = CLLocationCoordinate2DMake(top, right);

    CLLocationCoordinate2D leftBottom = CLLocationCoordinate2DMake(bottom, left);
    CLLocationCoordinate2D rightBottom = CLLocationCoordinate2DMake(bottom, right);

    CLLocationCoordinate2D coordinates[] = {leftTop, rightTop, rightBottom, leftBottom};

    MKPolygon *polygon = [MKPolygon polygonWithCoordinates:coordinates count:4];
    [self.mapView addOverlay:polygon];
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

#pragma mark - MKMapViewDelegate

- (void)mapViewDidFinishLoadingMap:(MKMapView *)mapView {
    for (int row = 0; row < self.coloring.rowsQty; ++row) {
        for (int column = 0; column < self.coloring.columnsQty; ++column) {
            MKCoordinateRegion region = [self regionForRow:row
                                                 andColumn:column];
            [self addPolygonWithRegion:region];
        }
    }
}

- (MKCoordinateRegion)regionForRow:(NSUInteger)row
                         andColumn:(NSUInteger)column {
    MKCoordinateRegion globalRegion = self.mapView.region;
    MKCoordinateSpan globalSpan = globalRegion.span;
    CLLocationCoordinate2D globalCenter = globalRegion.center;

    float top = globalCenter.latitude - globalSpan.latitudeDelta / 2;
    float bottom = globalCenter.latitude + globalSpan.latitudeDelta / 2;

    float left = globalCenter.longitude - globalSpan.longitudeDelta / 2;
    float right = globalCenter.longitude + globalSpan.longitudeDelta / 2;

    float height = bottom - top;
    float width = right - left;

    NSUInteger columnsQty = self.coloring.columnsQty, rowsQty = self.coloring.rowsQty;

    float localWidth = width / columnsQty;
    float localHeight = height / rowsQty;

    CLLocationDegrees longitude = left + (column + .5f) * localWidth;
    CLLocationDegrees latitude = top + (row + .5f) * localHeight;

    CLLocationCoordinate2D center = CLLocationCoordinate2DMake(latitude, longitude);

    MKCoordinateSpan span = MKCoordinateSpanMake(globalSpan.latitudeDelta / rowsQty,
                                                 globalSpan.longitudeDelta / columnsQty);

    MKCoordinateRegion polygonRegion = MKCoordinateRegionMake(center, span);
    return polygonRegion;
}

- (MKOverlayRenderer *)mapView:(MKMapView *)mapView
            rendererForOverlay:(id <MKOverlay>)overlay {
    if ([overlay isKindOfClass:[MKPolygon class]] == NO)
        abort();
    return [GradientRenderer rendererWithPolygon:(MKPolygon *)overlay
                                 andCornerColors:nil];
}


@end
