//
//  ViewController.m
//  MsgForwardDemo
//
//  Created by redye.hu on 2019/4/24.
//  Copyright © 2019 redye.hu. All rights reserved.
//

#import "ViewController.h"
#import "Person.h"
#import <objc/runtime.h>
#import "ExceptionHandler.h"

NSString * const forwardPrefix = @"cus_";

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    SEL sel = NSSelectorFromString(@"cus_test:desc:");
    [self performSelector:sel withObject:@"1" withObject:@"2"];
}

+ (BOOL)resolveInstanceMethod:(SEL)sel {
    // 动态添加方法的实现, 如果所有方法都动态添加方法实现，会影响到系统方法
    // 这里的设想是给所有自定义方法动态添加，这就需要用户在自定义方法的时候与系统方法能很容易的区别开来，如添加前缀等
    NSLog(@"--------1.-----------[%@] - [%@]", NSStringFromClass([self class]), NSStringFromSelector(sel));
    NSString *selName = NSStringFromSelector(sel);
    if ([selName hasPrefix:forwardPrefix]) {

        SEL newSel = NSSelectorFromString(@"catchException");
        Method method = class_getInstanceMethod(NSClassFromString(@"ExceptionHandler"), newSel);
        IMP imp = method_getImplementation(method);
        const char *type = method_getTypeEncoding(method);
        class_addMethod(self, sel, imp, type);
        return NO;
    }
    return [super resolveInstanceMethod:sel];
}

- (id)forwardingTargetForSelector:(SEL)aSelector {
    // 重定向到别的 target 执行
    NSLog(@"--------2.-----------[%@] - [%@]", NSStringFromClass([self class]), NSStringFromSelector(aSelector));
//    ExceptionHandler *handler = [[ExceptionHandler alloc] init];
//    if ([handler respondsToSelector:aSelector]) {
//        return handler;
//    }

    return [super forwardingTargetForSelector:aSelector];
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector {
    NSLog(@"--------3.-----------[%@] - [%@]", NSStringFromClass([self class]), NSStringFromSelector(aSelector));
//    ExceptionHandler *handler = [[ExceptionHandler alloc] init];
//    if ([handler respondsToSelector:aSelector]) {
//        return [handler methodSignatureForSelector:aSelector];
//    }
    NSString *selName = NSStringFromSelector(aSelector);
    if ([selName hasPrefix:forwardPrefix]) {
        return [NSMethodSignature signatureWithObjCTypes:"v@:@@"];
    }
    return [super methodSignatureForSelector:aSelector];
}

- (void)forwardInvocation:(NSInvocation *)anInvocation {
    NSLog(@"--------4.-----------[%@] - [%@]", NSStringFromClass([self class]), NSStringFromSelector(anInvocation.selector));
    NSString *selName = NSStringFromSelector(anInvocation.selector);
    if ([selName hasPrefix:forwardPrefix]) {
        id target = [[ExceptionHandler alloc] init];
        NSInteger numberOfArguments = anInvocation.methodSignature.numberOfArguments;
        if (numberOfArguments > 2) {
            for (int i = 2; i < numberOfArguments; i ++) {
                const char *argumentType = [anInvocation.methodSignature getArgumentTypeAtIndex:i];
                if (strcmp(argumentType, "@") == 0) {
                    NSString *argument = [NSString stringWithFormat:@"test%d", i];
                    [anInvocation setArgument:&argument atIndex:i];
                } else if (strcmp(argumentType, "i") == 0) {
                    [anInvocation setArgument:&i atIndex:i];
                }
            }
        }
        [anInvocation invokeWithTarget:target];
    } else {
        [super forwardInvocation:anInvocation];
    }
}

- (void)doesNotRecognizeSelector:(SEL)aSelector {
    NSLog(@"--------5.-----------[%@] - [%@]", NSStringFromClass([self class]), NSStringFromSelector(aSelector));
    [super doesNotRecognizeSelector:aSelector];
}

- (void)cus_test:(NSString *)msg {
    NSLog(@"test message: %@", msg);
}


@end
