//
//  ViewController.m
//  Location-Geofence-Demo
//
//  Created by eidan on 16/12/22.
//  Copyright © 2016年 autonavi. All rights reserved.
//

#import "ViewController.h"
#import <AMapLocationKit/AMapLocationKit.h>
#import <MAMapKit/MAMapKit.h>

@interface ViewController ()<MAMapViewDelegate,AMapGeoFenceManagerDelegate>

@property (nonatomic, strong) MAMapView *mapView;

@property (nonatomic, strong) AMapGeoFenceManager *geoFenceManager;  //地理围栏管理类ggit 

@property (nonatomic, strong) CLLocation *userLocation;  //获得自己的位置，方便demo添加围栏进行测试，

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initMapView];
    
    [self configGeoFenceManager];
    
    // Do any additional setup after loading the view, typically from a nib.
}

//初始化地图
- (void)initMapView {
    self.mapView = [[MAMapView alloc] initWithFrame:CGRectMake(0, 125, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 125)];
    self.mapView.delegate = self;
    self.mapView.showsUserLocation = YES;
    [self.view addSubview:self.mapView];
    [self.view sendSubviewToBack:self.mapView];
}

//初始化地理围栏manager
- (void)configGeoFenceManager {
    self.geoFenceManager = [[AMapGeoFenceManager alloc] init];
    self.geoFenceManager.delegate = self;
    self.geoFenceManager.allowsBackgroundLocationUpdates = YES;  //允许后台定位
}

//添加地理围栏对应的Overlay，方便查看。地图上显示圆
- (MACircle *)showCircleInMap:(CLLocationCoordinate2D )coordinate radius:(NSInteger)radius {
    MACircle *circleOverlay = [MACircle circleWithCenterCoordinate:coordinate radius:radius];
    [self.mapView addOverlay:circleOverlay];
    return circleOverlay;
}

//地图上显示多边形
- (MAPolygon *)showPolygonInMap:(CLLocationCoordinate2D *)coordinates count:(NSInteger)count {
    MAPolygon *polygonOverlay = [MAPolygon polygonWithCoordinates:coordinates count:count];
    [self.mapView addOverlay:polygonOverlay];
    return polygonOverlay;
}

// 清除上一次按钮点击创建的围栏
- (void)doClear {
    [self.mapView removeOverlays:self.mapView.overlays];  //把之前添加的Overlay都移除掉
    [self.geoFenceManager removeAllGeoFenceRegions];  //移除所有已经添加的围栏，如果有正在请求的围栏也会丢弃
}

#pragma mark - Xib btns click

//添加圆形围栏按钮点击
- (IBAction)addGeoFenceCircleRegion:(id)sender {
    
    [self doClear];
    self.geoFenceManager.activeAction = AMapGeoFenceActiveActionInside | AMapGeoFenceActiveActionOutside | AMapGeoFenceActiveActionStayed; //监听进入、退出、停留事件
    
    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(39.998919, 116.467841); //北京望京地铁站
    if (self.userLocation) {
        coordinate = self.userLocation.coordinate;
    }
    [self.geoFenceManager addCircleRegionForMonitoringWithCenter:coordinate radius:300 customID:@"circle_1"];
}

