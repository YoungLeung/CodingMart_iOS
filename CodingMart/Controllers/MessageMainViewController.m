//
//  MessageMainViewController.m
//  CodingMart
//
//  Created by chao chen on 2017/2/13.
//  Copyright © 2017年 net.coding. All rights reserved.
//

#import "MessageMainViewController.h"

@interface MessageMainViewController ()

@end

@implementation MessageMainViewController

+ (instancetype)storyboardVC{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Message" bundle:nil];
    return [storyboard instantiateViewControllerWithIdentifier:@"MessageMainViewController"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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
- (IBAction)button1:(id)sender {
    NSLog(@"111");
}

- (IBAction)button2:(id)sender {
    NSLog(@"222");
}

- (IBAction)button3:(id)sender {
}
@end
