//
//  MABMapperFetcher.h
//  MABMapper
//
//  Created by Ben Salah Med Amine on 02/02/2017.
//  Copyright © 2017 MAB. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MABMapper.h"

@interface MABMapperFetcher<ObjectType:id<MABMapper>> : NSObject

+(ObjectType)fetchDictionary:(NSDictionary*)dict andClass:(Class) _class;
+(NSArray<ObjectType>*)fetchArray:(NSArray*)array andClass:(Class) _class;

@end

