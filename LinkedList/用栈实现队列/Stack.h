//
//  Stack.h
//  栈
//
//  Created by 赵贺 on 2021/1/26.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Stack : NSObject


/// 栈长
- (NSUInteger)size;


/// 是否为空
- (BOOL)isEmpty;


/// 入栈
/// @param element 入栈元素
- (void)push:(id)element;


/// 出栈
- (id)pop;


/// 栈顶
- (id)top;

@end

NS_ASSUME_NONNULL_END
