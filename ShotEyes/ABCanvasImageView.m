//
//  ABCanvasImageView.m
//  ShotEyes
//
//  Created by LI LIN on 14-7-31.
//  Copyright (c) 2014年 Alphabets. All rights reserved.
//

#import "ABCanvasImageView.h"

@implementation ABCanvasImageView
{
    CGPoint _touchPoint;
    
    // 画像指定済みフラグ（指定済みの場合は、クリアするときファイルからオリジナル画像を再表示）
    BOOL _isImageSelected;
    
    // 選択情報等、一時保存用
    UIColor  *_penColor;
    NSNumber *_penBold;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = YES;
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)decoder
{
    self = [super initWithCoder:decoder];
    if (self) {
        self.userInteractionEnabled = YES;
    }
    return self;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (!_isImageSelected) {
        return;
    }
    
    // タッチ開始座標をインスタンス変数touchPointに保持
    UITouch *touch = [touches anyObject];
    _touchPoint = [touch locationInView:self];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (!_isImageSelected) {
        return;
    }
    
    // 現在のタッチ座標をローカル変数currentPointに保持
    UITouch *touch = [touches anyObject];
    CGPoint currentPoint = [touch locationInView:self];
    
    // 描画領域をcanvasの大きさで生成
    UIGraphicsBeginImageContext(self.frame.size);
    [self.image drawInRect:[self rect]];
    
    // 線の角を丸くする
    CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);
    
    // 線の太さを指定
    CGContextSetLineWidth(UIGraphicsGetCurrentContext(), _penBold.floatValue);
    
    // 線の色を指定（RGB）
    CGFloat red;
    CGFloat green;
    CGFloat blue;
    CGFloat alpha;
    [_penColor getRed:&red green:&green blue:&blue alpha:&alpha];
    CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), red, green, blue, alpha);
    
    // 線の描画座標をセット
    CGContextMoveToPoint(UIGraphicsGetCurrentContext(), _touchPoint.x, _touchPoint.y);
    CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), currentPoint.x, currentPoint.y);
    
    // 描画の開始～終了座標まで線を引く
    CGContextStrokePath(UIGraphicsGetCurrentContext());
    
    // 描画領域を画像（UIImage）としてcanvasにセット
    self.image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    _touchPoint = currentPoint;
}

- (CGRect)rect
{
    float widthRatio = self.bounds.size.width / self.image.size.width;
    float heightRatio = self.bounds.size.height / self.image.size.height;
    float scale = MIN(widthRatio, heightRatio);
    float width = scale * self.image.size.width;
    float height = scale * self.image.size.height;
    float y = (self.bounds.size.height - height) / 2;
    float x = (self.bounds.size.width - width) / 2;
    return CGRectMake(x, y, width, height);
}

@end
