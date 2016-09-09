//
//  Constant.h
//  bukket
//
//  Created by Tuan Nguyen on 4/4/14.
//  Copyright (c) 2014 Sigterm LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UIAlertView+BlockAndSelector.h"
#import "UIView+Helper.h"
#define DLog(fmt, ...) NSLog((@"%s [Line %d] " fmt),__PRETTY_FUNCTION__,__LINE__,##__VA_ARGS__);
#define IS_IPAD  UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad
#define RGBACOLOR(r,g,b,a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)]
#define isNull(str) [AppCommon isNullString:str]
#define SCREEN_SIZE [[UIScreen mainScreen] bounds].size
#define CommonShared [NSCommon shared]
#define UIImageNamed(str) [UIImage imageNamed:str]
#define isNSNull(obj) (obj == (id)[NSNull null])

#define MAIN_STORYBOARD [UIStoryboard storyboardWithName:@"Main" bundle:nil]

#define LOCALIZED(key) NSLocalizedString(key, nil)

#define SYSTEM_VERSION_LESS_THAN(v) ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)

#define UIColorFromHEX(hexValue) [UIColor \
colorWithRed:((float)((hexValue & 0xFF0000) >> 16))/255.0 \
green:((float)((hexValue & 0xFF00) >> 8))/255.0 \
blue:((float)(hexValue & 0xFF))/255.0 alpha:1.0]
 