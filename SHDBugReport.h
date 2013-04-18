//
//  SHDBugReport.h
//  Shakedown
//
//  Created by Max Goedjen on 4/17/13.
//  Copyright (c) 2013 Max Goedjen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SHDBugReport : NSObject

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *generalDescription;
@property (nonatomic, strong) NSString *reproducability;
@property (nonatomic, strong) NSMutableArray *screenshots;
@property (nonatomic, strong) NSDictionary *userInformation;
@property (nonatomic, readonly) NSDictionary *deviceDictionary;

@end
