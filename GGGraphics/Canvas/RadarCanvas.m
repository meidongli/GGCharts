//
//  RadarCanvas.m
//  GGCharts
//
//  Created by 黄舜 on 17/8/3.
//  Copyright © 2017年 I really is a farmer. All rights reserved.
//

#import "RadarCanvas.h"
#import "GGGraphics.h"
#import "DRadarScaler.h"
#import "CALayer+GGLayer.h"
#include <objc/runtime.h>

static const void * radarLayer = @"radarLayer";

#define SET_ASSOCIATED_ASSIGN(obj, key, value) objc_setAssociatedObject(obj, key, value, OBJC_ASSOCIATION_ASSIGN)
#define SET_ASSOCIATED_RETAIN(obj, key, value) objc_setAssociatedObject(obj, key, value, OBJC_ASSOCIATION_RETAIN)
#define GET_ASSOCIATED(obj, key) objc_getAssociatedObject(obj, key)

@interface RadarCanvas ()

@property (nonatomic, strong) GGPolygonRenderder * polyRenderer;

@property (nonatomic, strong) NSMutableArray * arrayNumberRenderer;

@property (nonatomic, strong) Animator * animator;

@end

@implementation RadarCanvas

- (instancetype)init
{
    self = [super init];
    
    if (self) {
        
        _polyRenderer = [[GGPolygonRenderder alloc] init];
        [self addRenderer:_polyRenderer];
        
        _topCanvas = [[GGCanvas alloc] init];
        [self addSublayer:_topCanvas];
    }
    
    return self;
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    
    _topCanvas.frame = CGRectMake(0, 0, self.gg_width, self.gg_height);
}

- (void)setRadarDrawConfig:(id <RadarAbstract, RadarSetAbstract>)radarDrawConfig
{
    _radarDrawConfig = radarDrawConfig;
    
    _polyRenderer.width = radarDrawConfig.lineWidth;
    _polyRenderer.strockColor = radarDrawConfig.strockColor;
    _polyRenderer.splitCount = radarDrawConfig.splitCount;
    _polyRenderer.stringColor = radarDrawConfig.stringColor;
    _polyRenderer.stringFont = radarDrawConfig.titleFont;
    _polyRenderer.titles = radarDrawConfig.titles;
    _polyRenderer.isPiece = YES;
    _polyRenderer.titleSpacing = 5;
}

/** 更新视图 */
- (void)drawChart
{
    [super drawChart];
    
    _polyRenderer.polygon = GGPolygonMake(_radarDrawConfig.radius, self.gg_width / 2, self.gg_height / 2, _radarDrawConfig.side, 0);
    [self updateSubLayers];
    [self setNeedsDisplay];
}

/** 更新子视图 */
- (void)updateSubLayers
{
    for (NSInteger i = 0; i < _radarDrawConfig.radarSet.count; i++) {
        
        id <RadarAbstract> drawData = _radarDrawConfig.radarSet[i];
        
        DRadarScaler * dataScaler = [[DRadarScaler alloc] init];
        dataScaler.polygon = _polyRenderer.polygon;
        dataScaler.radarProportions = drawData.ratios;
        [dataScaler updateScaler];
        
        GGShapeCanvas * shapeCanvas = [self getGGShapeCanvasEqualFrame];
        shapeCanvas.fillColor = [drawData fillColor].CGColor;
        shapeCanvas.strokeColor = [drawData strockColor].CGColor;
        shapeCanvas.lineWidth = [drawData lineWidth];
        
        CGMutablePathRef ref = CGPathCreateMutable();
        GGPathAddPoints(ref, dataScaler.radarPoints, dataScaler.radarProportions.count);
        CGPathCloseSubpath(ref);
        shapeCanvas.path = ref;
        CGPathRelease(ref);
        
        SET_ASSOCIATED_ASSIGN(drawData, radarLayer, shapeCanvas);
        
        if ([drawData gradientColors].count > 0) {
            
            CAGradientLayer * gradientLayer = [self getCAGradientEqualFrame];
            gradientLayer.mask = shapeCanvas;
            gradientLayer.colors = [drawData gradientColors];
            gradientLayer.locations = [drawData locations];
        }
    }
    
    [self addSublayer:_topCanvas];
}

/** 动画 */
- (void)addAnimationWithDuration:(NSTimeInterval)duration
{
    for (NSInteger i = 0; i < _radarDrawConfig.radarSet.count; i++) {
        
        id <RadarAbstract> drawData = _radarDrawConfig.radarSet[i];
        
        GGShapeCanvas * shapeCanvas = GET_ASSOCIATED(drawData, radarLayer);
        CAKeyframeAnimation * scaleAtnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
        scaleAtnimation.duration = duration;
        scaleAtnimation.values = @[@0 , @1];
        [shapeCanvas addAnimation:scaleAtnimation forKey:@"scaleAtnimation"];
    }
    
    __weak RadarCanvas * weakSelf = self;
    self.animator.animationType = AnimationLinear;
    
    [_animator startAnimationWithDuration:duration animationArray:self.arrayNumberRenderer updateBlock:^(CGFloat progress) {
        
        [weakSelf.topCanvas setNeedsDisplay];
    }];
}

/** 增加渲染器 */
- (void)addGGNumberRenderer:(GGNumberRenderer *)renderer
{
    [self.arrayNumberRenderer addObject:renderer];
}

/** 清除渲染器 */
- (void)removeAllGGNumberRenderer
{
    [self.arrayNumberRenderer removeAllObjects];
}

#pragma mark - Lazy

GGLazyGetMethod(NSMutableArray, arrayNumberRenderer);

GGLazyGetMethod(Animator, animator);

@end
