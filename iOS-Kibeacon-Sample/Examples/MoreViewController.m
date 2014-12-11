//
//  MoreViewController.m
//  iOS-Kibeacon-Sample
//
//  Created by thenopen on 2014. 12. 9..
//  Copyright (c) 2014년 thenopen. All rights reserved.
//

#import "MoreViewController.h"
#import "Characterics.h"

@interface MoreViewController ()
@property (weak, nonatomic) IBOutlet UILabel *lblAddress;
@property (weak, nonatomic) IBOutlet UILabel *lblUUID;
@property (weak, nonatomic) IBOutlet UILabel *lblMajor;
@property (weak, nonatomic) IBOutlet UILabel *lblMinor;
@property (weak, nonatomic) IBOutlet UILabel *lblBattery;
@property (weak, nonatomic) IBOutlet UILabel *lblManufactured;
@property (weak, nonatomic) IBOutlet UILabel *lblHWVersion;
@property (weak, nonatomic) IBOutlet UILabel *lblSWVersion;
@property (weak, nonatomic) IBOutlet UILabel *lblName;
@property (weak, nonatomic) IBOutlet UILabel *lblTxPower;
@property (weak, nonatomic) IBOutlet UILabel *lblInterval;

@property (nonatomic, strong) NSMutableDictionary *serviceDict;
@property (nonatomic,strong) NSArray * services;
@property (weak, nonatomic) IBOutlet UILabel *lblRSSI;

@end

@implementation MoreViewController

- (void)setup {
    __weak MoreViewController * this  = self;
    
    [self.peripheral discoverServices:nil completion:^(NSError *error) {
        
        this.services = this.peripheral.services;
        for (CBService *_service in this.services) {
            [self.peripheral discoverCharacteristics:nil forService:_service onFinish:^(CBService *service, NSError *error) {
                if (_service == service) {
                    for (CBCharacteristic *characterstic in service.characteristics) {
                        [self.peripheral readValueForCharacteristic:characterstic onFinish:^(Characterics *characterstics, unsigned long serviceCount) {
                            [this.serviceDict setObject:characterstics forKey:characterstics.uuid];
                            if (serviceCount == 1) {
                                [this displayBeacon];
                            }
                        }];
                    }
                }
            }];
        }
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setup];
    self.serviceDict = [NSMutableDictionary new];
    [self.tableView setSeparatorStyle: UITableViewCellSeparatorStyleSingleLine];

    [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(updateRSSI) userInfo:nil repeats:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)updateRSSI {
    if (self.peripheral.state == CBPeripheralStateConnected) {
        [self.peripheral.peripheral readRSSI];
        self.lblRSSI.text = [self.peripheral.RSSI stringValue];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

-(void) displayBeacon {
    NSArray *intervalArray = @[@"50 ms", @"100 ms", @"200 ms", @"500 ms", @"1000 ms", @"2000 ms", @"5000 ms", @"10000 ms", @"20000 ms"];

    self.lblAddress.text = [self.peripheral macAddress];
    self.lblUUID.text =  [[[self.serviceDict valueForKey:@"Device Normal"] valuekey] uppercaseString];
    self.lblRSSI.text = [self.peripheral.RSSI stringValue];
    self.lblHWVersion.text = [[self.serviceDict valueForKey:@"Hardware Version"] asscii];
    self.lblSWVersion.text = [[self.serviceDict valueForKey:@"Software Version"] asscii];
    self.lblManufactured.text = [[self.serviceDict valueForKey:@"Manufactured Name"] asscii];
    NSInteger major = [Characterics eghitBitHexTosignedInt:[[self.serviceDict valueForKey:@"Major"] valuekey]];
    self.lblMajor.text = [NSString stringWithFormat:@"%ld", (long)major];
    NSInteger minor = [Characterics eghitBitHexTosignedInt:[[self.serviceDict valueForKey:@"Minor"] valuekey]];
    self.lblMinor.text = [NSString stringWithFormat:@"%ld", (long)minor];
    NSInteger txpower = [Characterics eghitBitHexTosignedInt:[[self.serviceDict valueForKey:@"TX Power Level"] valuekey]];
    self.lblTxPower.text = [NSString stringWithFormat:@"%ld dBm", (long)txpower];
    self.lblInterval.text = [intervalArray objectAtIndex:[[self.serviceDict valueForKey:@"Advertising Interval"] valuekey].integerValue];
    self.lblBattery.text = [NSString stringWithFormat:@"%@%%", [self.peripheral batteryLevel]];
    
    if ([[self.peripheral batteryLevel] integerValue] >= 81)
        self.lblBattery.textColor = [UIColor blueColor];
    else
        self.lblBattery.textColor = [UIColor orangeColor];
}

@end
