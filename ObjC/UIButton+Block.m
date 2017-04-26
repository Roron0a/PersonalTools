//
//  UIButton+Block.m
//  Logging
//
//  Created by mac on 11/22/16.
//  Copyright © 2016 Roron0a. All rights reserved.
//

#import "UIButton+Block.h"
#import <objc/runtime.h>

static char overviewKey;
@interface UIButton()

@end

@implementation UIButton (Block)

+(void)load {

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
       
    });
}



-(void)setActions:(NSString *)action withHandleBlock:(HandleBlock)block {
    if ([self actions] == nil) {
        [self setActions:[[NSMutableDictionary alloc]init]];
    }
    [[self actions] setObject:[block copy] forKey:action];
    
    if ([@"TouchUpInside" isEqualToString:action]) {
        [self addTarget:self action:@selector(doTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    
}


-(void)doTouchUpInside:(UIButton *)btn {
    void(^block)();
    [[self actions] objectForKey:@"TouchUpInside"];
    block();
}


-(NSMutableDictionary *)actions {
    return objc_getAssociatedObject(self, &overviewKey);
}
-(void)setActions:(NSMutableDictionary *)actions {
    objc_setAssociatedObject(self, &overviewKey, actions, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
@end
