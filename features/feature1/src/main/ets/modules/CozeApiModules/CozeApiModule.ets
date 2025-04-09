export interface ICoZePostBody<K = string, V = string> {
  /**
   * 待执行的对话流 ID，此对话流应已发布。
   */
  workflow_id: string
  /**
   * 对话中用户问题和历史消息。数组长度限制为 50，即最多传入 50 条消息。
   * 你需要通过此字段传入本次对话中用户的问题，也就是对话流的输入参数 USER_INPUT 的值。
   * 可以同时传入多条历史消息，也就是本次对话的上下文。多条消息应按对话顺序排列，最后一条消息应为 role=user 的记录，也就是**本次对话**中用户的问题；其他消息为历史消息。
   */
  additional_messages: CozeHistoryMessagesItem[]
  /**
   * 设置对话流的输入参数。
   * 对话流的输入参数  USER_INPUT 应在 additional_messages 中传入，在 parameters 中的 USER_INPUT 不生效。
   * 如果 parameters 中未指定 CONVERSATION_NAME 或其他输入参数，则使用参数默认值运行对话流；如果指定了这些参数，则使用指定值。
   */
  parameters: Map<K, V>
  /**
   * 需要关联的扣子应用 ID。调用对话流时，必须指定 app_id 或 bot_id，便于模型调用智能体或应用的数据库、变量等数据处理问题。
   */
  app_id?: string
  /**
   * 需要关联的智能体 ID。 调用对话流时，必须指定 app_id 或 bot_id，便于模型调用智能体或应用的数据库、变量等数据处理问题。
   */
  bot_id?: string
  /**
   * 对话流对应的会话 ID，对话流产生的消息会保存到此对话中。会话默认为开始节点设置的 CONVERSATION_NAME，也可以通过 conversation_id 参数指定会话。
   */
  conversation_id?: string
  /**
   * 用于指定一些额外的字段，以 Map[String][String] 格式传入。例如某些插件会隐式用到的经纬度等字段。
   目前仅支持以下字段：
   latitude：String 类型，表示经度。
   longitude：String 类型，表示纬度。
   user_id：String 类型，表示用户 ID。
   */
  ext?: Map<CoZePostBody_ExtKeys, string>
}

/**
 * 扣子流式接口Body部分字段map的键值枚举类型
 */
export enum CoZePostBody_ExtKeys {
  /**
   * latitude：String 类型，表示经度。
   */
  Latitude = 'latitude',
  /**
   * longitude：String 类型，表示纬度。
   */
  Longitude = 'longitude',
  /**
   * user_id：String 类型，表示用户 ID。
   */
  User_id = 'user_id'
}

/**
 * 对话中用户问题和历史消息。
 * 指定 content 时，应同时设置 content_type。
 * 暂不支持多模态（文本、图片、文件混合输入）、卡片等类型的内容。
 * 设置meta_data时应当设置两个泛型参数
 */
export class CozeHistoryMessagesItem<K = undefined, V = undefined> {
  /**
   * 发送这条消息的实体。
   */
  role: HistoryMessages_Role
  /**
   * 消息类型。默认为 question。
   */
  type?: HistoryMessages_Type
  /**
   * 消息的内容，仅支持纯文本。
   */
  content?: string
  /**
   * 消息内容的类型。
   */
  content_type?: string
  /**
   * 创建消息时的附加消息，获取消息时也会返回此附加消息。
   * 自定义键值对，应指定为 Map 对象格式。长度为 16 对键值对，其中键（key）的长度范围为 1～64 个字符，值（value）的长度范围为 1～512 个字符。
   */
  meta_data?: Map<K, V>

  constructor(role: HistoryMessages_Role) {
    this.role = role
  }

  public clone(): CozeHistoryMessagesItem<K, V> {
    const newItem = new CozeHistoryMessagesItem<K, V>(this.role);

    if (this.type !== undefined) {
      newItem.type = this.type;
    }

    if (this.content !== undefined) {
      newItem.content = this.content;
    }

    if (this.content_type !== undefined) {
      newItem.content_type = this.content_type;
    }

    if (this.meta_data !== undefined) {
      newItem.meta_data = new Map(this.meta_data.entries());
    }

    return newItem;
  }
}

/**
 * user：代表该条消息内容是用户发送的。
 * assistant：代表该条消息内容是模型发送的。
 */
export enum HistoryMessages_Role {
  User = 'user',
  Assistant = 'assistant'
}

/**
 * question：用户输入内容。
 * answer：模型返回给用户的消息内容，支持增量返回。如果对话流绑定了消息节点，可能会存在多 answer 场景，此时可以用流式返回的结束标志来判断所有 answer 完成。
 * function_call：智能体对话过程中调用函数（function call）的中间结果。
 * tool_response：调用工具 （function call）后返回的结果。
 */
export enum HistoryMessages_Type {
  Question = 'question',
  Answer = 'answer',
  Function_call = 'function_call',
  Tool_response = 'tool_response'
}

/**
 * 对话渲染数据模型
 */
@ObservedV2
export class ViewMessageModel {
  /**
   * 人类是1Ai是0
   */
  type: number | null = null;
  @Trace hasEnd: boolean = true;
  @Trace content: string | null = null;
  @Trace currentIndex?: number;
}

export interface IHXYConversationMessage_DeltaData {
  "id": string;
  "conversation_id": string;
  "role": string;
  "type": string;
  "content": string;
  "content_type": string;
  "chat_id": string;
  "section_id": string;
}

// export interface IHXYConversationMessage_Event {
//   event: string;
//   data: IHXYConversationMessage_DeltaData;
// }