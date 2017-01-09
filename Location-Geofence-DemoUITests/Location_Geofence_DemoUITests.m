//
//  Location_Geofence_DemoUITests.m
//  Location-Geofence-DemoUITests
//
//  Created by eidan on 17/1/9.
//  Copyright © 2017年 autonavi. All rights reserved.
//

#import <XCTest/XCTest.h>

@interface Location_Geofence_DemoUITests : XCTestCase

@end

@implementation Location_Geofence_DemoUITests

- (void)setUp {
    [super setUp];
    
    // Put setup code here. This method is called before the invocation of each test method in the class.
    
    // In UI tests it is usually best to stop immediately when a failure occurs.
    self.continueAfterFailure = NO;
    // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
    [[[XCUIApplication alloc] init] launch];
    
    // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    
    XCUIApplication *app = [[XCUIApplication alloc] init];
    
    sleep(1);
    
    [app.buttons[@"\u6dfb\u52a0\u5706\u5f62\u56f4\u680f"] tap];  //圆形围栏
    sleep(1);
    
    [app.buttons[@"\u6dfb\u52a0\u591a\u8fb9\u5f62\u56f4\u680f"] tap];  //多边形围栏
    sleep(1);
    
    [app.buttons[@"\u6dfb\u52a0\u5317\u4eac\u9ea6\u5f53\u52b3\u56f4\u680f"] tap];  //北京麦当劳POI围栏
    sleep(2);
    
    [app.buttons[@"\u6dfb\u52a0\u5468\u8fb9\u80af\u5fb7\u57fa\u56f4\u680f"] tap]; //POI周边围栏：天安门附近肯德基
    sleep(2);
    
    [app.buttons[@"\u6dfb\u52a0\u5317\u4eac\u5e02\u897f\u57ce\u533a\u56f4\u680f"] tap];  //北京西城区围栏
    sleep(2);
    
}

@end
