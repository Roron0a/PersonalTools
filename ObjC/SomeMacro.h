//
//  SomeMacro.h
//  Tools
//
//  Created by mac on 11/6/16.
//  Copyright © 2016 Roron0a. All rights reserved.
//

#ifndef SomeMacro_h
#define SomeMacro_h

/* Logging */
#ifdef DEBUG
#   define MyLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)
#else
#   define AllLog(...)
#endif

#define AllLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)

/*
 ----------userdefault ----------
 */
#define SetUserDefaultsForKey(key,value)   [[NSUserDefaults standardUserDefaults] setObject:value forKey:key]
#define GetUserDefaultsWithKey(key)  [[NSUserDefaults standardUserDefaults] objectForKey:key]
#define SyncUserDefaults    [[NSUserDefaults standardUserDefaults] synchronize];


#define UserDefaultDSet(k,obj)     [[NSUserDefaults standardUserDefaults] setObject:obj forKey:k]
#define UserDefaultGet(k)       [[NSUserDefaults standardUserDefaults] objectForKey:k]
#define UserDefaultSetBool(k,d) [[NSUserDefaults standardUserDefaults] setBool:d forKey:k]
#define UserDefaultGetBool(k)   [[NSUserDefaults standardUserDefaults] boolForKey:k]
#define UserDefaultSetInt(k,d)  [[NSUserDefaults standardUserDefaults] setInteger:d forKey:k]
#define UserDefaultGetInt(k)    [[NSUserDefaults standardUserDefaults] integerForKey:k]
#define UserDefaultSync()       [[NSUserDefaults standardUserDefaults] synchronize]

/*----------String--------
*/


#define CHECKSTR(str) (str == nil || [str isKindOfClass:[NSNull class]])? @"" : str


#define  InitlizSyncTimeStamp @"0000-00-00 00:00:00"
#define CHECKDateSTR(str) (str == nil || [str isKindOfClass:[NSNull class]])? InitlizSyncTimeStamp : str


#define USELocalString(A) NSLocalizedString(A,nil)

/*-----------Colors----------
 */
#define RGBA(r,g,b,a)    [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]
#define RGB(r,g,b)       RGBA(r, g, b, 1.0f)


/*----------notifications----------*/
 
#define NotiAdd(selector,name)      [[NSNotificationCenter defaultCenter] addObserver:self selector:selector name:name object:nil]
#define NotiRemove()      [[NSNotificationCenter defaultCenter] removeObserver:self]
#define NCNotify(name,obj)   [[NSNotificationCenter defaultCenter] postNotificationName:name object:obj]

/*------------------font---------------*/
#define font(t,size) [UIFont fontWithName:t size:size]
/*-----------------Boolean Operators-------------- */
#define and &&
#define or ||
/*------------others------------
  */
#define ApplicationDelegate                 ((AppDelegate *)[[UIApplication sharedApplication] delegate])
#define UserDefaults                        [NSUserDefaults standardUserDefaults]
#define NotificationCenter                  [NSNotificationCenter defaultCenter]
#define SharedApplication                   [UIApplication sharedApplication]
#define Bundle                              [NSBundle mainBundle]
#define MainScreen                          [UIScreen mainScreen]
#define ShowNetworkActivityIndicator()      [UIApplication sharedApplication].networkActivityIndicatorVisible = YES
#define HideNetworkActivityIndicator()      [UIApplication sharedApplication].networkActivityIndicatorVisible = NO
#define NetworkActivityIndicatorVisible(x)  [UIApplication sharedApplication].networkActivityIndicatorVisible = x
#define NavBar                              self.navigationController.navigationBar
#define TabBar                              self.tabBarController.tabBar
#define NavBarHeight                        self.navigationController.navigationBar.bounds.size.height
#define TabBarHeight                        self.tabBarController.tabBar.bounds.size.height
#define ScreenWidth                         [[UIScreen mainScreen] bounds].size.width
#define ScreenHeight                        [[UIScreen mainScreen] bounds].size.height
#define rect(x,y,w,h) CGRectMake(x,y,w,h)
#define point(x,y)    CGPointMake(x,y)
#define size(w,h)     CGSizeMake(w,h)
#define range(s,l)    NSMakeRange(s,l)

#define uid [[[UIDevice currentDevice] identifierForVendor] UUIDString]

#endif /* SomeMacro_h */
