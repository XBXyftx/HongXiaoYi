import { IHXYCozeMessagesItem } from '..'

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
   * @param Message
   */
  public addMessage(Message:IHXYCozeMessagesItem){
    if (this.List.length >= 40) {

    }

  }

}