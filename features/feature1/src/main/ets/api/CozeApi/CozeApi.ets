import {
  HistoryMessages_Role,
  ICoZePostBody,
  CozeHistoryMessagesItem,
  IHXYConversationMessage_DeltaData,
  ViewMessageModel,
  HistoryMessageList
} from "../../modules";
import { AppStorageV2, promptAction } from "@kit.ArkUI";
import { rcp } from "@kit.RemoteCommunicationKit";
import { util } from "@kit.ArkTS";
import { BusinessError } from "@kit.BasicServicesKit";
import { logger } from 'common'
import { MESSAGE_LIST, MSG, STRING } from '../../constants/index'


/**
 * 当前正在进行接收的信息对象
 */
const currentMsg: ViewMessageModel = AppStorageV2.connect(ViewMessageModel, MSG, () => new ViewMessageModel())!;
/**
 * 当前需要发送给AI的聊天记录
 */
const historyMessageList: HistoryMessageList = AppStorageV2.connect(HistoryMessageList, MESSAGE_LIST,()=>new HistoryMessageList())!


const ON_DATA_RECEIVE = 'onDataReceive:  ';
const sessionConfig: rcp.SessionConfiguration = {
  headers: {
    Authorization: "Bearer pat_iuGVoKCI6tgDJal7l7GFqJGCMLPkpXrcYaYBwc2icILL0gRLmAJ07xegxb1ZG0cN",
    "Content-Type": "application/json"
  },
  requestConfiguration: {
    transfer: {
      timeout: {
        transferMs: 12000
      }
    },
    tracing: {
      httpEventsHandler: {
        onDataReceive: (inComingData: ArrayBuffer) => {
          currentMsg.hasEnd = false
          const bufferFrom: Uint8Array = new Uint8Array(inComingData);
          const s = new util.TextDecoder().decodeToString(bufferFrom);
          console.log('onDataReceive原始数据：  ' + s)
          try {
            if (s.includes('conversation.message.delta')) {
              s.split('data: ').forEach((item: string, index) => {
                if (index === 1) {
                const data = item.split('event: ')[0]
                logger.info('____________________________')
                logger.info('读取到的data： ' + data)
                const message_data = JSON.parse(data) as IHXYConversationMessage_DeltaData
                logger.info('onDataReceive写入： ' + message_data.content)
                currentMsg.content += message_data.content
                logger.info('msgModel.hasEnd= ' + currentMsg.hasEnd)
                logger.info('____________________________')
                }else if (index === 2){
                  const data = item
                  logger.info('____________________________')
                  logger.info('读取到的data： ' + data)
                  const message_data = JSON.parse(data) as IHXYConversationMessage_DeltaData
                  logger.info('onDataReceive写入： ' + message_data.content)
                  currentMsg.content += message_data.content
                  logger.info('msgModel.hasEnd= ' + currentMsg.hasEnd)
                  logger.info('____________________________')
                }
              })
            } else if (s.includes('done')) {
              logger.warn(ON_DATA_RECEIVE+ '当前对话流式传输结束，开始进行对话历史写入')
              currentMsg.hasEnd = true
              const message = new CozeHistoryMessagesItem(HistoryMessages_Role.Assistant)
              message.content_type= STRING
              message.content=currentMsg.content!
              historyMessageList.addMessage(message)
              logger.warn(ON_DATA_RECEIVE+'历史添加完毕')
            }
          } catch (err) {
            logger.error(ON_DATA_RECEIVE+ 'onDataReceive捕获异常: ' + err)
          }

        }
      }
    }
  }
}


export function requestCozeAi() {
  const ai: ICoZePostBody = {
    workflow_id: '7487986803871760399',
    additional_messages:historyMessageList.getList(),
    parameters: new Map<string, string>([['CONVERSATION_NAME', 'HXY' + Date.now()]])
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
      logger.info('requestCozeAi:  ' + '数据传输已完成')
      session.close()
      logger.warn('session已关闭')
    })
}