//
//  RHook.m
//  Logging
//
//  Created by mac on 11/8/16.
//  Copyright © 2016 Roron0a. All rights reserved.
//

#import "RHook.h"
#import <objc/runtime.h>
#import <objc/message.h>
#pragma mark HookEvent
@interface RHookEvent()
@property(nonatomic,assign)AspectOptions option;
@property(nonatomic,copy)id handlerBlock;
@property(nonatomic)SEL hookSelector;
@end

@implementation RHookEvent

-(RHookEvent *)after {
    self.option = AspectPositionAfter;
    return self;
}
-(RHookEvent *)before {
    self.option = AspectPositionBefore;
    return self;
}
-(RHookEvent *)instead {
    self.option = AspectPositionInstead;
    return self;
}
-(RHookEvent *)automaticRemoval {
    self.option = AspectOptionAutomaticRemoval;
    return self;
}
-(RHookEvent *)excute {
    return self;
}


-(RHookEvent *(^)(SEL selector))selector {
    return ^id(SEL selector) {
        self.hookSelector = selector;
        return self;
    };
}
-(RHookEvent *(^)(id blk))block {
    return ^id(id blk) {
        self.handlerBlock = blk;
        return self;
    };
}


@end
#pragma mark HookEventMaker

@interface RHookEventMaker()
@property(nonatomic,strong)NSMutableSet<RHookEvent *> *madeEvents;
@end

@implementation RHookEventMaker

-(RHookEvent *)after {
    return self.generatedEvent.after;
}
-(RHookEvent *)before {
    return self.generatedEvent.before;
}
-(RHookEvent *)instead {
    return self.generatedEvent.instead;
}
-(RHookEvent *)automaticRemoval {
    return self.generatedEvent.automaticRemoval;
}

-(RHookEvent *)generatedEvent {
    RHookEvent *event = [[RHookEvent alloc]init];
    [self.madeEvents addObject:event];
    return event;
}
-(NSMutableSet<RHookEvent *> *)madeEvents {
    if (_madeEvents == nil) {
        _madeEvents = [[NSMutableSet alloc]init];
    }
    return _madeEvents;
}
-(NSArray<RHookEvent *> *)events {
    return [self.madeEvents allObjects];
}

@end

#pragma mark Hook

@interface RHook()
@property(nonatomic,strong)RHookEventMaker *make;
@property(nonatomic,strong)id hook;
@property(nonatomic,strong)id instance;

@end


@implementation RHook

+(RHook *)hookClass:(Class)cls {
    return [self hook:cls];
}
+(RHook *)hookClassWithName:(NSString *)name {
    Class cls = NSClassFromString(name);
    return [self hook:cls];
}
+(RHook *)hookInstance:(id)instance {
    return [self hook:instance];
}


#pragma mark init hook , obj might be a Class or an Instance
+(RHook *)hook:(id)obj {
    RHook *hook = [[RHook alloc]init];
    hook.hook = obj;
    hook.make = [[RHookEventMaker alloc]init];
    return hook;
}

#pragma mark Hook, make events
-(void)makeEvents:(makeBlock)block {
    [self makeEvents:block catchError:nil];
}
-(void)makeEvents:(makeBlock)block catchError:(errorBlock)errorBlock {
    block(self.make);
    
    NSError *error = [self excute];
    if (errorBlock && error) {
        errorBlock(error);
    }
}


#pragma mark begin hook
-(NSError *)excute {
    __block NSError *error = nil;
// `hook` is allowed to be a Class or a Obj
    [self.make.events enumerateObjectsUsingBlock:^(RHookEvent * _Nonnull event, NSUInteger idx, BOOL * _Nonnull stop) {
        [self.hook aspect_hookSelector:event.hookSelector withOptions:event.option usingBlock:event.handlerBlock error:&error];
        
        if (error) {
            *stop = YES;
        }
    }];
    return error;
}
@end


#pragma mark NSObject (RHook)

@implementation NSObject (RHook)

-(void)r_makeEvents:(makeBlock)block {
    [[RHook hookInstance:self] makeEvents:block];
}
-(void)r_makeEvents:(makeBlock)block catchError:(errorBlock)errorBlock {
    [[RHook hookInstance:self] r_makeEvents:block catchError:errorBlock];
}


+(void)r_makeEvents:(makeBlock)block {
    [[RHook hookClass:[self class]] makeEvents:block];
}
+(void)r_makeEvents:(makeBlock)block catchError:(errorBlock)errorBlock {
    [[RHook hookClass:[self class]] r_makeEvents:block catchError:errorBlock];
}

@end
