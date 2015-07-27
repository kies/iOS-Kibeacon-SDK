//
//  beaconDetailViewController.m
//  IOS-Kibeacon-sample
//
//  Created by kimmoonki on 2015. 7. 7..
//  Copyright (c) 2015년 kimmoonki. All rights reserved.
//

#import "beaconDetailViewController.h"
#import "SVProgressHUD.h"
#import "JGActionSheet.h"

@interface beaconDetailViewController ()

@property (nonatomic, strong) IBOutlet UIScrollView *mainScrollView;
@property (weak, nonatomic) IBOutlet UILabel *deviceNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *rssiLabel;
@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *majorLabel;
@property (weak, nonatomic) IBOutlet UILabel *minorLabel;
@property (weak, nonatomic) IBOutlet UILabel *uuidLabel;
@property (weak, nonatomic) IBOutlet UILabel *batteryLabel;
@property (weak, nonatomic) IBOutlet UILabel *txpowerLabel;
@property (weak, nonatomic) IBOutlet UILabel *mepowerLabel;
@property (weak, nonatomic) IBOutlet UILabel *intervalLabel;
@property (weak, nonatomic) IBOutlet UILabel *hwVersionLabel;
@property (weak, nonatomic) IBOutlet UILabel *swVersionLabel;
@property (weak, nonatomic) IBOutlet UILabel *manufactureLabel;
@property (weak, nonatomic) IBOutlet UIButton *changeBtn;

@property (strong, nonatomic) NSArray *intervalArray;
@property (strong, nonatomic) NSArray *txpowerArray;

@property (nonatomic,strong) KBCentralManager * central;

@end

@implementation beaconDetailViewController

