//
//  ViewController.m
//  WeatherOnMars
//
//  Copyright © 2015 Viktor Edelberg. All rights reserved.
//

#import "ViewController.h"
#import "WeatherRestClient.h"

@interface ViewController ()
@property (nonatomic, strong) NSDateFormatter *dateFormatter;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.restClient = [WeatherRestClient sharedWeatherClient];
    [self reloadWeatherData];
    self.context = [SharedAppDelegate managedObjectContext];
    
    __weak __typeof(self)weakSelf = self;
    [[NSNotificationCenter defaultCenter] addObserverForName: kNotificationWeatherDataSaved object:nil queue: [NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
        _fetchedResultsController = nil;
        [weakSelf.weatherCV reloadData];
    }];
    
    if (!self.dateFormatter) {
        self.dateFormatter = [[NSDateFormatter alloc] init];
        self.dateFormatter.dateStyle = NSDateFormatterShortStyle;
        self.dateFormatter.timeStyle = NSDateFormatterShortStyle;
    }
    
    [self.marsBG addMotionEffect];
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    self.refreshControl.tintColor = [UIColor whiteColor];
    [self.refreshControl addTarget:self action:@selector(reloadWeatherData)
                  forControlEvents:UIControlEventValueChanged];
    [self.weatherCV addSubview:self.refreshControl];
    
    [[NSNotificationCenter defaultCenter] addObserverForName: kNotificationWeatherDataSaved object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note) {
        [self.refreshControl endRefreshing];
    }];
}

-(void)reloadWeatherData {
    [self.restClient getLatestMarsWeather];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)showAlert {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle: @"Error retrieving weather" message:nil preferredStyle: UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    
    [self presentViewController: alertController animated:YES completion: nil];
}

#pragma mark - CollectionView Delegate & Datasource

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [[[self fetchedResultsController] fetchedObjects] count];
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    WeatherCVCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier: @"weatherCell" forIndexPath:indexPath];
    NSInteger itemIndex = [indexPath item];
    NSManagedObject *weatherMO = _fetchedResultsController.fetchedObjects[itemIndex];
    
    NSString *earthDate = [NSString stringWithFormat:@"%@",[weatherMO valueForKey:@"terrestrial_date"]];
    cell.terrestrialDateLabel.text = earthDate;
    
    NSNumber *solDay = [weatherMO valueForKey:@"sol"];
    cell.marsDayLabel.text = [NSString stringWithFormat: @"Sol day %@", solDay];
    
    NSNumber *minTemp = [weatherMO valueForKey:@"min_temp"];
    NSNumber *minTempF = [weatherMO valueForKey:@"min_temp_fahrenheit"];
    NSString *minTempString = [NSString stringWithFormat:@"Min \n%@°C\n%@°F", minTemp, minTempF];
    cell.minTempLabel.text = minTempString;
    
    NSNumber *maxTemp = [weatherMO valueForKey:@"max_temp"];
    NSNumber *maxTempF = [weatherMO valueForKey:@"max_temp_fahrenheit"];
    NSString *maxTempString = [NSString stringWithFormat:@"Max \n%@°C\n%@°F", maxTemp, maxTempF];
    cell.maxTempLabel.text = maxTempString;
    
    NSDate *sunRiseDate = [weatherMO valueForKey: @"sunrise"];
    NSDate *sunSetDate = [weatherMO valueForKey: @"sunset"];
    NSString *sunRiseString = [self.dateFormatter stringFromDate: sunRiseDate];
    NSString *sunSetString = [self.dateFormatter stringFromDate: sunSetDate];
    NSString *fullSunRiseSetString = [NSString stringWithFormat:@"Rise %@\nSet  %@", sunRiseString, sunSetString];
    cell.sunRiseSetLabel.text = fullSunRiseSetString;
    
    NSString *weatherStatus = [weatherMO valueForKey: @"atmo_opacity"];
    cell.weatherStatusLabel.text = [NSString stringWithFormat:@"Average \n%@", weatherStatus];
    
    
    cell.weatherCellBg.layer.cornerRadius = 10;
    cell.weatherCellBg.layer.masksToBounds = YES;

    return cell;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGSize cellSize = CGSizeMake( collectionView.frame.size.width-4, 220 );
    return cellSize;
}

#pragma mark - Fetched results controller

- (NSFetchedResultsController *)fetchedResultsController {
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    
    // Create and configure a fetch request with the Lottery entity.
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Weather" inManagedObjectContext:self.context];
    [fetchRequest setEntity:entity];
    
//    [fetchRequest setPredicate: self.segmentPredicate];
    
    // Create the sort descriptors array.
    NSSortDescriptor *dateDescriptor = [[NSSortDescriptor alloc] initWithKey:@"sol" ascending:NO];
    NSArray *sortDescriptors = @[dateDescriptor];
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    // Create and initialize the fetch results controller.
    _fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                                                    managedObjectContext:self.context
                                                                      sectionNameKeyPath:nil
                                                                               cacheName:nil];
    _fetchedResultsController.delegate = self;
    NSError *error = nil;
    if (![_fetchedResultsController performFetch:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
    }
    
    return _fetchedResultsController;
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    [self.weatherCV reloadData];
}

@end
