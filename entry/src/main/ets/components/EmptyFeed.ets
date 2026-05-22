import { COPY_EMPTY_FEED } from '../constants/UiConstants';

@Component
export struct EmptyFeed {
  build() {
    Column() {
      Text(COPY_EMPTY_FEED)
        .fontSize(12)
        .fontColor('#9A9A9A')
        .textAlign(TextAlign.Center)
        .maxLines(2)
    }
    .width('100%')
    .padding({ left: 16, right: 16, top: 12, bottom: 12 })
    .justifyContent(FlexAlign.Center)
  }
}
