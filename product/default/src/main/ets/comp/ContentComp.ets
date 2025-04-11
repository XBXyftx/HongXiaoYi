import { ViewMessageModel } from "feature1";
import { MarkdownV2 } from '@lidary/markdown';
@ComponentV2
export struct ContentComp {
  @Param @Require messages: ViewMessageModel[];
  @Param @Require hasEnd: boolean;
  @Param @Require content: string;
  @Param @Require currentIndex: number;

  build() {
    Column() {
      Stack({alignContent:Alignment.Bottom}){
        List({ space: '5vp' }) {
          Repeat(this.messages)
            .each((msg: RepeatItem<ViewMessageModel>) => {
              ListItem() {
                if (msg.item.type === 0) {
                  Column() {
                    // Text(msg.item.content)
                    //   .backgroundColor(Color.Green)
                    //   .padding(10)
                    //   .fontColor(Color.White)
                    //   .borderRadius(5)
                    //   .visibility(msg.item.content == '' ? Visibility.None : Visibility.Visible)
                    MarkdownV2({
                      content:msg.item.content,
                      lineSpace:6,
                      fontStyle:{
                        fontColor:$r('app.color.chat_ai_fontcolor'),
                        fontSize:14
                      }
                    })
                      .padding(10)
                      .backgroundColor($r('app.color.chat_ai_bg_color'))
                      .visibility(msg.item.content == '' ? Visibility.None : Visibility.Visible)
                      .borderRadius(5)

                    if (!this.hasEnd && this.currentIndex == msg.index) {
                      Column({ space: '5vp' }) {
                        Row({space:10}){
                          LoadingProgress()
                            .size({
                              width: '20vp',
                              height: '20vp'
                            })
                            .color(Color.White)
                          Text('思考中')
                            .fontSize(14)
                            .fontColor($r('app.color.chat_ai_fontcolor'))
                        }

                        // Text(this.content)
                        //   .fontColor(Color.White)
                        MarkdownV2({
                          content:this.content,
                          lineSpace:6,
                          fontStyle:{
                            fontColor:$r('app.color.chat_ai_fontcolor'),
                            fontSize:14
                          },
                          theme:{
                            themeColor:$r('app.color.chat_ai_md_theme_color')
                          }
                        })
                      }
                      .backgroundColor($r('app.color.chat_ai_bg_color'))
                      .padding(10)
                      .alignItems(HorizontalAlign.Start)
                      .borderRadius(5)
                    }

                    Blank()
                  }
                  .width('80%')
                  .alignItems(HorizontalAlign.Start)
                } else if (msg.item.type === 1) {
                  Row() {
                    Blank()
                    Text(msg.item.content)
                      .backgroundColor($r('app.color.chat_human_bg_color'))
                      .padding(10)
                      .borderRadius(5)
                  }
                  .width('100%')

                }
              }
            })
        }
        .scrollBar(BarState.Off)
        .width('100%')
        .height('100%')
        Column()
          .width('100%')
          .height(35)
          .linearGradient({
            direction:GradientDirection.Bottom,
            colors:[[$r('app.color.chat_tool_hide_bar_color'),0],[$r('app.color.total_main_linearGradient_0point5'),1]]
          })
      }

    }
    .backgroundColor(Color.Transparent)
  }
}
