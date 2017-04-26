//
//  RHook.h
//  Logging
//
//  Created by mac on 11/8/16.
//  Copyright © 2016 Roron0a. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Aspects.h"


#define R_HELPER_0(x) #x
#define R_HELPER_1(x) R_HELPER_0(clang diagnostic ignored #x)
#define R_CLANG_WARNING(x) _Pragma(R_HELPER_1(x))


#define sel(SELECTOR)  selector(\
_Pragma("clang diagnostic push")    \
R_CLANG_WARNING(-Wundeclared-selector) \
@selector(SELECTOR) \
_Pragma("clang diagnostic pop")\
)

@interface RHookEvent : NSObject


@property(nonatomic,assign,readonly)AspectOptions option;
@property(nonatomic,copy,readonly)id handlerBlock;
@property(nonatomic,readonly)SEL hookSelector;




-(RHookEvent *(^)(SEL selector))selector;
-(RHookEvent *(^)(id blk))block;
-(RHookEvent *)after;
-(RHookEvent *)before;
-(RHookEvent *)instead;
-(RHookEvent *)automaticRemoval;
-(RHookEvent *)excute;


@end



@interface RHookEventMaker : NSObject
-(RHookEvent *)after;
-(RHookEvent *)before;
-(RHookEvent *)instead;
-(RHookEvent *)automaticRemoval;
-(NSArray<RHookEvent *> *)events;

@end


typedef void (^makeBlock)(RHookEventMaker *make);
typedef void (^errorBlock)(NSError *error);
@interface RHook : NSObject

+(RHook *)hookInstance:(id)instance;

//not supported static methods
+(RHook *)hookClass:(Class)cls;
+(RHook *)hookClassWithName:(NSString *)name;

-(void)makeEvents:(makeBlock)block;
-(void)makeEvents:(makeBlock)block catchError:(errorBlock)errorBlock;
@end




@interface NSObject (RHook)

-(void)r_makeEvents:(makeBlock)block;
-(void)r_makeEvents:(makeBlock)block catchError:(errorBlock)errorBlock;

// hooking `static method` is not supprted
+(void)r_makeEvents:(makeBlock)block;
+(void)r_makeEvents:(makeBlock)block catchError:(errorBlock)errorBlock;


@end
