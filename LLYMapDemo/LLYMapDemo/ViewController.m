//
//  ViewController.m
//  LLYMapDemo
//
//  Created by lly on 2017/4/21.
//  Copyright © 2017年 lly. All rights reserved.
//

#import "ViewController.h"
#import <MAMapKit/MAMapKit.h>
#import "HttpEngine.h"
#import "LLYDistrictsModel.h"
#import <NSObject+YYModel.h>
#import "SHFHAnnotation.h"
#import "SHFHDistrictAnnotationView.h"
#import "SHFHBuildAnnotationView.h"

#define kALevelMin 7.5
#define kALevelMax 10.5
#define kALevelBest 9
#define kBLevelMin 10.6
#define kBLevelMax 18
#define kBLevelBest 13

static NSString *const DisUrl = @"http://api-zhibo.focus.cn/api/building/district/search?cityId=1";


@interface ViewController ()<MAMapViewDelegate,SHFHDistrictAnnotationDelegate,SHFHBuildAnnotationViewDelegate>
{
    CLLocationDegrees maxLatitude;
    CLLocationDegrees minLatitude;
    
    CLLocationDegrees maxLongitude;
    CLLocationDegrees minLongitude;
    
    CLLocationCoordinate2D pointLT;
    CLLocationCoordinate2D pointRB;
    
    bool _isShowBigAnnotation;
}
@property (weak, nonatomic) IBOutlet MAMapView *mMapView;
@property (nonatomic,strong) NSMutableArray *disArray;
@property (nonatomic, strong) NSMutableArray *districtAnnotaions;

@property (nonatomic,strong) NSMutableArray *buildArray;
@property (nonatomic, strong) NSMutableArray *buildAnnotaions;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.disArray = [NSMutableArray array];
    self.districtAnnotaions = [NSMutableArray array];
    self.buildArray = [NSMutableArray array];
    self.buildAnnotaions = [NSMutableArray array];
    
    [self initMapView];
    
    [self getDistrictsData];
    
//    [self setBestRegion];
}

- (void)getDistrictsData{
    
    [self.districtAnnotaions removeAllObjects];
    [self.disArray removeAllObjects];
    _isShowBigAnnotation = YES;
    __weak typeof(self) weakSelf = self;
    [HttpEngine AfJSONGetRequest:DisUrl successfulBlock:^(id object) {
        //
        if ([[object[@"code"] stringValue] isEqualToString:@"200"]) {
            for (NSDictionary *dic in object[@"data"][@"districts"]) {
                LLYDistrictsModel *item = [[LLYDistrictsModel alloc] init];
                item.districtId = [NSString stringWithFormat:@"%@",dic[@"id"]];
                item.districtName = dic[@"desc"];
                item.latitude = [NSString stringWithFormat:@"%@",dic[@"lat"]];
                item.longitude = [NSString stringWithFormat:@"%@",dic[@"lng"]];
                item.buildingCount = [NSString stringWithFormat:@"%@",dic[@"buildingCount"]];
                [weakSelf.disArray addObject:item];
            }
            
            
            if (weakSelf.disArray.count > 0) {
                [_mMapView removeAnnotations:_buildAnnotaions];
                [weakSelf initDistrictAnnotations];
                [self setBestRegion];
                [weakSelf.mMapView addAnnotations:weakSelf.districtAnnotaions];
            }
        }
        
    } failBlock:^(NSError *error) {
        //
    }];
}

- (void)getBuildData:(NSString *)districtId{
    
    [self.buildAnnotaions removeAllObjects];
    [self.buildArray removeAllObjects];
    _isShowBigAnnotation = NO;
    __weak typeof(self) weakSelf = self;
    
    NSString *url = [NSString stringWithFormat:@"http://api-zhibo.focus.cn/api/building/search?districtId=%@&cityId=1",districtId];
    [HttpEngine AfJSONGetRequest:url successfulBlock:^(id object) {
        //
        if ([[object[@"code"] stringValue] isEqualToString:@"200"]) {
            for (NSDictionary *dic in object[@"data"][@"buildings"]) {
                LLYDistrictsModel *item = [[LLYDistrictsModel alloc] init];
                item.districtName = dic[@"projName"];
                item.latitude = [NSString stringWithFormat:@"%@",dic[@"lat"]];
                item.longitude = [NSString stringWithFormat:@"%@",dic[@"lon"]];
                [weakSelf.buildArray addObject:item];
            }
            
            if (weakSelf.buildArray.count > 0) {
                [_mMapView removeAnnotations:_districtAnnotaions];
                [weakSelf initBuildAnnotations];
                [self setBestRegion];
                [weakSelf.mMapView addAnnotations:weakSelf.buildAnnotaions];
            }
        }
        
    } failBlock:^(NSError *error) {
        //
    }];
    
}

