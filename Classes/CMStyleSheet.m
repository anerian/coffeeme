//
//  CMStyleSheet.m
//  CoffeeMe
//
//  Created by min on 5/20/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "CMStyleSheet.h"

@implementation CMStyleSheet

- (TTStyle*)blackForwardButton:(UIControlState)state {
  TTShape* shape = [TTRoundedRightArrowShape shapeWithRadius:4.5];
  UIColor* tintColor = RGBCOLOR(0, 0, 0);
  return [TTSTYLESHEET toolbarButtonForState:state shape:shape tintColor:tintColor font:nil];
}

- (TTStyle*)blueToolbarButton:(UIControlState)state {
  TTShape* shape = [TTRoundedRectangleShape shapeWithRadius:4.5];
  UIColor* tintColor = RGBCOLOR(30, 110, 255);
  return [TTSTYLESHEET toolbarButtonForState:state shape:shape tintColor:tintColor font:nil];
}

- (TTStyle*)embossedButton:(UIControlState)state {
  if (state == UIControlStateNormal) {
  return 
    [TTShapeStyle styleWithShape:[TTRoundedRectangleShape shapeWithRadius:8] next:
    [TTShadowStyle styleWithColor:HexToUIColor(0xaa8156) blur:0 offset:CGSizeMake(0, -1) next:
    [TTShadowStyle styleWithColor:HexToUIColor(0xffffff) blur:1 offset:CGSizeMake(0, -1) next:
    [TTShadowStyle styleWithColor:HexToUIColor(0xffffff) blur:1 offset:CGSizeMake(0, 1) next:
    [TTShadowStyle styleWithColor:HexToUIColor(0xaa8156) blur:0 offset:CGSizeMake(0, 1) next:
    [TTLinearGradientFillStyle styleWithColor1:HexToUIColor(0xeddabe) color2:HexToUIColor(0xc99865) next:
    [TTBoxStyle styleWithPadding:UIEdgeInsetsMake(10, 12, 9, 12) next:
    [TTTextStyle styleWithFont:[UIFont boldSystemFontOfSize:12]  color:HexToUIColor(0x45290f)
                 minimumFontSize:8 shadowColor:[UIColor colorWithWhite:1 alpha:0.8]
                 shadowOffset:CGSizeMake(0, 1) next:nil]]]]]]]];
                 
  } else if (state == UIControlStateHighlighted) {
    return 
      [TTShapeStyle styleWithShape:[TTRoundedRectangleShape shapeWithRadius:8] next:
      [TTShadowStyle styleWithColor:HexToUIColor(0xaa8156) blur:0 offset:CGSizeMake(0, -1) next:
      [TTShadowStyle styleWithColor:HexToUIColor(0xffffff) blur:1 offset:CGSizeMake(0, -1) next:
      [TTShadowStyle styleWithColor:HexToUIColor(0xffffff) blur:1 offset:CGSizeMake(0, 1) next:
      [TTShadowStyle styleWithColor:HexToUIColor(0xaa8156) blur:0 offset:CGSizeMake(0, 1) next:
      [TTLinearGradientFillStyle styleWithColor1:HexToUIColor(0xc99865) color2:HexToUIColor(0xeddabe) next:
      [TTBoxStyle styleWithPadding:UIEdgeInsetsMake(10, 12, 9, 12) next:
      [TTTextStyle styleWithFont:[UIFont boldSystemFontOfSize:12]  color:HexToUIColor(0x45290f)
                   minimumFontSize:8 shadowColor:[UIColor colorWithWhite:1 alpha:0.8]
                   shadowOffset:CGSizeMake(0, 1) next:nil]]]]]]]];
  } else {
    return nil;
  }
}

