//
//  MoreViewController.h
//  iOS-Kibeacon-Sample
//
//  Created by thenopen on 2014. 12. 9..
//  Copyright (c) 2014년 thenopen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KBPeripheral.h"

@interface MoreViewController : UITableViewController

@property (nonatomic,strong) KBPeripheral *peripheral;
@property (nonatomic, strong) CBPeripheral *hello;
@end
