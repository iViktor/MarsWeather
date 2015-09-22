//
//  WeatherCVCell.h
//  WeatherOnMars
//
//  Copyright © 2015 Viktor Edelberg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WeatherRestClient.h"

@interface WeatherCVCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UILabel *terrestrialDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *marsDayLabel;
@property (weak, nonatomic) IBOutlet UILabel *minTempLabel;
@property (weak, nonatomic) IBOutlet UILabel *maxTempLabel;
@property (weak, nonatomic) IBOutlet UILabel *weatherStatusLabel;
@property (weak, nonatomic) IBOutlet UIImageView *weatherCellBg;
@property (weak, nonatomic) IBOutlet UILabel *sunRiseSetLabel;


@end
