import { ViewMessageModel } from 'feature1/src/main/ets/modules/CozeApiModules/CozeApiModule'

@Entry
@ComponentV2
struct Index {
  @Local viewMessageList: ViewMessageModel[] = []

  build() {
    Column() {

    }
    .height('100%')
    .width('100%')
  }
}