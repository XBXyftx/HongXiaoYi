import { ViewMessageModel } from "feature1";
import { MarkdownV2 } from '@lidary/markdown';
import { animateParam } from "common";
import { LengthMetrics } from "@kit.ArkUI";

@ComponentV2
export struct ContentComp {
  @Param @Require messages: ViewMessageModel[];
  @Param @Require hasEnd: boolean;
  @Param @Require content: string;
  @Param @Require currentIndex: number;
  listScroller:Scroller = new Scroller()
  @Monitor('content')
  onChange(){
    this.listScroller.scrollEdge(Edge.Bottom)
  }
  build() {
    Column() {
      Stack({alignContent:Alignment.Bottom}){
        List({ space: '5vp' ,scroller:this.listScroller}) {
          Repeat(this.messages)
            .each((msg: RepeatItem<ViewMessageModel>) => {
              ListItem() {
                if (msg.item.type === 0) {
                  Column() {
                    MarkdownV2({
                      content:msg.item.content,
                      lineSpace:6,
                      fontStyle:{
                        fontColor:$r('app.color.chat_ai_fontcolor'),
                        fontSize:16
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
                            .fontSize(16)
                            .fontColor($r('app.color.chat_ai_fontcolor'))
                        }
                        MarkdownV2({
                          content:this.content,
                          lineSpace:6,
                          fontStyle:{
                            fontColor:$r('app.color.chat_ai_fontcolor'),
                            fontSize:16
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
                      .fontColor($r('app.color.chat_ai_fontcolor'))
                      .fontSize(16)
                      .backgroundColor($r('app.color.chat_human_bg_color'))
                      .padding(10)
                      .borderRadius(5)
                  }
                  .width('100%')

                }
              }
              .transition(TransitionEffect.OPACITY
                .animation(animateParam)
                .combine(TransitionEffect.translate({y:200})))
            })
        }
        .scrollBar(BarState.Off)
        .width('100%')
        .height('100%')
        .fadingEdge(true,{fadingEdgeLength:LengthMetrics.vp(50)})
      }

    }
    .backgroundColor(Color.Transparent)
  }
}
