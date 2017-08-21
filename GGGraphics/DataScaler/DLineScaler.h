//
//  DLineScaler.h
//  HSCharts
//
//  Created by 黄舜 on 17/6/22.
//  Copyright © 2017年 I really is a farmer. All rights reserved.
//

#import "BaseScaler.h"

@interface DLineScaler : BaseScaler

@property (nonatomic, assign) CGFloat max;              ///< 区域内最大值
@property (nonatomic, assign) CGFloat min;              ///< 区域内最小值
@property (nonatomic, assign) NSUInteger xMaxCount;     ///< 横向最大点数 默认与数组一致

@property (nonatomic, strong) NSArray <NSNumber *> *dataAry;    ///< 数据与lineObjAry二选一
@property (nonatomic, readonly) NSArray <NSObject *> *lineObjAry;   ///< 数据与dataAry二选一
@property (nonatomic, readonly) CGPoint * linePoints;           ///< 数据点 size 与数据一致
@property (nonatomic, readonly) NSInteger pointSize;    ///< 点个数

@property (nonatomic, assign) CGFloat xRatio;           ///< x轴偏移比例 0-1 默认 0.5

@property (nonatomic, strong) NSNumber * aroundNumber;          ///< 环绕点数据

/**
 * 根据 aroundNumber 计算出的最低点
 *
 * 注意 : 如果 aroundNumber == nil, 则 : CGRectGetMaxY(self.rect)
 */
@property (nonatomic, readonly) CGFloat aroundY;

/**
 * 自定义对象转换转换, 如果设置则忽略dataAry
 *
 * @param objAry 模型类数组
 * @param getter 模型类方法, 方法无参数, 返回值为CGFloat, 否则会崩溃。
 */
- (void)setObjAry:(NSArray <NSObject *> *)objAry getSelector:(SEL)getter;

/** 靠近点的数据index */
- (NSUInteger)indexOfPoint:(CGPoint)point;

/** 更新计算点 */
- (void)updateScaler;

/** 区域更新计算点 */
- (void)updateScalerWithRange:(NSRange)range;

/** 获取价格点 */
- (CGFloat)getYPixelWithData:(CGFloat)data;

/** 根据点获取价格 */
- (CGFloat)getPriceWithPoint:(CGPoint)point;

/** 根据点获取价格 */
- (CGFloat)getPriceWithYPixel:(CGFloat)y;

@end
