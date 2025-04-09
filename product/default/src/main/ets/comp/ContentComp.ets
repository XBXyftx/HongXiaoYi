import { ViewMessageModel } from "feature1";

@ComponentV2
export struct ContentComp {
  @Param @Require messages: ViewMessageModel[];
  @Param @Require hasEnd: boolean;
  @Param @Require content: string;
  @Param @Require currentIndex: number;

  build() {
    Column() {
      List({ space: '5vp' }) {
        Repeat(this.messages)
          .each((msg: RepeatItem<ViewMessageModel>) => {
            ListItem() {
              if (msg.item.type === 0) {
                Column() {
                  Text(msg.item.content)
                    .backgroundColor(Color.Green)
                    .padding(10)
                    .fontColor(Color.White)
                    .borderRadius(5)
                    .visibility(msg.item.content == '' ? Visibility.None : Visibility.Visible)

                  if (!this.hasEnd && this.currentIndex == msg.index) {
                    Column({ space: '5vp' }) {
                      LoadingProgress()
                        .size({
                          width: '20vp',
                          height: '20vp'
                        })
                        .color(Color.White)
                      Text(this.content)
                        .fontColor(Color.White)
                    }
                    .backgroundColor(Color.Green)
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
                    .backgroundColor(Color.Orange)
                    .padding(10)
                    .borderRadius(5)
                }
                .width('100%')

              }
            }
          })
      }
      .width('100%')
      .height('100%')
    }
    .backgroundColor(Color.Transparent)
  }
}
