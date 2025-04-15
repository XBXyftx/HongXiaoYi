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
  private startSign: boolean = false
  /**
   * 待输出字符串数组
   */
  private charArray: string[] = []
  /**
   * 当前轮次流式传输结束标识符
   */
  public rcpEnd: boolean = true
  currentMsg: ViewMessageModel = AppStorageV2.connect(ViewMessageModel, MSG, () => new ViewMessageModel())!;

  strAdd(addStr: string) {
    if (addStr === '') {
      logger.warn('StringBuffer.strAdd:  ' + 'str为空')
      return
    }
    logger.warn('StringBuffer.strAdd:  ' + 'addstr=' + addStr)
    for (let i = 0; i < addStr.length; i++) {
      this.charArray.push(addStr.charAt(i));
    }
    // logger.warn('StringBuffer.strAdd:  ' + 'charArray=' + this.charArray.join(''));
  }

  start() {
    if (this.startSign) {
      logger.warn('StringBuffer.start:  ' + '已经在执行')
    } else {
      this.startSign = true;
      setTimeout(() => {
        const id = setInterval(() => {
          if (this.charArray.length > 0) {
            const currentChar = this.charArray.shift()!; // 取出并删除第一个字符
            logger.warn('StringBuffer.start:  ' + 'currentChar=' + currentChar)
            this.currentMsg.content += currentChar;
          } else if (this.charArray.length === 0 && !this.rcpEnd) { // 当当前输出速度过快，本轮流式传输没有完成但缓冲区已经输出完成
            logger.warn('StringBuffer.start:  ' + '当前无数据但流失传输未结束')
          } else if (this.rcpEnd && this.charArray.length === 0) { // 当本轮流式传输结束并且缓冲区全部输出完成
            clearInterval(id);
            this.startSign = false;
            logger.warn('StringBuffer.start:  ' + '所有字符已输出');
            this.currentMsg.hasEnd = true
          }
        }, 10);
      }, 2000);
    }
  }
}
export const typeStringBuffer: TypeStringBuffer = new TypeStringBuffer()