import { ConfigurationConstant } from '@kit.AbilityKit';
@ObservedV2
class Env {
  /**
   * 语言模式
   */
  @Trace language: string | undefined;
  /**
   * 颜色模式，0是深色模式，1是浅色模式
   */
  @Trace colorMode: ConfigurationConstant.ColorMode | undefined;
}
/**
 * 当前系统环境参数对象
 */
export let env: Env = new Env();