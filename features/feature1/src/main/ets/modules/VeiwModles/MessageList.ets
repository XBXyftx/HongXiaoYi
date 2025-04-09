import { logger } from 'common';
import { CozeHistoryMessagesItem } from '..'

const MESSAGE_LIST = 'MessageList:  '

/**
 * 扣子对话历史工具类
 */
@ObservedV2
export class HistoryMessageList {
  /**
   * 传输给扣子的对话历史
   * 数量上限为50
   */
  @Trace private list: CozeHistoryMessagesItem[] = []

  /**
   * 添加聊天记录
   * 检测数组长度防止超过30
   * @param Message 待添加对话记录对象
   */
  public addMessage(Message: CozeHistoryMessagesItem) {
    if (this.list.length >= 30) {
      logger.warn(MESSAGE_LIST + '当前数组长度超过30')
      // 如果数组长度超过30，删除数组的第一位
      this.list.shift();
    }
    // 加入新的消息
    this.list.push(Message);
    logger.info(MESSAGE_LIST + '当前数组长度:  ' + this.list.length)
    logger.info(MESSAGE_LIST + '添加成功')
    this.list.forEach((item:CozeHistoryMessagesItem)=>[
      logger.info(JSON.stringify(item))
    ])
  }

  public clone() {
    const newList = this.list.map(item => item.clone())
    logger.debug(MESSAGE_LIST + 'list:  ' + this.list.toString())
    logger.debug(MESSAGE_LIST + 'newList:  ' + newList.toString())
    return newList
  }

  public getList(): CozeHistoryMessagesItem<undefined, undefined>[] {
    // return this.clone()
    return this.list
  }
}