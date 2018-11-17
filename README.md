# MABMapper
MABMapper is a simple Objective-C library to convert JSON to strongly typed objects.

---

## Integration
### Via cocoapods
```sh
pod "MABMapper"
```
### Manual Integration
First, you have to download the sdk from [github].
Drag and drop MABMapper Folder in your project.

---
## Usage
All object that will be mapped has to conform MABMapper protocol.
```objc
#import <UIKit/UIKit.h>
#import "MABMapper.h"

@interface Object : NSObject<MABMapper>
```
MABMapper protocol has one required method **+[MABMapper map]**.
```objc
@protocol MABMapper <NSObject>

@required
+(NSDictionary *)map;

@end
```
This method returns an NSDictionary that contains the mapping configuration.
```objc
+(NSDictionary *)map{
    return @{
             ...
             };
}
```
The class **MABMapperFetcher** is responsable of parsing serialized data to typed objects.
It has tow methods:
- +[MABMapperFetcher fetchDictionary:andClass:]
- +[MABMapperFetcher fetchArray:andClass:]
```objc
NSArray *rawObjects = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
NSArray<Object*> *array = [MABMapperFetcher<Object*> fetchArray:rawObjects andClass:[Object class]];
```
```objc
NSDictinary *rawObject = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
Object* *object = [MABMapperFetcher<Object*> fetchDictionary:rawObject andClass:[Object class]];
```
### Map Configuration

Map configuration is an NSDictionary that contains all properties that will be mapped with it's settings.
```objc
+(NSDictionary *)map{
    return @{
             @"property_name": @{
                     @"class": /*class of the property*/,
                     @"path": /*path of property on json*/,
                     @"required": /*is required or not*/,
                     @"array": /*is a collection or not*/
                     }
             };
}
```

### Property Settings
| Setting | Description |
| ----- | ----- |
| class | The class of the property, if the property is an array, you have to set the class of one element. <br/>For scalar types like (CGFloat, BOOL, ...) you have to use NSNumber <br/> Supported class are: NSString, NSNumber, NSDate, NSObject&lt;MABMapper&gt;<br/>The fetcher try to convert data from JSON to selected class, if it can not, it will set nil value|
| path | The path of the property on the JSON.<br/>The path supports internal objects<br/>exemple:<br/>{<br/>"geometry":{<br/> "lat": 10.1234,<br/> "lng":30.12345<br/>}<br/>}<br/>We have 2 properties, lat with path @"geometry.lat" and lng with path @"geometry.lng".|
| required | An NSNumber that contains a boolean value ( @(YES)/@(NO) ) that defines if the property can be nil or not.<br/>If the property is required and fetcher can not covert data to desired class, the returned object will be nil, so the fetcher return an object only if all required properties are not nil. |
| array |An NSNumber that contains a boolean value ( @(YES)/@(NO) ) that defines if the property is an array or not.<br/>If the setting **array** setted to NO and the JSON data is an array, the fetcher will convert only the first object.<br/>If the setting **array** setted to YES and the JSON data is an object, the fetcher will convert it and put it on an array.|

---
[github]:[https://github.com/MedAmineBenSalah/MABMapper]
