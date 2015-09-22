//
//  WeatherRestClient.m
//  WeatherOnMars
//
//  Copyright © 2015 Viktor Edelberg. All rights reserved.
//

#import "WeatherRestClient.h"

static NSString * const latestMarsWeatherURLString = @"http://marsweather.ingenology.com/v1/latest/?format=json";
static NSString * const archiveMarsWeatherURLString = @"http://marsweather.ingenology.com/v1/archive/?format=json";

@implementation WeatherRestClient

+ (WeatherRestClient *)sharedWeatherClient
{
    static WeatherRestClient *_sharedWeatherClient = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedWeatherClient = [[self alloc] initWithBaseURL:[NSURL URLWithString:latestMarsWeatherURLString]];
    });
    
    return _sharedWeatherClient;
}

- (instancetype)initWithBaseURL:(NSURL *)url
{
    self = [super initWithBaseURL:url];
    
    if (self) {
        self.responseSerializer = [AFJSONResponseSerializer serializer];
        self.requestSerializer = [AFJSONRequestSerializer serializer];
    }
    
    return self;
}

-(void)getLatestMarsWeather {

    NSURL *url = [NSURL URLWithString:latestMarsWeatherURLString];
    [self getMarsWeatherFromURL: url];
    [self getArchivedMarsWeather];
}

-(void)getArchivedMarsWeather {
    
    NSURL *url = [NSURL URLWithString:archiveMarsWeatherURLString];
    [self getMarsWeatherFromURL: url];
}

-(void)getMarsWeatherFromURL: (NSURL*)url {
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        [self parseRetrievedWeather: (NSDictionary*)responseObject];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if ([self.delegate respondsToSelector:@selector(showAlert)]) {
            [self.delegate performSelector:@selector(showAlert)];
        }
    }];
    
    [operation start];

}

-(void)parseRetrievedWeather:(NSDictionary*)weatherDictionary {
    if (weatherDictionary) {
        if (weatherDictionary[@"results"]) {
            for (NSDictionary *daysWeather in weatherDictionary[@"results"]) {
                [self parseWeather:daysWeather];
            }
        } else if (weatherDictionary[@"report"]) {
            [self parseWeather:weatherDictionary[@"report"]];
        }
    } else {
        // This would be a place for more error handling.
    }
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        [self enqueueNotificationCoalescedOnName:kNotificationWeatherDataSaved];
    }];
}

-(void) parseWeather:(NSDictionary*)daysWeather {
    
    if (!self.context) {
        self.context = [[NSManagedObjectContext alloc] initWithConcurrencyType: NSMainQueueConcurrencyType];
        self.context.parentContext = [SharedAppDelegate managedObjectContext];
    }

    static NSFetchRequest *request;
    if (!request) {
        request = [[NSFetchRequest alloc] init];
        NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"Weather"
                                                             inManagedObjectContext:self.context];
        request.entity = entityDescription;
    }
    NSString *checkDate = [daysWeather valueForKey:@"terrestrial_date"];
    request.predicate = [NSPredicate predicateWithFormat:@"terrestrial_date = %@", checkDate];
    
    NSError *error = nil;
    NSArray *fetchedData = [self.context executeFetchRequest:request error:&error];
    if (error) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    NSManagedObject *weatherMO = fetchedData.lastObject;
    if (weatherMO) {
        NSLog(@"Weather data for %@ already downloaded.", checkDate);
        return;
    } else {
        weatherMO = [NSEntityDescription insertNewObjectForEntityForName: @"Weather" inManagedObjectContext: self.context];
    }

    NSString *terrestrialDateString = daysWeather[@"terrestrial_date"];
    if (terrestrialDateString) {
        [weatherMO setValue: terrestrialDateString forKey: @"terrestrial_date"];
    }
    
    NSNumber *sol = daysWeather[@"sol"];
    if (sol) {
        [weatherMO setValue: sol forKey: @"sol"];
    }
    
    NSNumber  *ls = daysWeather[@"ls"];
    if (ls) {
        [weatherMO setValue: ls forKey: @"ls"];
    }

    NSNumber *minTemp = daysWeather[@"min_temp"];
    if (minTemp) {
        [weatherMO setValue: minTemp forKey: @"min_temp"];
    }
    
    NSNumber *minTempF = daysWeather[@"min_temp_fahrenheit"];
    if (minTempF) {
        [weatherMO setValue: minTempF forKey: @"min_temp_fahrenheit"];
    }
    
    NSNumber *maxTemp = daysWeather[@"max_temp"];
    if (maxTemp) {
        [weatherMO setValue: maxTemp forKey: @"max_temp"];
    }
    
    NSNumber *maxTempF = daysWeather[@"max_temp_fahrenheit"];
    if (maxTempF) {
        [weatherMO setValue: maxTempF forKey: @"max_temp_fahrenheit"];
    }
    
    NSNumber *pressure = daysWeather[@"pressure"];
    if (pressure) {
        [weatherMO setValue: daysWeather[@"pressure"] forKey: @"pressure"];
    }
    
    NSString *pressureString = daysWeather[@"pressure_string"];
    if (pressureString) {
        [weatherMO setValue: pressureString forKey: @"pressure_string"];
    }
    
