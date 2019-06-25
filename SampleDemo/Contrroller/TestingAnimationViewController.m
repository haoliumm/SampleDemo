//
//  TestingAnimationViewController.m
//  SampleDemo
//
//  Created by liuhao on 2019/6/25.
//  Copyright © 2019 liuhao. All rights reserved.
//

#import "TestingAnimationViewController.h"

@interface TestingAnimationViewController ()

@end

@implementation TestingAnimationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor redColor];
    // Do any additional setup after loading the view.
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self dismissViewControllerAnimated:YES completion:nil];
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
