import { BreakpointType } from "./BreakPointSystem"

/**
 * 断点响应式状态配置接口（泛型）
 * 允许为不同断点设置不同的状态值
 */
export interface BreakpointOptions<T> {
  xs?: T    // 超小屏配置
  sm?: T    // 小屏配置
  md?: T    // 中屏配置
  lg?: T    // 大屏配置
  xl?: T    // 扩展配置
  xxl?: T   // 扩展配置
}

/**
 * 断点状态管理类（观察者模式）
 * 根据当前断点类型切换对应配置值
 */
@ObservedV2
export class BreakpointState<T extends Object> {
  /** 当前生效的状态值*/
  @Trace private value: T | undefined = undefined
  /** 配置存储*/
  private options: BreakpointOptions<T>

  constructor(options: BreakpointOptions<T>) {
    this.options = options
  }

  /**
   * 工厂方法创建实例
   * 创建一个断点监听器
   * @param options 当前组件不同断点状态数据
   */
  static of<T extends Object>(options: BreakpointOptions<T>): BreakpointState<T> {
    return new BreakpointState(options)
  }

  /**
   * 获取当前的断点状态
   * @returns 断点状态简写字符串
   */
  public getCurrentBreakPointType(){
    return this.value?.toString()
  }

  /** 根据断点类型更新状态值 */
  public update(type: BreakpointType): void {
    // 通过条件判断选择对应配置[1](@ref)
    if (type === 'xs') {
      this.value = this.options.xs
    } else if (type === 'sm') {
      this.value = this.options.sm
    } else if (type === 'md') {
      this.value = this.options.md
    } else if (type === 'lg') {
      this.value = this.options.lg
    } else if (type === 'xl') {
      this.value = this.options.xl
    } else if (type === 'xxl') {
      this.value = this.options.xxl
    } else {
      this.value = undefined  // 未知类型重置状态
    }
  }
}