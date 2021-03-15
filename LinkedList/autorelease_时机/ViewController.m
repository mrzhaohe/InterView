//
//  ViewController.m
//  autorelease_时机
//
//  Created by 秦翌桐 on 2021/3/8.
//

#import "ViewController.h"

#import "Person.h"

static int b = 10;

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    
//    Person *p = [[[Person alloc] init] autorelease];
//    Person *p = [[Person alloc] init];
//
//    NSLog(@"%s", __func__);
    
    Person *p = [Person alloc];
    
    NSLog(@"person alloc --- %p  %p", p, &p);
    
    NSString *str = @"123";

    NSString *str1 = [NSString stringWithFormat:@"123"];

    NSLog(@"str --- %p  %p", str, &str);
    
    NSLog(@"str1 format ---%p  %p", str1, &str1);

    NSLog(@"sel ---%p  %p", @selector(viewDidLoad), &@selector(viewDidLoad));

    int a = 10;
    
    NSLog(@"inta --  %p", &a);
    
    NSLog(@"intb --  %p", &b);


}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSLog(@"%s", __func__);

}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    NSLog(@"%s", __func__);
}


@end