//添加多边形围栏按钮点击:北京朝阳公园
- (IBAction)addGeoFencePolygonRegion:(id)sender {
    
    NSString * coordianteString = @"116.48954,39.949035;116.48956,39.946986;116.489545,39.945793;116.489545,39.945151;116.489547,39.944534;116.489537,39.942016;116.489542,39.940404;116.489532,39.939772;116.489516,39.936447;116.489476,39.935253;116.489468,39.933894;116.488858,39.933901;116.488646,39.933904;116.486819,39.933926;116.486029,39.933919;116.482808,39.933924;116.481209,39.933928;116.477237,39.93393;116.474738,39.93395;116.474632,39.934851;116.474466,39.935205;116.474103,39.935351;116.473723,39.935406;116.473488,39.935378;116.473412,39.935423;116.4734,39.93551;116.473558,39.935659;116.473987,39.936095;116.474344,39.936446;116.474609,39.936707;116.474815,39.936986;116.474899,39.937155;116.474915,39.93733;116.474916,39.937721;116.474919,39.93805;116.4749,39.938376;116.474871,39.938953;116.474855,39.939258;116.474816,39.93977;116.474781,39.940558;116.474724,39.941285;116.474689,39.941889;116.474649,39.942447;116.474628,39.942775;116.474608,39.943028;116.474601,39.943117;116.474551,39.943673;116.474499,39.944207;116.474488,39.944354;116.474467,39.944524;116.474415,39.945015;116.47436,39.945305;116.474335,39.945401;116.474247,39.945691;116.47414,39.946063;116.47393,39.946832;116.473854,39.94711;116.473716,39.94752;116.47362,39.947742;116.473991,39.947865;116.474236,39.947932;116.474385,39.947925;116.474506,39.94798;116.474887,39.948182;116.475212,39.948319;116.475795,39.948419;116.476327,39.948544;116.476614,39.948657;116.477115,39.948675;116.477472,39.948712;116.477793,39.948754;116.478074,39.948851;116.478588,39.948964;116.478705,39.949009;116.478752,39.949069;116.478818,39.949282;116.47883,39.949374;116.478824,39.949446;116.478789,39.949503;116.478648,39.949599;116.478616,39.949629;116.478538,39.949775;116.478451,39.949898;116.478378,39.94997;116.478336,39.950033;116.478318,39.950072;116.478328,39.950211;116.478418,39.950352;116.478481,39.95041;116.47855,39.950433;116.478575,39.95046;116.478593,39.950512;116.478417,39.950964;116.478236,39.951219;116.478168,39.951292;116.477863,39.951713;116.476722,39.953685;116.476775,39.953867;116.479074,39.954626;116.480838,39.955196;116.483278,39.955976;116.483806,39.956138;116.484569,39.956407;116.485044,39.956637;116.486039,39.95704;116.486266,39.957121;116.487219,39.957523;116.487311,39.95754;116.487474,39.957491;116.48762,39.957241;116.487655,39.957173;116.487715,39.957055;116.487805,39.956968;116.488078,39.956501;116.488223,39.956233;116.488432,39.955773;116.488625,39.955281;116.4887,39.95508;116.488843,39.954612;116.489033,39.953949;116.489154,39.95345;116.489218,39.953167;116.489278,39.952847;116.489303,39.952651;116.489309,39.952553;116.489299,39.952429;116.489257,39.952256;116.48923,39.952153;116.489223,39.951986;116.489266,39.951738;116.489317,39.951608;116.48936,39.95151;116.489402,39.951426;116.489434,39.951363;116.489466,39.951212;116.489493,39.950603;116.48954,39.94958;116.48954,39.949035";
    
    NSArray *array = [coordianteString componentsSeparatedByString:@";"];
    
    CLLocationCoordinate2D *coorArr = malloc(sizeof(CLLocationCoordinate2D) * array.count);
    
    for (int i = 0; i < array.count; i++) {
        NSArray *temp = [[array objectAtIndex:i] componentsSeparatedByString:@","];
        coorArr[i] = CLLocationCoordinate2DMake([temp[1] doubleValue], [temp[0] doubleValue]);
    }
    
    [self doClear];
    self.geoFenceManager.activeAction = AMapGeoFenceActiveActionInside | AMapGeoFenceActiveActionOutside | AMapGeoFenceActiveActionStayed; //监听进入、退出、停留事件
    
    [self.geoFenceManager addPolygonRegionForMonitoringWithCoordinates:coorArr count:array.count customID:@"polygon_1"];
    
    free(coorArr);  //malloc，使用后，记得free
    coorArr = NULL;
}

