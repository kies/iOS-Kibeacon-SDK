//
//  beaconCell.h
//  IOS-Kibeacon-sample
//
//  Created by kimmoonki on 2015. 7. 7..
//  Copyright (c) 2015년 kimmoonki. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface beaconCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *nameLbl;
@property (weak, nonatomic) IBOutlet UILabel *macAddressLbl;
@property (weak, nonatomic) IBOutlet UILabel *UUIDLbl;
@property (weak, nonatomic) IBOutlet UILabel *batteryLbl;
@property (weak, nonatomic) IBOutlet UILabel *RSSILbl;

@end
