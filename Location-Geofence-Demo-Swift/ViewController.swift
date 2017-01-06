//
//  ViewController.swift
//  Location-Geofence-Demo-Swift
//
//  Created by eidan on 17/1/6.
//  Copyright © 2017年 autonavi. All rights reserved.
//

import UIKit

class ViewController: UIViewController, MAMapViewDelegate,AMapGeoFenceManagerDelegate {

    var mapView: MAMapView!
    var geoFenceManager:AMapGeoFenceManager!
    var userLocation:CLLocation!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.initMapView()
        
        self.configGeoFenceManager()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //初始化地图
    func initMapView() {
        self.mapView = MAMapView(frame: view.bounds)
        self.mapView.delegate = self
        self.mapView.showsUserLocation = true
        self.view.addSubview(mapView)
        self.view.sendSubview(toBack: self.mapView);
    }
    
    //初始化地理围栏manager
    func configGeoFenceManager() {
        self.geoFenceManager = AMapGeoFenceManager()
        self.geoFenceManager.delegate = self
        self.geoFenceManager.activeAction = [AMapGeoFenceActiveAction.inside , AMapGeoFenceActiveAction.outside , AMapGeoFenceActiveAction.stayed ]//进入，离开，停留都要进行通知
        self.geoFenceManager.allowsBackgroundLocationUpdates = true  //允许后台定位
    }
    
    //添加地理围栏对应的Overlay，方便查看。地图上显示圆
    func showCircle(inMap coordinate: CLLocationCoordinate2D, radius: CLLocationDistance) -> MACircle {
        let circleOverlay = MACircle(center: coordinate, radius: radius)
        self.mapView.add(circleOverlay)
        return circleOverlay!
    }
    
    //清除上一次按钮点击创建的围栏
    func doClear() {
        self.mapView.removeOverlays(self.mapView.overlays)
        self.geoFenceManager.removeAllGeoFenceRegions()
    }
    
    // MARK: - xib btn click
    
    //添加圆形围栏按钮点击
    @IBAction func addGeoFenceCircleRegion(_ sender: Any) {
        self.doClear()
        var coordinate = CLLocationCoordinate2DMake(39.908692, 116.397477) //天安门
        if (self.userLocation != nil) {
            coordinate = self.userLocation.coordinate
        }
        self.geoFenceManager.addCircleRegionForMonitoring(withCenter: coordinate, radius: 300, customID: "circle_1")
    }
    
    //添加多边形围栏按钮点击
    @IBAction func addGeoFencePolygonRegion(_ sender: Any) {
        
        var coordinates: [CLLocationCoordinate2D] = [
            CLLocationCoordinate2D(latitude: 39.933921, longitude: 116.372927),
            CLLocationCoordinate2D(latitude: 39.907261, longitude: 116.376532),
            CLLocationCoordinate2D(latitude: 39.900611, longitude: 116.418161),
            CLLocationCoordinate2D(latitude: 39.941949, longitude: 116.435497)]
        
        self.doClear()
        self.geoFenceManager.addPolygonRegionForMonitoring(withCoordinates: &coordinates, count: 4, customID: "polygon_1")
        
    }
    
    //添加POI关键词围栏按钮点击
    @IBAction func addGeoFencePOIKeywordRegion(_ sender: Any) {
        self.doClear()
        self.geoFenceManager.addKeywordPOIRegionForMonitoring(withKeyword: "北京大学", poiType: "高等院校", city: "北京", size: 20, customID: "poi_1")
    }
    
    //添加POI周边围栏按钮点击
    @IBAction func addGeoFencePOIAroundRegion(_ sender: Any) {
        self.doClear()
        let coordinate = CLLocationCoordinate2DMake(39.908692, 116.397477) //天安门
        self.geoFenceManager.addAroundPOIRegionForMonitoring(withLocationPoint: coordinate, aroundRadius: 10000, keyword: "肯德基", poiType: "050301", size: 20, customID: "poi_2")
    }
    
    //添加行政区域围栏按钮点击
    @IBAction func addGeoFenceDistrictRegion(_ sender: Any) {
        self.doClear()
        self.geoFenceManager.addDistrictRegionForMonitoring(withDistrictName: "海淀区", customID: "district_1")
    }
    
    // MARK: - AMapGeoFenceManagerDelegate
    
