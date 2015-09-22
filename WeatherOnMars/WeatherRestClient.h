//
//  WeatherRestClient.h
//  WeatherOnMars
//
//  Copyright © 2015 Viktor Edelberg. All rights reserved.
//

#import "AFHTTPSessionManager.h"
#import "AFHTTPRequestOperation.h"

@protocol WeatherHTTPClientDelegate;

@interface WeatherRestClient : AFHTTPSessionManager
@property (nonatomic, weak) id<WeatherHTTPClientDelegate>delegate;
@property (nonatomic, strong) NSManagedObjectContext *context;

+ (WeatherRestClient *)sharedWeatherClient;
- (instancetype)initWithBaseURL:(NSURL *)url;
-(void)getLatestMarsWeather;

@end

@protocol WeatherHTTPClientDelegate <NSObject>
@optional
-(void)weatherHTTPClient:(WeatherRestClient *)client didUpdateWithWeather:(id)weather;
-(void)weatherHTTPClient:(WeatherRestClient *)client didFailWithError:(NSError *)error;
-(void)showAlert;
@end