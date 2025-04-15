import { logger, WELCOME_WORD } from 'common'
import { typeStringBuffer } from '../../modules'
const WELCOME_API_LOG_TAG = 'WelcomeApi:  '
@ObservedV2
export class WelcomeApi{
  public static welcome (){
    const currentWelcomeWord :string =WELCOME_WORD[Math.floor(Math.random() * WELCOME_WORD.length)]
    logger.warn(WELCOME_API_LOG_TAG+currentWelcomeWord)
    typeStringBuffer.strAdd(currentWelcomeWord)
    typeStringBuffer.start()
  }
}