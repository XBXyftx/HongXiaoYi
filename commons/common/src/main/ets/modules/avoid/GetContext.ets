import { Context } from '@kit.AbilityKit'

/**
 * 上下文对象包装类
 * 用于在AppStorageV2中存储上下文对象
 */
@ObservedV2
export class GetContext{
  @Trace context:Context

  constructor(context: Context) {
    this.context = context
  }

}