- (void)setup {
    [SVProgressHUD showWithStatus:@"Loading from BLE"];
    
    __weak beaconDetailViewController * this  = self;
    
    [self.peripheral discoverServices:nil completion:^(NSError *error) {
        
        this.services = this.peripheral.services;
        for (CBService *_service in this.services) {
            [self.peripheral discoverCharacteristics:nil forService:_service onFinish:^(CBService *service, NSError *error) {
                if (_service == service) {
                    for (CBCharacteristic *characterstic in service.characteristics) {
                        [self.peripheral readValueForCharacteristic:characterstic onFinish:^(NSDictionary *characterstics, unsigned long serviceCount) {
                            [this.serviceDict setObject:characterstics forKey:[characterstics valueForKey:@"UUID"]];
                            if (serviceCount == 1) {
                                [this displayView];
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
    
    self.navigationItem.title = @"Connected Kibeacon";
    
    self.serviceDict = [NSMutableDictionary new];
    self.deviceNameLabel.text = [self.peripheral name];
    self.rssiLabel.text = [self.peripheral.RSSI stringValue];
    [self setup];
    
    self.intervalArray = @[@"50 ms", @"100 ms", @"200 ms", @"500 ms", @"1000 ms", @"2000 ms", @"5000 ms", @"10000 ms", @"20000 ms"];
    self.txpowerArray = @[@"4 dBm", @"0 dBm", @"-5 dBm", @"-9 dBm", @"-12 dBm", @"-16 dBm", @"-19 dBm", @"-23 dBm"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    _changeBtn.frame = CGRectMake(self.view.center.x-75, 469, 150, 30);
    [self.mainScrollView setContentSize:CGSizeMake([UIScreen mainScreen].bounds.size.width, 510)];
    
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [SVProgressHUD dismiss];
}

- (void)updateRSSI {
    if (self.peripheral.state == CBPeripheralStateConnected) {
        [self.peripheral.peripheral readRSSI];
        NSString *rssiStr = [self.peripheral.RSSI stringValue];
        self.rssiLabel.text = [NSString stringWithFormat:@"rssi : %@", rssiStr];
        
        if([rssiStr doubleValue] == 127)
            return;
        
        double distanceValue = [self.peripheral getDistance:rssiStr measuredPw:self.mepowerLabel.text];
        self.distanceLabel.text = [NSString stringWithFormat:@"Distance : %.2fm", distanceValue];
    }
}

- (IBAction)changeValue:(UIButton *)sender {
    JGActionSheetSection *section1 = [JGActionSheetSection sectionWithTitle:@"Write Characteristic" message:nil buttonTitles:@[@"Proximity UUID", @"Major", @"Minor", @"Advertising Interval", @"Tx Power"] buttonStyle:JGActionSheetButtonStyleDefault];
    JGActionSheetSection *cancelSection = [JGActionSheetSection sectionWithTitle:nil message:nil buttonTitles:@[@"Cancel"] buttonStyle:JGActionSheetButtonStyleRed];
    
    NSArray *sections = @[section1, cancelSection];
    
    JGActionSheet *sheet = [JGActionSheet actionSheetWithSections:sections];
    [sheet setButtonPressedBlock:^(JGActionSheet *sheet, NSIndexPath *indexPath) {
        [sheet dismissAnimated:YES];
        if (indexPath.section == 1)
            return ;
        switch (indexPath.row) {
            case 0: {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Proximity UUID"
                                                                message:@"Input Proximity UUID"
                                                               delegate:self
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:@"Cancel", nil];
                alert.alertViewStyle = UIAlertViewStylePlainTextInput;
                UITextField * alertTextField = [alert textFieldAtIndex:0];
                alertTextField.text = self.uuidLabel.text;
                alert.tag = 1;
                [alert show];
                break;
            }
            case 1: {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Major"
                                                                message:@"Input Major"
                                                               delegate:self
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:@"Cancel", nil];
                alert.alertViewStyle = UIAlertViewStylePlainTextInput;
                UITextField * alertTextField = [alert textFieldAtIndex:0];
                alertTextField.text = self.majorLabel.text;
                alert.tag = 2;
                [alert show];
                break;
            }
            case 2: {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Minor"
                                                                message:@"Input Minor"
                                                               delegate:self
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:@"Cancel", nil];
                alert.alertViewStyle = UIAlertViewStylePlainTextInput;
                UITextField * alertTextField = [alert textFieldAtIndex:0];
                alertTextField.text = self.minorLabel.text;
                alert.tag = 3;
                [alert show];
                break;
            }
            case 3: {
                JGActionSheetSection *section1 = [JGActionSheetSection sectionWithTitle:@"Advertising Interval" message:nil buttonTitles:_intervalArray buttonStyle:JGActionSheetButtonStyleDefault];
                JGActionSheetSection *cancelSection = [JGActionSheetSection sectionWithTitle:nil message:nil buttonTitles:@[@"Cancel"] buttonStyle:JGActionSheetButtonStyleRed];
                
                NSArray *sections = @[section1, cancelSection];
                JGActionSheet *sheet = [JGActionSheet actionSheetWithSections:sections];
                [sheet setButtonPressedBlock:^(JGActionSheet *sheet, NSIndexPath *indexPath) {
                    [sheet dismissAnimated:YES];
                    if (indexPath.section == 1)
                        return ;
                    
                    CBCharacteristic *characteristic = [[self.serviceDict valueForKey:@"Advertising Interval"] valueForKey:@"characteristic"];
                    
                    NSLog(@"%@", [NSString stringWithFormat:@"%02lX", (long)indexPath.row]);
                    [self writeCharacteristic:[NSString stringWithFormat:@"%02lX", (long)indexPath.row] characteristic:characteristic];
                    
                }];
                [sheet showInView:self.view animated:YES];
                break;
            }
            case 4: {
                JGActionSheetSection *section1 = [JGActionSheetSection sectionWithTitle:@"Tx Power" message:nil buttonTitles:_txpowerArray buttonStyle:JGActionSheetButtonStyleDefault];
                JGActionSheetSection *cancelSection = [JGActionSheetSection sectionWithTitle:nil message:nil buttonTitles:@[@"Cancel"] buttonStyle:JGActionSheetButtonStyleRed];
                
                NSArray *sections = @[section1, cancelSection];
                JGActionSheet *sheet = [JGActionSheet actionSheetWithSections:sections];
                [sheet setButtonPressedBlock:^(JGActionSheet *sheet, NSIndexPath *indexPath) {
                    [sheet dismissAnimated:YES];
                    if (indexPath.section == 1)
                        return ;
                    NSArray *txpower = @[@4, @0, @-5, @-9, @-12, @-16, @-19, @-23];
                    
                    
                    CBCharacteristic *characteristic = [[self.serviceDict valueForKey:@"TX Power Level"] valueForKey:@"characteristic"];
                    
                    unsigned char value = [[txpower objectAtIndex:indexPath.row] unsignedCharValue];
                    
                    [self writeCharacteristic:[NSString stringWithFormat:@"%02X", value] characteristic:characteristic];
                    
                }];
                [sheet showInView:self.view animated:YES];
                break;
            }
        }
    }];
    [sheet showInView:self.view animated:YES];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1)
        return;
    UITextField * alertTextField = [alertView textFieldAtIndex:0];
    
    CBCharacteristic *characteristic;
    switch (alertView.tag) {
        case 1:
            characteristic = [[self.serviceDict valueForKey:@"Device Normal"] valueForKey:@"characteristic"];
            [self writeCharacteristic:alertTextField.text characteristic:characteristic];
            break;
        case 2: {
            NSString *hexString = [NSString stringWithFormat:@"%04X", [alertTextField.text intValue]];
            characteristic = [[self.serviceDict valueForKey:@"Major"] valueForKey:@"characteristic"];
            [self writeCharacteristic:hexString characteristic:characteristic];
            break;
        }
        case 3: {
            NSString *hexString = [NSString stringWithFormat:@"%04X", [alertTextField.text intValue]];
            characteristic = [[self.serviceDict valueForKey:@"Minor"] valueForKey:@"characteristic"];
            [self writeCharacteristic:hexString characteristic:characteristic];
            break;
        }
    }
    
}


- (void) writeCharacteristic:(NSString *)saveValue characteristic:(CBCharacteristic *)_characteristic {
    // if don't remove white space, you will get to wrong data value.
    NSString *newString = [saveValue stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    NSData * data = [self.peripheral dataWithHexString:newString ];
    
    [SVProgressHUD showWithStatus:@"Write to characteristic"];
    
    if (data) {
        CBCharacteristicWriteType type =CBCharacteristicWriteWithResponse;
        KBCharacteristicChangedBlock onfinish=nil;
        
        onfinish = ^(CBCharacteristic * characteristic, NSError * error) {
            if (error) {
                [SVProgressHUD showErrorWithStatus:@"Faild to write characteristic"];
            } else {
                [self setup];
            }
        };
        
        if (_characteristic.properties & CBCharacteristicPropertyWrite)
            [self.peripheral writeValue:data forCharacteristic:_characteristic type:type onFinish:onfinish];
        
    }
}

- (void) displayView{
//    NSLog(@"self.serviceDict = %@", self.serviceDict);
    self.addressLabel.text = [self.peripheral macAddress];
    
    NSInteger x = [self.peripheral eghitBitHexTosignedInt:[[self.serviceDict valueForKey:@"Major"] valueForKey:@"value"]];
    self.majorLabel.text = [NSString stringWithFormat:@"%ld", (long)x];
    NSInteger y = [self.peripheral eghitBitHexTosignedInt:[[self.serviceDict valueForKey:@"Minor"] valueForKey:@"value"]];
    self.minorLabel.text = [NSString stringWithFormat:@"%ld", (long)y];
    self.uuidLabel.text =  [[self.serviceDict valueForKey:@"Device Normal"] valueForKey:@"value"];
    self.batteryLabel.text =  [NSString stringWithFormat:@"%@%%", [self.peripheral batteryLevel]];
    NSInteger z = [self.peripheral eghitBitHexTosignedInt:[[self.serviceDict valueForKey:@"TX Power Level"] valueForKey:@"value"]];
    self.txpowerLabel.text = [NSString stringWithFormat:@"%ld dBm", (long)z];

    self.mepowerLabel.text = [[self.serviceDict valueForKey:@"Measured Power"] valueForKey:@"value"];
    
    self.intervalLabel.text = [self.intervalArray objectAtIndex:[[[self.serviceDict valueForKey:@"Advertising Interval"] valueForKey:@"value"] intValue]];
    self.hwVersionLabel.text = [[self.serviceDict valueForKey:@"Hardware Version"] valueForKey:@"ascii"];
    self.swVersionLabel.text = [[self.serviceDict valueForKey:@"Software Version"] valueForKey:@"ascii"];
    self.manufactureLabel.text = [[self.serviceDict valueForKey:@"Manufactured Name"] valueForKey:@"ascii"];
    
    if ([[self.peripheral batteryLevel] integerValue] >= 81)
        self.batteryLabel.textColor = [UIColor blueColor];
    else
        self.batteryLabel.textColor = [UIColor orangeColor];
    
    [SVProgressHUD dismiss];
    
    [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(updateRSSI) userInfo:nil repeats:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
