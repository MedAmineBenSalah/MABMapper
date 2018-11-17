//
//  MABMapperFetcher.m
//  MABMapper
//
//  Created by Ben Salah Med Amine on 02/02/2017.
//  Copyright © 2017 MAB. All rights reserved.
//

#import "MABMapperFetcher.h"

@implementation MABMapperFetcher

+(id<MABMapper>)fetchDictionary:(NSDictionary*)dict andClass:(Class) _class{
    
    // check if dict already <null>
    if ([dict isKindOfClass:[NSNull class]]) {
        return nil;
    }
    
    NSDictionary *map = [_class map];
    
    NSObject<MABMapper> * object = [[_class alloc]init];
   
    for (NSString *key in map.allKeys) {
        NSString *path = map[key][@"path"];
        BOOL required = [map[key][@"required"]boolValue];
        BOOL isArray = [map[key][@"array"]boolValue];
        Class klass = map[key][@"class"];
        NSString *dateFormat = map[key][@"dateFormat"];
        NSTimeZone *timeZone = map[key][@"timeZone"];
        NSArray *pathComponents = [path componentsSeparatedByString:@"."];
        
        NSDictionary *currentDict = dict;
        if ([currentDict isKindOfClass:[NSArray class]]) {
            currentDict = [(NSArray*)dict firstObject];
        }
        for (NSString *component in pathComponents) {
            if ([currentDict isKindOfClass:[NSArray class]]) {
                currentDict = [(NSArray*)currentDict firstObject];
            }
            if ([currentDict isKindOfClass:[NSNull class]]) {
                currentDict = nil;
            }
            if (![currentDict isKindOfClass:[NSDictionary class]]) {
                currentDict = nil;
            }
            currentDict = currentDict[component];
        }
        NSObject *obj = currentDict;
        
        if (!obj) {
            if (required) {
                return nil;
            }else{
                continue;
            }
        }else{
            NSObject *parsedObj;
            if (klass == [NSString class]) {
                if (isArray) {
                    parsedObj = [self arrayOfStringsFromObject:obj];
                }else{
                    parsedObj = [self stringFromObject:obj];
                }
            }else if (klass == [NSNumber class]) {
                if (isArray) {
                    parsedObj = [self arrayOfNumbersFromObject:obj];
                }else{
                    parsedObj = [self numberFromObject:obj];
                }
            }else if (klass == [NSDate class]) {
                if (isArray) {
                    parsedObj = [self arrayOfDateFromObject:obj format:dateFormat timeZone:timeZone];
                }else{
                    parsedObj = [self dateFromObject:obj format:dateFormat timeZone:timeZone];
                }
            }else{
                if (isArray) {
                    if ([obj isKindOfClass:[NSArray class]]) {
                        parsedObj = [self fetchArray:(NSArray *)obj andClass:klass];
                    }else{
                        NSObject * obj2 = [self fetchDictionary:(NSDictionary *)obj andClass:klass];
                        if (obj2) {
                            parsedObj = @[obj2];
                        }
                    }
                }else{
                    parsedObj = [self fetchDictionary:(NSDictionary *)obj andClass:klass];
                }
            }
            if (parsedObj) {
                [object setValue:parsedObj forKey:key];
            }else{
                if (required) {
                    return nil;
                }
            }
            
        }
        
    }
    
    return object;
}

+(NSArray<id<MABMapper>>*)fetchArray:(NSArray*)array andClass:(Class) _class{
    
    if ([array isKindOfClass:[NSNull class]]) {
        return nil;
    }
    
    NSMutableArray *resultArray;
    for (NSDictionary *dict in array) {
        id<MABMapper> object = [MABMapperFetcher<id<MABMapper>> fetchDictionary:dict andClass:_class];
        if (object) {
            if (!resultArray) {
                resultArray = [[NSMutableArray alloc]init];
            }
            [resultArray addObject:object];
        }
    }
    return resultArray;
}

+(NSDate *)dateFromObject:(id)object format:(NSString*)format timeZone:(NSTimeZone*)timeZone{
    
    if ([object isKindOfClass:[NSArray class]]) {
        if ([object count]) {
            object = object[0];
        }else{
            return nil;
        }
    }
    return [self getDateFromObject:object format:format timeZone:timeZone];
}

