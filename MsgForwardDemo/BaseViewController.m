//
//  BaseViewController.m
//  MsgForwardDemo
//
//  Created by redye.hu on 2019/4/25.
//  Copyright © 2019 redye.hu. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

+ (BOOL)resolveInstanceMethod:(SEL)sel {
    return [super resolveInstanceMethod:sel];
}

- (id)forwardingTargetForSelector:(SEL)aSelector {
    return [super forwardingTargetForSelector:aSelector];
}

@end
