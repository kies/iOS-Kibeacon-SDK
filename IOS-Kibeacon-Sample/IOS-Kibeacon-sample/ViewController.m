//
//  ViewController.m
//  IOS-Kibeacon-sample
//
//  Created by kimmoonki on 2015. 7. 7..
//  Copyright (c) 2015년 kimmoonki. All rights reserved.
//

#import "ViewController.h"
#import "scanModeViewController.h"
#import "tabModeViewController.h"

@interface ViewController ()

- (IBAction) menu_move:(id)sender;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction) menu_move:(id)sender
{
    
    tabModeViewController *vc = [[tabModeViewController alloc] initWithNibName:@"tabModeViewController" bundle:nil];
    
    self.navigationController.navigationBarHidden = NO;
    [self.navigationController pushViewController:vc animated:YES];
}

@end