+(NSDate *)getDateFromObject:(id)object format:(NSString*)format timeZone:(NSTimeZone*)timeZone{
    NSDate *date = nil;
    if (format) {
        NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
        formatter.dateFormat = format;
        if (timeZone) {
            formatter.timeZone = timeZone;
        }else{
            formatter.timeZone = [NSTimeZone defaultTimeZone];
        }
        
        formatter.locale = [NSLocale systemLocale];
        NSString *dateString = [self getStringValueFromObject:object];
        if (!dateString) {
            return nil;
        }
        date = [formatter dateFromString:dateString];
    }else{
        NSNumber *dateNumber = [self getNumberValueFromObject:object];
        if (!dateNumber) {
            return nil;
        }
        NSTimeInterval timeStamp = [dateNumber integerValue];
        date = [NSDate dateWithTimeIntervalSince1970:timeStamp];
    }
    
    return date;
}

+(NSArray *)arrayOfDateFromObject:(id)object format:(NSString*)format timeZone:(NSTimeZone*)timeZone{
    NSMutableArray *array = [[NSMutableArray alloc]init];
    
    if ([object isKindOfClass:[NSArray class]]) {
        if ([object count]) {
            for (id subObject in object) {
                id parsedObject = [self getDateFromObject:subObject format:format timeZone:timeZone];
                if (parsedObject)[array addObject:parsedObject];
            }
        }
    }else{
        id parsedObject = [self getDateFromObject:object format:format timeZone:timeZone];
        if (parsedObject)[array addObject:parsedObject];
    }
    
    return array;
}

+(NSNumber *)numberFromObject:(id)object{
    
    if ([object isKindOfClass:[NSArray class]]) {
        if ([object count]) {
            object = object[0];
        }else{
            return nil;
        }
    }
    
    return [self getNumberValueFromObject:object];
}

+(NSString *)stringFromObject:(id)object{
    
    if ([object isKindOfClass:[NSArray class]]) {
        if ([object count]) {
            object = object[0];
        }else{
            return nil;
        }
    }
    return [self getStringValueFromObject:object];
}

+(NSArray *)arrayOfNumbersFromObject:(id)object{
    NSMutableArray *array = [[NSMutableArray alloc]init];
    
    if ([object isKindOfClass:[NSArray class]]) {
        if ([object count]) {
            for (id subObject in object) {
                id parsedObject = [self getNumberValueFromObject:subObject];
                if (parsedObject)[array addObject:parsedObject];
            }
        }
    }else{
        id parsedObject = [self getNumberValueFromObject:object];
        if (parsedObject)[array addObject:parsedObject];
    }
    
    return array;
}

+(NSArray *)arrayOfStringsFromObject:(id)object{
    NSMutableArray *array = [[NSMutableArray alloc]init];
    
    if ([object isKindOfClass:[NSArray class]]) {
        if ([object count]) {
            for (id subObject in object) {
                id parsedObject = [self getStringValueFromObject:subObject];
                if (parsedObject)[array addObject:parsedObject];
            }
        }
    }else{
        id parsedObject = [self getStringValueFromObject:object];
        if (parsedObject)[array addObject:parsedObject];
    }
    
    return array;
}

+(BOOL)boolFromObject:(id)object{
    
    if ([object isKindOfClass:[NSArray class]]) {
        if ([object count]) {
            object = object[0];
        }else{
            return NO;
        }
    }
    return [self getBoolValueFromObject:object];
    
}

+(NSArray *)arrayOfObjectsFromObject:(id)object{
    NSMutableArray *array = [[NSMutableArray alloc]init];
    
    if ([object isKindOfClass:[NSArray class]]) {
        return object;
    }else{
        if (object)[array addObject:object];
    }
    
    return array;
}

+(BOOL)getBoolValueFromObject:(id)object{
    
    if (!object || [object isKindOfClass:[NSNull class]]) {
        return NO;
    }
    
    if ([object isKindOfClass:[NSNumber class]]) {
        return [object boolValue];
    }
    
    if ([object isKindOfClass:[NSString class]]) {
        return [object boolValue];
    }
    
    return NO;
}

+(NSNumber *)getNumberValueFromObject:(id)object{
    
    if (!object || [object isKindOfClass:[NSNull class]]) {
        return nil;
    }
    
    if ([object isKindOfClass:[NSNumber class]]) {
        return object;
    }
    
    if ([object isKindOfClass:[NSString class]]) {
        NSNumberFormatter *formatter = [[NSNumberFormatter alloc]init];
        return @([(NSString*)object floatValue]); //[formatter numberFromString:object];
    }
    
    return nil;
    
}

+(NSString *)getStringValueFromObject:(id)object{
    if (!object || [object isKindOfClass:[NSNull class]]) {
        return nil;
    }
    
    if ([object isKindOfClass:[NSNumber class]]) {
        NSNumberFormatter *formatter = [[NSNumberFormatter alloc]init];
        return [formatter stringFromNumber:object];
    }
    
    if ([object isKindOfClass:[NSString class]]) {
        return object;
    }
    
    return nil;
}

@end
