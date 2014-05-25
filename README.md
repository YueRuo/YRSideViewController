###Introduction
把之前自己做的小玩意整理了拿出来共享一下。  
侧边栏抽屉效果不少，但是我这个还是有一些不同的。目前默认的效果有点类似网易新闻客户端，可以很方便的改为其他效果。

* 默认支持左和右两个控制器

* 支持修改滑动距离、是否开启手势拖拽、是否显示阴影等。

* 动画可以自定义。通过设置rootViewMoveBlock可以重写动画效果，甚至更改显示的位置等等。  
* 支持左右两个viewController的appear和disAppear方法触发

具体的效果可以看Demo。

###BugFixed  

1.0.0  修正了iOS7以下版本中，各view的顶部栏多空出20像素的问题

另：感谢[uxyheaven](https://github.com/uxyheaven/XYQuickDevelop)指出一个Bug，该Bug会导致横屏后滑动手势方向出错，目前已修复。
