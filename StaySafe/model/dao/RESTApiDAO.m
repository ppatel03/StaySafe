//
//  RESTApiDAO.m
//  StaySafe
//
//  Created by Prashant Mahesh Patel on 12/1/15.
//  Copyright © 2015 Prashant Mahesh Patel. All rights reserved.
//

#import "RESTApiDAO.h"

@interface RESTApiDAO ()

@end


@implementation RESTApiDAO

//default constructor
- (id) init
{
    if ( self = [super init] )
    {
        // do nothing
    }
    return self;
}


//fetches the data from the Cluster point DB based on Search query
-(NSString*) makeRESTAPIcallForSearch:(NSString*)  query table : (NSString*) tableName{
    NSString *post = [NSString stringWithFormat:@"%@",query];
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    
    NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    
   
    NSString *url = [NSString stringWithFormat:@"%@%@%@%@%@%@%@", DOMAIN_URL, URL_DELIMITER,USER_ACCOUNT_NUMBER,URL_DELIMITER,
                     tableName,URL_DELIMITER,SEARCH_OPERATION];
    
    //creating the request
    [request setURL:[NSURL URLWithString:url]];
    [request setHTTPMethod:METHOD_POST];
    [request setValue:postLength forHTTPHeaderField:CONTENT_LENGTH_HEADER_FIELD];
    [request setHTTPBody:postData];
    NSString* plainString = USER_CREDENTIALS;
    NSData *plainData = [plainString dataUsingEncoding:NSUTF8StringEncoding];
    NSString *base64String = [plainData base64EncodedStringWithOptions:0];
    NSString* headerValue = [USER_CREDENTIALS_TYPE stringByAppendingString:base64String];
    [request addValue:headerValue forHTTPHeaderField:AUTHORIZATION_HEADER_FIELD];
    
    return [self getResponse:request];
    
}

//performs the blocking operation for the asynchronous REST API call and returns the data received from the server
-(NSString*) getResponse : (NSMutableURLRequest*) request {
    NSString* jsonResponse = nil;
    
    //creating the semaphore to make sure you process ahead only when the reponse is received from the server
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    
    //creatinng the session to get the json response
    __block NSData* responseData = nil;
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    [[session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        responseData = data;
        //signal the wait operation by incrementing the semaphore
        dispatch_semaphore_signal(semaphore);
    }] resume];
    
    //halting the process till the signal is sent - decrements the semaphore
    // If the resulting value is less than zero, this function waits in FIFO order for a signal to occur before returning.
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    
    //check if the server received the correct response
    if (responseData != nil) {
        jsonResponse = [[NSString alloc] initWithData:responseData encoding:NSASCIIStringEncoding];
    }

    NSLog(@"This is from the calling : %@",jsonResponse);
    return jsonResponse;
}





@end
