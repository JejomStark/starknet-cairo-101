# ######## Ex 11
# # 导入函数
# 在这个练习中，您需要：
# - 阅读此合约并了解它如何从另一个合约中导入函数
# - 找到导入的相关合约
# - 阅读代码，了解您需要做什么

%lang starknet
%builtins pedersen range_check

from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.cairo.common.math import assert_not_zero, assert_le
from starkware.starknet.common.syscalls import get_caller_address

# 该合约从其他文件中导入函数，而不是从其他练习中导入，请注意
from contracts.utils.ex11_base import (
    tderc20_address,
    has_validated_exercise,
    distribute_points,
    validate_exercise,
    ex_initializer,
    validate_answers,
    ex11_secret_value,
)

#
# 建构函数
#
@constructor
func constructor{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
    _tderc20_address : felt, _players_registry : felt, _workshop_id : felt, _exercise_id : felt
):
    ex_initializer(_tderc20_address, _players_registry, _workshop_id, _exercise_id)
    return ()
end

#
# 外部函数
# 呼叫此函数，指定地址将得2分
#

@external
func claim_points{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
    secret_value_i_guess : felt, next_secret_value_i_chose : felt
):
    # 读取呼叫者的地址
    let (sender_address) = get_caller_address()
    # 检查您的答案是否正确
    validate_answers(sender_address, secret_value_i_guess, next_secret_value_i_chose)
    # 再次读取呼叫者的地址，被撤销的references，我含泪爱了T T
    let (sender_address) = get_caller_address()
    # 检查用户之前是否验证过练习
    validate_exercise(sender_address)
    # 发送分数给参数指定的地址
    distribute_points(sender_address, 2)
    return ()
end
