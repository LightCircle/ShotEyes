
#import "Entities.h"

@implementation Shot
+(Class) tag_class {
    return [NSString class];
}
@end

@implementation ShotList
+(Class) items_class {
    return [Shot class];
}
@end

@implementation User
@end

@implementation Tag
@end

@implementation TagList
+(Class) items_class {
    return [Tag class];
}
@end