//
//  UIButton+Block.h
//  Logging
//
//  Created by mac on 11/22/16.
//  Copyright © 2016 Roron0a. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef void (^HandleBlock)(NSInteger index);




@interface UIButton (Block)
@property(nonatomic,strong)NSMutableDictionary *actions;
-(void)setActions:(NSString *)action withHandleBlock:(HandleBlock)block;

-(void)addHandlBlock:(HandleBlock)block;


@end
