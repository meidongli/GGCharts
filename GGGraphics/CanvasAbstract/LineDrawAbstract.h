//
//  LineDrawAbstract.h
//  GGCharts
//
//  Created by 黄舜 on 17/8/4.
//  Copyright © 2017年 I really is a farmer. All rights reserved.
//

#ifndef LineDrawAbstract_h
#define LineDrawAbstract_h

#import "DLineScaler.h"

@protocol LineDrawAbstract <NSObject>

@property (nonatomic, strong, readonly) DLineScaler * lineScaler;

#pragma mark - Line

@property (nonatomic, assign) CGFloat lineWidth;
@property (nonatomic, strong) UIColor * lineColor;

#pragma mark - Point

@property (nonatomic, assign) CGFloat shapeRadius;
@property (nonatomic, strong) UIColor * shapeFillColor;

#pragma mark - String

@property (nonatomic, strong) UIFont * stringFont;
@property (nonatomic, strong) UIColor * stringColor;
@property (nonatomic, strong) NSString * dataFormatter;

#pragma mark - Fill

@property (nonatomic, strong) NSNumber * fillRoundPrice;
@property (nonatomic, strong) UIColor * lineFillColor;

#pragma mark - Gradient

@property (nonatomic, strong) NSArray * gradientColors;     ///< CGColor
@property (nonatomic, strong) NSArray <NSNumber *> *locations;

@end

#endif /* LineDrawAbstract_h */
