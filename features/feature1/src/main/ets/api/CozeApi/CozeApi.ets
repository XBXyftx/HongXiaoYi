import {
  HistoryMessages_Role,
  ICoZePostBody,
  CozeHistoryMessagesItem,
  IHXYConversationMessage_DeltaData,
  ViewMessageModel,
  HistoryMessageList,
  typeStringBuffer
} from "../../modules";
import { AppStorageV2, promptAction } from "@kit.ArkUI";
import { rcp } from "@kit.RemoteCommunicationKit";
import { util } from "@kit.ArkTS";
import { BusinessError } from "@kit.BasicServicesKit";
import { logger } from 'common'
import { MESSAGE_LIST, MSG, CONTENT_TYPE_STRING, STRING_BUFFER_ZONE } from '../../constants/index'


/**
 * 当前正在进行接收的信息对象
 */
const currentMsg: ViewMessageModel = AppStorageV2.connect(ViewMessageModel, MSG, () => new ViewMessageModel())!;
/**
 * 当前需要发送给AI的聊天记录
 */
const historyMessageList: HistoryMessageList =
  AppStorageV2.connect(HistoryMessageList, MESSAGE_LIST, () => new HistoryMessageList())!
// let bufferZone = AppStorageV2.connect(String,STRING_BUFFER_ZONE,()=>'')!

const ON_DATA_RECEIVE = 'onDataReceive:  ';
const sessionConfig: rcp.SessionConfiguration = {
  headers: {
    Authorization: "Bearer pat_n4dspAiKcFus7k7zaW9OC5fzGqlXuJWu4E6PWyTajDBvqUfkhzpOVUljUKL6CPv7",
    "Content-Type": "application/json"
  },
  requestConfiguration: {
    transfer: {
      timeout: {
        transferMs: 1200000
      }
    },
    tracing: {
      httpEventsHandler: {
        onDataReceive: (inComingData: ArrayBuffer) => {
          currentMsg.hasEnd = false
          const bufferFrom: Uint8Array = new Uint8Array(inComingData);
          const s = new util.TextDecoder().decodeToString(bufferFrom);
          logger.info('onDataReceive原始数据：  ' + s)
          try {
            typeStringBuffer.rcpEnd = false
            let secondIsCompleted: boolean = false
            if (s.includes('conversation.message.delta')) {
              s.split('data: ').forEach((item: string, index) => {
                if (index === 1) {
                  const data = item.split('event: ')[0]
                  const secondEvent = item.split('event: ')[1]
                  if (secondEvent.includes('message.completed')) {
                    secondIsCompleted = true
                    logger.warn('onDataReceive 第二个事件为completed')
                  }
                  logger.info('____________________________')
                  logger.info('读取到的data： ' + data)
                  const message_data = JSON.parse(data) as IHXYConversationMessage_DeltaData
                  const dataWaitToAdd = message_data.content.replace('null', '')
                  logger.info('onDataReceive 向字符缓冲区写入： ' + dataWaitToAdd)
                  typeStringBuffer.strAdd(dataWaitToAdd)
                  typeStringBuffer.start()
                  logger.info('msgModel.hasEnd= ' + currentMsg.hasEnd)
                  logger.info('____________________________')
                } else if (index === 2 && !secondIsCompleted) {
                  const data = item
                  logger.info('____________________________')
                  logger.info('读取到的data： ' + data)
                  const message_data = JSON.parse(data) as IHXYConversationMessage_DeltaData
                  logger.info('onDataReceive 向字符缓冲区写入： ' + message_data.content)
                  const dataWaitToAdd = message_data.content.replace('null', '')
                  typeStringBuffer.strAdd(dataWaitToAdd)
                  logger.info('msgModel.hasEnd= ' + currentMsg.hasEnd)
                  logger.info('____________________________')
                }
              })
            }
          } catch (err) {
            logger.error(ON_DATA_RECEIVE + 'onDataReceive捕获异常: ' + err)
          }

        }
      }
    }
  }
}
const date = `${Date.now()}${Math.floor(Math.random() * 1000)}`

export function requestCozeAi() {
  const ai: ICoZePostBody = {
    workflow_id: '7487986803871760399',
    additional_messages: historyMessageList.getList(),
    parameters: new Map<string, string>([['CONVERSATION_NAME', 'HXY' + date]])
  }
  promptAction.showToast({
    message: '发送请求成功'
  })
  console.log('进入requestAi')
  const session = rcp.createSession(sessionConfig)
  session.post('https://api.coze.cn/v1/workflows/chat', ai)
    .catch((err: BusinessError) => {
      logger.error(err.message)
    })
    .finally(() => {
      typeStringBuffer.rcpEnd = true
      logger.warn('requestCozeAi:  ' + '当前对话流式传输结束，开始进行对话历史写入')
      const message = new CozeHistoryMessagesItem(HistoryMessages_Role.Assistant)
      message.content_type = CONTENT_TYPE_STRING
      message.content = currentMsg.content!
      historyMessageList.addMessage(message)
      logger.warn('requestCozeAi:  ' + '历史添加完毕')
      // // currentMsg.hasEnd = true
      // logger.info('requestCozeAi:  ' + '数据传输已完成')
      session.close()
      logger.warn('requestCozeAi:  ' + 'session已关闭')
    })
}