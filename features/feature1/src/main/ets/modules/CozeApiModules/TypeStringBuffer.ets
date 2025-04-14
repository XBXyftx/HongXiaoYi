import { logger } from 'common'
import { ViewMessageModel } from '..';
import { AppStorageV2 } from '@kit.ArkUI';
import { MSG } from '../../constants';

@ObservedV2
  /**
   * 打字机效果的数据接收缓冲区
   */
class TypeStringBuffer {
  /**
   * 启动标识符
   */
  @Trace private startSign: boolean = false
  /**
   * 待输出字符串数组
   */
  @Trace private charArray: string[] = []
  currentMsg: ViewMessageModel = AppStorageV2.connect(ViewMessageModel, MSG, () => new ViewMessageModel())!;

  strAdd(addStr: string) {
    if (addStr === '') {
      logger.warn('StringBuffer.strAdd:  ' + 'str为空')
      return
    }
    logger.warn('StringBuffer.strAdd:  '+'addstr='+addStr)
    for (let i=0;i<addStr.length;i++) {
      this.charArray.push(addStr.charAt(i));
    }
    logger.warn('StringBuffer.strAdd:  ' + 'charArray=' + this.charArray.join(''));
  }

  start() {
    if (this.startSign) {
      logger.warn('StringBuffer.start:  '+'已经在执行')
    }else {
      this.startSign = true;
      setTimeout(() => {
        const id = setInterval(() => {
          if (this.charArray.length > 0) {
            const currentChar = this.charArray.shift()!; // 取出并删除第一个字符
            logger.warn('StringBuffer.start:  '+'currentChar='+currentChar)
            this.currentMsg.content += currentChar;
            logger.warn('StringBuffer.start:  ' + '输出字符=' + currentChar);
          } else {
            clearInterval(id);
            this.startSign = false;
            logger.warn('StringBuffer.start:  ' + '所有字符已输出');
            this.currentMsg.hasEnd=true
          }
        }, 20);
      }, 1000);
    }
  }
}

export const typeStringBuffer: TypeStringBuffer = new TypeStringBuffer()