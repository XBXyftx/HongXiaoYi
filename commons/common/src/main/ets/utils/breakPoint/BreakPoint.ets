import { Breakpoint, BreakpointType } from "../../modules/breakPoint/BreakPointSystem"
import { AppStorageV2, mediaquery } from "@kit.ArkUI"
import { BreakpointState } from "../../modules/breakPoint/BreakpointState"
import { logger } from ".."

const BREAK_POINT_SYSTEM_LOG_TAG = 'BreakpointSystem:  '
/**
 * 断点系统核心类（单例模式）
 * 负责管理设备断点状态及监听逻辑
 */
export class BreakpointSystem {
  // 单例实例引用，确保全局唯一性[1](@ref)
  private static instance: BreakpointSystem

  /** 预定义断点范围配置（可扩展）*/
  private readonly breakpoints: Breakpoint[] = [
    { name: 'xs', size: 0 },     // 0vp <= width < 320vp
    { name: 'sm', size: 320 },   // 320vp <= width < 600vp
    { name: 'md', size: 600 },   // 600vp <= width < 840vp
    { name: 'lg', size: 840 }    // 840vp <= width
  ]

  /** 使用Set存储状态观察者（自动去重）[1](@ref)*/
  private _states: Set<BreakpointState<Object>>

  public get states(): Set<BreakpointState<Object>> {
    return this._states
  }

  // 私有构造器（单例模式）
  private constructor() {
    this._states = new Set()  // 初始化观察者集合
  }

  /** 获取单例实例 */
  public static getInstance(): BreakpointSystem {
    if (!BreakpointSystem.instance) {
      BreakpointSystem.instance = new BreakpointSystem()
    }
    return BreakpointSystem.instance
  }

  /** 注册状态观察者 */
  public attach(state: BreakpointState<Object>): void {
    this._states.add(state)  // 添加新观察者到集合
  }

  /** 注销状态观察者 */
  public detach(state: BreakpointState<Object>): void {
    this._states.delete(state)  // 从集合中移除观察者
  }

  /** 启动断点监听系统 */
  public start() {
    this.breakpoints.forEach((breakpoint: Breakpoint, index) => {
      /**
       * 查询条件
       */
      let condition: string
      // 动态生成媒体查询条件：
      if (index === this.breakpoints.length - 1) {
        // 最后一个断点使用 >= 条件
        condition = `(${breakpoint.size}vp<=width)`
      } else {
        // 中间断点使用区间条件
        condition = `(${breakpoint.size}vp<=width<${this.breakpoints[index + 1].size}vp)`
      }

      // 创建媒体查询监听器[1](@ref)
      breakpoint.mediaQueryListener = mediaquery.matchMediaSync(condition)

      // 初始化匹配状态检查
      if (breakpoint.mediaQueryListener.matches) {
        this.updateAllState(breakpoint.name)
      }

      // 注册尺寸变化监听回调
      breakpoint.mediaQueryListener.on('change', (mediaQueryResult) => {
        if (mediaQueryResult.matches) {
          this.updateAllState(breakpoint.name)  // 触发状态更新
        }
      })
      logger.info(BREAK_POINT_SYSTEM_LOG_TAG+`第${index}个断点状态对象启动完成`)
    })
  }

  /** 更新所有观察者状态 */
  private updateAllState(type: BreakpointType): void {
    this._states.forEach(state => state.update(type))  // 遍历执行更新
    logger.info(BREAK_POINT_SYSTEM_LOG_TAG+'全部断点状态更新完成')
  }

  /** 停止监听并清理资源 */
  public stop() {
    this.breakpoints.forEach(breakpoint => {
      if (breakpoint.mediaQueryListener) {
        breakpoint.mediaQueryListener.off('change')  // 注销监听器
      }
    })
    this._states.clear()  // 清空观察者集合
    logger.info(BREAK_POINT_SYSTEM_LOG_TAG+'断点状态对象全部关闭')
  }
}

/**
 * 获取当前设备断点系统的包装类
 * 调用getBreakPointSystem获取当前断点系统
 */
export class GetBreakPointSystem{
  private breakPointSystem:BreakpointSystem=BreakpointSystem.getInstance()
  /**
   * 获取当前断点系统
   * @returns 当前断点系统
   */
  getBreakPointSystem(){
    return this.breakPointSystem
  }
}
export const GET_BREAK_POINT_SYSTEM='getBreakpointSystem'
