import { BreakpointState, env, Env, logger } from 'common'
import { ViewMessageModel } from 'feature1/src/main/ets/modules/CozeApiModules/CozeApiModule'

@Entry
@ComponentV2
struct Index {
  /**
   * 渲染对话列表数组
   */
  @Local viewMessageList: ViewMessageModel[] = []
  @Local breakPointState: BreakpointState<Object> = BreakpointState.of({
    xs: 'xs',
    sm: 'sm',
    xl: 'xl',
    xxl: 'xxl',
    md: 'md',
    lg: 'lg'
  })
  @Local env:Env = env
  @Monitor('env.colorMode')
  onColorModeChange(){
    logger.warn('onColorModeChange:  '+'当前颜色模式编号为'+env.colorMode)
  }

  build() {
    Navigation() {
      Column(){
        Text('深浅色模式测试')
          .fontSize(30)
          .fontColor($r('app.color.test_fontcolor'))
          .backgroundColor('#003b2222')
      }
      .justifyContent(FlexAlign.Center)
      .width('100%')
      .height('100%')

    }
    .linearGradient({
      direction:GradientDirection.Bottom,
      colors:[[$r('app.color.total_main_linearGradient_0'),0],[$r('app.color.total_main_linearGradient_0point5'),0.5]]
    })
    .hideTitleBar(true)
    .hideToolBar(true)
    .height('100%')
    .width('100%')
  }
}