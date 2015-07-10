//
//  tabModeViewController.m
//  IOS-Kibeacon-sample
//
//  Created by kimmoonki on 2015. 7. 7..
//  Copyright (c) 2015년 kimmoonki. All rights reserved.
//

#import "tabModeViewController.h"
#import "KBCentralManager.h"
#import "KBPeripheral.h"
#import "beaconDetailViewController.h"
#import "JGActionSheet.h"

@interface tabModeViewController ()

@property (nonatomic,strong) KBCentralManager * central;
@property (nonatomic, strong) NSMutableArray *peripherals;
@property (nonatomic, strong) KBPeripheral *choicePeripheral;
@property (nonatomic,weak) NSTimer  * timer;
@property (nonatomic, assign) NSInteger settingRSSI;

@property (nonatomic, assign) BOOL animating;
@property (weak, nonatomic) IBOutlet UIImageView *indicatorImageView;

@end

static int BeaconCount = 0;

@implementation tabModeViewController

-(void) kiBeaconScan {
    self.peripherals = [NSMutableArray new];
    self.settingRSSI = -40;
    NSDictionary * opts = nil;
    if ([[UIDevice currentDevice].systemVersion floatValue]>=7.0)
    {
        //DebugLog(@"%f",[[UIDevice currentDevice].systemVersion floatValue]);
        opts = @{CBCentralManagerOptionShowPowerAlertKey:@YES};
    }
    
    self.central = [[KBCentralManager alloc] initWithQueue:nil options:opts];
    
    __weak tabModeViewController *wp = self;
    
    if (self.central.state != CBCentralManagerStatePoweredOn) {
        self.central.onStateChanged = ^(NSError * error){
            [wp.central scanForPeripheralsWithServices:nil options:@{CBCentralManagerScanOptionAllowDuplicatesKey:@YES}  onUpdated:^(KBPeripheral *peripheral) {
                [wp.peripherals addObject:peripheral];
            }];
        };
    }
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:2.0f target:self selector:@selector(compareRSSI) userInfo:nil repeats:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.title = @"Device Scan";
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self startAnimating];
    [self kiBeaconScan];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.timer invalidate];
    [self stopAnimating];
}

- (void)startAnimating
{
    if (self.animating) return;
    
    self.animating = YES;
    [self _rotateImageViewFrom:0.0f to:M_PI*2 duration:3.0f repeatCount:HUGE_VALF];
}


- (void)stopAnimating
{
    if (!self.animating) return;
    
    self.animating = NO;
    [self.indicatorImageView.layer removeAllAnimations];
}


- (void)_rotateImageViewFrom:(CGFloat)fromValue to:(CGFloat)toValue duration:(CFTimeInterval)duration repeatCount:(CGFloat)repeatCount
{
    CABasicAnimation *rotationAnimation;
    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.fromValue = [NSNumber numberWithFloat:fromValue];
    rotationAnimation.toValue = [NSNumber numberWithFloat:toValue];
    rotationAnimation.duration = duration;
    rotationAnimation.repeatCount = repeatCount;
    rotationAnimation.removedOnCompletion = NO;
    rotationAnimation.fillMode = kCAFillModeForwards;
    [self.indicatorImageView.layer addAnimation:rotationAnimation forKey:@"rotation"];
}

- (IBAction)changeReference:(UIButton *)sender {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Change RSSI Value"
                                                    message:nil
                                                   delegate:self
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    UITextField * alertTextField = [alert textFieldAtIndex:0];
    alertTextField.placeholder = @"-40";
    
    alert.tag = 0;
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    UITextField * alertTextField = [alertView textFieldAtIndex:0];
    if ([alertTextField.text integerValue] >= 1) {
        return;
    } else {
        self.settingRSSI = [alertTextField.text integerValue];
    }
}


- (void) compareRSSI {
    
    for (KBPeripheral *peripheral in self.peripherals) {
        if ([peripheral.RSSI intValue] > 1)
            continue;

        if (self.settingRSSI <= [peripheral.RSSI intValue]) {
            if (![_choicePeripheral isEqual:peripheral]) {
                self.choicePeripheral = peripheral;
                BeaconCount = 0;
            } else {
                BeaconCount++;
            }
            if (BeaconCount == 3) {
                [self.timer invalidate];
                [self.central stopScan];
                __weak tabModeViewController * this = self;
                
                if(peripheral.state == CBPeripheralStateDisconnected)
                {
                    [self.central connectPeripheral: peripheral options:nil completion:^(KBPeripheral * connectedperipheral, NSError *error) {
                        if (!error)
                        {
                            beaconDetailViewController *vc = [[beaconDetailViewController alloc] initWithNibName:@"beaconDetailViewController" bundle:nil];
                            vc.peripheral = peripheral;
                            [self.navigationController pushViewController:vc animated:NO];
                            
                        }
                        
                    } ondisconnected:^(KBPeripheral *connectedperipheral, NSError *error) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            NSArray * vcs  = [this.navigationController viewControllers];
                            tabModeViewController * top = vcs[vcs.count-1];
                            NSLog(@"Top %@", top);
                        });
                        
                    }];
                }
            }
        }
    }
    [self.peripherals removeAllObjects];
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

@end
