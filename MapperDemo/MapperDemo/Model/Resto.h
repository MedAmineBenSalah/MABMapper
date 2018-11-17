//
//  Resto.h
//  MapperDemo
//
//  Created by MedAmine BenSalah on 17/11/2018.
//  Copyright © 2018 mab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MABMapper.h"

NS_ASSUME_NONNULL_BEGIN

@interface Resto : NSObject<MABMapper>

@property NSString * restoId;
@property NSString *address;
@property CGFloat lat;
@property CGFloat lng;
@property NSString *name;
@property NSString *icon;

@end

NS_ASSUME_NONNULL_END
