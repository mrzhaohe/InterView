//
//  LinkList.m
//  算法
//
//  Created by 赵贺 on 2021/1/22.
//

#import "LinkList.h"

@interface LinkList ()

@property (nonatomic, strong) dispatch_ba

@end

@implementation LinkList

- (instancetype)initWithData:(id)data {
    self = [super init];
    if (self) {
        self.first = [Node new];
        self.first.element = data;
        self.first.next = nil;
        self.size++;
    }
    return self;
}

- (BOOL)isEmpty {
    return self.size == 0;
}

- (BOOL)containsOf:(id)obj {
    return [self indexOf:obj] != -1;
}

- (void)clear {
    self.size = 0;
    self.first = nil;
}

- (void)add:(nonnull id)element index:(int)index {
    if (index == 0) {
        self.first = [Node nodeWithElement:element next:self.first];
    } else {
        Node *pre = [self node:index-1];
        pre.next = [Node nodeWithElement:element next:pre.next];
    }
    self.size++;
}

- (nonnull id)get:(int)index {
    return [self node:index].element;
}


- (int)indexOf:(nonnull id)element {
    Node *node = self.first;
    int index = 0;
    for (int i = 0; i < self.size; i++) {
        if ([node.element isEqual:element]) {
            index = i;
            break;
        }
        node = node.next;
    }
    return index;
}

- (nonnull id)remove:(int)index {
    Node *old;
    
    if (index == 0) {
        old = self.first;
        self.first = old.next;
    } else {
        Node *pre = [self node:index-1];
        old = [self node:index];
        pre.next = old.next;
    }
    self.size--;
    return old.element;
}


- (nonnull id)set:(int)index element:(nonnull id)element {
    Node *node = [self node:index];
    id old = node.element;
    node.element = element;
    return old;
}

- (Node *)node:(int)index {
    if (index < 0) {
        return nil;
    }
    Node *node = self.first;
    for (int i = 0; i < index; i++) {
        node = node.next;
    }
    return node;
}

- (NSString *)description {
    Node *node = self.first;
    NSMutableArray *arr = [NSMutableArray array];
    for (int i =0; i < self.size; i++) {
        [arr addObject:node.element];
        node = node.next;
    }
    return  [arr description];
}

@end
