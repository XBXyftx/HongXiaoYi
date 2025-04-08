import { BreakpointState } from 'common'
import { ViewMessageModel } from 'feature1/src/main/ets/modules/CozeApiModules/CozeApiModule'

@Entry
@ComponentV2
struct Index {
  /**
   * 渲染数组
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

  build() {
    Navigation() {

    }
    .expandSafeArea()
    .linearGradient({
      direction:GradientDirection.Bottom,
      colors:[[$r('app.color.total_main_linearGradient_0'),0],[$r('app.color.total_main_linearGradient_0point5'),0.5]]
    })
    .hideNavBar(true)
    .hideTitleBar(true)
    .height('100%')
    .width('100%')
  }
}