//
//  BryxHTTPHandler.m
//  Bryx 911
//
//  Created by Harlan Haskins on 12/30/13.
//  Copyright (c) 2013 Bryx. All rights reserved.
//

#import "WebNewsDataHandler.h"

@implementation WebNewsDataHandler

+ (void) runHTTPGETOperationWithParameters:(NSString*)parameters
                                success:(HTTPSuccessBlock)successBlock
                                failure:(HTTPFailureBlock)failure {
    
    NSURL *url = [self urlFromParameters:parameters];
    
    // Create an NSURLRequest with that URL.
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setHTTPMethod:@"GET"];
    
    [self runHTTPOperationWithRequest:request success:successBlock failure:failure];
}

+ (NSURL *) urlFromParameters:(NSString*)parameters {
    NSString *apiKey = [[PDKeychainBindings sharedKeychainBindings] objectForKey:kApiKeyKey];
    
    NSString *apiKeyString = [NSString stringWithFormat:@"api_key=%@&api_agent=iOS", apiKey];
    
    NSString *questionMarkString = @"?";
    NSString *ampersandString = @"&";
    
    if ([parameters rangeOfString:questionMarkString].location == NSNotFound) {
        apiKeyString = [questionMarkString stringByAppendingString:apiKeyString];
    }
    else {
        apiKeyString = [ampersandString stringByAppendingString:apiKeyString];
    }
    
    parameters = [parameters stringByAppendingString:apiKeyString];
    
    NSString *activityString = [NSString stringWithFormat:kBaseURLFormat, parameters];
    
    NSURL *url = [NSURL URLWithString:[activityString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    return url;
}

+ (void) runHTTPOperationWithRequest:(NSURLRequest*)request
                                success:(HTTPSuccessBlock)successBlock
                                failure:(HTTPFailureBlock)failure  {
    // Create an AFHTTPRequestOperation with that request. Lots of creation here.
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    
    // Necessary because CSH is stingy with their SSL.
    operation.securityPolicy.allowInvalidCertificates = YES;
    
    // Create a response serializer. That'll convert the JSON to an NSDictionary automagically (read: so I don't have to.)
    AFJSONResponseSerializer *serializer = [AFJSONResponseSerializer serializerWithReadingOptions:(NSJSONReadingMutableContainers | NSJSONReadingMutableLeaves)];
    
    operation.responseSerializer = serializer;
    [operation setCompletionBlockWithSuccess:successBlock failure:failure];
    [[NSOperationQueue mainQueue] addOperation:operation];
}

+ (void) runHTTPPUTOperationWithParameters:(NSString*)parameters
                                success:(HTTPSuccessBlock)successBlock
                                failure:(HTTPFailureBlock)failure {
    NSURL *url = [self urlFromParameters:parameters];
    
    // Create an NSURLRequest with that URL.
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setHTTPMethod:@"PUT"];
    
    [self runHTTPOperationWithRequest:request success:successBlock failure:failure];
}

@end
