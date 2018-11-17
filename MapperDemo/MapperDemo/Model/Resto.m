//
//  Resto.m
//  MapperDemo
//
//  Created by MedAmine BenSalah on 17/11/2018.
//  Copyright © 2018 mab. All rights reserved.
//

#import "Resto.h"

@implementation Resto

+(NSDictionary *)map{
    return @{
             @"restoId": @{
                     @"class": [NSString class],
                     @"path": @"id",
                     @"required": @(YES),
                     @"array": @(NO)
                     
                     },
             @"address": @{
                     @"class": [NSString class],
                     @"path": @"formatted_address",
                     @"required": @(YES),
                     @"array": @(NO)
                     
                     },
             @"name": @{
                     @"class": [NSString class],
                     @"path": @"name",
                     @"required": @(YES),
                     @"array": @(NO)
                     
                     },
             @"lat": @{
                     @"class": [NSNumber class],
                     @"path": @"lat",
                     @"required": @(YES),
                     @"array": @(NO)
                     
                     },
             @"lng": @{
                     @"class": [NSNumber class],
                     @"path": @"lng",
                     @"required": @(YES),
                     @"array": @(NO)
                     
                     },
             @"icon": @{
                     @"class": [NSString class],
                     @"path": @"icon",
                     @"required": @(NO),
                     @"array": @(NO)
                     
                     }
             
             };
}

@end
