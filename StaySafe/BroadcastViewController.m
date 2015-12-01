//
//  BroadcastViewController.m
//  StaySafe
//
//  Created by Prashant Mahesh Patel on 11/24/15.
//  Copyright © 2015 Prashant Mahesh Patel. All rights reserved.
//

#import "BroadcastViewController.h"
#import "Annotation.h"
#import <MapKit/MapKit.h>
#import "model/RepositoryModel.h"
@import CoreLocation;


@interface BroadcastViewController ()
@property (weak, nonatomic) IBOutlet MKMapView *broadcastMapView;
@property (nonatomic , strong) CLLocationManager *mgr;
@property(nonatomic,weak) RepositoryModel *repository;
@end

@implementation BroadcastViewController

double latitude, longitude;


//default span for zoom
#define THE_SPAN 0.02f;




- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //loading defaults
    [self loadDefault];
    
    //load gps data
    [self loadGpsParams];
    
    //adding the annotation
    [self addAnnotation];
    
    //make a REST call
    [self makeRestAPICall];
    
}

//set by IconPageViewcontroller in order to have a single repository instance
- (void) setRepository:(RepositoryModel *)repository{
    _repository = repository;
}

-(void) loadDefault{
    //default latitude and longitude - incase GPS is not working
    latitude = [self.repository defaultLatitude];
    longitude = [self.repository defaultLongitude];
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

-(void) addAnnotation{
    //Annotation
    
    //Create the location array for storing multiple annotations
    NSMutableArray* nearbyUsersLocation = [[NSMutableArray alloc] init];
    CLLocationCoordinate2D location;
    Annotation* nearbyUsersAnnotation;
    
    //setting annotation for nearby user 1
    nearbyUsersAnnotation = [[Annotation alloc]init];
    location.latitude = 43.0377;
    location.longitude = -76.1340;
    nearbyUsersAnnotation.coordinate = location;
    nearbyUsersAnnotation.title = @"Mark";
    nearbyUsersAnnotation.subtitle = @"Mark's description";
    [nearbyUsersLocation addObject:nearbyUsersAnnotation];
    
    //setting annotation for nearby user 2
    nearbyUsersAnnotation = [[Annotation alloc]init];
    location.latitude = 43.0412;
    location.longitude = -76.1195;
    nearbyUsersAnnotation.coordinate = location;
    nearbyUsersAnnotation.title = @"Jersey";
    nearbyUsersAnnotation.subtitle = @"Jersey's description";
    [nearbyUsersLocation addObject:nearbyUsersAnnotation];
    
    //adding the set  annotations to Mapview
    [self.broadcastMapView addAnnotations:nearbyUsersLocation];

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

-(void) makeRestAPICall
{
    NSString *post = [NSString stringWithFormat:@"{\"query\":\"*\"}"];
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    
    NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:@"https://api-us.clusterpoint.com/102990/user_detail/_search.json"]];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setHTTPBody:postData];
    NSString* plainString = @"pp231189@gmail.com:123ABCabc$";
    NSData *plainData = [plainString dataUsingEncoding:NSUTF8StringEncoding];
    NSString *base64String = [plainData base64EncodedStringWithOptions:0];
    NSString* headerValue = [@"Basic " stringByAppendingString:base64String];
    [request addValue:headerValue forHTTPHeaderField:@"Authorization"];
    
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    [[session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSString *requestReply = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
        NSLog(@"requestReply: %@", requestReply);
    }] resume];
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
