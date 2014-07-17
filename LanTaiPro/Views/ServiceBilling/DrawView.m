//
//  DrawView.m
//  LanTaiPro
//
//  Created by comdosoft on 14-6-20.
//  Copyright (c) 2014年 LanTaiPro. All rights reserved.
//

#import "DrawView.h"

@implementation DrawView
//线条宽度的数组
static float lineWidthArray[4]={5.0,20.0,30.0,40.0};
//确定颜色的值，将颜色计数的值存到数组里默认为0，即为绿色
static int colorCount;
//确定宽度的值，将宽度计数的值存到数组里默认为0，即为10
static int widthCount;
//保存颜色的数组
static NSMutableArray *colors;
- (id)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //初始化颜色数组，将用到的颜色存储到数组里
        colors=[[NSMutableArray alloc]initWithObjects:[UIColor colorWithRed:91./255 green:223./255 blue:243./255 alpha:1],[UIColor blueColor],[UIColor redColor],[UIColor blackColor],[UIColor whiteColor], nil];
        self.WidthArray=[[NSMutableArray alloc]init];
        self.deleWidthArray=[[NSMutableArray alloc]init];
        self.pointArray=[[NSMutableArray alloc]init];
        self.lineArray=[[NSMutableArray alloc]init];
        self.deleArray=[[NSMutableArray alloc]init];
        self.colorArray=[[NSMutableArray alloc]init];
        self.deleColorArray=[[NSMutableArray alloc]init];
        //颜色和宽度默认都取当前数组第0位为默认值
        colorCount=0;
        widthCount=0;
    }
    return self;
}
//给界面按钮操作时获取tag值作为width的计数。来确定宽度，颜色同理
-(void)setlineWidth:(NSInteger)width{
    widthCount=width;
}
-(void)setLineColor:(NSInteger)color{
    colorCount=color;
}

//uiview默认的drawRect方法，覆盖重写，可在界面上重绘
- (void)drawRect:(CGRect)rect
{
    //获取当前上下文，
    CGContextRef context=UIGraphicsGetCurrentContext();
    CGContextBeginPath(context);
    CGContextSetLineWidth(context, 10.0f);
    //线条拐角样式，设置为平滑
    CGContextSetLineJoin(context,kCGLineJoinRound);
    //线条开始样式，设置为平滑
    CGContextSetLineCap(context, kCGLineCapRound);
    //查看lineArray数组里是否有线条，有就将之前画的重绘，没有只画当前线条
    if ([self.lineArray count]>0) {
        for (int i=0; i<[self.lineArray count]; i++) {
            NSArray * array=[NSArray
                             arrayWithArray:[self.lineArray objectAtIndex:i]];
            
            if ([array count]>0)
            {
                CGContextBeginPath(context);
                CGPoint myStartPoint=CGPointFromString([array objectAtIndex:0]);
                CGContextMoveToPoint(context, myStartPoint.x, myStartPoint.y);
                
                for (int j=0; j<[array count]-1; j++)
                {
                    CGPoint myEndPoint=CGPointFromString([array objectAtIndex:j+1]);
                    CGContextAddLineToPoint(context, myEndPoint.x,myEndPoint.y);
                }
                //获取colorArray数组里的要绘制线条的颜色
                NSNumber *num=[self.colorArray objectAtIndex:i];
                int count=[num intValue];
                UIColor *lineColor=[colors objectAtIndex:count];
                //获取WidthArray数组里的要绘制线条的宽度
                NSNumber *wid=[self.WidthArray objectAtIndex:i];
                int widthc=[wid intValue];
                float width=lineWidthArray[widthc];
                //设置线条的颜色，要取uicolor的CGColor
                CGContextSetStrokeColorWithColor(context,[lineColor CGColor]);
                //-------------------------------------------------------
                //设置线条宽度
                CGContextSetLineWidth(context, width);
                //保存自己画的
                CGContextStrokePath(context);
            }
        }
    }
    //画当前的线
    if ([self.pointArray count]>0)
    {
        CGContextBeginPath(context);
        CGPoint myStartPoint=CGPointFromString([self.pointArray objectAtIndex:0]);
        CGContextMoveToPoint(context, myStartPoint.x, myStartPoint.y);
        
        for (int j=0; j<[self.pointArray count]-1; j++)
        {
            CGPoint myEndPoint=CGPointFromString([self.pointArray objectAtIndex:j+1]);
            //--------------------------------------------------------
            CGContextAddLineToPoint(context, myEndPoint.x,myEndPoint.y);
        }
        UIColor *lineColor=[colors objectAtIndex:colorCount];
        float width=lineWidthArray[widthCount];
        CGContextSetStrokeColorWithColor(context,[lineColor CGColor]);
        //-------------------------------------------------------
        CGContextSetLineWidth(context, width);
        CGContextStrokePath(context);
    }
    
    
}
//在touch结束前将获取到的点，放到pointArray里
-(void)addPA:(CGPoint)nPoint{
    NSString *sPoint=NSStringFromCGPoint(nPoint);
    [self.pointArray addObject:sPoint];
}
//在touchend时，将已经绘制的线条的颜色，宽度，线条线路保存到数组里
-(void)addLA{
    NSNumber *wid=[[NSNumber alloc]initWithInt:widthCount];
    NSNumber *num=[[NSNumber alloc]initWithInt:colorCount];
    [self.colorArray addObject:num];
    [self.WidthArray addObject:wid];
    NSArray *array=[NSArray arrayWithArray:self.pointArray];
    [self.lineArray addObject:array];
    self.pointArray=[[NSMutableArray alloc]init];
}

