//
//  ViewController.m
//  AutoReleasePool
//
//  Created by 秦翌桐 on 2021/1/29.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

__weak NSString *ref = nil;

- (void)viewDidLoad {
    [super viewDidLoad];
    @autoreleasepool {
        NSString *str = [NSString stringWithFormat:@"sunnyxx"];
        NSLog(@"%@", str);
    }
    
    
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSLog(@"%@", ref);
    // Console: sunnyxx
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    NSLog(@"%@", ref);
    // Console: (null)
}

@end
