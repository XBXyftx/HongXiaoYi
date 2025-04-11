/**
 * 存储开启沉浸式模式后的导航栏和状态栏规避高度信息
 * top:     顶部状态栏规避高度
 * bottom:  底部导航栏规避高度
 */
@ObservedV2
export class AvoidArea {
  @Trace top: number = 0;
  @Trace bottom: number = 0;
}