//
//  BroadcastViewController.m
//  StaySafe
//
//  Created by Prashant Mahesh Patel on 11/24/15.
//  Copyright © 2015 Prashant Mahesh Patel. All rights reserved.
//

#import "BroadcastViewController.h"
#import <MapKit/MapKit.h>
@import CoreLocation;


@interface BroadcastViewController ()
@property (weak, nonatomic) IBOutlet MKMapView *broadcastMapView;
@property (nonatomic , strong) CLLocationManager *mgr;
@end

@implementation BroadcastViewController

double latitude, longitude;

//default coordinates
#define SU_LATITUDE 43.0469444444
#define SU_LONGITUDE -76.2777777777
//default span for zoom
#define THE_SPAN 0.05f;




- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //loading defaults
    [self loadDefault];
    
    //load gps data
    [self loadGpsParams];
    
}


-(void) loadDefault{
    //default latitude and longitude - incase GPS is not working
    latitude = SU_LATITUDE;
    longitude = SU_LONGITUDE;
}

-(void) loadGpsParams{
    //gpx
    if ( [CLLocationManager locationServicesEnabled] )
    {
        NSLog(@"locationServicesEnabled");
        self.mgr = [[CLLocationManager alloc] init];  // get a location manager
        self.mgr.distanceFilter = 50.0;               // set criterion for location updating
        self.mgr.desiredAccuracy = kCLLocationAccuracyBest; // set criterion for location updating
        self.mgr.delegate =  self; // establish delegate to listen for updates
        if ( [[[UIDevice currentDevice] systemVersion] doubleValue] >= 8.0 )
        {
            NSLog(@"iOS >= 8.0");
            [self.mgr requestAlwaysAuthorization]; // for permission to use location services whenever the app is running.
        }
        //        if([self.mgr respondsToSelector:@selector(requestAlwaysAuthorization)]) {
        //            [self.mgr requestAlwaysAuthorization];
        //        }
        // - or -
        //        if([self.mgr respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        //            [self.mgr requestWhenInUseAuthorization];
        //        }
        [self.mgr startUpdatingLocation ];
    }
}

// CLLocationManagerDelegate method that receives location updates
- (void)locationManager: (CLLocationManager *)manager
     didUpdateLocations: (NSArray *)locations
{
    
    NSLog(@"locationManager:didUpdateLocations:");
    CLLocation* location = [locations lastObject];
    NSLog(@"latitude %+.6f, longitude %+.6f\n",location.coordinate.latitude, location.coordinate.longitude);
    
    latitude = location.coordinate.latitude;
    longitude = location.coordinate.longitude;
    
    //create the region
    MKCoordinateRegion userRegion;
    //Center
    CLLocationCoordinate2D center;
    center.latitude = latitude;
    center.longitude = longitude;
    //Span
    MKCoordinateSpan userSpan;
    userSpan.latitudeDelta = THE_SPAN;
    userSpan.longitudeDelta = THE_SPAN;
    //assign the center
    userRegion.center = center;
    userRegion.span = userSpan;
    //set our Mapview
    [self.broadcastMapView setRegion:userRegion animated:YES];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
