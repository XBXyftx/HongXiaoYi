import { promptAction } from "@kit.ArkUI";
import { animateParam, logger } from "common/Index";

@ComponentV2
export struct ToolBarComp {
  @Local content: string = '';
  @Param @Require hasEnd: boolean
  @Event submit: (content: string) => void;

  build() {
    Row({ space: '10vp' }) {
      TextInput({ placeholder: '请输入内容', text: this.content })
        .layoutWeight(3)
        .onChange((value: string) => {
          this.content = value;
        })
        .transition(TransitionEffect.OPACITY
          .animation(animateParam)
          .combine(TransitionEffect.translate({y:200})))
      if (this.hasEnd) {
        Button('发送')
          .layoutWeight(1)
          .clickEffect({ level: ClickEffectLevel.LIGHT })
          .onClick(() => {
            if (this.content === '') {
              logger.warn('消息为空')
              promptAction.showToast({
                message: '发送消息不能为空',
                duration: 3000
              })
            } else {
              this.submit(this.content);
              this.content = ''
            }
          })
          .transition(TransitionEffect.OPACITY
            .animation(animateParam)
            .combine(TransitionEffect.translate({y:200})))
      }

    }
    .height('10%')
    .width('100%')

    .padding(10)
  }
}


