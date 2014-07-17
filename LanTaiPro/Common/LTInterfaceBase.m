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
        if(![key isEqualToString:@"pic"])  {
            NSString *value=[params objectForKey:key];
            postString=[postString stringByAppendingFormat:@"%@=%@&",key,value];
        }
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

    NSMutableString *header= [NSMutableString stringWithFormat:@"%@",[LTInterfaceBase createPostURL:params]];
    if ([method isEqualToString:@"POST"])
    {
        request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:requestUrl] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:60];
        
        //分界线的标识符
        NSString *TWITTERFON_FORM_BOUNDARY = @"AaB03x";
        //分界线 --AaB03x
        NSString *MPboundary=[[NSString alloc]initWithFormat:@"--%@",TWITTERFON_FORM_BOUNDARY];
        //结束符 AaB03x--
        NSString *endMPboundary=[[NSString alloc]initWithFormat:@"%@--",MPboundary];
        
        //http body的字符串
        NSMutableString *body=[[NSMutableString alloc]init];
        //参数的集合的所有key的集合
        NSArray *keys= [params allKeys];
        //遍历keys
        for(int i=0;i<[keys count];i++)
        {
            //得到当前key
            NSString *key=[keys objectAtIndex:i];
            //如果key不是pic，说明value是字符类型，比如name：Boris
            if(![key isEqualToString:@"pic"])
            {
                //添加分界线，换行
                [body appendFormat:@"%@\r\n",MPboundary];
                //添加字段名称，换2行
                [body appendFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n",key];
                //添加字段的值
                [body appendFormat:@"%@\r\n",[params objectForKey:key]];
            }
        }
        
        ////添加分界线，换行
        [body appendFormat:@"%@\r\n",MPboundary];
        //声明pic字段，文件名为boris.png
        [body appendFormat:@"Content-Disposition: form-data; name=\"pic\"; filename=\"boris.png\"\r\n"];
        //声明上传文件的格式
        [body appendFormat:@"Content-Type: image/png\r\n\r\n"];
        
        //声明结束符：--AaB03x--
        NSString *end=[[NSString alloc]initWithFormat:@"\r\n%@",endMPboundary];
        //声明myRequestData，用来放入http body
        NSMutableData *myRequestData=[NSMutableData data];
        
        //将body字符串转化为UTF8格式的二进制
        [myRequestData appendData:[body dataUsingEncoding:NSUTF8StringEncoding]];
        //将image的data加入
        if ([keys containsObject:@"pic"]) {
            UIImage *image=[params objectForKey:@"pic"];
            NSData* data = UIImagePNGRepresentation(image);
            //将image的data加入
            [myRequestData appendData:data];
        }
        //加入结束符--AaB03x--
        [myRequestData appendData:[end dataUsingEncoding:NSUTF8StringEncoding]];
        
        //设置HTTPHeader中Content-Type的值
        NSString *content=[[NSString alloc]initWithFormat:@"multipart/form-data; boundary=%@",TWITTERFON_FORM_BOUNDARY];
        //设置HTTPHeader
        [request setValue:content forHTTPHeaderField:@"Content-Type"];
        //设置Content-Length
        [request setValue:[NSString stringWithFormat:@"%d", [myRequestData length]] forHTTPHeaderField:@"Content-Length"];
        //设置http body
        [request setHTTPBody:myRequestData];
        
        [request setHTTPMethod:@"POST"];
    }else if ([method isEqualToString:@"GET"])
    {
        NSMutableString *urlStr = [NSMutableString stringWithFormat:@"%@",requestUrl];
        [urlStr appendFormat:@"?%@",header];
        //url含中文转化UTF8
        urlStr = (__bridge_transfer NSMutableString *)CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                                                              (CFStringRef)urlStr,
                                                                                              NULL,
                                                                                              NULL,
                                                                                              kCFStringEncodingUTF8);
        request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlStr] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:60];
    }
    else if ([method isEqualToString:@"PUT"]){
        
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
    }else {
        if (errorBlock_) {
            errorBlock_(@"后台出错了,产品经理要被扣工资了～");
        }
    }
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    if (errorBlock_) {
        errorBlock_(@"与服务器链接失败");
    }
}

@end
