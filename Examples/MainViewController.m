//
//  ViewController.m
//  iOS-Kibeacon-Sample
//
//  Created by thenopen on 2014. 12. 9..
//  Copyright (c) 2014년 thenopen. All rights reserved.
//

#import "MainViewController.h"
#import "KBCentralManager.h"
#import "KibeaconTableViewCell.h"
#import "KBPeripheral.h"
#import "MoreViewController.h"

@interface MainViewController ()

@property (nonatomic,strong) KBCentralManager * central;

@end

@implementation MainViewController

-(void) setupScan {
    NSDictionary * opts = nil;
    if ([[UIDevice currentDevice].systemVersion floatValue]>=7.0)
    {
        opts = @{CBCentralManagerOptionShowPowerAlertKey:@YES};
    }
    
    self.central = [[KBCentralManager alloc] initWithQueue:nil options:opts];
    
    __weak MainViewController *wp = self;
    
    if (self.central.state != CBCentralManagerStatePoweredOn) {
        self.central.onStateChanged = ^(NSError * error){
            [wp.central scanForPeripheralsWithServices:nil options:@{CBCentralManagerScanOptionAllowDuplicatesKey:@YES}  onUpdated:^(KBPeripheral *peripheral) {
                [wp.tableView reloadData];
            }];
        };
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

-(void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self setupScan];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _central.peripherals.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"KibeaconMainCell";
    UITableViewCell *cell = nil;
    KibeaconTableViewCell *pcell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    
    KBPeripheral * peripheral = _central.peripherals[indexPath.row];
    pcell.nameLbl.text = peripheral.name;
    pcell.UUIDLbl.text = [NSString stringWithFormat:@"UUID : %@", peripheral.identifier.UUIDString];
    pcell.RSSILbl.text = [peripheral.RSSI stringValue];
    pcell.macAddressLbl.text = [NSString stringWithFormat:@"Address : %@", peripheral.macAddress];
    pcell.batteryLbl.text = [NSString stringWithFormat:@"Battery : %@%%", peripheral.batteryLevel];
    if ([peripheral.batteryLevel integerValue] >= 81)
        pcell.batteryLbl.textColor = [UIColor blueColor];
    else
        pcell.batteryLbl.textColor = [UIColor orangeColor];
    
    
    cell = pcell;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.central stopScan];
    
    KBPeripheral * peripheral = self.central.peripherals[indexPath.row];
    __weak MainViewController * this = self;
    if(peripheral.state == CBPeripheralStateDisconnected)
    {
        [self.central connectPeripheral: peripheral options:nil completion:^(KBPeripheral * connectedperipheral, NSError *error) {
            if (!error)
            {
                [this performSegueWithIdentifier:@"services" sender: peripheral];
            }
        } ondisconnected:^(KBPeripheral *connectedperipheral, NSError *error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                NSArray * vcs  = [this.navigationController viewControllers];
                MainViewController * top = vcs[vcs.count-2];
                NSLog(@"Top %@", top);
                NSLog(@"Not Connected!!\nTry Again");
            });
        }];
    }else
    {
        [self performSegueWithIdentifier:@"services" sender: peripheral];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    MoreViewController *detail = segue.destinationViewController;
    detail.peripheral = sender;
}


@end
