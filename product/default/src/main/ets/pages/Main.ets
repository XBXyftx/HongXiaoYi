import { BreakpointState, env, Env, logger, NavDests, NAV_PATH_STUCK } from 'common'
import { ViewMessageModel } from 'feature1/src/main/ets/modules/CozeApiModules/CozeApiModule'
import { AppStorageV2 } from '@kit.ArkUI'

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
    if (name===NavDests.MAIN){
      Main()
    }
  }

  build() {
    Navigation(this.navPathStuck) {
      GridRow(){
        GridCol({span:{sm:12,md:10,lg:8},offset:{sm:0,md:1,lg:2}}){
          Column() {
            Image($rawfile('logo.png'))
            Text('深浅色模式测试')
              .fontSize(30)
              .fontColor($r('app.color.test_fontcolor'))
              .backgroundColor('#003b2222')
          }
          .justifyContent(FlexAlign.Center)
          .width('100%')
          .height('100%')
        }

      }
      .width('100%')
      .height('100%')


    }
    .navDestination(this.NavDestMap)
    .linearGradient({
      direction: GradientDirection.Bottom,
      colors: [[$r('app.color.total_main_linearGradient_0'), 0],
        [$r('app.color.total_main_linearGradient_0point5'), 0.5]]
    })
    .hideTitleBar(true)
    .hideToolBar(true)
    .height('100%')
    .width('100%')
  }
}