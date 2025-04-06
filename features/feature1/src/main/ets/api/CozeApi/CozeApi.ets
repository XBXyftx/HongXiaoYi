import {
  AdditionalMessages_Role,
  ICoZePostBody,
  IHXYCozeMessagesItem,
  IHXYConversationMessage_DeltaData,
  MessageModel
} from "../../modules";
import { AppStorageV2, promptAction } from "@kit.ArkUI";
import { rcp } from "@kit.RemoteCommunicationKit";
import { util } from "@kit.ArkTS";
import { BusinessError } from "@kit.BasicServicesKit";
import { logger } from 'common'
import { MSG } from '../../constants/index'


/**
 * 当前正在进行接收的信息对象
 */
const CurrentMsg: MessageModel = AppStorageV2.connect(MessageModel, MSG, () => new MessageModel())!;


const sessionConfig: rcp.SessionConfiguration = {
  headers: {
    Authorization: "Bearer pat_iuGVoKCI6tgDJal7l7GFqJGCMLPkpXrcYaYBwc2icILL0gRLmAJ07xegxb1ZG0cN",
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
          CurrentMsg.hasEnd = false
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
                CurrentMsg.content += message_data.content
                logger.info('msgModel.hasEnd= ' + CurrentMsg.hasEnd)
                logger.info('____________________________')
                }else if (index === 2){
                  const data = item
                  logger.info('____________________________')
                  logger.info('读取到的data： ' + data)
                  const message_data = JSON.parse(data) as IHXYConversationMessage_DeltaData
                  logger.info('onDataReceive写入： ' + message_data.content)
                  CurrentMsg.content += message_data.content
                  logger.info('msgModel.hasEnd= ' + CurrentMsg.hasEnd)
                  logger.info('____________________________')
                }
              })

            } else if (s.includes('done')) {
              CurrentMsg.hasEnd = true
            }
          } catch (err) {
            logger.error('onDataReceive捕获异常: ' + err)
          }

        }
      }
    }
  }
}


export function requestCozeAi() {
  const ai: ICoZePostBody = {
    workflow_id: '7487986803871760399',
    additional_messages: [
      {
        role: AdditionalMessages_Role.User,
        content: '鸿蒙的一多能力是什么',
        content_type: 'string'
      } as IHXYCozeMessagesItem
    ],
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