import { logger } from ".."
import { AppStorageV2, promptAction, window } from "@kit.ArkUI"
import { AvoidArea, AVOID_AREA, CONTEXT, GetContext } from "../../modules"

/**
 * 初始化AppStorageV2中的AvoidAres键值
 * 用于存储需要规避区域的高度值
 */
const avoid_area = AppStorageV2.connect(AvoidArea, AVOID_AREA, () => new AvoidArea())!
const FULL_SCREEN_LOG_TAG = 'FullScreen:  '
class FullScreen {
  /**
   * 开启沉浸式方法
   * 依赖于当前应用的上下文对象
   */
  async enable() {
    logger.debug(FULL_SCREEN_LOG_TAG+'进入FullScreen.enable')
    try {
      const getContext = AppStorageV2.connect<GetContext>(GetContext, CONTEXT)
      if (getContext) {
        logger.info(FULL_SCREEN_LOG_TAG+'找到Context')
        //获取当前窗口
        const win = await window.getLastWindow(getContext.context)
        //设置当前窗口为沉浸式模式
        await win.setWindowLayoutFullScreen(true)

        //获取顶部区域
        const topArea = win.getWindowAvoidArea(window.AvoidAreaType.TYPE_SYSTEM).topRect
        //将顶部高度存储到AppStorage
        logger.info(FULL_SCREEN_LOG_TAG+'topAreaHeight: ' + px2vp(topArea.height))


        //获取底部区域和底部区域高度
        const bottomArea = win.getWindowAvoidArea(window.AvoidAreaType.TYPE_NAVIGATION_INDICATOR).bottomRect
        logger.info(FULL_SCREEN_LOG_TAG+'bottomAreaHeight: ' + px2vp(bottomArea.height))


        avoid_area.top = px2vp(topArea.height);
        avoid_area.bottom = px2vp(bottomArea.height)
        logger.debug(FULL_SCREEN_LOG_TAG+'avoid_area数据更新完成')

      } else {
        logger.warn(FULL_SCREEN_LOG_TAG+'未找到Context')
      }

    } catch (err) {
      logger.error(err)
      promptAction.showToast({ message: err })
    }
  }

  /**
   * 关闭沉浸式方法
   * 依赖于当前应用的上下文对象
   */
  async disable(){
    logger.debug(FULL_SCREEN_LOG_TAG+'进入FullScreen.disable')
    try {
      const context = AppStorageV2.connect<GetContext>(GetContext, CONTEXT)
      if (context) {
        logger.info(FULL_SCREEN_LOG_TAG+'找到Context')
        //获取当前窗口
        const win = await window.getLastWindow(context.context)
        //设置当前窗口为沉浸式模式
        await win.setWindowLayoutFullScreen(false)

        avoid_area.top = 0
        avoid_area.bottom = 0
        logger.debug(FULL_SCREEN_LOG_TAG+'avoid_area数据更新完成')

      } else {
        logger.warn(FULL_SCREEN_LOG_TAG+'未找到Context')
      }

    } catch (err) {
      logger.error(err)
      promptAction.showToast({ message: err })
    }
  }
}

export const fullScreen = new FullScreen()