import { BreakpointState, logger, NAV_PATH_STUCK, } from "common"
import {
  CONTENT_TYPE_STRING,
  CozeHistoryMessagesItem,
  HistoryMessageList,
  HistoryMessages_Role,
  MESSAGE_LIST,
  MSG,
  requestCozeAi,
  ViewMessageModel,
  WelcomeApi
} from "feature1"
import { AppStorageV2 } from "@kit.ArkUI"
import { ToolBarComp } from "../../comp/ToolBarComp"
import { ContentComp } from "../../comp/ContentComp"

@ComponentV2
export struct Chat {
  /**
   * 渲染对话列表数组
   * 初始化欢迎语空对象
   */
  @Local viewMessageList: ViewMessageModel[] = [{ content: '', type: 0, hasEnd: true }]
  @Local breakPointState: BreakpointState<Object> = BreakpointState.of({
    xs: 'xs',
    sm: 'sm',
    xl: 'xl',
    xxl: 'xxl',
    md: 'md',
    lg: 'lg'
  })
  @Local navPathStuck: NavPathStack = AppStorageV2.connect(NavPathStack, NAV_PATH_STUCK)!
  @Local currentMsg: ViewMessageModel = AppStorageV2.connect(ViewMessageModel, MSG, () => new ViewMessageModel())!
  @Local historyMsgs: HistoryMessageList =
    AppStorageV2.connect(HistoryMessageList, MESSAGE_LIST, () => new HistoryMessageList())!

  @Monitor ('currentMsg.hasEnd')
  onContentEnd(): void {
    if (this.currentMsg.hasEnd) {
      this.viewMessageList.pop();
      this.viewMessageList.push({ content: this.currentMsg.content!.replace('null', ''), type: 0, hasEnd: true });
      this.currentMsg.content = '';
    }
  }


  build() {
    NavDestination() {
      GridRow() {
        GridCol({ span: { sm: 12, md: 10, lg: 8 }, offset: { sm: 0, md: 1, lg: 2 } }) {
          Column() {
            ContentComp({
              messages: this.viewMessageList,
              content: this.currentMsg.content!,
              hasEnd: this.currentMsg.hasEnd,
              currentIndex: this.currentMsg.currentIndex
            })
              .layoutWeight(1)
            ToolBarComp({
              submit: (content: string) => {
                this.viewMessageList.push({ content: content, type: 1, hasEnd: true });
                this.viewMessageList.push({ content: '', type: 0, hasEnd: true });
                const history: CozeHistoryMessagesItem = new CozeHistoryMessagesItem(HistoryMessages_Role.User)
                history.content_type = CONTENT_TYPE_STRING
                history.content = content
                this.historyMsgs.addMessage(history)
                logger.info('Chat:  ' + 'addMessage成功' + content)
                this.currentMsg.currentIndex = this.viewMessageList.length - 1;
                this.currentMsg.hasEnd = false;
                requestCozeAi()
              },
              hasEnd:this.currentMsg.hasEnd
            })
          }
          .width('100%')
          .height('100%')
        }
        .width('100%')
        .height('100%')
      }
      .width('100%')
      .height('100%')

    }
    .onReady(()=>{
      WelcomeApi.welcome()
    })
    .hideTitleBar(true)
    .title('鸿小易')
    .backgroundColor(Color.Transparent)
    .width('100%')
    .height('100%')
  }
}