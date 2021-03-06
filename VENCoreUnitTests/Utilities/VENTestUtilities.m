#import "VENTestUtilities.h"
#import "VENCore.h"

@implementation VENTestUtilities

+ (id)objectFromJSONResource:(NSString *)name {
    NSString *fileString = [VENTestUtilities stringFromJSONResource:name];
    return [NSJSONSerialization JSONObjectWithData:[fileString dataUsingEncoding:
                                             NSUTF8StringEncoding] options:0 error:nil];
}


+ (NSString *)stringFromJSONResource:(NSString *)name {
    NSString *filePath = [[NSBundle bundleForClass:[self class]] pathForResource:name ofType:@"json"];
    NSString *fileString = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding
                                                        error:NULL];
    return fileString;
}


+ (NSString *)baseURLStringForCore:(VENCore *)core {
    return [core.httpClient.baseURL absoluteString];
}


+ (void)stubNetworkGET:(NSString *)path
        withStatusCode:(NSInteger)statusCode
   andResponseFilePath:(NSString *)filePath {
    
    NSString *responseFileContents = [self stringFromJSONResource:filePath];
    
    NSMutableDictionary *headers = [[[VENCore defaultCore].httpClient defaultHeaders] mutableCopy];

    stubRequest(@"GET", path).
    andReturn(statusCode).
    withHeaders(headers).
    withBody(responseFileContents);
}


+ (void)stubNetworkPOST:(NSString *)path
          forParameters:(NSDictionary *)dictionary
         withStatusCode:(NSInteger)statusCode
    andResponseFilePath:(NSString *)filePath {
    
    NSString *responseFileContents = [self stringFromJSONResource:filePath];
    
    NSMutableDictionary *headers = [[[VENCore defaultCore].httpClient defaultHeaders] mutableCopy];
    headers[@"Content-Type"] = @"application/json";
    
    stubRequest(@"POST", path).
    andReturn(statusCode).
    withBody([NSKeyedArchiver archivedDataWithRootObject:dictionary]).
    withHeaders(headers).
    withBody(responseFileContents);
}


+ (NSString *)accessToken {
    NSString *plistPath = [[NSBundle bundleForClass:[self class]] pathForResource:@"config" ofType:@"plist"];
    NSDictionary *config = [[NSDictionary alloc] initWithContentsOfFile:plistPath];
    return config[@"access_token"];
}

@end
