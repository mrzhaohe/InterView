//
//  ViewController.m
//  AutoReleasePool
//
//  Created by 秦翌桐 on 2021/1/29.
//

#import "ViewController.h"

@interface ViewController ()
{
    __weak NSString *string_weak;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // 场景一
//    NSString *str =  [NSString stringWithFormat:@"https://ityongzhen.github.io/"];
//    string_weak = str;

    // 场景二
//    @autoreleasepool {
//        NSString *str = [NSString stringWithFormat:@"https://ityongzhen.github.io/"];
//        string_weak = str;
//    }
//
//    // 场景三
    NSString *str = nil;
    @autoreleasepool {
        str = [NSString stringWithFormat:@"https://ityongzhen.github.io/"];
        string_weak = str;
    }
    NSLog(@"viewDidLoad: %@", string_weak);
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    NSLog(@"viewWillAppear: %@", string_weak);
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    NSLog(@"viewDidAppear : %@", string_weak);
}

@end