- (TTStyle*)dropButton:(UIControlState)state {
  if (state == UIControlStateNormal) {
    return 
      [TTShapeStyle styleWithShape:[TTRoundedRectangleShape shapeWithRadius:8] next:
      [TTShadowStyle styleWithColor:RGBACOLOR(0,0,0,0.7) blur:3 offset:CGSizeMake(2, 2) next:
      [TTInsetStyle styleWithInset:UIEdgeInsetsMake(0.25, 0.25, 0.25, 0.25) next:
      [TTSolidFillStyle styleWithColor:[UIColor whiteColor] next:
      [TTInsetStyle styleWithInset:UIEdgeInsetsMake(-0.25, -0.25, -0.25, -0.25) next:
      [TTSolidBorderStyle styleWithColor:RGBCOLOR(161, 167, 178) width:1 next:
      [TTInsetStyle styleWithInset:UIEdgeInsetsMake(2, 0, 0, 0) next:
      [TTBoxStyle styleWithPadding:UIEdgeInsetsMake(11, 10, 9, 10) next:
      [TTTextStyle styleWithFont:nil color:TTSTYLEVAR(linkTextColor)
                   shadowColor:[UIColor colorWithWhite:255 alpha:0.4]
                   shadowOffset:CGSizeMake(0, -1) next:nil]]]]]]]]];
  } else if (state == UIControlStateHighlighted) {
    return 
      [TTInsetStyle styleWithInset:UIEdgeInsetsMake(3, 3, 0, 0) next:
      [TTShapeStyle styleWithShape:[TTRoundedRectangleShape shapeWithRadius:8] next:
      [TTSolidFillStyle styleWithColor:[UIColor whiteColor] next:
      [TTSolidBorderStyle styleWithColor:RGBCOLOR(161, 167, 178) width:1 next:
      [TTInsetStyle styleWithInset:UIEdgeInsetsMake(2, 0, 0, 0) next:
      [TTBoxStyle styleWithPadding:UIEdgeInsetsMake(11, 10, 9, 10) next:
      [TTTextStyle styleWithFont:nil color:TTSTYLEVAR(linkTextColor)
                   shadowColor:[UIColor colorWithWhite:255 alpha:0.4]
                   shadowOffset:CGSizeMake(0, -1) next:nil]]]]]]];
  } else {
    return nil;
  }
}

- (TTStyle*)tabRound:(UIControlState)state {
  if (state == UIControlStateSelected) {
    return
      [TTShapeStyle styleWithShape:[TTRoundedRectangleShape shapeWithRadius:TT_ROUNDED] next:
      [TTInsetStyle styleWithInset:UIEdgeInsetsMake(9, 1, 8, 1) next:
      [TTShadowStyle styleWithColor:RGBACOLOR(255,255,255,0.8) blur:0 offset:CGSizeMake(0, 1) next:
      [TTLinearGradientFillStyle styleWithColor1:HexToUIColor(0x4d3a26) color2:HexToUIColor(0x25190c) next:
      [TTInsetStyle styleWithInset:UIEdgeInsetsMake(-1, -1, -1, -1) next:
      [TTBoxStyle styleWithPadding:UIEdgeInsetsMake(0, 10, 0, 10) next:
      [TTTextStyle styleWithFont:[UIFont boldSystemFontOfSize:12]  color:[UIColor whiteColor]
                   minimumFontSize:8 shadowColor:[UIColor colorWithWhite:0 alpha:0.5]
                   shadowOffset:CGSizeMake(0, -1) next:nil]]]]]]];
  } else {
    return
      [TTBoxStyle styleWithPadding:UIEdgeInsetsMake(0, 10, 0, 10) next:
      [TTTextStyle styleWithFont:[UIFont boldSystemFontOfSize:12] color:HexToUIColor(0x45290f)
                   minimumFontSize:8 shadowColor:[UIColor colorWithWhite:1 alpha:0.9]
                   shadowOffset:CGSizeMake(0, 1) next:nil]];
  }
}

- (TTStyle*)tabStrip {
  return
    [TTLinearGradientFillStyle styleWithColor1:HexToUIColor(0xeddabe) color2:HexToUIColor(0xc99865) next:
    [TTFourBorderStyle styleWithTop:nil right:nil bottom:HexToUIColor(0x25190c) left:nil width:1 next:nil]];
}

- (TTStyle*)tabOverflowLeft {
  UIImage* image = [UIImage imageNamed:@"overflowLeft.png"];
  return [TTImageStyle styleWithImage:image next:nil];
}

- (TTStyle*)tabOverflowRight {
  UIImage* image = [UIImage imageNamed:@"overflowRight.png"];
  return [TTImageStyle styleWithImage:image next:nil];
}

- (TTStyle*)titleLabel {
  TTTextStyle *style =   
    [TTTextStyle styleWithFont:[UIFont boldSystemFontOfSize:18] color:HexToUIColor(0x45290f)
    minimumFontSize:8 shadowColor:[UIColor whiteColor]
    shadowOffset:CGSizeMake(0, 1) next:nil];
  style.textAlignment = UITextAlignmentLeft;  
  return style;
}

- (TTStyle*)descriptionLabel {
  TTTextStyle *style =   
    [TTTextStyle styleWithFont:[UIFont boldSystemFontOfSize:16] color:HexToUIColor(0x45290f)
    minimumFontSize:16 shadowColor:[UIColor whiteColor]
    shadowOffset:CGSizeMake(0, 1) next:nil];
  style.textAlignment = UITextAlignmentLeft;  
  style.lineBreakMode = UILineBreakModeWordWrap;
  return style;
}

@end