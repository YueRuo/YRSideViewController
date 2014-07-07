//
//  LeftViewController.m
//  YRSideViewController
//
//  Created by 王晓宇 on 14-5-10.
//  Copyright (c) 2014年 YueRuo. All rights reserved.
//

#import "LeftViewController.h"
#import "AppDelegate.h"
#import "RootViewController.h"

@interface LeftViewController ()

@end

@implementation LeftViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIButton *button=[[UIButton alloc]initWithFrame:CGRectMake(20, 80, 200, 60)];
    [button addTarget:self action:@selector(changeRootViewAction) forControlEvents:UIControlEventTouchUpInside];
    [button setTitle:@"changeRootVCButton" forState:UIControlStateNormal];
    [self.view addSubview:button];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    NSLog(@"--->>>leftView will appear");
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    NSLog(@"--->>>leftView did appear");
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    NSLog(@"--->>>leftView will disappear");
}
-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    NSLog(@"--->>>leftView did disappear");
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
//-(BOOL)shouldAutorotate{
//    return true;
//}
//-(NSUInteger)supportedInterfaceOrientations{
//    return UIInterfaceOrientationMaskAll;
//}
-(void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration{
    NSLog(@"left view rotate");
}

-(void)changeRootViewAction{
    YRSideViewController *sideViewController=[((AppDelegate*)[[UIApplication sharedApplication]delegate])sideViewController];
    RootViewController *vc=[[RootViewController alloc]initWithNibName:nil bundle:nil];
    CGFloat randomR=arc4random()%255/255.0f;
    [vc.view setBackgroundColor:[UIColor colorWithRed:randomR green:0.8 blue:0.8 alpha:1]];
    [sideViewController setRootViewController:vc];
}

@end
