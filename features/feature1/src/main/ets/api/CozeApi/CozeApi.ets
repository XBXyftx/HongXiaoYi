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
          const lines:string[] = s.split('\n');
          let deltaDataLines:number[]=[]
          typeStringBuffer.rcpEnd = false
          try {
            lines.forEach((item:string,index:number)=>{
              if (item.includes('conversation.message.delta')) {
                deltaDataLines.push(index+1)
              }
            })
            lines.forEach((item:string,index:number)=>{
              if (deltaDataLines.includes(index)) {
                const data = item.split('data: ')[1]
                const message_data = (JSON.parse(data) as IHXYConversationMessage_DeltaData).content.replace('null', '')
                logger.info('________________________________________________________')
                logger.info('onDataReceive data='+data)
                typeStringBuffer.strAdd(message_data)
                typeStringBuffer.start()
                logger.info('onDataReceive 向字符缓冲区写入： ' + message_data)
                logger.info('________________________________________________________')
              }
            })
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
    parameters: new Map<string, string>([['CONVERSATION_NAME', 'HXY' + date]]),
    // parameters:{},
    conversation_id: 'abc'+date
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