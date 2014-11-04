
#import <ABEntities.h>

@protocol Shot
@end

@interface Shot : LightModel
@property (retain, nonatomic) NSString <Optional> *title;
@property (retain, nonatomic) NSString <Optional> *message;
@property (retain, nonatomic) NSArray  <Optional> *tag;
@property (retain, nonatomic) NSString <Optional> *image;
@property (retain, nonatomic) NSNumber <Optional> *latitude;
@property (retain, nonatomic) NSNumber <Optional> *longitude;
@end

@interface ShotList : JSONModel
@property (retain, nonatomic) NSArray <Shot> *items;
@end