- (void)getSearchBuildData:(NSString *)url{
    
    
    [_mMapView removeAnnotations:_districtAnnotaions];
    [_mMapView removeAnnotations:_buildAnnotaions];
    
    [self.buildAnnotaions removeAllObjects];
    [self.buildArray removeAllObjects];
    [self.disArray removeAllObjects];
    [self.districtAnnotaions removeAllObjects];
    
    _isShowBigAnnotation = NO;
    __weak typeof(self) weakSelf = self;
    
    [HttpEngine AfJSONGetRequest:url successfulBlock:^(id object) {
        //
        if ([[object[@"code"] stringValue] isEqualToString:@"200"]) {
            for (NSDictionary *dic in object[@"data"][@"buildings"]) {
                LLYDistrictsModel *item = [[LLYDistrictsModel alloc] init];
                item.districtName = dic[@"projName"];
                item.latitude = [NSString stringWithFormat:@"%@",dic[@"lat"]];
                item.longitude = [NSString stringWithFormat:@"%@",dic[@"lon"]];
                [weakSelf.buildArray addObject:item];
            }
            
            if (weakSelf.buildArray.count > 0) {
                [weakSelf initBuildAnnotations];
                
                [self setBestRegion];
                [weakSelf.mMapView addAnnotations:weakSelf.buildAnnotaions];
            }
        }
        
    } failBlock:^(NSError *error) {
        //
    }];
    
}



- (void)initMapView{

    self.mMapView.delegate = self;
    self.mMapView.showsCompass = YES;
    self.mMapView.showsScale = YES;
    
    NSLog(@"min == %f, max == %f",self.mMapView.minZoomLevel, self.mMapView.maxZoomLevel);
//    self.mMapView.zoomLevel = kALevelBest;
    NSLog(@"zoomLevel === %.2f",self.mMapView.zoomLevel);

}

- (void)viewDidAppear:(BOOL)animated{

    [super viewDidAppear:animated];
    
}


- (void)initDistrictAnnotations
{
    
    maxLatitude = 0.0;
    minLatitude = 180.0;
    maxLongitude = 0.0;
    minLongitude = 180.0;
    
    [_districtAnnotaions removeAllObjects];
    for (int i = 0; i < _disArray.count; i ++ )
    {
        LLYDistrictsModel *item = _disArray[i];
        if ([item.latitude floatValue] != 0 && [item.longitude floatValue] != 0)
        {
            SHFHAnnotation *annotation = [[SHFHAnnotation alloc] init];
            annotation.type = kSHFHAnnotationTypeDistrict;
            annotation.index = i;
            annotation.coordinate = CLLocationCoordinate2DMake([item.latitude floatValue],[item.longitude floatValue]);
            
            maxLongitude = MAX(annotation.coordinate.longitude, maxLongitude);
            minLongitude = MIN(annotation.coordinate.longitude, minLongitude);
            maxLatitude = MAX(annotation.coordinate.latitude, maxLatitude);
            minLatitude = MIN(annotation.coordinate.latitude, minLatitude);
            
            [_districtAnnotaions addObject:annotation];
        }
    }
    
//    _isShowBigAnnotation = YES;
}

- (void)initBuildAnnotations{
    
    maxLatitude = 0.0;
    minLatitude = 180.0;
    maxLongitude = 0.0;
    minLongitude = 180.0;

    [_buildAnnotaions removeAllObjects];
    for (int i = 0; i < _buildArray.count; i ++ )
    {
        LLYDistrictsModel *item = _buildArray[i];
        if ([item.latitude floatValue] != 0 && [item.longitude floatValue] != 0)
        {
            SHFHAnnotation *annotation = [[SHFHAnnotation alloc] init];
            annotation.type = kSHFHAnnotationTypeBuildings;
            annotation.index = i;
            annotation.coordinate = CLLocationCoordinate2DMake([item.latitude floatValue],[item.longitude floatValue]);
            
            maxLongitude = MAX(annotation.coordinate.longitude, maxLongitude);
            minLongitude = MIN(annotation.coordinate.longitude, minLongitude);
            maxLatitude = MAX(annotation.coordinate.latitude, maxLatitude);
            minLatitude = MIN(annotation.coordinate.latitude, minLatitude);
            
            [_buildAnnotaions addObject:annotation];
        }
    }

}

