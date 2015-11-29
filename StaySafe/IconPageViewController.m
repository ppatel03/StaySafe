//
//  IconPageViewController.m
//  StaySafe
//
//  Created by Prashant Mahesh Patel on 11/19/15.
//  Copyright © 2015 Prashant Mahesh Patel. All rights reserved.
//
@import CoreLocation;
#import "model/RepositoryModel.h"
#import "IconPageViewController.h"
#import "BroadcastViewController.h"

@interface IconPageViewController ()


@property (weak, nonatomic) IBOutlet UIButton *shareIconButton;
@property (weak, nonatomic) IBOutlet UIButton *broadcastIconButton;
@property (weak, nonatomic) IBOutlet UIButton *helpIconButton;
@property (weak, nonatomic) IBOutlet UIButton *safewalkIconButton;
@property (strong,nonatomic) RepositoryModel *repository;
@property (weak, nonatomic) BroadcastViewController  *broadcastViewController;


- (IBAction)shareIconButtonAction:(id)sender;
@end

@implementation IconPageViewController

NSString* const imagePath = @"../images/";

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    // note which segue chosen (need to know if more than one segue from current view controller)
    NSLog( @"Transition via segue: '%@'", segue.identifier);
    
    [super prepareForSegue:segue sender:sender];
    
    //load the defaults in the repository
    [self.repository storeDefaultLatitudeAndLongitude];
    
    if([@"broadcast" caseInsensitiveCompare: segue.identifier] == NSOrderedSame  ){
        // pick up destination view controller from segue object - broadcast
        self.broadcastViewController = segue.destinationViewController;
        [self.broadcastViewController setRepository:self.repository];
        
    }
}

- (IBAction)shareIconButtonAction:(id)sender {
}

// We override the default auto-generated getter for property model (which just
// returns the current value of ivar _model;), so we can do LAZY INSTANTIATION
// of our model object of class Model; doing lazy instantiation in getters
// is good practice, as objects won't be created until they are needed).  Note
// that we must use ivar _model here (using self.model would cause recursive call!)
- (RepositoryModel *) repository
{
    if (!_repository)
        _repository = [[RepositoryModel alloc] init];
    
    return _repository;
}
@end
