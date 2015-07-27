//
//  scanModeViewController.m
//  IOS-Kibeacon-sample
//
//  Created by kimmoonki on 2015. 7. 7..
//  Copyright (c) 2015년 kimmoonki. All rights reserved.
//

#import "scanModeViewController.h"
#import "beaconCell.h"
#import "SVProgressHUD.h"
#import "KBCentralManager.h"
#import "KBPeripheral.h"
#import "beaconDetailViewController.h"

@interface scanModeViewController ()

@property (nonatomic, strong) IBOutlet UITableView *mainTableView;
@property (nonatomic,strong) KBCentralManager * central;

@end

@implementation scanModeViewController
@synthesize mainTableView;

-(void) setupScan {
    NSDictionary * opts = nil;
    if ([[UIDevice currentDevice].systemVersion floatValue]>=7.0)
    {
        opts = @{CBCentralManagerOptionShowPowerAlertKey:@YES};
    }
    
    self.central = [[KBCentralManager alloc] initWithQueue:nil options:opts];
    
    __weak scanModeViewController *wp = self;
    
    if (self.central.state != CBCentralManagerStatePoweredOn) {
        self.central.onStateChanged = ^(NSError * error){
            [wp.central scanForPeripheralsWithServices:nil options:@{CBCentralManagerScanOptionAllowDuplicatesKey:@YES}  onUpdated:^(KBPeripheral *peripheral) {
                    [wp.mainTableView reloadData];
            }];
        };
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"Kibeacon Sample";
    
    self.navigationController.navigationBarHidden = NO;
}

-(void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self setupScan];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _central.peripherals.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"beaconCell";
    UITableViewCell *cell = nil;
    beaconCell *pcell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    
    KBPeripheral * peripheral = _central.peripherals[indexPath.row];
    
    pcell.nameLbl.text = peripheral.name;
    pcell.UUIDLbl.text = peripheral.identifier.UUIDString;
    pcell.RSSILbl.text = [peripheral.RSSI stringValue];
    pcell.macAddressLbl.text = peripheral.macAddress;
    pcell.batteryLbl.text = [NSString stringWithFormat:@"%@%%", peripheral.batteryLevel];
    if ([peripheral.batteryLevel integerValue] >= 81)
        pcell.batteryLbl.textColor = [UIColor blueColor];
    else
        pcell.batteryLbl.textColor = [UIColor orangeColor];
    
    cell = pcell;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    [self.central stopScan];
    
    KBPeripheral * peripheral = self.central.peripherals[indexPath.row];
    __weak scanModeViewController * this = self;
    if(peripheral.state == CBPeripheralStateDisconnected)
    {
        [self.central connectPeripheral: peripheral options:nil completion:^(KBPeripheral * connectedperipheral, NSError *error) {
            if (!error)
            {
                beaconDetailViewController *detailVc = [[beaconDetailViewController alloc] initWithNibName:@"beaconDetailViewController" bundle:nil];
                detailVc.peripheral = peripheral;
                [self.navigationController pushViewController:detailVc animated:YES];
            }
        } ondisconnected:^(KBPeripheral *connectedperipheral, NSError *error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                NSArray * vcs  = [this.navigationController viewControllers];
                scanModeViewController * top = vcs[vcs.count-1];
                NSLog(@"Top %@", top);
                [SVProgressHUD showErrorWithStatus:@"Not Connected!!\nTry Again"];
            });
            
        }];
    }else
    {
        beaconDetailViewController *detailVc = [[beaconDetailViewController alloc] initWithNibName:@"beaconDetailViewController" bundle:nil];
        detailVc.peripheral = peripheral;
        [self.navigationController pushViewController:detailVc animated:YES];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 130;
}

@end