//添加POI关键词围栏按钮点击:北京地区麦当劳
- (IBAction)addGeoFencePOIKeywordRegion:(id)sender {
    
    [self doClear];
    self.geoFenceManager.activeAction = AMapGeoFenceActiveActionInside | AMapGeoFenceActiveActionStayed; //监听进入、停留事件
    
    [self.geoFenceManager addKeywordPOIRegionForMonitoringWithKeyword:@"麦当劳" POIType:@"快餐厅" city:@"北京" size:2 customID:@"poi_keyword"];
}

//添加POI周边围栏按钮点击：周边肯德基围栏
- (IBAction)addGeoFencePOIAroundRegion:(id)sender {
    
    [self doClear];
    self.geoFenceManager.activeAction = AMapGeoFenceActiveActionInside | AMapGeoFenceActiveActionStayed; //监听进入、停留事件
    
    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(39.908692, 116.397477); //天安门
    if (self.userLocation) {
        coordinate = self.userLocation.coordinate;
    }
    [self.geoFenceManager addAroundPOIRegionForMonitoringWithLocationPoint:coordinate aroundRadius:5000 keyword:@"肯德基" POIType:@"快餐厅" size:2 customID:@"poi_around"];
}

//添加行政区域围栏按钮点击:北京市西城区
- (IBAction)addGeoFenceDistrictRegion:(id)sender {
    
    [self doClear];
    self.geoFenceManager.activeAction = AMapGeoFenceActiveActionInside | AMapGeoFenceActiveActionStayed; //监听进入、停留事件
    
    [self.geoFenceManager addDistrictRegionForMonitoringWithDistrictName:@"西城区" customID:@"district_1"];
}

#pragma mark - AMapGeoFenceManagerDelegate

//添加地理围栏完成后的回调，成功与失败都会调用
- (void)amapGeoFenceManager:(AMapGeoFenceManager *)manager didAddRegionForMonitoringFinished:(NSArray<AMapGeoFenceRegion *> *)regions customID:(NSString *)customID error:(NSError *)error {
        if ([customID hasPrefix:@"circle"]) {
        if (error) {
            NSLog(@"======= circle error %@",error);
        } else {  //围栏添加后，在地图上的显示，只是为了更方便的演示，并不是必须的.
            
            AMapGeoFenceCircleRegion *circleRegion = (AMapGeoFenceCircleRegion *)regions.firstObject;  //一次添加一个圆形围栏，只会返回一个
            MACircle *circleOverlay = [self showCircleInMap:circleRegion.center radius:circleRegion.radius];
            [self.mapView setVisibleMapRect:circleOverlay.boundingMapRect edgePadding:UIEdgeInsetsMake(20, 20, 20, 20) animated:YES];   //设置地图的可见范围，让地图缩放和平移到合适的位置
            
        }
    } else if ([customID isEqualToString:@"polygon_1"]){
        if (error) {
            NSLog(@"=======polygon error %@",error);
        } else {  //围栏添加后，在地图上的显示，只是为了更方便的演示，并不是必须的.
            
            AMapGeoFencePolygonRegion *polygonRegion = (AMapGeoFencePolygonRegion *)regions.firstObject;
            MAPolygon *polygonOverlay = [self showPolygonInMap:polygonRegion.coordinates count:polygonRegion.count];
            [self.mapView setVisibleMapRect:polygonOverlay.boundingMapRect edgePadding:UIEdgeInsetsMake(20, 20, 20, 20) animated:YES];
            
        }
    } else if ([customID isEqualToString:@"poi_keyword"]){
        if (error) {
            NSLog(@"======== poi_keyword error %@",error);
        } else {  //围栏添加后，在地图上的显示，只是为了更方便的演示，并不是必须的.
            
            for (AMapGeoFencePOIRegion *region in regions) {
                [self showCircleInMap:region.center radius:region.radius];
            }
            
            CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(39.908692, 116.397477); //天安门
            self.mapView.centerCoordinate = coordinate;
            self.mapView.zoomLevel = 11;
            
        }
    } else if ([customID isEqualToString:@"poi_around"]){
        if (error) {
            NSLog(@"======== poi_around error %@",error);
        } else {  //围栏添加后，在地图上的显示，只是为了更方便的演示，并不是必须的.
            
            for (AMapGeoFencePOIRegion *region in regions) {
                [self showCircleInMap:region.center radius:region.radius];
            }
            
            CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(39.908692, 116.397477); //天安门
            self.mapView.centerCoordinate = self.userLocation ? self.userLocation.coordinate : coordinate;
            self.mapView.zoomLevel = 13;
        }
    } else if ([customID isEqualToString:@"district_1"]){
        if (error) {
            NSLog(@"======== district1 error %@",error);
        } else { //围栏添加后，在地图上的显示，只是为了更方便的演示，并不是必须的.
            
            for (AMapGeoFenceDistrictRegion *region in regions) {
                
                for (NSArray *arealocation in region.polylinePoints) {
                    
                    CLLocationCoordinate2D *coorArr = malloc(sizeof(CLLocationCoordinate2D) * arealocation.count);
                    
                    for (int i = 0; i < arealocation.count; i++) {
                        AMapLocationPoint *point = [arealocation objectAtIndex:i];
                        coorArr[i] = CLLocationCoordinate2DMake(point.latitude, point.longitude);
                    }
                    
                    MAPolygon *polygonOverlay = [self showPolygonInMap:coorArr count:arealocation.count];
                    [self.mapView setVisibleMapRect:polygonOverlay.boundingMapRect edgePadding:UIEdgeInsetsMake(20, 20, 20, 20) animated:YES];
                    
                    free(coorArr);  //malloc，使用后，记得free
                    coorArr = NULL;
                    
                }
                
            }
        }
    }
}

