//
//  YRSideViewController.m
//  YRSnippets
//
//  Created by 王晓宇 on 14-5-10.
//  Copyright (c) 2014年 王晓宇. All rights reserved.
//

#import "YRSideViewController.h"
#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height

@interface YRSideViewController ()<UIGestureRecognizerDelegate>{
    UIView *baseView;//目前是self.view
    UIView *currentView;//其实就是rootViewController.view
    
    UIPanGestureRecognizer *panGestureRecognizer;
    
    CGPoint startPanPoint;
    CGPoint lastPanPoint;
    BOOL panMovingRightOrLeft;//true是向右，false是向左
//    BOOL onMenuMoving;
    
    UIButton *coverButton;
}
@end

@implementation YRSideViewController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _leftViewShowWidth=267;
        _rightViewShowWidth=267;
        _animationDuration=0.35;
        _showBoundsShadow=true;
        
        panGestureRecognizer=[[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(pan:)];
        [panGestureRecognizer setDelegate:self];
        
        panMovingRightOrLeft=false;
        lastPanPoint=CGPointZero;
        
        coverButton=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        [coverButton addTarget:self action:@selector(hideSideViewController) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

-(id)init{
    return [self initWithNibName:nil bundle:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    baseView=self.view;
    [baseView setBackgroundColor:[UIColor colorWithRed:0.5 green:0.6 blue:0.8 alpha:1]];
    self.needSwipeShowMenu=true;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (!self.rootViewController) {
        NSAssert(false, @"you must set rootViewController!!");
    }

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setRootViewController:(UIViewController *)rootViewController{
    if (_rootViewController!=rootViewController) {
        _rootViewController=rootViewController;
        
        [currentView removeFromSuperview];
        currentView=_rootViewController.view;
        [self.view addSubview:currentView];
    }

}


-(void)setNeedSwipeShowMenu:(BOOL)needSwipeShowMenu{
    _needSwipeShowMenu=needSwipeShowMenu;
    if (needSwipeShowMenu) {
        [self.view addGestureRecognizer:panGestureRecognizer];
    }else{
        [self.view removeGestureRecognizer:panGestureRecognizer];
    }
}
- (void)showShadow:(BOOL)show{
    currentView.layer.shadowOpacity = show ? 0.8f : 0.0f;
    if (show) {
        currentView.layer.cornerRadius = 4.0f;
        currentView.layer.shadowOffset = CGSizeZero;
        currentView.layer.shadowRadius = 4.0f;
        currentView.layer.shadowPath = [UIBezierPath bezierPathWithRect:currentView.bounds].CGPath;
    }
}
#pragma mark  ShowOrHideTheView
-(void)willShowLeftViewController{
    if (!_leftViewController||_leftViewController.view.superview) {
        return;
    }
    [baseView insertSubview:_leftViewController.view belowSubview:currentView];
    if (_rightViewController&&_rightViewController.view.superview) {
        [_rightViewController viewWillDisappear:false];
        [_rightViewController.view removeFromSuperview];
        [_rightViewController viewDidDisappear:false];
    }
}
-(void)willShowRightViewController{
    if (!_rightViewController||_rightViewController.view.superview) {
        return;
    }
    [baseView insertSubview:_rightViewController.view belowSubview:currentView];
    if (_leftViewController&&_leftViewController.view.superview) {
        [_leftViewController viewWillDisappear:false];
        [_leftViewController.view removeFromSuperview];
        [_leftViewController viewDidDisappear:false];
    }
}
-(void)showLeftViewController:(BOOL)animated{
    if (!_leftViewController) {
        return;
    }
    [self willShowLeftViewController];
    NSTimeInterval animatedTime=0;
    if (animated) {
        animatedTime=ABS(_leftViewShowWidth-currentView.frame.origin.x)/_leftViewShowWidth*_animationDuration;
    }
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView animateWithDuration:animatedTime animations:^{
        [self layoutCurrentViewWithOffset:_leftViewShowWidth];
        [currentView addSubview:coverButton];
        [self showShadow:_showBoundsShadow];
    }];
}
-(void)showRightViewController:(BOOL)animated{
    if (!_rightViewController) {
        return;
    }
    [self willShowRightViewController];
    NSTimeInterval animatedTime=0;
    if (animated) {
        animatedTime=ABS(_rightViewShowWidth+currentView.frame.origin.x)/_rightViewShowWidth*_animationDuration;
    }
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView animateWithDuration:animatedTime animations:^{
        [self layoutCurrentViewWithOffset:-_rightViewShowWidth];
        [currentView addSubview:coverButton];
        [self showShadow:_showBoundsShadow];
    }];
}
-(void)hideSideViewController:(BOOL)animated{
    [self showShadow:false];
    NSTimeInterval animatedTime=0;
    if (animated) {
        animatedTime=ABS(currentView.frame.origin.x/(currentView.frame.origin.x>0?_leftViewShowWidth:_rightViewShowWidth))*_animationDuration;
    }
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView animateWithDuration:animatedTime animations:^{
        [self layoutCurrentViewWithOffset:0];
    } completion:^(BOOL finished) {
        [coverButton removeFromSuperview];
        [_leftViewController.view removeFromSuperview];
        [_rightViewController.view removeFromSuperview];
    }];
}
-(void)hideSideViewController{
    [self hideSideViewController:true];
}

#pragma mark UIGestureRecognizerDelegate
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    // Check for horizontal pan gesture
    if (gestureRecognizer == panGestureRecognizer) {
        UIPanGestureRecognizer *panGesture = (UIPanGestureRecognizer*)gestureRecognizer;
        CGPoint translation = [panGesture translationInView:self.view];
        if ([panGesture velocityInView:self.view].x < 600 && ABS(translation.x)/ABS(translation.y)>1) {
            return YES;
        }
        return NO;
    }
    return YES;
}
-(void)pan:(UIPanGestureRecognizer*)pan{
    if (panGestureRecognizer.state==UIGestureRecognizerStateBegan) {
        startPanPoint=currentView.frame.origin;
        if (currentView.frame.origin.x==0) {
            [self showShadow:_showBoundsShadow];
        }
        CGPoint velocity=[pan velocityInView:self.view.window];
        if(velocity.x>0){
            if (currentView.frame.origin.x>=0&&_leftViewController&&!_leftViewController.view.superview) {
                [self willShowLeftViewController];
            }
        }else if (velocity.x<0) {
            if (currentView.frame.origin.x<=0&&_rightViewController&&!_rightViewController.view.superview) {
                [self willShowRightViewController];
            }
        }
        return;
    }
    CGPoint currentPostion=[pan translationInView:self.view.window];
    CGFloat xoffset=startPanPoint.x+currentPostion.x;
    if (xoffset>0) {//向右滑
        if (_leftViewController&&_leftViewController.view.superview) {
            xoffset=xoffset>_leftViewShowWidth?_leftViewShowWidth:xoffset;
        }else{
            xoffset=0;
        }
    }else if(xoffset<0){//向左滑
        if (_rightViewController&&_rightViewController.view.superview) {
            xoffset=xoffset<-_rightViewShowWidth?-_rightViewShowWidth:xoffset;
        }else{
            xoffset=0;
        }
    }
    if (xoffset!=currentView.frame.origin.x) {
        [self layoutCurrentViewWithOffset:xoffset];
    }
    if (panGestureRecognizer.state==UIGestureRecognizerStateEnded) {
        if (currentView.frame.origin.x!=0&&currentView.frame.origin.x!=_leftViewShowWidth&&currentView.frame.origin.x!=-_rightViewShowWidth) {
            if (panMovingRightOrLeft&&currentView.frame.origin.x>20) {
                [self showLeftViewController:true];
            }else if(!panMovingRightOrLeft&&currentView.frame.origin.x<-20){
                [self showRightViewController:true];
            }else{
                [self hideSideViewController];
            }
        }else if (currentView.frame.origin.x==0) {
            [self showShadow:false];
        }
        lastPanPoint=CGPointZero;
    }else{
        CGPoint velocity=[pan velocityInView:self.view.window];
        if (velocity.x>0) {
            panMovingRightOrLeft=true;
        }else if(velocity.x<0){
            panMovingRightOrLeft=false;
        }
    }
}

