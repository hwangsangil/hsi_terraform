# 변수 configuration
# ex)이름 규칙 {prefix}-{prouct}-{env : option으로 값 없으면 생략}-ssm-vpce-sg
# https://atc.bmwgroup.net/confluence/x/0QP9cQ

profile = ""      # aws credential에서 설정한 profile 이름으로 입력
prefix  = "nsckr" # 이름 규칙에 따라 첫 접두사 위치에 올 이름 설정 ex) nsckr
product = ""      # product name 또는 naming rule 에 따른 두번째 위치 이름 설정
env     = ""      # dev or prod 값 입력. 두 값 이외에 값이 들어가면 생략됨
