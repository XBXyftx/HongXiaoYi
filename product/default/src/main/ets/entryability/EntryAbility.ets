import { AbilityConstant, ConfigurationConstant, UIAbility, Want } from '@kit.AbilityKit';
import { hilog } from '@kit.PerformanceAnalysisKit';
import { AppStorageV2, window } from '@kit.ArkUI';
import { GetBreakPointSystem, GET_BREAK_POINT_SYSTEM, logger } from 'common';
import { MessageList, MessageModel, MESSAGE_LIST, MSG } from 'feature1';

const DOMAIN = 0x0000;
const ENTRYABILITY_LOG_TAG = 'EntryAbility:  '

export default class EntryAbility extends UIAbility {
  onCreate(want: Want, launchParam: AbilityConstant.LaunchParam): void {
    this.context.getApplicationContext().setColorMode(ConfigurationConstant.ColorMode.COLOR_MODE_NOT_SET);
    hilog.info(DOMAIN, 'testTag', '%{public}s', 'Ability onCreate');
    AppStorageV2.connect(GetBreakPointSystem,GET_BREAK_POINT_SYSTEM,()=>new GetBreakPointSystem())!.getBreakPointSystem().start()
    logger.warn(ENTRYABILITY_LOG_TAG+'断点系统已经启动')
    AppStorageV2.connect(MessageModel, MSG, () => new MessageModel())
    logger.warn(ENTRYABILITY_LOG_TAG+'当前信息对象已经初始化完成')
    AppStorageV2.connect(MessageList, MESSAGE_LIST,()=>new MessageList())
  }

  onDestroy(): void {
    hilog.info(DOMAIN, 'testTag', '%{public}s', 'Ability onDestroy');
    AppStorageV2.connect(GetBreakPointSystem,GET_BREAK_POINT_SYSTEM,()=>new GetBreakPointSystem())!.getBreakPointSystem().stop()
    logger.warn(ENTRYABILITY_LOG_TAG+'断点系统已经关闭')
  }

  onWindowStageCreate(windowStage: window.WindowStage): void {
    // Main window is created, set main page for this ability
    hilog.info(DOMAIN, 'testTag', '%{public}s', 'Ability onWindowStageCreate');

    windowStage.loadContent('pages/Index', (err) => {
      if (err.code) {
        hilog.error(DOMAIN, 'testTag', 'Failed to load the content. Cause: %{public}s', JSON.stringify(err));
        return;
      }
      hilog.info(DOMAIN, 'testTag', 'Succeeded in loading the content.');
    });
  }

  onWindowStageDestroy(): void {
    // Main window is destroyed, release UI related resources
    hilog.info(DOMAIN, 'testTag', '%{public}s', 'Ability onWindowStageDestroy');
  }

  onForeground(): void {
    // Ability has brought to foreground
    hilog.info(DOMAIN, 'testTag', '%{public}s', 'Ability onForeground');
  }

  onBackground(): void {
    // Ability has back to background
    hilog.info(DOMAIN, 'testTag', '%{public}s', 'Ability onBackground');
  }
}