@Component
export struct PrimaryActionButton {
  @Prop label: string;
  @Prop disabled: boolean;
  @Prop emphasis: 'primary' | 'secondary';
  onTap: () => void = () => {};

  private bgColor(): string {
    if (this.disabled) {
      return '#2A2A2A';
    }
    if (this.emphasis === 'secondary') {
      return '#243447';
    }
    return '#1F6FEB';
  }

  private fgColor(): string {
    if (this.disabled) {
      return '#6E6E6E';
    }
    return '#FFFFFF';
  }

  build() {
    Button(this.label)
      .fontSize(12)
      .fontColor(this.fgColor())
      .backgroundColor(this.bgColor())
      .height(28)
      .width('100%')
      .borderRadius(14)
      .enabled(!this.disabled)
      .onClick(() => {
        this.onTap();
      })
  }
}
