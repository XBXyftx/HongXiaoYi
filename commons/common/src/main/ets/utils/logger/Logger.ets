import { hilog } from '@kit.PerformanceAnalysisKit'
const tag = 'XBXLogger'
/**
 * hilog的业务封装类
 * 内置了业务领域的输出格式，开发者个人标识，以及信息的格式化方式
 * 包含了hilog的四种日志打印模式
 * 支持传入一个字符串作为输出内容
 */
class Logger{
  private domain:number // 十六进制输出业务格式
  private tag:string // 制定的自己的标识
  private format:string = '%{public}s' //格式化方式

  constructor(domain: number = 0x0000, tag: string = '') {
    this.domain = domain
    this.tag = tag
  }
  debug(args: string): void {
    hilog.debug(this.domain, this.tag, this.format, args);
  }

  info(args: string): void {
    hilog.info(this.domain, this.tag, this.format, args);
  }

  warn(args: string): void {
    hilog.warn(this.domain, this.tag, this.format, args);
  }

  error(args: string): void {
    hilog.error(this.domain, this.tag, this.format, args);
  }

}

export const logger:Logger = new Logger(0x1234,tag)