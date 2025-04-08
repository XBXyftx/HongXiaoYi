import { ConfigurationConstant } from '@kit.AbilityKit';
import { logger } from '../../../../../Index';

const ENV_LOG_TAG = 'Env:  '

@ObservedV2
export class Env {
  /**
   * 语言模式
   */
  @Trace language: string | undefined;
  /**
   * 颜色模式，0是深色模式，1是浅色模式
   */
  @Trace colorMode: ConfigurationConstant.ColorMode | undefined;
  /**
   * 唯一实例
   */
  private static instance: Env | null = null;

  private constructor() {
    this.language = undefined;
    this.colorMode = undefined;
  }

  public static getInstance(): Env {
    if (!Env.instance) {
      logger.warn(ENV_LOG_TAG + '当前没有实例，已经创建唯一实例')
      Env.instance = new Env();
    }
    logger.info(ENV_LOG_TAG + '获取唯一实例')
    return Env.instance;
  }
}

/**
 * 当前系统环境参数对象
 */
export let env: Env = Env.getInstance();