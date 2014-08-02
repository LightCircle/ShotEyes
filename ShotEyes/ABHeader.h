//
//  ABHeader.h
//  ShotEyes
//
//  Created by LI LIN on 14-8-2.
//  Copyright (c) 2014年 Alphabets. All rights reserved.
//

#import <AFHTTPSessionManager.h>
#import <DAConfigManager.h>
#import <UIImageView+WebCache.h>
#import <DAStorable.h>
#import "Entities.h"
#import "KxMenu.h"
#import "ABHelper.h"

#ifndef ShotEyes_ABHeader_h
#define ShotEyes_ABHeader_h

#define kNotificationNameNeedsLogin @"NeedsLogin"

#define kHTTPHeaderCookieName       @"Set-Cookie"
#define kHTTPHeaderCsrftokenName    @"csrftoken"

#define kConfigManagerUserID        @"cn.alphabets.userid"
#define kConfigManagerDefaultUserID @"cn.alphabets.defaultuserid"
#define kConfigManagerCookie        @"cn.alphabets.cookie"
#define kConfigManagerCsrfToken     @"cn.alphabets.csrftoken"

#endif

