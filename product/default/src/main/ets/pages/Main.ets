import { BreakpointState, env, Env, logger, NavDests, NAV_PATH_STUCK } from 'common'
import { ViewMessageModel } from 'feature1/src/main/ets/modules/CozeApiModules/CozeApiModule'
import { AppStorageV2 } from '@kit.ArkUI'
import { Chat } from './navDestsComponents/Chat'

@Entry
@ComponentV2
struct Main {
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
  @Local navPathStuck: NavPathStack = AppStorageV2.connect(NavPathStack, NAV_PATH_STUCK)!
  @Local env: Env = env

  @Monitor('env.colorMode')
  onColorModeChange() {
    logger.warn('onColorModeChange:  ' + '当前颜色模式编号为' + env.colorMode)
  }

  @Builder
  NavDestMap(name: string) {
    if (name === NavDests.MAIN) {
      Main()
    } else if (name === NavDests.CHAT) {
      Chat()
    }
  }

  onPageShow(): void {
    setTimeout(() => {
      this.navPathStuck.pushPath({ name: NavDests.CHAT })
    }, 2000)
  }

  build() {
    Column() {
      Navigation(this.navPathStuck) {
        GridRow() {
          GridCol({ span: { sm: 12, md: 10, lg: 8 }, offset: { sm: 0, md: 1, lg: 2 } }) {
            Column() {
              Image($rawfile('logo.jpg'))
                .width(100)
                .borderRadius(25)
              Text('鸿小易')
                .fontSize(50)
                .fontColor($r('app.color.start_fontcolor'))
              Row({ space: 20 }) {
                Text('鸿蒙开发智能体')
                  .fontSize(25)
                  .width(30)
                  .fontColor($r('app.color.start_fontcolor'))
                  .margin({ bottom: 25 })
                Text('您的开发好帮手')
                  .fontSize(25)
                  .width(30)
                  .fontColor($r('app.color.start_fontcolor'))
                  .margin({ top: 25 })
              }
            }
            .justifyContent(FlexAlign.SpaceEvenly)
            .padding({ top: '20%', bottom: '10%' })
            .width('100%')
            .height('100%')
          }

        }
        .width('100%')
        .height('100%')

      }
      .backgroundColor(Color.Transparent)
      .padding(10)
      .navDestination(this.NavDestMap)
      .hideTitleBar(true)
      .hideToolBar(true)
      .height('100%')
      .width('100%')
      .hideBackButton(true)
      .titleMode(NavigationTitleMode.Mini)
      .mode(NavigationMode.Stack)
    }
    .expandSafeArea()
    .linearGradient({
      direction: GradientDirection.Bottom,
      colors: [[$r('app.color.total_main_linearGradient_0'), 0],
        [$r('app.color.total_main_linearGradient_0point5'), 0.5]]
    })
  }
}