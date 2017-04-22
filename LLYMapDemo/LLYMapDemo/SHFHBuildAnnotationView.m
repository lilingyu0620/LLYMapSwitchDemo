//
//  SHFHBuildAnnotationView.m
//  FocusLive
//
//  Created by 任丽凤 on 2016/12/15.
//  Copyright © 2016年 sohu. All rights reserved.
//

#import "SHFHBuildAnnotationView.h"
#import "LLYDistrictsModel.h"

@interface SHFHBuildAnnotationView ()

@property (strong, nonatomic) UIImageView *bgImageView;
@property (strong, nonatomic) UILabel *mLabelName;

@property (strong, nonatomic, readwrite) LLYDistrictsModel *buildInfo;

@end

@implementation SHFHBuildAnnotationView

#pragma mark - Override
- (void)setSelected:(BOOL)selected
{
    [self setSelected:selected animated:NO];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    [self setMBackgroundImageSeleted:selected];
    
    if ([self.delegate respondsToSelector:@selector(annotationClick:isOpen:)]) {
        [self.delegate annotationClick:self isOpen:selected];
    }
}

- (void)setMBackgroundImageSeleted:(BOOL)selected
{
    if (selected)
    {
//        DLog(@"selected");
        
        NSString *imageName = @"home_map_build_bg_hl";
//        if (_buildInfo.hasLiveroom == NO) {
//            imageName = @"home_map_build_bg_no_hl";
//        }
        UIImage *image = [UIImage imageNamed:imageName];
        UIImage *newImage = [image resizableImageWithCapInsets:UIEdgeInsetsMake(0, 34.0f, 0, 32.0f)];
        _bgImageView.image = newImage;
    }else {
        NSString *imageName = @"home_map_build_bg";
//        if (_buildInfo.hasLiveroom == NO) {
//            imageName = @"home_map_build_bg_no";
//        }
        UIImage *image = [UIImage imageNamed:imageName];
        UIImage *newImage = [image resizableImageWithCapInsets:UIEdgeInsetsMake(0, 34.0f, 0, 32.0f)];
        _bgImageView.image = newImage;
    }
}

#pragma mark - Life Cycle

- (id)initWithAnnotation:(id<MAAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    if (self) {
        UIImage *image = [UIImage imageNamed:@"home_map_build_bg"];
        self.bgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, image.size.width, image.size.height)];
        _bgImageView.image = image;
        [self addSubview:_bgImageView];
        
        self.mLabelName = [[UILabel alloc] init];
        _mLabelName.font = [UIFont systemFontOfSize:11.0f];
        _mLabelName.textColor = [UIColor whiteColor];
        [self addSubview:_mLabelName];
    }
    return self;
}

- (void)loadUIData:(LLYDistrictsModel *)buildInfo
{
    self.buildInfo = buildInfo;
    
    _mLabelName.text = buildInfo.districtName;
    [_mLabelName sizeToFit];
    _mLabelName.frame = CGRectMake(10, 0, _mLabelName.frame.size.width, 20);
    
    CGFloat width = _mLabelName.frame.size.width + 10.0f + 5.0f + 32.0f;
   
    NSString *imageName = @"home_map_build_bg";
//    if (buildInfo.hasLiveroom == NO) {
//        width = _mLabelName.frame.size.width + 10.0f + 10.0f;
//        imageName = @"home_map_build_bg_no";
//    }
    UIImage *image = [UIImage imageNamed:imageName];
    UIImage *newImage = [image resizableImageWithCapInsets:UIEdgeInsetsMake(0, 34.0f, 0, 32.0f)];
    _bgImageView.image = newImage;
    _bgImageView.frame = CGRectMake(0, 0, width, image.size.height);
    
    self.bounds = _bgImageView.frame;
}

@end
