# ######## Ex 07
# 在这个练习中，您需要：
# - 使用这个合约的 claim_points() 函数
# - 由合约记入您的积分

# ######## References
# ######## 参考资料
# 文档仍在编写中。 您可以在此文件中找到答案
# https://github.com/starkware-libs/cairo-lang/blob/master/src/starkware/cairo/common/math.cairo

%lang starknet
%builtins pedersen range_check

from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.starknet.common.syscalls import get_caller_address
from starkware.cairo.common.math import (
    assert_not_zero,
    assert_not_equal,
    assert_nn,
    assert_le,
    assert_lt,
    assert_in_range,
)

from contracts.utils.ex00_base import (
    tderc20_address,
    has_validated_exercise,
    distribute_points,
    validate_exercise,
    ex_initializer,
)

#
# 构建函数
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
    value_a : felt, value_b : felt
):
    # 读取呼叫者的地址
    let (sender_address) = get_caller_address()
    # 检查通过的值是否正确
    assert_not_zero(value_a)
    assert_nn(value_b)
    assert_not_equal(value_a, value_b)
    assert_le(value_a, 75)
    assert_in_range(value_a, 40, 70)
    assert_lt(value_b, 1)
    # 检查用户之前是否验证过练习
    validate_exercise(sender_address)
    # 发送分数给参数指定的地址
    distribute_points(sender_address, 2)
    return ()
end
