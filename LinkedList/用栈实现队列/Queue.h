//
//  Queue.h
//  栈
//
//  Created by 赵贺 on 2021/1/26.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Queue : NSObject

/// 长度
- (NSUInteger)size;


/// 队列是否为空
- (BOOL)isEmpty;


/// 入队
/// @param element obj
- (void)enQueue:(id)element;



/// 队头
- (id)front;



/// 出队
- (id)deQueue;


/// 清空
- (void)clear;
@end

NS_ASSUME_NONNULL_END