#pragma mark -
//手指开始触屏开始
static CGPoint MyBeganpoint;
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
}
//手指移动时候发出
-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch* touch=[touches anyObject];
	MyBeganpoint=[touch locationInView:self];
    NSString *sPoint=NSStringFromCGPoint(MyBeganpoint);
    [self.pointArray addObject:sPoint];
    [self setNeedsDisplay];
}
//当手指离开屏幕时候
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self addLA];
}
//电话呼入等事件取消时候发出
-(void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{

}
//撤销，将当前最后一条信息移动到删除数组里，方便恢复时调用
-(void)revocation{
    if ([self.lineArray count]) {
        [self.deleArray addObject:[self.lineArray lastObject]];
        [self.lineArray removeLastObject];
    }
    if ([self.colorArray count]) {
        [self.deleColorArray addObject:[self.colorArray lastObject]];
        [self.colorArray removeLastObject];
    }
    if ([self.WidthArray count]) {
        [self.deleWidthArray addObject:[self.WidthArray lastObject]];
        [self.WidthArray removeLastObject];
    }
    //界面重绘方法
    [self setNeedsDisplay];
}
//将删除线条数组里的信息，移动到当前数组，在主界面重绘
-(void)refrom{
    if ([self.deleArray count]) {
        [self.lineArray addObject:[self.deleArray lastObject]];
        [self.deleArray removeLastObject];
    }
    if ([self.deleColorArray count]) {
        [self.colorArray addObject:[self.deleColorArray lastObject]];
        [self.deleColorArray removeLastObject];
    }
    if ([self.deleWidthArray count]) {
        [self.WidthArray addObject:[self.deleWidthArray lastObject]];
        [self.deleWidthArray removeLastObject];
    }
    [self setNeedsDisplay];
    
}
-(void)clear{
    //移除所有信息并重绘
    [self.deleArray removeAllObjects];
    [self.deleColorArray removeAllObjects];
    colorCount=0;
    [self.colorArray removeAllObjects];
    [self.lineArray removeAllObjects];
    [self.pointArray removeAllObjects];
    [self.deleWidthArray removeAllObjects];
    widthCount=0;
    [self.WidthArray removeAllObjects];
    [self setNeedsDisplay];
}


@end