//地理围栏状态改变时回调，当围栏状态的值发生改变，定位失败都会调用
- (void)amapGeoFenceManager:(AMapGeoFenceManager *)manager didGeoFencesStatusChangedForRegion:(AMapGeoFenceRegion *)region customID:(NSString *)customID error:(NSError *)error {
    if (error) {
        NSLog(@"status changed error %@",error);
    }else{
        NSLog(@"status changed %@",[region description]);
    }
}


#pragma mark - MAMapViewDelegate

- (void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation updatingLocation:(BOOL)updatingLocation{
    self.userLocation = userLocation.location;
}

- (MAOverlayRenderer *)mapView:(MAMapView *)mapView rendererForOverlay:(id <MAOverlay>)overlay {
    if ([overlay isKindOfClass:[MAPolygon class]]) {
        MAPolygonRenderer *polylineRenderer = [[MAPolygonRenderer alloc] initWithPolygon:overlay];
        polylineRenderer.lineWidth = 3.0f;
        polylineRenderer.strokeColor = [UIColor orangeColor];
        
        return polylineRenderer;
    } else if ([overlay isKindOfClass:[MACircle class]]) {
        MACircleRenderer *circleRenderer = [[MACircleRenderer alloc] initWithCircle:overlay];
        circleRenderer.lineWidth = 3.0f;
        circleRenderer.strokeColor = [UIColor purpleColor];
        
        return circleRenderer;
    }
    return nil;
}

- (MAAnnotationView*)mapView:(MAMapView *)mapView viewForAnnotation:(id <MAAnnotation>)annotation {
    if ([annotation isKindOfClass:[MAPointAnnotation class]]) {
        static NSString *pointReuseIndetifier = @"pointReuseIndetifier";
        MAPinAnnotationView *annotationView = (MAPinAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:pointReuseIndetifier];
        if (annotationView == nil) {
            annotationView = [[MAPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:pointReuseIndetifier];
        }
        
        annotationView.canShowCallout               = YES;
        annotationView.animatesDrop                 = YES;
        annotationView.draggable                    = NO;
        annotationView.rightCalloutAccessoryView    = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        
        return annotationView;
    }
    
    return nil;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
