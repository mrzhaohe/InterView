//
//  LinkList.h
//  算法
//
//  Created by 秦翌桐 on 2021/1/22.
//

#import <Foundation/Foundation.h>

#import "Node.h"

#import "ArrayListProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface LinkList : NSObject <ArrayListProtocol>


/// 初始化
/// @param data first
- (instancetype)initWithData:(id)data;

@property (nonatomic, assign) int size;

@property (nonatomic, strong) Node *first;

@end

NS_ASSUME_NONNULL_END
