import { animateParam } from 'common'
import { router } from '@kit.ArkUI'


@Entry
@ComponentV2
struct StartPage {
  onPageShow(): void {
    setTimeout(()=>{
      router.replaceUrl({url:"pages/Main"})
    },2000)
  }
  build() {
    GridRow() {
      GridCol({ span: { sm: 12, md: 10, lg: 8 }, offset: { sm: 0, md: 1, lg: 2 } }) {
        Column() {
          Image($rawfile('logo.jpg'))
            .width(100)
            .borderRadius(25)
            .transition(TransitionEffect.OPACITY
              .animation(animateParam)
              .combine(TransitionEffect.translate({ y: 200 })))
          Text('鸿小易')
            .fontSize(50)
            .fontColor($r('app.color.start_fontcolor'))
            .transition(TransitionEffect.OPACITY
              .animation(animateParam)
              .combine(TransitionEffect.translate({ y: 200 })))
          Row({ space: 20 }) {
            Text('鸿蒙开发智能体')
              .fontSize(25)
              .width(30)
              .fontColor($r('app.color.start_fontcolor'))
              .margin({ bottom: 25 })
              .transition(TransitionEffect.OPACITY
                .animation(animateParam)
                .combine(TransitionEffect.translate({ y: 200 })))
            Text('您的开发好帮手')
              .fontSize(25)
              .width(30)
              .fontColor($r('app.color.start_fontcolor'))
              .margin({ top: 25 })
              .transition(TransitionEffect.OPACITY
                .animation(animateParam)
                .combine(TransitionEffect.translate({ y: 200 })))
          }
        }
        .justifyContent(FlexAlign.SpaceEvenly)
        .padding({ top: '20%', bottom: '10%' })
        .width('100%')
        .height('100%')
      }

    }
    .expandSafeArea()
    .linearGradient({
      direction: GradientDirection.LeftBottom,
      colors: [[$r('app.color.total_main_linearGradient_0'), 0],
        [$r('app.color.total_main_linearGradient_0point5'), 0.7]]
    })
    .width('100%')
    .height('100%')

  }
}

export { StartPage }