//    NSNumber *absHumidity = daysWeather[@"abs_humidity"];
//    if (absHumidity) {
//        [weatherMO setValue: absHumidity forKey: @"abs_humidity"];
//    }
    
//    NSNumber *windSpeed = daysWeather[@"wind_speed"];
//    if (windSpeed) {
//        [weatherMO setValue: windSpeed forKey: @"wind_speed"];
//    }
    
    NSString *windDirection = daysWeather[@"wind_direction"];
    if (windDirection) {
        [weatherMO setValue: windDirection forKey: @"wind_direction"];
    }
    
    NSString *atmoOpacity = daysWeather[@"atmo_opacity"];
    if (atmoOpacity) {
        [weatherMO setValue: atmoOpacity forKey: @"atmo_opacity"];
    }
    
    NSString *season = daysWeather[@"season"];
    if (season) {
        [weatherMO setValue: season forKey: @"season"];
    }
    
    NSString *sunriseString = daysWeather[@"sunrise"];
    if (sunriseString) {
        NSDate *date = [NSDate dateForServerDateTimeString: sunriseString];
        [weatherMO setValue: date forKey: @"sunrise"];
    }
    
    NSString *sunsetString = daysWeather[@"sunset"];
    if (sunsetString) {
        NSDate *date = [NSDate dateForServerDateTimeString: sunsetString];
        [weatherMO setValue: date forKey: @"sunset"];
    }
    
    /* One day weather dictionary:
    {"terrestrial_date": "2015-09-16",
     "sol": 1106, 
     "ls": 42.0, 
     "min_temp": -82.0, 
     "min_temp_fahrenheit": -115.6, 
     "max_temp": -22.0, 
     "max_temp_fahrenheit": -7.6, 
     "pressure": 893.0, 
     "pressure_string": "Higher", 
     "abs_humidity": null, 
     "wind_speed": null, 
     "wind_direction": "--", 
     "atmo_opacity": "Sunny", 
     "season": "Month 2", 
     "sunrise": "2015-09-16T11:16:00Z", 
     "sunset": "2015-09-16T23:04:00Z"},
     */
    NSError *saveContextError = nil;
    [self.context save:&saveContextError];
}

- (void)enqueueNotificationCoalescedOnName:(NSString *)notificationName {
    
    NSNotification *notification = [NSNotification notificationWithName:notificationName
                                                                 object:self
                                                               userInfo:nil];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [[NSNotificationQueue defaultQueue] enqueueNotification:notification
                                                   postingStyle:NSPostWhenIdle
                                                   coalesceMask:NSNotificationCoalescingOnName
                                                       forModes:nil];
    });
}
@end
