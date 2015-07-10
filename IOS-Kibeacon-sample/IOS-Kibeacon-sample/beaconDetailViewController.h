//
//  beaconDetailViewController.h
//  IOS-Kibeacon-sample
//
//  Created by kimmoonki on 2015. 7. 7..
//  Copyright (c) 2015년 kimmoonki. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KBCentralManager.h"
#import "KBPeripheral.h"

@interface beaconDetailViewController : UIViewController
<UITextFieldDelegate>

@property (nonatomic,strong) NSArray * services;
@property (nonatomic,strong) KBPeripheral *peripheral;
@property (nonatomic, strong) NSMutableDictionary *serviceDict;

@end
