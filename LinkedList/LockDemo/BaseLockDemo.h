//
//  BaseLockDemo.h
//  LockDemo
//
//  Created by 赵贺 on 2021/2/22.
//

#import <Foundation/Foundation.h>

#import "LockDemoProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface BaseLockDemo : NSObject<LockDemoProtocol>

- (void)moneyTest;

- (void)ticketTest;

- (void)otherTest;



@end

NS_ASSUME_NONNULL_END
