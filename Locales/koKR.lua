local _, ns = ...

ns.Locales.koKR = {
    strings = {
        TOAST_ON = "%s 자동 시전 켜짐",
        TOAST_OFF = "%s 자동 시전 꺼짐",
        REASON_SOLO = "혼자일 때는 소환수가 몹을 붙잡습니다: 으르렁거리기 켜기, 웅크리기 끄기.",
        REASON_DUNGEON = "던전 파티에서는 방어 전담이 몹을 붙잡습니다: 으르렁거리기 끄기, 웅크리기 켜기.",
        REASON_KITE = "카이팅 모드: 몹이 소환수가 아니라 당신을 쫓습니다: 으르렁거리기 끄기, 웅크리기 켜기.",
        REASON_TANK = "방어 모드: 소환수가 파티를 위해 방어합니다: 으르렁거리기 켜기, 웅크리기 끄기.",
        HINT_TURN_OFF = "소환수 바나 소환수 주문책에서 오른쪽 클릭하여 자동 시전을 끄세요.",
        HINT_TURN_ON = "소환수 바나 소환수 주문책에서 오른쪽 클릭하여 자동 시전을 켜세요.",

        STATUS = "모드 %s (%s). 감시: 으르렁거리기 %s, 웅크리기 %s, 전투 시작 알림 %s. "
            .. "알림 %d초, 크기 %.2f, 소리 %s, 디버그 %s. 명령어: %s",
        STATUS_ON = "켜짐",
        STATUS_OFF = "꺼짐",
        MODE_SOLO = "혼자",
        MODE_DUNGEON = "던전",
        MODE_KITE = "카이팅",
        MODE_TANK = "방어",
        MODE_AUTO = "애드온이 선택",
        MODE_CHOSEN = "직접 선택",
        SOUND_NAME_FAMILY = "소환수 울음소리",
        SOUND_NAME_WARNING = "공격대 경보",
        NOT_HUNTER = "사냥꾼 소환수만 으르렁거리기와 웅크리기가 있습니다. 이 캐릭터에서는 아무것도 감시하지 않습니다.",
        KITE_ON = "카이팅 모드 켜짐: 으르렁거리기 끄기, 웅크리기 켜기.",
        KITE_OFF = "카이팅 모드 꺼짐: 상황에 따라 다시 혼자 또는 던전 모드.",
        TANK_ON = "방어 모드 켜짐: 으르렁거리기 켜기, 웅크리기 끄기.",
        TANK_OFF = "방어 모드 꺼짐: 상황에 따라 다시 혼자 또는 던전 모드.",
        GROWL_ON = "으르렁거리기의 자동 시전이 모드와 맞지 않으면 알림을 표시합니다.",
        GROWL_OFF = "으르렁거리기를 감시하지 않습니다.",
        COWER_ON = "웅크리기의 자동 시전이 모드와 맞지 않으면 알림을 표시합니다.",
        COWER_OFF = "웅크리기를 감시하지 않습니다.",
        REMIND_ON = "전투가 시작되면 아직 잘못된 것을 다시 알립니다.",
        REMIND_OFF = "전투 시작 알림 없음.",
        SOUND_FAMILY = "소리: 공격 명령 때처럼 소환수의 울음소리 (없으면 공격대 경보).",
        SOUND_WARNING = "소리: 공격대 경보.",
        SOUND_OFF = "소리 끔.",
        DURATION_SET = "알림 표시 시간: %d초.",
        SCALE_SET = "알림 크기: %.2f.",
        POSITION_RESET = "알림 위치를 초기화했습니다.",
        DEBUG_ON = "디버그 켜짐.",
        DEBUG_OFF = "디버그 꺼짐.",
        OPTIONS_AFTER_COMBAT = "전투 중: 전투가 끝나면 설정이 열립니다.",

        BINDING_KITE = "카이팅 모드 전환",
        BINDING_TANK = "방어 모드 전환",

        OPTION_ABOUT = "버전 %s, 제작 %s, %s 라이선스.",
        OPTION_WEBSITE = "웹사이트 (Ctrl+C로 복사):",
        OPTION_DESCRIPTION = "소환수의 으르렁거리기나 웅크리기 자동 시전이 지금 하는 일과 맞지 않으면 화면 "
            .. "가운데에 알림을 표시합니다:\n"
            .. "- 혼자: 으르렁거리기 켜기, 웅크리기 끄기.\n"
            .. "- 던전이나 공격대 파티: 으르렁거리기 끄기, 웅크리기 켜기.\n"
            .. "- 카이팅 모드: 으르렁거리기 끄기, 웅크리기 켜기.\n"
            .. "- 방어 모드, 소환수가 파티를 위해 방어할 때: 으르렁거리기 켜기, 웅크리기 끄기.\n\n"
            .. "알림을 끌어서 옮기고, 오른쪽 클릭으로 닫고, 마우스를 올려 유지하세요. "
            .. "명령어는 /pac 를 입력하세요.",
        OPTION_SETTINGS = "설정",
        OPTION_MODE = "모드",
        OPTION_MODE_AUTO = "자동: 혼자, 또는 던전이나 공격대 파티에서는 던전",
        OPTION_MODE_KITE = "카이팅: 으르렁거리기 끄기, 웅크리기 켜기",
        OPTION_MODE_TANK = "방어: 으르렁거리기 켜기, 웅크리기 끄기, 던전에서도",
        OPTION_MODE_NOTE = "/pac kite 및 /pac tank 와 같습니다. 둘 다 Esc > 설정 > 단축키에 단축키가 있고 "
            .. "매크로에 넣을 수 있습니다.",
        OPTION_GROWL = "으르렁거리기 감시",
        OPTION_GROWL_NOTE = "으르렁거리기의 자동 시전이 모드와 맞지 않으면 알림을 표시합니다. "
            .. "/pac growl on 및 off 와 같습니다.",
        OPTION_COWER = "웅크리기 감시",
        OPTION_COWER_NOTE = "웅크리기의 자동 시전이 모드와 맞지 않으면 알림을 표시합니다. "
            .. "/pac cower on 및 off 와 같습니다.",
        OPTION_REMIND = "전투 시작 시 알림",
        OPTION_REMIND_NOTE = "풀링할 때 아직 잘못된 것을 다시 알립니다. /pac remind on 및 off 와 같습니다.",
        OPTION_SOUND = "소리",
        OPTION_SOUND_FAMILY = "공격 명령 때처럼 소환수의 울음소리 (없으면 공격대 경보)",
        OPTION_SOUND_WARNING = "공격대 경보",
        OPTION_SOUND_OFF = "소리 없음",
        OPTION_DEBUG = "디버그 추적",
        OPTION_DEBUG_NOTE = "애드온이 찾거나 해결된 문제를 모두 대화창에 출력합니다. /pac debug 와 같습니다.",
        OPTION_DURATION = "알림 표시 시간: %d초",
        OPTION_SCALE = "알림 크기: %.2f",
        OPTION_TEST = "알림 보기",
    },
}
