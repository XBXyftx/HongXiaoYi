import { logger, WELCOME_WORD } from 'common'
import { typeStringBuffer, ViewMessageModel } from '../../modules'
import { AppStorageV2 } from '@kit.ArkUI'
import { MSG } from '../../constants'

const WELCOME_API_LOG_TAG = 'WelcomeApi:  '
@ObservedV2
export class WelcomeApi{
  /**
   * 随机获取欢迎词并进行打字机输出
   */
  public static welcome (){
    const currentWelcomeWord :string =WELCOME_WORD[Math.floor(Math.random() * WELCOME_WORD.length)]
    logger.warn(WELCOME_API_LOG_TAG+currentWelcomeWord)
    typeStringBuffer.strAdd(currentWelcomeWord)
    AppStorageV2.connect(ViewMessageModel, MSG, () => new ViewMessageModel())!.hasEnd=false
    AppStorageV2.connect(ViewMessageModel, MSG, () => new ViewMessageModel())!.type=0
    AppStorageV2.connect(ViewMessageModel, MSG, () => new ViewMessageModel())!.currentIndex=0
    typeStringBuffer.start()
  }
}