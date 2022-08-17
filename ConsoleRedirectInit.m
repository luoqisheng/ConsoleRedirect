//
//  ConsoleRedirectInit.m
//  ConsoleRedirect
//
//  Created by Luo Qisheng on 2022/8/17.
//

#import "ConsoleRedirectInit.h"

static id redirecter;
@implementation ConsoleRedirectInit

+ (void)load {
    redirecter = [NSClassFromString(@"ConsoleRedirect.ConsoleRedirect") new];
}

@end
