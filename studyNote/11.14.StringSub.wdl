version 1.0

String chocolike="I like chocolate when it's late"
# 将like 全部替换成love
String chocolove=sub(chocolike,"like","love") # I love chocolate when it's late
# 用early替换所有的late
String chocolove=sub(chocolike,"late","early") # I like chocoearly when it's early
# 用early替换最后的late
String chocolove=sub(chocolike,"late$","early") # I like chocolate when it's early