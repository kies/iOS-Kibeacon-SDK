//
//  KibeaconTableViewCell.h
//  iOS-Kibeacon-Sample
//
//  Created by thenopen on 2014. 12. 9..
//  Copyright (c) 2014년 thenopen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KibeaconTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *nameLbl;
@property (weak, nonatomic) IBOutlet UILabel *macAddressLbl;
@property (weak, nonatomic) IBOutlet UILabel *UUIDLbl;
@property (weak, nonatomic) IBOutlet UILabel *batteryLbl;
@property (weak, nonatomic) IBOutlet UILabel *RSSILbl;

@end