    //添加地理围栏完成后的回调，成功与失败都会调用
    func amapGeoFenceManager(_ manager: AMapGeoFenceManager!, didAddRegionForMonitoringFinished regions: [AMapGeoFenceRegion]!, customID: String!, error: Error!) {
        if customID.hasPrefix("circle") {
            if error == nil {
                let circleRegion : AMapGeoFenceCircleRegion = regions.first as! AMapGeoFenceCircleRegion
                let circleOverlay = self.showCircle(inMap: circleRegion.center, radius: circleRegion.radius)
                self.mapView.setVisibleMapRect(circleOverlay.boundingMapRect, edgePadding: UIEdgeInsetsMake(20, 20, 20, 20), animated: true)
            }
        } else if customID.hasPrefix("polygon") {
            if error == nil {
                let polygonRegion : AMapGeoFencePolygonRegion = regions.first as! AMapGeoFencePolygonRegion
                let polygonOverlay = MAPolygon(coordinates: polygonRegion.coordinates, count: UInt(polygonRegion.count))
                self.mapView.add(polygonOverlay)
                self.mapView.setVisibleMapRect((polygonOverlay?.boundingMapRect)!, edgePadding: UIEdgeInsetsMake(20, 20, 20, 20), animated: true)
            }
        } else if customID == "poi_1" {
            if error == nil {
                for region: AMapGeoFenceCircleRegion in regions as! Array {
                    _ = self.showCircle(inMap: region.center, radius: region.radius)
                }
                let coordinate = CLLocationCoordinate2DMake(39.908692, 116.397477) //天安门
                self.mapView.centerCoordinate = coordinate
                self.mapView.zoomLevel = 11
            }
        } else if customID == "poi_2" {
            if error == nil {
                for region: AMapGeoFenceCircleRegion in regions as! Array {
                    _ = self.showCircle(inMap: region.center, radius: region.radius)
                }
                let coordinate = CLLocationCoordinate2DMake(39.908692, 116.397477) //天安门
                self.mapView.centerCoordinate = coordinate
                self.mapView.zoomLevel = 13
            }
        } else if customID == "district_1" {
            for polygonRegion: AMapGeoFenceDistrictRegion in regions as! Array {
                for arealocation: Array in polygonRegion.polylinePoints {
                    var coordinates: [CLLocationCoordinate2D] = Array()
                    for i in 0..<arealocation.count{
                        let point: AMapLocationPoint = arealocation[i]
                        coordinates.append(CLLocationCoordinate2DMake(CLLocationDegrees(point.latitude), CLLocationDegrees(point.longitude)))
                    }
                    let polygonOverlay = MAPolygon(coordinates: &coordinates, count: UInt(arealocation.count))
                    self.mapView.add(polygonOverlay)
                    self.mapView.setVisibleMapRect((polygonOverlay?.boundingMapRect)!, edgePadding: UIEdgeInsetsMake(20, 20, 20, 20), animated: true)
                }
                
            }
        }
    }
    
    //地理围栏状态改变时回调，当围栏状态的值发生改变，定位失败都会调用
    func amapGeoFenceManager(_ manager: AMapGeoFenceManager!, didGeoFencesStatusChangedFor region: AMapGeoFenceRegion!, customID: String!, error: Error!) {
        if error == nil {
            print("status changed \(region.description)")
        } else {
            print("status changed error \(error)")
        }
    }
    
    // MARK: - MAMapViewDelegate
    
    func mapView(_ mapView: MAMapView!, didUpdate userLocation: MAUserLocation!, updatingLocation: Bool) {
        self.userLocation = userLocation.location
    }
    
    func mapView(_ mapView: MAMapView!, viewFor annotation: MAAnnotation!) -> MAAnnotationView! {
        if annotation is MAPointAnnotation {
            
            let pointReuseIndetifier: String = "pointReuseIndetifier"
            
            var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: pointReuseIndetifier) as? MAPinAnnotationView
            
            if annotationView == nil {
                annotationView = MAPinAnnotationView.init(annotation: annotation, reuseIdentifier: pointReuseIndetifier)
                
                annotationView?.canShowCallout = true
                annotationView?.isDraggable = false
                annotationView?.animatesDrop = true
            }
            
            return annotationView
        }
        
        return nil
    }
    
    func mapView(_ mapView: MAMapView!, rendererFor overlay: MAOverlay!) -> MAOverlayRenderer! {
        if overlay.isKind(of: MAPolygon.self) {
            let polylineRenderer: MAPolygonRenderer =  MAPolygonRenderer(polygon: overlay as! MAPolygon!)
            polylineRenderer.lineWidth = 3
            polylineRenderer.strokeColor = UIColor.orange
            return polylineRenderer
        }
        
        if overlay.isKind(of: MACircle.self) {
            let circleRenderer: MACircleRenderer = MACircleRenderer(circle: overlay as! MACircle!)
            circleRenderer.lineWidth = 3
            circleRenderer.strokeColor = UIColor.purple
            return circleRenderer
        }
        return nil
    }



}

