//
//  Node.m
//  算法
//
//  Created by 赵贺 on 2021/1/22.
//

#import "Node.h"

@implementation Node

+ (Node *)nodeWithElement:(id)element next:(Node *)next {
    Node *node = [Node new];
    node.element = element;
    node.next = next;
    return node;
}

@end
