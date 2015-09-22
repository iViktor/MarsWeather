//
//  ViewController.h
//  WeatherOnMars
//
//  Copyright © 2015 Viktor Edelberg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WeatherCVCell.h"
#import "WeatherRestClient.h"

@interface ViewController : UIViewController <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, NSFetchedResultsControllerDelegate>
@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, strong) NSManagedObjectContext *context;
@property (nonatomic, strong) WeatherRestClient *restClient;
@property (nonatomic, strong) UIRefreshControl *refreshControl;

@property (weak, nonatomic) IBOutlet UICollectionView *weatherCV;
@property (weak, nonatomic) IBOutlet UIImageView *marsBG;
@end