//重写此方法可以改变动画效果,PS.currentView就是RootViewController.view
-(void)layoutCurrentViewWithOffset:(CGFloat)xoffset{
    if (_showBoundsShadow) {
        currentView.layer.shadowPath = [UIBezierPath bezierPathWithRect:currentView.bounds].CGPath;
    }
    if (self.rootViewMoveBlock) {//如果有自定义动画，使用自定义的效果
        self.rootViewMoveBlock(currentView,baseView.bounds,xoffset);
        return;
    }
    /*平移的动画
     [currentView setFrame:CGRectMake(xoffset, baseView.frame.origin.y, baseView.frame.size.width, baseView.frame.size.height)];
    return;
    //*/
    
//    /*平移带缩放效果的动画
    static CGFloat h2w=0;
    if (h2w==0) {
        h2w=baseView.frame.size.height/baseView.frame.size.width;
    }
    CGFloat scale=ABS(600-ABS(xoffset))/600;
    scale=MAX(0.8, scale);
    currentView.transform=CGAffineTransformMakeScale(scale, scale);
    if (xoffset>0) {//向右滑的
        [currentView setFrame:CGRectMake(xoffset, baseView.frame.origin.y+(baseView.frame.size.height*(1-scale)/2), baseView.frame.size.width*scale, baseView.frame.size.height*scale)];
    }else{//向左滑的
        [currentView setFrame:CGRectMake(baseView.frame.size.width*(1-scale)+xoffset, baseView.frame.origin.y+(baseView.frame.size.height*(1-scale)/2), baseView.frame.size.width*scale, baseView.frame.size.height*scale)];
    }
     //*/
}

@end
