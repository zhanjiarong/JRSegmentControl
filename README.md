# JRSegmentControl


一个类似于**UISegmentControl**的自定义控制，可以点击和滑动来切换不同的选项。同时封装了**JRSegmentViewController**可以方便集成类似于《猫眼电影》中的切换效果。

-------------

![JRSegmentControl](https://github.com/zhanjiarong/JRSegmentControl/blob/master/2015-08-30_16_49_40.gif?raw=true)

-------------

## 使用方法

##### (一)

```
#import "JRSegmentViewController.h"
```

初始化视图控制器，并设置viewControllers属性，如：

```
	JRSegmentViewController *vc = [[JRSegmentViewController alloc] init];
    vc.segmentBgColor = [UIColor colorWithRed:18.0f/255 green:50.0f/255 blue:110.0f/255 alpha:1.0f];
    vc.indicatorViewColor = [UIColor whiteColor];
    vc.titleColor = [UIColor whiteColor];
    
    [vc setViewControllers:@[firstVC, secondVC, thirdVC]];
    [vc setTitles:@[@"热点", @"聚焦", @"推荐"]];
    
    [self.navigationController pushViewController:vc animated:YES];
```

以上方法可以实现Demo中的效果，可参考Demo。


##### (二)

单独使用 **JRSegmentControl**，使用方法类似 **UISegmentControl**

```
#import "JRSegmentControl"
```

```
	JRSegmentControl *segment = [[JRSegmentControl alloc] initWithFrame:CGRectMake(0, 0, _itemWidth * 3, 30.0f)];
    segment.titles = @[@"热点", @"聚焦", @"推荐"];
    segment.cornerRadius = 5.0f;
    segment.titleColor = [UIColor whiteColor];
    segment.indicatorViewColor = [UIColor whiteColor];
    segment.backgroundColor = [UIColor colorWithRed:18.0f/255 green:50.0f/255 blue:110.0f/255 alpha:1.0f];
    
    segment.delegate = self; // 遵守协议即可
    
    [self.view addSubView:segment];

```


## QQ:541135917