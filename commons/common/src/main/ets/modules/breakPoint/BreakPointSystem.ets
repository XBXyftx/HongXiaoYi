import { mediaquery } from "@kit.ArkUI"

/**
 * 定义断点名称的联合类型，规范断点命名规则
 * xs: 超小屏幕（如手机竖屏）
 * sm: 小屏幕（如手机横屏）
 * md: 中等屏幕（如平板）
 * lg: 大屏幕（如PC）
 */
export type BreakpointType = 'xs' | 'sm' | 'md' | 'lg' | 'xl' | 'xxl'

/**
 * 断点配置接口，描述每个断点的特征
 * @property name 断点名称，对应BreakpointType
 * @property size 断点触发的最小宽度（单位：vp）
 * @property mediaQueryListener 媒体查询监听器实例
 */
export interface Breakpoint {
  /**name 断点名称，对应BreakpointType*/
  name: BreakpointType
  /**size 断点触发的最小宽度（单位：vp）*/
  size: number
  /**mediaQueryListener 媒体查询监听器实例*/
  mediaQueryListener?: mediaquery.MediaQueryListener
}