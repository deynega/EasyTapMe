//
//  Colors.h
//  TapMeIfYouCan
//
//  Created by Andrey on 21.12.17.
//  Copyright © 2017 deynega. All rights reserved.
//

#define RGBCOLOR(r, g, b) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1]

#define NAVIGATION_BAR_TINT_COLOR RGBCOLOR(69, 137, 133)

#define APP_BACKGROUND @[(id)RGBCOLOR(69.f, 137.f, 133.f).CGColor, (id)RGBCOLOR(215.f, 214.f, 165.f).CGColor];
#define GRADIENT_BUTTON @[(id)RGBCOLOR(219.f, 166.f, 123.f).CGColor, (id)RGBCOLOR(162.f, 92.f, 85.f).CGColor];

#define DEFAULT_COLOR_BOX [UIColor colorWithRed:27.f/255 green:37.f/255 blue:66.f/255 alpha:0.6f]
#define ANIMATE_COLOR_BOX [UIColor colorWithRed:2.f/255 green:192.f/255 blue:245.f/255 alpha:1.f]
#define TOUCH_COLOR [UIColor whiteColor]
#define SUCCESS_COLOR [UIColor whiteColor]
#define ERROR_COLOR [UIColor redColor]
