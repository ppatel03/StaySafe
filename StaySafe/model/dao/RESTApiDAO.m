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
    query = @"{\"query\":\"*\",\"docs\":1000}";
    NSString *post = [NSString stringWithFormat:@"%@",query];
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    
    NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    
   
    NSString *url = [NSString stringWithFormat:@"%@%@%@%@%@%@%@", DOMAIN_URL, URL_DELIMITER,USER_ACCOUNT_NUMBER,URL_DELIMITER,
                     tableName,URL_DELIMITER,SEARCH_OPERATION];
    
    //preparing the request Data to query Cluster point server
    [self prepareRequestToQueryJSON:request urlString:url postLen:postLength postContent:postData httpMethod:METHOD_POST authRequired:true];
    
    NSLog(@"Searching all users : ");
    
    //return the synchronous response from asynchronous request
    return [self getSynchronousResponse:request];
    
}

// asynchronous update on the user location
-(void) makeRESTAPIcallToUpdaterUserLocation : (NSString*) query table : (NSString*) tableName{
    NSString *post = [NSString stringWithFormat:@"%@",query];
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    
    NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    
    
    NSString *url = [NSString stringWithFormat:@"%@%@%@%@%@%@%@", DOMAIN_URL, URL_DELIMITER,USER_ACCOUNT_NUMBER,URL_DELIMITER,
                     tableName,URL_DELIMITER,PARTIAL_REPLACE_OPERATION];
    
    //preparing the request Data to query Cluster point server
    [self prepareRequestToQueryJSON:request urlString:url postLen:postLength postContent:postData httpMethod:METHOD_POST authRequired:true];
    
    NSLog(@"Updating the user location for query : %@", query);
    //sending asynchronous update request
    [self sendAsynchronousRequest:request];
    
}

// asynchronous insert for safewalk db
-(void) makeRESTAPIcallToInsertUserSafeWalkData : (NSString*) query table : (NSString*) tableName{
    NSString *post = [NSString stringWithFormat:@"%@",query];
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    
    NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    
    
    NSString *url = [NSString stringWithFormat:@"%@%@%@%@%@%@%@", DOMAIN_URL, URL_DELIMITER,USER_ACCOUNT_NUMBER,URL_DELIMITER,
                     tableName,URL_DELIMITER,JSON_EXTENSION];
    
    //preparing the request Data to query Cluster point server
    [self prepareRequestToQueryJSON:request urlString:url postLen:postLength postContent:postData httpMethod:METHOD_POST authRequired:true];
    
    NSLog(@"Inserting the user safe walk data for query : %@", query);
    //sending asynchronous update request
    [self sendAsynchronousRequest:request];
    
}



// asynchronous sms sending to the user
-(void) makeRESTAPIcallToSendSMS : (NSString*) query {
   
    NSLog(@"SMS send request Query  : %@",query);
    NSString *post = [NSString stringWithFormat:@"%@",query];
    NSData *postData = [post  dataUsingEncoding:NSUTF8StringEncoding ];
    
    NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    
    NSString *url = [NSString stringWithFormat:@"%@", SMS_API_URL];
    
    
    //preparing the request Data to query Cluster point server
    [self prepareRequestToQueryJSON:request urlString:url postLen:postLength postContent:postData httpMethod:METHOD_POST authRequired:false];
    
    
    NSLog(@"Sending the SMS to the user ");
    
    //sending asynchronous update request
    [self sendAsynchronousRequest:request];
    
}

// prepare the request to query the cluster point database
- (void) prepareRequestToQueryJSON : (NSMutableURLRequest*) request urlString : (NSString*) url
                           postLen : (NSString*) postLength postContent : (NSData*) postData
                        httpMethod : (NSString*) methodName authRequired : (BOOL) isAuthRequired{
    
    [request setURL:[NSURL URLWithString:url]];
    [request setHTTPMethod:methodName];
    [request setValue:postLength forHTTPHeaderField:CONTENT_LENGTH_HEADER_FIELD];
    [request setHTTPBody:postData];
    
    if (isAuthRequired) {
        NSString* plainString = USER_CREDENTIALS;
        NSData *plainData = [plainString dataUsingEncoding:NSUTF8StringEncoding];
        NSString *base64String = [plainData base64EncodedStringWithOptions:0];
        NSString* headerValue = [USER_CREDENTIALS_TYPE stringByAppendingString:base64String];
        [request addValue:headerValue forHTTPHeaderField:AUTHORIZATION_HEADER_FIELD];
    }
    
}

/* ============================= METHODS WITH LOGIC OF SENDING SYNCHRONOUS/ASYNCHRONOUS REQUEST STARTS HERE ===================================== */

//performs the asynchronous non-blocking operation for the asynchronous REST API call and returns the data received from the server
-(void) sendAsynchronousRequest : (NSMutableURLRequest*) request {
    //creating the session to get the json response
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    [[session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        // useful for logging
        if (data != nil) {
            NSString* jsonResponse = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
            NSLog(@"This is Asynchronous Succesfull Response : %@",jsonResponse);
        } else{
            NSLog(@"This is Asynchronous Request Error : %@",error);

        }
       

    }] resume];
}


//performs the blocking operation for the asynchronous REST API call and returns the data received from the server
-(NSString*) getSynchronousResponse : (NSMutableURLRequest*) request {
    NSString* jsonResponse = nil;
    
    //creating the semaphore to make sure you process ahead only when the reponse is received from the server
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    
    //creatinng the session to get the json response
    __block NSData* responseData = nil;
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    [[session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        // useful for logging
        if (data != nil) {
            NSString* jsonResponse = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
            NSLog(@"This is Synchronous Succesfull Response : %@",jsonResponse);
        } else{
            NSLog(@"This is Synchronous Request Error : %@",error);
            
        }
        
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

    return jsonResponse;
}


/* ============================= METHODS WITH LOGIC OF SENDING SYNCHRONOUS/ASYNCHRONOUS REQUEST ENDS HERE ===================================== */




@end
