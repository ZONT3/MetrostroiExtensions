local SpawnerConstants = {
    NAME = 1,
    TRANSLATION = 2,
    TYPE = 3,
    TYPE_LIST = "List",
    TYPE_SLIDER = "Slider",
    TYPE_BOOLEAN = "Boolean",
    List = {
        ELEMENTS = 4,
        DEFAULT_VALUE = 5,
        WAGON_CALLBACK = 6,
        CHANGE_CALLBACK = 7,
    },
    Slider = {
        DECIMALS = 4,
        MIN_VALUE = 5,
        MAX_VALUE = 6,
        DEFAULT = 7,
        WAGON_CALLBACK = 8,
    },
    Boolean = {
        DEFAULT = 4,
        WAGON_CALLBACK = 5,
        CHANGE_CALLBACK = 6,
    }
}

return SpawnerConstants
