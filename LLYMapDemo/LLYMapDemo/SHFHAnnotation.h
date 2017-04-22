//
//  SHFHAnnotation.h
//  FocusLive
//
//  Created by 任丽凤 on 2016/12/19.
//  Copyright © 2016年 sohu. All rights reserved.
//

#import <MAMapKit/MAMapKit.h>


typedef enum : NSUInteger {
    kSHFHAnnotationTypeDistrict = 1001,
    kSHFHAnnotationTypeBuildings,//B级地图
    kSHFHAnnotationTypeStation,//地铁站
} kSHFHAnnotationTypes;

@interface SHFHAnnotation : MAPointAnnotation

@property (assign, nonatomic) NSInteger index;
@property (assign, nonatomic) kSHFHAnnotationTypes type;

@end
