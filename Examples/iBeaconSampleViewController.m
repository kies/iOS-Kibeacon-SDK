//
//  iBeaconSampleViewController.m
//  iOS-Kibeacon-Sample
//
//  Created by thenopen on 2014. 12. 10..
//  Copyright (c) 2014년 thenopen. All rights reserved.
//

#import "iBeaconSampleViewController.h"
#import "KibeaconManager.h"

@interface iBeaconSampleViewController ()

@property (strong, nonatomic) NSArray *beaconsData;
@property (strong, nonatomic) KibeaconManager *manager;

@end

@implementation iBeaconSampleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.manager = [KibeaconManager kibeaconManager];
    [_manager startRangingForBeacons:^(NSArray *beacons, CLBeaconRegion *region) {
        self.beaconsData = [[NSArray alloc] initWithArray:beacons];
        [self.tableView reloadData];
    }];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [_manager stopRangingForBeacons];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return _beaconsData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *testIdentifer = @"BeaconCells";
    UITableViewCell *cell;
    
    cell = [tableView dequeueReusableCellWithIdentifier:testIdentifer];
    
    if(!cell){
        
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:testIdentifer];
        
    }
    CLBeacon *beacon = self.beaconsData[indexPath.row];

    cell.textLabel.font = [UIFont systemFontOfSize:13];;
    cell.textLabel.text = beacon.proximityUUID.UUIDString;

    cell.detailTextLabel.font = [UIFont systemFontOfSize:9.5];;
    cell.detailTextLabel.text = [_manager detailsStringForBeacon:beacon];
    cell.detailTextLabel.textColor = [UIColor grayColor];
    
    return  cell;
}

@end
