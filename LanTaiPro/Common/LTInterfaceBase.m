//
//  LTInterfaceBase.m
//  LanTaiPro
//
//  Created by comdosoft on 14-5-6.
//  Copyright (c) 2014年 LanTaiPro. All rights reserved.
//

#import "LTInterfaceBase.h"

@implementation LTInterfaceBase

+(NSString *)createPostURL:(NSMutableDictionary *)params
{
    NSString *postString=@"";
    for(NSString *key in [params allKeys])
    {
        NSString *value=[params objectForKey:key];
        postString=[postString stringByAppendingFormat:@"%@=%@&",key,value];
    }
    if([postString length]>1)
    {
        postString=[postString substringToIndex:[postString length]-1];
    }
    return postString;
}

+ (id)request:(NSMutableDictionary *)params requestUrl:(NSString *)requestUrl method:(NSString *)method completeBlock:(CompleteBlock_t)compleBlock errorBlock:(ErrorBlock_t)errorBlock;
{
    return [[self alloc] initWithRequest:params requestUrl:requestUrl method:method completeBlock:compleBlock errorBlock:errorBlock];
}

- (id)initWithRequest:(NSMutableDictionary *)params requestUrl:(NSString *)requestUrl method:(NSString *)method completeBlock:(CompleteBlock_t)compleBlock errorBlock:(ErrorBlock_t)errorBlock
{
    NSMutableURLRequest *request;
    
    NSString *header=[LTInterfaceBase createPostURL:params];
    if ([method isEqualToString:@"POST"]) {
        request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:requestUrl]];
        [request setHTTPMethod:@"POST"];
        [request setHTTPBody:[header dataUsingEncoding:NSUTF8StringEncoding]];
        [request addValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    }else if ([method isEqualToString:@"GET"]){
        NSMutableString *urlStr = [NSMutableString stringWithFormat:@"%@",requestUrl];
        [urlStr appendFormat:@"?%@",header];
        //url含中文转化UTF8
        urlStr = (__bridge_transfer NSMutableString *)CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                                                              (CFStringRef)urlStr,
                                                                                              NULL,
                                                                                              NULL,
                                                                                              kCFStringEncodingUTF8);
        request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlStr] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:60];
    }else if ([method isEqualToString:@"PUT"]){
        
    }
    
    if (self = [super initWithRequest:request delegate:self startImmediately:NO]) {
        data_ = [[NSMutableData alloc] init];
        
        completeBlock_ = [compleBlock copy];
        errorBlock_ = [errorBlock copy];
        
        [self start];
    }
    
    return self;
}

#pragma mark- NSURLConnectionDataDelegate

-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    [data_ setLength:0];
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [data_ appendData:data];
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    id jsonObject=[NSJSONSerialization JSONObjectWithData:data_ options:NSJSONReadingAllowFragments error:nil];
    if (jsonObject !=nil) {
        if ([jsonObject isKindOfClass:[NSDictionary class]]) {
            NSDictionary *jsonData=(NSDictionary *)jsonObject;
            if ([[jsonData objectForKey:@"status"]intValue]==1){
                NSDictionary *obj = [jsonData objectForKey:@"obj"];
                if (completeBlock_) {
                    completeBlock_(obj);
                }
            }else if ([[jsonData objectForKey:@"status"]intValue]==0){
                NSString *msg = [jsonData objectForKey:@"msg"];
                if (errorBlock_) {
                    errorBlock_(msg);
                }
            }
        }
    }
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    errorBlock_(@"出错了,产品经理要被扣工资了～");
}

@end