//显示当前位置
- (void)setBestRegion
{
    MACoordinateRegion region;
    if(maxLatitude == minLatitude)
    {
        region = MACoordinateRegionMake(CLLocationCoordinate2DMake((minLatitude+maxLatitude)/2,
                                                                   (maxLongitude+minLongitude)/2),
                                        MACoordinateSpanMake(0.1, 0.1));
    }
    else
    {
        CLLocationCoordinate2D center = CLLocationCoordinate2DMake((minLatitude+maxLatitude)/2 , (maxLongitude+minLongitude)/2);
        MACoordinateSpan span = MACoordinateSpanMake(fabs(maxLatitude-minLatitude)*1.3,fabs(maxLongitude-minLongitude)*1.3);
        region = MACoordinateRegionMake(center,span);
        
    }

    if(self.disArray.count > 0 || self.buildArray > 0){
        [self.mMapView setRegion:region animated:YES];
    }
    else{
        [self.mMapView setCenterCoordinate:region.center];
    }
    
}


#pragma mark - MapView Delegate

- (void)mapView:(MAMapView *)mapView regionDidChangeAnimated:(BOOL)animated
{
//    NSLog(@"zoomLevel=%f",mapView.zoomLevel);
}

- (void)mapView:(MAMapView *)mapView mapDidMoveByUser:(BOOL)wasUserAction{
    
    NSLog(@"moveeeeeeeeeeeeeeee!!!!!!!!!!!!!!!!!!");
    
    
    pointLT = [mapView convertPoint:CGPointMake(10, 20) toCoordinateFromView:mapView];
    pointRB = [mapView convertPoint:CGPointMake(mapView.bounds.size.width - 20, mapView.bounds.size.height - 50) toCoordinateFromView:mapView];
    
    
    NSString *url = [NSString stringWithFormat:@"http://api-zhibo.focus.cn/api/building/search?ulLongitude=%f&ulLatitude=%f&cityId=1&lrLongitude=%f&lrLatitude=%f",pointLT.longitude,pointLT.latitude,pointRB.longitude,pointRB.latitude];
    
    NSLog(@"zoomLevel === %.2f",self.mMapView.zoomLevel);
    
    if (self.mMapView.zoomLevel > kBLevelMin && _isShowBigAnnotation) {
        [self getSearchBuildData:url];
    }
    else if (self.mMapView.zoomLevel < kALevelMax && !_isShowBigAnnotation)
    {
        [self getDistrictsData];
    }

}

- (void)mapView:(MAMapView *)mapView mapDidZoomByUser:(BOOL)wasUserAction{
    
    NSLog(@"zoommmmmmmmmmmmmmm!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!");
}

- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation{

    if ([annotation isKindOfClass:[SHFHAnnotation class]])
    {
        SHFHAnnotation *pointAnnotation = (SHFHAnnotation *)annotation;
        if (pointAnnotation.type == kSHFHAnnotationTypeDistrict)
        {
            static NSString *pointReuseIndetifier = @"DistrictAnnotationView";
            SHFHDistrictAnnotationView *annotationView = (SHFHDistrictAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:pointReuseIndetifier];
            if (annotationView == nil)
            {
                annotationView = [[SHFHDistrictAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:pointReuseIndetifier];
                annotationView.canShowCallout = NO;// must set to NO, so we can show the custom callout view.
                annotationView.draggable = NO;
                annotationView.delegate = self;
            }
            annotationView.tag = pointAnnotation.index;
            if (_disArray.count <= annotationView.tag) {
                return nil;
            }
            LLYDistrictsModel *item = _disArray[annotationView.tag];
            [annotationView loadUIData:item];
            
            return annotationView;
        }
        else if (pointAnnotation.type == kSHFHAnnotationTypeBuildings)
        {
            static NSString *pointReuseIndetifier = @"PointIndetifier";
            SHFHBuildAnnotationView *annotationView = (SHFHBuildAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:pointReuseIndetifier];
            if (annotationView == nil)
            {
                annotationView = [[SHFHBuildAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:pointReuseIndetifier];
                annotationView.delegate = self;
            }
            
            if (_buildArray.count <= pointAnnotation.index) {
                return nil;
            }
            annotationView.tag = pointAnnotation.index;
            LLYDistrictsModel *item = _buildArray[annotationView.tag];
            [annotationView loadUIData:item];
            
            return annotationView;
        }
    }
    
    return nil;
}

- (void)districtAnnotationClick:(LLYDistrictsModel *)districtInfo{

    _mMapView.zoomLevel = kBLevelBest;
    [self getBuildData:districtInfo.districtId];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
