import { logger } from 'common';
import { IHXYCozeMessagesItem } from '..'

const MESSAGE_LIST = 'MessageList:  '

/**
 * 扣子对话历史工具类
 */
@ObservedV2
export class MessageList {
  /**
   * 传输给扣子的对话历史
   * 数量上限为50
   */
  @Trace private List: IHXYCozeMessagesItem[] = []

  /**
   * 添加聊天记录
   * 检测数组长度防止超过30
   * @param Message 待添加对话记录对象
   */
  public addMessage(Message: IHXYCozeMessagesItem) {
    if (this.List.length >= 30) {
      logger.warn(MESSAGE_LIST + '当前数组长度超过30')
      // 如果数组长度超过30，删除数组的第一位
      this.List.shift();
    }
    logger.info(MESSAGE_LIST + '当前数组长度:  ' + this.List.length)
    // 加入新的消息
    this.List.push(Message);
  }
}