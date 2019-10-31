//
//  ExceptionHandler.m
//  MsgForwardDemo
//
//  Created by redye.hu on 2019/4/24.
//  Copyright © 2019 redye.hu. All rights reserved.
//

#import "ExceptionHandler.h"

@implementation ExceptionHandler

- (void)catchException {
    NSString *selName = NSStringFromSelector(_cmd);
    NSString *className = NSStringFromClass([self class]);
    NSLog(@"Catch exception with [%@] of [%@]", selName, className);
}

- (void)cus_test:(NSString *)msg {
    NSLog(@"test message: %@", msg);
}

- (NSInteger)cus_test:(NSString *)msg desc:(NSString *)desc {
    NSLog(@"test message: %@; %@", msg, desc);
    return 0;
}

@end
