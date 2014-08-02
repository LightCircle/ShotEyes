
#import <DAEntity.h>

@interface DATag : DAEntity

@end

@interface DAShot : DAEntity

@property (retain, nonatomic) NSString *_id;
@property (retain, nonatomic) NSString *valid;
@property (retain, nonatomic) NSString *createAt;
@property (retain, nonatomic) NSString *createBy;
@property (retain, nonatomic) NSString *updateAt;
@property (retain, nonatomic) NSString *updateBy;
@property (retain, nonatomic) NSString *title;
@property (retain, nonatomic) NSString *message;
@property (retain, nonatomic) NSArray *tag;
@property (retain, nonatomic) NSString *image;

@end

@interface User : DAEntity
@property (retain, nonatomic) NSString *_id;
@property (retain, nonatomic) NSString *id;
@property (retain, nonatomic) NSString *name;
@property (retain, nonatomic) NSString *valid;
@property (retain, nonatomic) NSString *createAt;
@property (retain, nonatomic) NSString *createBy;
@property (retain, nonatomic) NSString *updateAt;
@property (retain, nonatomic) NSString *updateBy;
@end