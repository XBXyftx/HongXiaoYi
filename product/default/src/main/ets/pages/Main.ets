import { animateParam, BreakpointState, env, Env, logger, NavDests, NAV_PATH_STUCK } from 'common'
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
  @Local removeId:string=''
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

  // aboutToAppear(): void {logg
  //   this.navPathStuck.pushPath({name:NavDests.CHAT})
  // }


  build() {
    Column() {
      Navigation(this.navPathStuck) {
        Chat()
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
      direction: GradientDirection.LeftBottom,
      colors: [[$r('app.color.total_main_linearGradient_0'), 0],
        [$r('app.color.total_main_linearGradient_0point5'), 0.7]]
    })
  }
}